//
//  FMDBHandle.h
//  GoodDoctor
//
//  Created by yanghao on 16/5/18.
//  Copyright © 2016年 wikj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDBHandle : NSObject
+ (FMDBHandle *)sharedManager;

-(FMDatabase *)getDataBaseWithFileName:(NSString *)fileName;
-(NSArray *)searchDataValueWithSql:(NSString *)sql key:(NSString *)key fileName:(NSString *)fileName;
-(NSInteger )searchDataCountWithSql:(NSString *)sql fileName:(NSString *)fileName;
-(NSDictionary *)searchDataWithSqlStr:(NSString *)sqlStr db:(FMDatabase *)db;
-(NSArray *)searchDataWithSql:(NSString *)sql fileName:(NSString *)fileName;
-(void)copySqliteFileToDocmentWithFileName:(NSString *)sqliteFileName;


@end
