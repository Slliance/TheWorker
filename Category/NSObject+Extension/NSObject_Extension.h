//
//  NSObject_Extension.h
//  kuaiyonggong
//
//  Created by vic.hu on 15/8/27.
//  Copyright (c) 2015年 vic.hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject_Extension : NSObject
+(NSString*)DataTOjsonString:(id)object;
+(BOOL)isValidateIdentityCard:(NSString *)identityCard;
+(BOOL)isValidtePhone:(NSString *)phone;

//网址判断
+(BOOL)isValidteHttpUrl:(NSString *)url;
+(BOOL)isValidteRightPWd:(NSString *)password;
@end
