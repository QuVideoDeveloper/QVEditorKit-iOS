//
//  XYDBUtility.m
//  XiaoYingCoreSDK
//
//  Created by ShouHangjun on 1/19/16.
//  Copyright © 2016 QuVideo. All rights reserved.
//

#import "XYDBUtility.h"
#import <sqlite3.h>
#import <FMDB/FMDB.h>

@interface XYDBUtility ()

@property (nonatomic, strong) NSMutableDictionary *DBDict;

@end

@implementation XYDBUtility{
    NSRecursiveLock *_lock;
}

+ (XYDBUtility *)shareInstance {
    static XYDBUtility *sharedInstance;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[XYDBUtility alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _lock = [NSRecursiveLock new];
    }
    return self;
}

- (NSMutableDictionary *)DBDict {
    if (nil == _DBDict) {
        _DBDict = [NSMutableDictionary dictionary];
    }
    
    return _DBDict;
}

- (void)registerDatabaseManager:(XYBaseDatabase *)DBMgr forName:(NSString *)name {
    [_lock lock];
    [self.DBDict setValue:DBMgr forKey:name];
    [_lock unlock];
}

- (XYBaseDatabase *)databaseManager:(NSString *)name {
    [_lock lock];
    XYBaseDatabase *dbMgr = [self.DBDict valueForKey:name];
    [_lock unlock];
    return dbMgr;
}

+(NSString*)updateDataToAppDB:(NSDictionary*)dict2DB table:(NSString*)tableName where:(NSString*)where DBMgr:(XYBaseDatabase *)DBMgr {
    NSString* sqlResult;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",tableName,where];
    __block BOOL needUpdate = NO;
    [DBMgr queryData:sql getResult:^(FMResultSet *result) {
        if(result && [result next]) {
            needUpdate = YES;
        }
    }];
    
    if (needUpdate) {
        sqlResult = [XYDBUtility createUpdateSQL:tableName withParameterDictionary:dict2DB where:where];
    }else {
        sqlResult = [XYDBUtility createInsertSQL:tableName withParameterDictionary:dict2DB];
    }
    
    return sqlResult;
}

+ (NSString *)createInsertSQL:(NSString *)tableName withParameterDictionary:(NSDictionary *)argsDict {
    NSEnumerator *enumerator = [argsDict keyEnumerator];
    id key;
    NSString *tempValues = @"";
    NSString *tempKeys = @"";
    
    while ((key = [enumerator nextObject])) {
        id value = [argsDict valueForKey:key];
        if([value isKindOfClass:[NSString class]]){
            value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            tempValues = [tempValues stringByAppendingFormat:@"'%@',",value];
        }else if([value isKindOfClass:[NSNumber class]]){
            tempValues = [tempValues stringByAppendingFormat:@"%@,",[value stringValue]];
        }else{
            NSLog(@"this is wrong format value");
            continue;
        }
        tempKeys = [tempKeys stringByAppendingFormat:@"%@,",key];
    }
    NSUInteger valuesLength = [tempValues length];
    if(valuesLength>0){
        tempValues = [tempValues substringToIndex:valuesLength-1];
    }
    NSUInteger keyLength = [tempKeys length];
    if(keyLength>0){
        tempKeys = [tempKeys substringToIndex:keyLength-1];
    }
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@);",tableName,tempKeys,tempValues];
    return sql;
}

+ (NSString *)createUpdateSQL:(NSString *)tableName
      withParameterDictionary:(NSDictionary *)argsDict
                        where:(NSString *)where
{
    NSEnumerator *enumerator = [argsDict keyEnumerator];
    id key;
    NSString *temp = @"";
    
    while ((key = [enumerator nextObject])) {
        id value = [argsDict valueForKey:key];
        if([value isKindOfClass:[NSString class]]){
            value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            temp = [temp stringByAppendingFormat:@"%@='%@',",key,value];
        }else if([value isKindOfClass:[NSNumber class]]){
            temp = [temp stringByAppendingFormat:@"%@=%@,",key,[value stringValue]];
        }else{
            NSLog(@"this is wrong format value");
        }
        
    }
    NSUInteger tempLength = [temp length];
    if(tempLength>0){
        temp = [temp substringToIndex:tempLength-1];
    }
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@;",tableName,temp,where];
    return sql;
}

@end
