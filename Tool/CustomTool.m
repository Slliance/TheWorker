//
//  CustomTool.m
//  Sotao
//
//  Created by huzhu on 11/10/14.
//  Copyright (c) 2014 搜淘APP. All rights reserved.
//

#import "CustomTool.h"
#define DEFAULT_VOID_COLOR [UIColor whiteColor]


@implementation CustomTool


+(NSString *)getNotNullString:(NSString *)string{
    if (string == nil || [string isKindOfClass:[NSNull class]]) {
        string = @"";
    }
    return string;
}

+(NSString *)getAdviserName:(NSString *)name{
    NSString *nameStr = name;
    if ([nameStr isKindOfClass:[NSNull class]] || [nameStr isEqualToString:@""] || nameStr == nil || [nameStr isEqualToString:@"搜小淘"]) {
        nameStr = @"搜小淘";
    }else{
        NSRange range = [nameStr rangeOfString:@"楼盘分析师"];
        if (range.location == NSNotFound) {
            nameStr = [NSString stringWithFormat:@"%@(楼盘分析师)",nameStr];
        }
    }
    return nameStr;
}

+(void)umengEvent:(NSString *)eventId{
    [self umengEvent:eventId attributes:nil number:[NSNumber numberWithInteger:1]];
}

+(void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes number:(NSNumber *)number{
    NSString *numberKey = @"__ct__";
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [mutableDictionary setObject:[number stringValue] forKey:numberKey];
//    [MobClick event:eventId attributes:mutableDictionary];
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
    NSString *regex = @"^(1[1-9][0-9])\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:phone];
    if (phone.length == 11 && [pred evaluateWithObject:phone]) {
        isMatch = YES;
    }
    else{
        isMatch = NO;
    }
    return isMatch;
}

+(BOOL)isValidteEmail:(NSString *)email
{
    //w 英文字母或数字的字符串，和 [a-zA-Z0-9] 语法一样
    NSString *tmpRegex = @"^[\\w-]+@[\\w-]+\\.(com|net|org|edu|mil|tv|biz|info)$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:email];
}

+(BOOL)isValidtePassword:(NSString *)password{
    
    //6-20位字母数字组合密码
    NSString *tmpRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:password];
}
@end


@implementation NSDate (SotaoExtention)

+ (NSDate *)dateFromeString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

+(NSString *)getUTCFormateLocalDate:(NSString *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:localDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}

+(NSString *)getSTTimeStringFromDateStr:(NSString *)dateStr{
    if (dateStr == nil || [dateStr isKindOfClass:[NSNull class]] || [dateStr length]<20) {
        return @"";
    }
    NSMutableString *timeStr = [dateStr mutableCopy];
    [timeStr replaceOccurrencesOfString:@"T" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, [timeStr length])];
    NSDate *date = [NSDate dateFromeString:[timeStr substringToIndex:19]];
    return [date minuteDescription];
    
}

+(NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate
{
//    utcDate = @"2015-04-14T16:50:52.7385+08:00";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];

    return dateString;
}


- (NSString *)MM_DD_hh_mm
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    return [formatter stringFromDate:self];
}



/*精确到分钟的日期描述*/
- (NSString *)minuteDescription
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *theDay = [dateFormatter stringFromDate:self];//日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    if ([theDay isEqualToString:currentDay]) {//当天
        [dateFormatter setDateFormat:@"HH:mm"];
        return [dateFormatter stringFromDate:self];
    } else if ([self isThisYear]) {//以前
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        return [dateFormatter stringFromDate:self];
    }else{
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [dateFormatter stringFromDate:self];
    }
}
//- (NSString *)minuteDescription
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    
//    NSString *theDay = [dateFormatter stringFromDate:self];//日期的年月日
//    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
//    if ([theDay isEqualToString:currentDay]) {//当天
//        [dateFormatter setDateFormat:@"ah:mm"];
//        return [dateFormatter stringFromDate:self];
//    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == 86400) {//昨天
//        [dateFormatter setDateFormat:@"ah:mm"];
//        return [NSString stringWithFormat:@"昨天 %@", [dateFormatter stringFromDate:self]];
//    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] < 86400 * 7) {//间隔一周内
//        [dateFormatter setDateFormat:@"EEEE ah:mm"];
//        return [dateFormatter stringFromDate:self];
//    } else if ([self isThisYear]) {//以前
//        [dateFormatter setDateFormat:@"MM-dd ah:mm"];
//        return [dateFormatter stringFromDate:self];
//    }else{
//        [dateFormatter setDateFormat:@"yyyy-MM-dd ah:mm"];
//        return [dateFormatter stringFromDate:self];
//    }
//}



- (BOOL) isSameYearAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:aDate];
    return (components1.year == components2.year);
}

- (BOOL) isThisYear
{
    // Thanks, baspellis
    return [self isSameYearAsDate:[NSDate date]];
}


@end
