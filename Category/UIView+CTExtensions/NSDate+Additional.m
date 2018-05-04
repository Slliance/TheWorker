//
//  NSDate+Additional.m
//  SupplierApp
//
//  Created by 张舒 on 17/2/21.
//  Copyright © 2017年 liujianzhong. All rights reserved.
//

#import "NSDate+Additional.h"


NSString *const XJDateFormat_y_M_d = @"yyyy-MM-dd";      ///< 格式化类型 yyyy-MM-dd
NSString *const XJDateFormat_H_m_s = @"HH:mm:ss";        ///< 格式化类型 HH:mm:ss
NSString *const XJDateFormat_h_m_s = @"hh:mm:ss";        ///< 格式化类型 hh:mm:ss
NSString *const XJDateFormat_y_M_d_H_m_s = @"yyyy-MM-dd HH:mm:ss";   ///< 格式化类型 yyyy-MM-dd HH:mm:ss
NSString *const XJDateFormat_y_M_d_h_m_s = @"yyyy-MM-dd hh:mm:ss";   ///< 格式化类型 yyyy-MM-dd hh:mm:ss
NSString *const XJDateFormat_yMd = @"yyyyMMdd";                      ///< 格式化类型 yyyyMMdd
NSString *const XJDateFormat_zh_y_M_d = @"yyyy年MM月dd日";            ///< 格式化类型 yyyy年MM月dd日
NSString *const XJDateFormat_zh_y_M_d_H_m_s = @"yyyy年MM月dd日 HH:mm:ss";   ///< 格式化类型 yyyy年MM月dd日 HH:mm:ss
NSString *const XJDateFormat_zh_y_M_d_h_m_s = @"yyyy年MM月dd日 hh:mm:ss";   ///< 格式化类型 yyyy年MM月dd日 hh:mm:ss
NSString *const XJDateFormat_MD = @"MM.dd"; ///< 格式化类型 MM.dd
@implementation NSDate (Additional)
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    NSTimeZone *timeZone = [[NSTimeZone alloc] init];
    timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSTimeInterval interval = [timeZone secondsFromGMT];
    NSDate *GMTDate = [date dateByAddingTimeInterval:-interval];
    return [GMTDate stringWithFormat:format];
}
// 获取年月日如:19871127.
- (NSString *)getFormatYearMonthDay
{
    NSString *string = [NSString stringWithFormat:@"%lu%02lu%02lu",(unsigned long)[self getYear],(unsigned long)[self getMonth],(unsigned long)[self getDay]];
    return string;
}
+(NSString *)stringWithDateFromString:(NSString *)str{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyyMMdd"; // HH:mm:ss
    NSDate *createDate = [format dateFromString:str];
    
    format.dateFormat = @"yyyy-MM-dd";  // HH:mm
    return [format stringFromDate:createDate];
}

+(NSString *)stringWithDateFromString:(NSString *)str toDateFormat: (NSString *) dateFormat{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyyMMdd"; // HH:mm:ss
    NSDate *createDate = [format dateFromString:str];
    
    format.dateFormat = dateFormat;  // HH:mm
    return [format stringFromDate:createDate];
}
- (NSString *)getYear
{
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateFormat = @"yyyy";
    //NSString *year = [dateFormatter stringFromDate:self];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self];
    NSString *year = [@(components.year) stringValue];
    
    return year;
}
- (NSString *)getMonth
{
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateFormat = @"M";
    //NSString *month = [dateFormatter stringFromDate:self];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self];
    //    NSString *month = [@(components.month) stringValue];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithInt: components.month]];
    string = [NSString stringWithFormat:@"%@月",string];
    return string;
}
// 获取日
- (NSUInteger)getDay{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitDay) fromDate:self];
    return [dayComponents day];
    
}

- (NSString *)getWeekOfYear
{
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateFormat = @"w";
    //NSString *week = [dateFormatter stringFromDate:self];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekOfYear fromDate:self];
    //    NSString *week = [@(components.weekOfYear) stringValue];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithInt: components.weekOfYear]];
    string = [NSString stringWithFormat:@"第%@周",string];
    return string;
}

- (NSDate *)firstDayOfWeekByAddingWeek:(NSInteger)week
{
    NSDate *startDate;              /// 单位内地开始时间
    NSTimeInterval intervalLength;  /// 单位内的时间长度 秒
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [self dateByAddingWeek:week];
    
    BOOL flag = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&startDate interval:&intervalLength forDate:date];
    
    if (!flag) {
        startDate = nil;
    }
    return date;
}

- (NSDate *)lastDayOfWeekByAddingWeek:(NSInteger)week
{
    NSDate *date = [self firstDayOfWeekByAddingWeek:(week + 1)];
    if (date) {
        date = [date dateByAddingDay:-1];
    }
    return date;
}
- (NSDate *)dateByAddingDay:(NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = day;
    return [calendar dateByAddingComponents:components toDate:self options:0];
}
-(NSDate *)dateByAddingSecond:(NSInteger)second{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.second = second;
    return [calendar dateByAddingComponents:components toDate:self options:0];
}
- (NSDate *)dateByAddingWeek:(NSInteger)week
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = week * 7;
    return [calender dateByAddingComponents:components toDate:self options:0];
}
- (NSDate *)dateByAddingMonth:(NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:self];
    components.month = components.month + month;
    return [calendar dateFromComponents:components];
}
- (NSDate *)weekday:(XJWeekDay)weekday byAddingWeek:(NSInteger)week
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday fromDate:self];
    components.day = components.day + week * 7;
    components.day = components.day - components.weekday + weekday;
    return [calendar dateFromComponents:components];
}
- (NSString *)getDayOfWeek
{
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateFormat = @"e";
    //NSString *day = [dateFormatter stringFromDate:self];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:self];
    NSString *day = [@(components.weekday) stringValue];
    
    return day;
}
- (NSString *)stringWithDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return [dateFormatter stringFromDate:self];
}
#pragma mark 时间差
- (NSInteger)dayNumberSinceDate:(NSDate *)anotherDate
{
    NSDate *dateSelf = [self dateByCleaningDateFormat:XJDateFormat_yMd];
    NSDate *dateAnother = [anotherDate dateByCleaningDateFormat:XJDateFormat_yMd];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:dateAnother toDate:dateSelf options:0];
    return components.day;
}

- (NSInteger)weekNumberSinceDate:(NSDate *)anotherDate
{
    NSDate *dateSelf = [self dateByCleaningDateFormat:XJDateFormat_yMd];
    NSDate *dateAnother = [anotherDate dateByCleaningDateFormat:XJDateFormat_yMd];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekOfMonth fromDate:dateAnother toDate:dateSelf options:0];
    return components.weekOfMonth;
}

- (NSInteger)monthNumberSinceDate:(NSDate *)anotherDate
{
    NSDate *dateSelf = [self dateByCleaningDateFormat:@"yyyyMM"];
    NSDate *dateAnother = [anotherDate dateByCleaningDateFormat:@"yyyyMM"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:dateAnother toDate:dateSelf options:0];
    return components.month;
}

- (NSInteger)yearNumberSinceDate:(NSDate *)anotherDate
{
    NSInteger yearSelf = [self getYear].integerValue;
    NSInteger yearAnother = [anotherDate getYear].integerValue;
    
    return yearSelf - yearAnother;
}

- (NSDateComponents *)components:(NSCalendarUnit)unitFlags sinceDate:(NSDate *)anotherDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:anotherDate toDate:self options:0];
    return components;
}
#pragma mark - 日期时间运算
- (NSDate *)dateByCleaningDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    NSString *string = [dateFormatter stringFromDate:self];
    return [dateFormatter dateFromString:string];
}

- (NSComparisonResult)compare:(NSDate *)anotherDate withDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    NSDate *selfDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:self]];
    NSDate *otherDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:anotherDate]];
    return [selfDate compare:otherDate];
}
- (NSDate *)firstDayOfMonthByAddingMonth:(NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:self];
    components.month = components.month + month;
    components.day = 1;
    return [calendar dateFromComponents:components];
}

- (NSDate *)lastDayOfMonthByAddingMonth:(NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:self];
    components.month = components.month + month + 1;
    components.day = 0;
    return [calendar dateFromComponents:components];
}

- (NSString *)stringWithFormat:(NSString *)format
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    
    NSString *retStr = [outputFormatter stringFromDate:self];
    
    return retStr;
}
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format
{
    return [date stringWithFormat:format];
}

@end

