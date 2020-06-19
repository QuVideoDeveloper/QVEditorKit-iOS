//
//  XYBaseDatabase.h
//  XYDatabase
//
//  Created by qichao.ma on 2017/6/16.
//
//

#import <Foundation/Foundation.h>

#define OPEN_DB_SUCCEED             0
#define OPEN_DB_FAILED              -1
#define DB_ALREADY_EXISTED          1

@class FMResultSet;

@interface XYBaseDatabase : NSObject

- (void)initDBWithTargetPath:(NSString *)targetPath sourcePath:(NSString *)sourcePath;

/**
 Upgrade database in sub class
 */
- (void)onUpgradDataBase;

/**
 Connect the database
 */
- (BOOL)connect;

/**
 Close the database
 */
- (void)close;

- (int)version;

- (id)DBQueue;

/**
 Insert the data into the table in queue
 @param tableName Name of the table that you want to insert
 */
- (long long)insertInQueue:(NSString *)tableName withParameterDictionary:(NSDictionary *)argsDict;

/**
 Update data of table
 */
- (BOOL)updateInQueue:(NSString *)tableName withParameterDictionary:(NSDictionary *)argsDict where:(NSString *)where;

/**
 Query data from table
 */
- (void)queryData:(NSString *)sql getResult:(void (^)(FMResultSet *result))getResult;

/**
 Delete data from table
 */
- (void)deleteInQueue:(NSString *)tableName where:(NSString *)where;

/**
 Execute sql
 */
- (BOOL)executeStatements:(NSString *)sql;

@end
