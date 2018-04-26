//
//  DeleteButton.m
//  NewSale
//
//  Created by 苏晓凯 on 2017/3/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "DeleteButton.h"
@implementation DeleteButton
{
    CGRect boundingRect;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//自定义的初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {

        [self setTitle:@"删除" forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];

    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat imageX=20;
    CGFloat imageY=34;
    CGFloat width=24;
    CGFloat height=24;
    return CGRectMake(imageX, imageY, width, height);
    
}
//2.改变title文字的位置,构造title的矩形即可
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    CGFloat imageX=20;
    CGFloat imageY=60;
    CGFloat width=40;
    CGFloat height=25;
    return CGRectMake(imageX, imageY, width, height);
    
}
@end
