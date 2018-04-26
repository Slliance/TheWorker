//
//  CustomTool.h
//  Sotao
//
//  Created by huzhu on 11/10/14.
//  Copyright (c) 2014 搜淘APP. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CustomTool: NSObject

+(BOOL)showImageAtWiFi;
#pragma mark 身份证验证
+(BOOL)isValidateIdentityCard:(NSString *)identityCard;
#pragma mark 电话验证
+(BOOL)isValidtePhone:(NSString *)phone;
#pragma mark 电子邮箱
+(BOOL)isValidteEmail:(NSString *)email;
#pragma mark 字母数字组合密码
+(BOOL)isValidtePassword:(NSString *)password;
+(void)umengEvent:(NSString *)eventId;

+(NSString *)getAdviserName:(NSString *)name;

+(NSString *)getNotNullString:(NSString *)string;
@end

@interface NSDate (SotaoExtention)
+ (NSDate *)dateFromeString:(NSString *)dateString;
+(NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate;
+(NSString *)getUTCFormateLocalDate:(NSString *)localDate;
+(NSString *)getSTTimeStringFromDateStr:(NSString *)dateStr;
- (NSString *)MM_DD_hh_mm;

- (NSString *)minuteDescription;
@end
