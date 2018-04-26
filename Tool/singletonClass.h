//
//  singletonClass.h
//  kuaiyonggong
//
//  Created by vic.hu on 15/8/21.
//  Copyright (c) 2015年 vic.hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UILabel_Extension.h"
#import "NSString+Extension.h"

@interface singletonClass : NSObject
+ (singletonClass *)sharedManager;
- (id)getStrByNull:(id)thestr;
-(NSString*)base64Encode:(NSData *)data;




-(void)updateUserInfoWithKey:(NSString *)key value:(id)value;
-(void)updateUserDataInfoWithKey:(NSString *)key value:(id)value;

-(CGRect)getLabelWidthWithLabel:(UILabel *)label;
-(CGRect)getLabelWidthWithLabel:(UILabel *)label width:(CGFloat)width;
-(CGRect)getLabelHeightWithLabel:(UILabel *)label;
-(CGRect)getLabelHeightWithLabelWidth:(UILabel *)label maxWidth:(CGFloat)maxWidth;
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate ;
-(NSString *)getYearMonthDay:(NSDate *)senddate;
-(NSString *)getHourMinuteSecond:(NSDate *)senddate;
-(NSString *)getAreaCodeWithState:(NSString *)state city:(NSString *)city;

-(NSString *)shareFailErrorCode:(NSInteger)errorCode;
@end
