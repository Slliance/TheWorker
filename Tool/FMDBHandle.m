//
//  FMDBHandle.m
//  GoodDoctor
//
//  Created by yanghao on 16/5/18.
//  Copyright © 2016年 wikj. All rights reserved.
//

#import "FMDBHandle.h"

@implementation FMDBHandle

+ (FMDBHandle *)sharedManager
{
    static FMDBHandle *sharedSimpleManageInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedSimpleManageInstance = [[self alloc] init];
    });
    return sharedSimpleManageInstance;
}
-(NSString *)getFilePathWithFileName:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:fileName];
}
/**
 *  获取数据库，如果没有，则创建。
 *
 *  @param fileName 文件名称
 *
 *  @return 数据库对象
 */
-(FMDatabase *)getDataBaseWithFileName:(NSString *)fileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[self getFilePathWithFileName:fileName]]) {
        [fileManager createFileAtPath:[self getFilePathWithFileName:fileName] contents:nil attributes:nil];
    }
    return [FMDatabase databaseWithPath:[self getFilePathWithFileName:fileName]] ;
}

/**
 *  查询表
 *
 *  @param sqlStr   SQL语句
 *  @param fileName 数据库文件名称
 *
 *  @return 查询到的数据
 */
-(NSDictionary *)searchDataWithSqlStr:(NSString *)sqlStr db:(FMDatabase *)db{
    NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] init];
    FMResultSet *rs = [db executeQuery:sqlStr];
    if ([rs next]) {
        [resultDictionary addEntriesFromDictionary:[rs resultDictionary]];
    }
    [rs close];
    return resultDictionary;
}
/**
 *  查询表中数据
 *
 *  @param sql SQL语句
 *  @param db  数据库
 */
-(NSArray *)searchDataWithSql:(NSString *)sql fileName:(NSString *)fileName{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    FMDatabase *db = [self getDataBaseWithFileName:fileName];
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [result addObject:[rs resultDictionary]];
        }
        [db close];
    }
    return result;
}
/**
 *  查询表中数据的某个字段
 *
 *  @param sql SQL语句
 *  @param db  数据库
 */
-(NSArray *)searchDataValueWithSql:(NSString *)sql key:(NSString *)key fileName:(NSString *)fileName{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    FMDatabase *db = [self getDataBaseWithFileName:fileName];
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [result addObject:[rs resultDictionary][key]];
        }
        [db close];
    }
    return result;
}
/**
 *  查询表中数据的某个字段的分组
 *
 *  @param sql SQL语句
 *  @param db  数据库
 */
-(NSInteger )searchDataCountWithSql:(NSString *)sql fileName:(NSString *)fileName{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [self getDataBaseWithFileName:fileName];
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        if ([rs next]) {
            [result addObject:[rs resultDictionary]];
        }
        [db close];
    }
    return 0;
}

/**
 *  拷贝数据库文件到沙盒中
 *
 *  @param sqliteFileName 文件名称
 */
-(void)copySqliteFileToDocmentWithFileName:(NSString *)sqliteFileName
{
    NSString *sqliteFileNamePath = [[NSBundle mainBundle] pathForResource:sqliteFileName ofType:nil];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[self getFilePathWithFileName:sqliteFileName]]) {
        BOOL b = [fileManager copyItemAtPath:sqliteFileNamePath toPath:[self getFilePathWithFileName:sqliteFileName] error:nil];
        if (b) {
            NSLog(@"拷贝成功");
        }
        else{
            NSLog(@"拷贝失败");
        }
    }
    else{
        NSLog(@"数据库文件已经存在沙盒中");
    }
}


@end
