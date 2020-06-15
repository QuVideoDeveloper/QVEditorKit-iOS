//
//  XYTemplateDBMgr.m
//  XYTemplateDataMgr
//
//  Created by hzy on 2019/8/22.
//

#import "XYTemplateDBMgr.h"

#import <FMDB/FMDB.h>

#define CURRENT_TEMPLATE_DB_VERSION         1

@implementation XYTemplateDBMgr

//Upgrade the database
- (void) onUpgradDataBase{
    FMDatabaseQueue *queue = [self DBQueue];
    if(queue == nil)
        return;
    
    int version = [self version];
    if(CURRENT_TEMPLATE_DB_VERSION > version){
        if (version == 0) {
            [queue inDatabase:^(FMDatabase *db) {
                //delete old video table in global.db
                NSString*  sql;
                sql = @"CREATE TABLE Template (template_id INTEGER PRIMARY KEY,title TEXT,points REAL,price REAL,logo TEXT,url TEXT,from_type INTEGER,orderno INTEGER DEFAULT 2147483647,ver INTEGER,updatetime LONG,favorite INTEGER,suborder INTEGER,layout INTEGER,extInfo TEXT,description TEXT,configureCount INTEGER DEFAULT 0,downFlag INTEGER DEFAULT 0,mission TEXT,mresult TEXT,delFlag integer  DEFAULT 0,scene_code TEXT DEFAULT NULL,appFlag INTEGER  DEFAULT 0)";
                [db executeUpdate:sql];
            }];
            version = 1;
        }

        if(queue){
            [queue inDatabase:^(FMDatabase *db) {
                NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS Version (db_version INTEGER)"];
                [db executeUpdate:sql];
                sql = @"DELETE FROM Version";
                [db executeUpdate:sql];
                sql = [NSString stringWithFormat:@"insert into Version(db_version) values(%d)",CURRENT_TEMPLATE_DB_VERSION];
                [db executeUpdate:sql];
            }];
        }
    }
}

@end
