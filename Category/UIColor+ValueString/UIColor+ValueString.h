//
//  UIColor+ValueString.h
//  Analyst
//
//  Created by vic.hu on 15/5/6.
//  Copyright (c) 2015年 vic.hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(Extension)
+ (UIColor *)colorWithHexString:(NSString *) stringToConvert;
+ (UIColor *)colorWithHexString:(NSString *) stringToConvert alpha:(CGFloat)alpha;
@end
