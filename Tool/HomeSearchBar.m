//
//  HomeSearchBar.m
//  NewSale
//
//  Created by 苏晓凯 on 2017/3/24.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HomeSearchBar.h"

@implementation HomeSearchBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 29)];
        self.font = [UIFont systemFontOfSize:13];
        self.textColor = UIColorFromRGB(0xc5c5c5);
        self.placeholder = @"请输入关键字";
        self.backgroundColor = UIColorFromRGB(0xffffff);
        // 提前在Xcode上设置图片中间拉伸
//        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
//        
        // 通过init初始化的控件大多都没有尺寸
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"icon_serach"];
        // contentMode：default is UIViewContentModeScaleToFill，要设置为UIViewContentModeCenter：使图片居中，防止图片填充整个imageView
        searchIcon.contentMode = UIViewContentModeCenter;
        [searchIcon setFrame:CGRectMake(10, 0, 40, 15)];
        
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

+(instancetype)searchBar
{
    return [[self alloc] init];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
