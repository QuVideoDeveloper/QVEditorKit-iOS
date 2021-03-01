//
//  XYDBUtility.h
//  XiaoYingCoreSDK
//
//  Created by ShouHangjun on 1/19/16.
//  Copyright © 2016 QuVideo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QVBaseDatabase.h"

@interface QVDBUtility : NSObject

+ (QVDBUtility *)shareInstance;

- (void)registerDatabaseManager:(QVBaseDatabase *)DBMgr forName:(NSString *)name;

- (QVBaseDatabase *)databaseManager:(NSString *)name;

+(NSString*)updateDataToAppDB:(NSDictionary*)dict2DB table:(NSString*)tableName where:(NSString*)where DBMgr:(QVBaseDatabase *)DBMgr;

+(NSString *)createInsertSQL:(NSString *)tableName withParameterDictionary:(NSDictionary *)argsDict;

+(NSString *)createUpdateSQL:(NSString *)tableName
       withParameterDictionary:(NSDictionary *)argsDict
                         where:(NSString *)where;
@end
