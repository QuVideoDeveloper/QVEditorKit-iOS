//
//  XYDBUtility.h
//  XiaoYingCoreSDK
//
//  Created by ShouHangjun on 1/19/16.
//  Copyright © 2016 QuVideo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYBaseDatabase.h"

@interface XYDBUtility : NSObject

+ (XYDBUtility *)shareInstance;

- (void)registerDatabaseManager:(XYBaseDatabase *)DBMgr forName:(NSString *)name;

- (XYBaseDatabase *)databaseManager:(NSString *)name;

+(NSString*)updateDataToAppDB:(NSDictionary*)dict2DB table:(NSString*)tableName where:(NSString*)where DBMgr:(XYBaseDatabase *)DBMgr;

+(NSString *)createInsertSQL:(NSString *)tableName withParameterDictionary:(NSDictionary *)argsDict;

+(NSString *)createUpdateSQL:(NSString *)tableName
       withParameterDictionary:(NSDictionary *)argsDict
                         where:(NSString *)where;
@end
