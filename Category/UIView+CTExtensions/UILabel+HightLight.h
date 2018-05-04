//
//  UILabel+HightLight.h
//  CTRIP_WIRELESS
//
//  Created by Sou Dai on 14-6-25.
//  Copyright (c) 2014年 携程. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UILabel (HightLight)

- (void)highLightTextInRange:(NSRange)range forColor:(UIColor*)color;
//数字高亮
-(void)highLightNumberTextforColor:(UIColor*)color;

//设置下划线，必须先设置text
- (void)setUnderline;
//不设置下划线，必须先设置text
- (void)setNoUnderline;

@end
