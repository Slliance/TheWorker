//
//  CallPhoneSingleton.m
//  TheArtist
//
//  Created by yanghao on 16/5/8.
//  Copyright © 2016年 wikj. All rights reserved.
//

#import "CallPhoneSingleton.h"

@implementation CallPhoneSingleton
+ (CallPhoneSingleton *)sharedManager
{
    static CallPhoneSingleton *sharedSimpleManageInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedSimpleManageInstance = [[self alloc] init];
    });
    return sharedSimpleManageInstance;
}
/**
 *  拨打电话
 */
-(void)callPhoneWithPhoneNum:(NSString *)phoneNum
{
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"telprompt:%@",phoneNum]];
    [[UIApplication sharedApplication] openURL:url];
}

@end
