//
//  UIView+Underline.m
//  AgentApp
//
//  Created by liujianzhong on 16/10/24.
//  Copyright © 2016年 liujianzhong. All rights reserved.
//

#import "UIView+Underline.h"

@implementation UIView (Underline)
- (void)drawLineAtX:(CGFloat) x andY:(CGFloat) y{
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(x, y, ScreenWidth - 2*x, 0.5f)];
    viewLine.backgroundColor = DSColorFromHex(0x4D4D4D);
    [self addSubview:viewLine];
}

- (void)drawRightLineAtX:(CGFloat) x andY:(CGFloat) y{
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(x, y, ScreenWidth - x, 0.5f)];
    viewLine.backgroundColor = DSColorFromHex(0x4D4D4D);
    [self addSubview:viewLine];
}
@end
