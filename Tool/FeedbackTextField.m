//
//  FeedbackTextField.m
//  NewSale
//
//  Created by 苏晓凯 on 2017/3/27.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "FeedbackTextField.h"

@interface FeedbackTextField()
@property (nonatomic, weak) UILabel *placeholderLabel;
@end


@implementation FeedbackTextField

- (UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
        UILabel *placeholderLabel = [[UILabel alloc]init];
//        placeholderLabel.frame.origin.x = 4;
        
    }
    return _placeholderLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        /**
         *  初始化的时候为属性设置默认值
         */
        self.placeholder      = @"请输入文字";
        self.placeholderColor = [UIColor lightGrayColor];
        self.placeholderFont  = [UIFont systemFontOfSize:14];
        [self.placeholderLabel setText:self.placeholder];
        /**
         *  用textVeiw添加通知，当textView发生变化的时候会调用textChanged方法
         */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

#pragma mark -- 重绘(为textVeiw加上placeholder) --
- (void)drawRect:(CGRect)rect {
    //如果文字消失了就会绘制placeholder
    if (self.text.length == 0) {
        CGRect placeholderRect = CGRectZero;
        placeholderRect.origin.x = 15;
        placeholderRect.origin.y = 5    ;
        placeholderRect.size.width = self.frame.size.width-30;
        placeholderRect.size.height = 15;
        [self.placeholder drawInRect:placeholderRect withAttributes:@{
                                                                      NSFontAttributeName:_placeholderFont,
                                                                      NSForegroundColorAttributeName:_placeholderColor
                                                                      }];
    }
    [super drawRect:rect];
}

#pragma mark -- 文字改变的时候会调用该方法
- (void)textChanged:(NSNotification *)notification {
    /**
     *  在文字改变的时候就重绘
     */
    [self setNeedsDisplay];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
