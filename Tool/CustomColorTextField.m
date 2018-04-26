//
//  CustomColorTextField.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/11/3.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "CustomColorTextField.h"

@implementation CustomColorTextField

// 重写此方法
-(void)drawPlaceholderInRect:(CGRect)rect {
    // 计算占位文字的 Size
    CGSize placeholderSize = [self.placeholder sizeWithAttributes:
                              @{NSFontAttributeName : self.font}];
    
    [self.placeholder drawInRect:CGRectMake(rect.size.width-placeholderSize.width, (rect.size.height - placeholderSize.height)/2, rect.size.width, rect.size.height) withAttributes:
     @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"666666"],
       NSFontAttributeName : self.font}];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
