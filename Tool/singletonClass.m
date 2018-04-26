//
//  singletonClass.m
//  kuaiyonggong
//
//  Created by vic.hu on 15/8/21.
//  Copyright (c) 2015年 vic.hu. All rights reserved.
//

#import "singletonClass.h"

@implementation singletonClass

+ (singletonClass *)sharedManager
{
    static singletonClass *sharedSimpleManageInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedSimpleManageInstance = [[self alloc] init];
    });
    return sharedSimpleManageInstance;
}
-(NSString*)base64Encode:(NSData *)data
{
    static char base64EncodingTable[64] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
    };
    int length = [data length];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        ixtext += 3;
        charsonline += 4;
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}
- (id)getStrByNull:(id)thestr{
    if ([thestr isKindOfClass:[NSNull class]] || [thestr isEqualToString:@"<null>"] || [thestr isEqual:nil]) {
        return nil;
    }
    else{
        return thestr;
    }
}

-(CGRect)getLabelWidthWithLabel:(UILabel *)label width:(CGFloat)width
{
    CGRect rect = label.frame;
    CGSize size = [label.text sizeWithFont:label.font maxSize:CGSizeMake(width, rect.size.height)];
    rect.size = size;
    
    
    return rect;
}

-(CGRect)getLabelWidthWithLabel:(UILabel *)label
{
    CGRect rect = label.frame;
    CGSize size = [label.text sizeWithFont:label.font maxSize:CGSizeMake(ScreenWidth, rect.size.height)];
    rect.size = size;
    
    
    return rect;
}

-(CGRect)getLabelHeightWithLabel:(UILabel *)label
{
    CGRect rect = label.frame;
    CGSize size = [label.text sizeWithFont:label.font maxSize:CGSizeMake(rect.size.width, 8000)];
    rect.size = size;
    
    
    return rect;
}

-(CGRect)getLabelHeightWithLabelWidth:(UILabel *)label maxWidth:(CGFloat)maxWidth
{
    CGRect rect = label.frame;
    CGSize size = [label.text sizeWithFont:label.font maxSize:CGSizeMake(maxWidth, 8000)];
    rect.size = size;
    
    
    return rect;
}
/**
 *  获取星期几
 *
 *  @param inputDate 时间参数
 *
 *  @return 返回星期字符串
 */
-(NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}
/**
 *  获取年月日
 * */
-(NSString *)getYearMonthDay:(NSDate *)senddate
{
//    NSCalendar  * cal=[NSCalendar  currentCalendar];
//    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
//    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
//    NSInteger year=[conponent year];
//    NSInteger month=[conponent month];
//    NSInteger day=[conponent day];
//    return [NSString  stringWithFormat:@"%4ld-%2ld-%2ld",(long)year,(long)month,(long)day];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd-hh-mm-ss"];
    
    NSString *string_time = [formatter stringFromDate:date];
    NSArray *time = [string_time componentsSeparatedByString:@"-"];
    int value_year = [[time objectAtIndex:0]intValue];
    int value_month = [[time objectAtIndex:1]intValue];
    int value_day = [[time objectAtIndex:2]intValue];

    return [NSString stringWithFormat:@"%d-%d-%d",value_year,value_month,value_day];
}

/**
 *  获取时分秒
 * */
-(NSString *)getHourMinuteSecond:(NSDate *)senddate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd-hh:mm:ss"];
    
    NSString *string_time = [formatter stringFromDate:date];
    NSArray *time = [string_time componentsSeparatedByString:@"-"];
    NSArray *lasttime = [[time lastObject] componentsSeparatedByString:@":"];
    int value_hour = [[lasttime objectAtIndex:0]intValue];
    int value_minute = [[lasttime objectAtIndex:1]intValue];
    int value_second = [[lasttime objectAtIndex:2]intValue];
    [formatter setDateFormat:@"EEEE"];
    NSString *system_time = [[NSString alloc]initWithFormat:@"%d:%2d:%2d",value_hour,value_minute,value_second];
    
    NSLog(@"\nsystem time is %@",system_time);
    return system_time;
}
/**
 *  IOS内部错误码,分享
 * */
-(NSString *)shareFailErrorCode:(NSInteger)errorCode
{
    NSString *errorStr;
    switch (errorCode) {
        case -22003:
            errorStr = @"未安装微信客户端";
            break;
        case -22004:
            errorStr = @"当前微信版本不支持该功能";
            break;
        case -24002:
            errorStr = @"尚未安装QQ";
            break;
        case -24003:
            errorStr = @"当前QQ版本不支持该功能";
            break;
            
        default:
            break;
    }
    return errorStr;
}

@end
