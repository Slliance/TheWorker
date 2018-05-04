//
//  NSDate+Additional.h
//  SupplierApp
//
//  Created by 张舒 on 17/2/21.
//  Copyright © 2017年 liujianzhong. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const XJDateFormat_y_M_d;          ///< 格式化类型 yyyy-MM-dd
extern NSString *const XJDateFormat_H_m_s;          ///< 格式化类型 HH:mm:ss
extern NSString *const XJDateFormat_h_m_s;          ///< 格式化类型 hh:mm:ss
extern NSString *const XJDateFormat_y_M_d_H_m_s;    ///< 格式化类型 yyyy-MM-dd HH:mm:ss
extern NSString *const XJDateFormat_y_M_d_h_m_s;    ///< 格式化类型 yyyy-MM-dd hh:mm:ss
extern NSString *const XJDateFormat_yMd;            ///< 格式化类型 yyyyMMdd
extern NSString *const XJDateFormat_zh_y_M_d;       ///< 格式化类型 yyyy年MM月dd日
extern NSString *const XJDateFormat_zh_y_M_d_H_m_s; ///< 格式化类型 yyyy年MM月dd日 HH:mm:ss
extern NSString *const XJDateFormat_zh_y_M_d_h_m_s; ///< 格式化类型 yyyy年MM月dd日 hh:mm:ss
extern NSString *const XJDateFormat_MD;             ///< 格式化类型 MM.dd
typedef NS_ENUM(NSInteger, XJWeekDay) {
    XJWeekDaySun = 1,        ///< 星期天
    XJWeekDayMon,            ///< 星期一
    XJWeekDayTues,           ///< 星期二
    XJWeekDayWed,            ///< 星期三
    XJWeekDayThurs,          ///< 星期四
    XJWeekDayFri,            ///< 星期五
    XJWeekDaySat,            ///< 星期六
};

@interface NSDate (Additional)

///  根据时间格式将时间转换成字符串（类方法）
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;


/**
 *  @brief  获取年月日字符串
 *
 *  @param
 *
 *  @return NSString 比如19871127
 */
- (NSString *)getFormatYearMonthDay;

/**
 *  日期转字符串 转换的格式yyyy-MM-dd
 *
 *  @param str 日期
 *
 *  @return 格式化字符串
 */
+ (NSString *)stringWithDateFromString:(NSString *)str;
+(NSString *)stringWithDateFromString:(NSString *)str toDateFormat: (NSString *) dateFormat;
/**
 *  获取当前日期所在的年
 *
 *  @return str
 */
- (NSString *)getYear;

/**
 *  获取当前日期所在的月份
 *
 *  @return 1～12
 */
- (NSString *)getMonth;
/**
 *  @brief  获取日
 *
 *  @param
 *
 *  @return NSinteger
 */
- (NSUInteger)getDay;
/**
 *  24小时制 日期转字符串 转换的格式yyyy-MM-dd HH:mm:ss
 *
 *  @param date 日期
 *
 *  @return 格式化字符串
 */

/**
 *  获取当前日期在年份中的第几周
 *
 *  @return 1～53
 */
- (NSString *)getWeekOfYear;

/**
 *  返回week周后，周的第一天。
 *
 *  @param week 周
 *
 *  @return NSDate
 */
- (NSDate *)firstDayOfWeekByAddingWeek:(NSInteger)week;

/**
 *  返回week周后，周的最后一天。
 *
 *  @param week 周
 *
 *  @return NSDate
 */
- (NSDate *)lastDayOfWeekByAddingWeek:(NSInteger)week;
/**
 *  返回时间加上day天后的时间。day>0,是fabs(day)天后的时间, day<0, 是fabs(day)天前的时间
 *
 *  @param day 天
 *
 *  @return NSDate
 */
- (NSDate *)dateByAddingDay:(NSInteger)day;

/**
 *  返回时间加上day天后的时间。day>0,是fabs(day)天后的时间, day<0, 是fabs(day)天前的时间
 *
 *  @param day 天
 *
 *  @return NSDate
 */
- (NSDate *)dateByAddingSecond:(NSInteger)second;
/**
 *  返回时间加上week周后的时间。week>0,是fabs(week)周后的时间, week<0, 是fabs(week)周前的时间
 *
 *  @param week 周
 *
 *  @return NSDate
 */
- (NSDate *)dateByAddingWeek:(NSInteger)week;

/**
 *  返回时间加上month月后的时间。month>0,是fabs(month)月后的时间, month<0, 是fabs(month)月前的时间
 *
 *  @param month 月
 *
 *  @return NSDate
 */
- (NSDate *)dateByAddingMonth:(NSInteger)month;
/**
 *  返回week周后的星期几的时间。
 *
 *  @param weekday 星期几
 *  @param week    周
 *
 *  @return NSDate
 */
- (NSDate *)weekday:(XJWeekDay)weekday byAddingWeek:(NSInteger)week;
/**
 *  获取当前日期在这周中的第几天
 *
 *  @return 1～7，周末为1
 */
- (NSString *)getDayOfWeek;
/**
 *  把时间格式化为一个指定格式的字符串
 *
 *  @param dateFormat 格式化样式
 *
 *  @return 格式化后的字符串
 */
- (NSString *)stringWithDateFormat:(NSString *)dateFormat;
#pragma mark 时间差
/**
 *  计算时间相差天数
 *
 *  @param anotherDate 比较的时间
 *
 *  @return 天数
 */
- (NSInteger)dayNumberSinceDate:(NSDate *)anotherDate;

/**
 *  计算时间相差周数
 *
 *  @param anotherDate 比较的时间
 *
 *  @return 周数
 */
- (NSInteger)weekNumberSinceDate:(NSDate *)anotherDate;

/**
 *  计算时间相差月数
 *
 *  @param anotherDate 比较的时间
 *
 *  @return 月数
 */
- (NSInteger)monthNumberSinceDate:(NSDate *)anotherDate;

/**
 *  计算时间相差年数
 *
 *  @param anotherDate 比较的时间
 *
 *  @return 年数
 */
- (NSInteger)yearNumberSinceDate:(NSDate *)anotherDate;

/**
 *  计算指定单位内的时间相差值
 *
 *  @param unitFlags   时间相差单位
 *  @param anotherDate 比较的单位
 *
 *  @return 单位内时间相差值
 */
- (NSDateComponents *)components:(NSCalendarUnit)unitFlags sinceDate:(NSDate *)anotherDate;
#pragma mark - 日期时间运算
/**
 *  清楚格式化样式以外的时间
 *
 *  @param dateFormat 格式化样式
 *
 *  @return 时间
 */
- (NSDate *)dateByCleaningDateFormat:(NSString *)dateFormat;

/**
 *  格式化样式内的时间比较
 *
 *  @param anotherDate  比较时间
 *  @param dateFormat   格式化样式
 *
 *  @return 比较结果
 */
- (NSComparisonResult)compare:(NSDate *)anotherDate withDateFormat:(NSString *)dateFormat;

/**
 *  返回month月后，月的第一天。
 *
 *  @param month 月
 *
 *  @return NSDate
 */
- (NSDate *)firstDayOfMonthByAddingMonth:(NSInteger)month;

/**
 *  返回month月后，月的最后一天。
 *
 *  @param month 月
 *
 *  @return NSDate
 */
- (NSDate *)lastDayOfMonthByAddingMonth:(NSInteger)month;
/**
 *  date字符串化
 *
 *  @param format 时间格式
 *
 *  @return 字符串时间
 */
- (NSString *)stringWithFormat:(NSString *)format;
@end
