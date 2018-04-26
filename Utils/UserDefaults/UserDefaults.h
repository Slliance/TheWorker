//
//  UserDefaults.h
//  Sotao
//
//  Created by 李新 on 14-9-12.
//  Copyright (c) 2014年 搜淘APP. All rights reserved.
//

#import <Foundation/Foundation.h>
//用户数据保存
@interface UserDefaults : NSUserDefaults
+(id)readUserDefaultObjectValueForKey:(NSString*)aKey;
+(void)writeUserDefaultObjectValue:(NSObject*)aValue
                           withKey:(NSString*)aKey;
+ (void)clearUserDefaultWithKey:(NSString *)key;

@end
