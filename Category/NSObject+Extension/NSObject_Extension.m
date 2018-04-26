//
//  NSObject_Extension.m
//  kuaiyonggong
//
//  Created by vic.hu on 15/8/27.
//  Copyright (c) 2015年 vic.hu. All rights reserved.
//

#import "NSObject_Extension.h"

@implementation NSObject_Extension
+(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
#pragma mark 身份证验证
+(BOOL)isValidateIdentityCard:(NSString *)identityCard
{
    NSString *identityCardRegex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", identityCardRegex];
    return [identityCardTest evaluateWithObject:identityCard];
}
#pragma mark 手机号码验证
+(BOOL)isValidtePhone:(NSString *)phone{
    NSString *regex = @"^(13[0-9]|16[0-9]|14[0-9]|15[0-9]|17[0-9]|18[0-9])\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:phone];
    return isMatch;
}
#pragma mark 网址验证

+(BOOL)isValidteHttpUrl:(NSString *)url{
    NSString *regex = @"^([hH][tT]{2}[pP]://|[hH][tT]{2}[pP][sS]://)(([A-Za-z0-9-~]+).)+([A-Za-z0-9-~\\/])+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
}
#pragma mark  密码验证
+(BOOL)isValidteRightPWd:(NSString *)password{
    NSString *regex = @"^[^\u4e00-\u9fa5]{0,}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}
@end
