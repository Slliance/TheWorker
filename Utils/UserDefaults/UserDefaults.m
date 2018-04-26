//
//  UserDefaults.m
//  Sotao
//
//  Created by 李新 on 14-9-12.
//  Copyright (c) 2014年 搜淘APP. All rights reserved.
//

#import "UserDefaults.h"

@implementation UserDefaults
+(id)readUserDefaultObjectValueForKey:(NSString*)aKey {
    if (aKey) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:aKey];
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    else {
        return nil;
    }
}

+(void)writeUserDefaultObjectValue:(NSObject*)aValue
                           withKey:(NSString*)aKey {
//    if (!aValue || !aKey)
//    {
//        return;
//    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSObject *objc = aValue ; // set value
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:objc];
    [defaults setObject:data forKey:aKey];
    [defaults synchronize];
}
+ (void)clearUserDefaultWithKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

@end
