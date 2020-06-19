//
//  XYBaseDatabase.m
//  XYDatabase
//
//  Created by qichao.ma on 2017/6/16.
//
//

#import "XYBaseDatabase.h"
#import <sqlite3.h>
#import <FMDB/FMDB.h>

#define NOTIFICATION_DB                         @"NOTIFICATION_DB_"

@interface XYBaseDatabase(){
    FMDatabaseQueue *queue;
    NSString *dbTargetPath;
    NSString *dbSourcePath;
}
@end

@implementation XYBaseDatabase

- (void)initDBWithTargetPath:(NSString *)targetPath sourcePath:(NSString *)sourcePath {
    dbTargetPath = targetPath;
    dbSourcePath = sourcePath;
    [self createDataBase];
}

- (void)onUpgradDataBase {
    
}

- (int)createDataBase {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    NSString *databasePath = [dbTargetPath stringByDeletingLastPathComponent];
    BOOL bo = [fileManager createDirectoryAtPath:databasePath
                     withIntermediateDirectories:YES
                                      attributes:nil
                                           error:nil];
    NSAssert(bo,@"Create folder failed!");
    BOOL exist = [fileManager fileExistsAtPath:dbTargetPath];
    if (!exist) {
        [self createAllTables];
        BOOL ret = [self connect];
        if(ret == NO){
            return OPEN_DB_FAILED;
        }else{
            return OPEN_DB_SUCCEED;
        }
    } else {
        BOOL ret = [self connect];
        if(ret == NO){
            return OPEN_DB_FAILED;
        }else{
            [self onUpgradDataBase];
            return DB_ALREADY_EXISTED;
        }
    }
}

- (void)createAllTables {
    [self copySourceFilePath:dbSourcePath intoFolder:dbTargetPath];
}

- (void)dealloc {
    [self close];
}

- (BOOL)connect {
    if (queue) {
        [queue close];
        queue = nil;
    }
    
    queue = [FMDatabaseQueue databaseQueueWithPath:dbTargetPath];
    return YES;
}

- (void)close {
    if (queue){
        [queue close];
        queue = nil;
    }
}

// Get the database version
- (int)version {
    __block int version = 0;
    if(queue){
        [queue inDatabase:^(FMDatabase *db) {
            FMResultSet *s = [db executeQuery:@"SELECT * FROM Version"];
            if ([s next]) {
                version = [s intForColumnIndex:0];
            }
            if(s){
                [s close];
            }
        }];
    }else{
        NSLog(@"getVersion error");
    }
    
    return version;
}

- (id)DBQueue {
    return queue;
}

- (long long)insertInQueue:(NSString *)tableName withParameterDictionary:(NSDictionary *)argsDict{
    __block sqlite_int64 lastInsertRowId = -1;
    if(queue){
        NSEnumerator *enumerator = [argsDict keyEnumerator];
        id key;
        NSString *tempValues = @"";
        NSString *tempKeys = @"";
        
        while ((key = [enumerator nextObject])) {
            tempValues = [tempValues stringByAppendingFormat:@":%@,",key];
            tempKeys = [tempKeys stringByAppendingFormat:@"%@,",key];
        }
        NSInteger valuesLength = [tempValues length];
        if(valuesLength>0){
            tempValues = [tempValues substringToIndex:valuesLength-1];
        }
        NSInteger keyLength = [tempKeys length];
        if(keyLength>0){
            tempKeys = [tempKeys substringToIndex:keyLength-1];
        }
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",tableName,tempKeys,tempValues];
        NSDictionary *dict = argsDict;
        [queue inDatabase:^(FMDatabase *db) {
            BOOL ret =[db executeUpdate:sql withParameterDictionary:dict];
            if(ret){
                lastInsertRowId = [db lastInsertRowId];
                //Notify data is inserted
                [self notifyChange:tableName];
            }
        }];
    }else{
        NSLog(@"queue is nil");
    }
    //NSLog(@"lastInsertRowId = %lld",lastInsertRowId);
    return lastInsertRowId;
}


- (BOOL)updateInQueue:(NSString *)tableName withParameterDictionary:(NSDictionary *)argsDict where:(NSString *)where {
    if(queue && argsDict && [argsDict count]>0){
        NSEnumerator *enumerator = [argsDict keyEnumerator];
        id key;
        NSString *temp = @"";
        
        while ((key = [enumerator nextObject])) {
            temp = [temp stringByAppendingFormat:@"%@=:%@,",key,key];
        }
        NSInteger tempLength = [temp length];
        if(tempLength>0){
            temp = [temp substringToIndex:tempLength-1];
        }
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",tableName,temp,where];
        NSDictionary *dict = argsDict;
        __block BOOL ret = YES;
        [queue inDatabase:^(FMDatabase *db) {
            ret = [db executeUpdate:sql withParameterDictionary:dict];
            if(ret){
                //Notify data is inserted
                [self notifyChange:tableName];
            }
        }];
        return ret;
    }else{
        NSLog(@"updateInQueue error");
        return NO;
    }
}

- (void)queryData:(NSString *)sql getResult:(void (^)(FMResultSet *result))getResult {
    if(queue){
        [queue inDatabase:^(FMDatabase *db) {
            FMResultSet *ret =[db executeQuery:sql];
            getResult(ret);
            if(ret){
                [ret close];
            }
        }];
    }else{
        NSLog(@"queryData error");
    }
}


- (void)deleteInQueue:(NSString *)tableName where:(NSString *)where {
    if(queue){
        NSString *sql = @"";
        if([XYBaseDatabase isEmptyString:where]){
            sql = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
        }else{
            sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",tableName,where];
        }
        
        [queue inDatabase:^(FMDatabase *db) {
            BOOL ret =[db executeUpdate:sql];
            if(ret){
                //notify data is deleted
                [self notifyChange:tableName];
            }
        }];
    }else{
        NSLog(@"deleteInQueue error");
    }
}

- (BOOL)executeStatements:(NSString *)sql {
    if ([XYBaseDatabase isEmptyString:sql]) {
        return NO;
    }
    
    __block BOOL result = NO;
    if(queue){
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            result = [db executeStatements:sql];
        }];
    }else{
        NSLog(@"queue is nil");
    }
    
    if (result == NO) {
        NSLog(@"sql:%@",sql);
    }
    return result;
}

- (void)notifyChange:(NSString *)tableName {
    //Notify data is changed
    //NSLog(@"Notify: Table %@ is changed",tableName);
    NSString *name = [NSString stringWithFormat:@"%@%@",NOTIFICATION_DB,tableName];
    NSNotification* notification = [NSNotification notificationWithName:name object:tableName userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)copySourceFilePath:(NSString *)sourcePath intoFolder:(NSString *)targetPath {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    // set up the full path for the destination file
    success = [fileManager fileExistsAtPath:targetPath];
    
    // if the file is already there, just return
    if (success)
        return;
    
    // Check  in main bundle
    if ([fileManager fileExistsAtPath:sourcePath]) {
        success = [fileManager copyItemAtPath:sourcePath toPath:targetPath error:&error];
        if (!success) {
            //[self alert:@"Failed to copy resource file"];
            NSAssert1(0, @"Failed to copy file to documents with message '%@'.", [error localizedDescription]);
        }
        return;
    }
}

+ (BOOL)isEmptyString:(NSString *)string {
    // Note that [string length] == 0 can be false when [string isEqualToString:@""] is true, because these are Unicode strings.
    
    if (((NSNull *) string == [NSNull null]) || (string == nil) || ![string isKindOfClass:(NSString.class)]) {
        return YES;
    }
    string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

@end
