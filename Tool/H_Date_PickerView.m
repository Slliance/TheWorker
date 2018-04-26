//
//  H_Date_PickerView.m
//  WLT
//
//  Created by cl z on 12-12-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "H_Date_PickerView.h"

@implementation H_Date_PickerView
@synthesize datePicker = _datePicker;
@synthesize backView = _backView;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //init backgroundcolor
        self.backgroundColor = [UIColor clearColor];
        
        UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.7;
        [self addSubview:backView];
        
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, ScreenHeight,ScreenWidth, 216)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker setMinimumDate:[NSDate date]];
        [_datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        _datePicker.backgroundColor = [UIColor whiteColor];
        [self addSubview:_datePicker];
        
        //add btn
        _backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 50)];
        [_backView setUserInteractionEnabled:YES];
        [_backView setImage:[UIImage imageNamed:@"H_back"]];
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 6, 60, 38)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"H_btn_1"] forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"H_btn_2"] forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:cancelBtn];
        
        UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(250, 6, 60, 38)];
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [doneBtn setBackgroundImage:[UIImage imageNamed:@"H_btn_1"] forState:UIControlStateNormal];
        [doneBtn setBackgroundImage:[UIImage imageNamed:@"H_btn_2"] forState:UIControlStateHighlighted];
        [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:doneBtn];
        
        [self addSubview:_backView];
        
        [UIView animateWithDuration:0.3 animations:^{
            [_datePicker setFrame:CGRectMake(0, ScreenHeight - 216 - 64, ScreenWidth, 216)];
            [_backView setFrame:CGRectMake(0, ScreenHeight - 216 - 50 - 64, ScreenWidth, 50)];
        } completion:^(BOOL finished) {
            
        }];
    }
    return self;
}

#pragma mark - Custom Methods
-(void)cancelAction
{
    [UIView animateWithDuration:0.3 animations:^{
        [_datePicker setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 216)];
        [_backView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 50)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)doneAction
{
    [UIView animateWithDuration:0.3 animations:^{
        [_datePicker setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 216)];
        [_backView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 50)];
    } completion:^(BOOL finished) {
        [self.delegate getSelect:self date:[NSString stringWithFormat:@"%@",_datePicker.date]];
        [self removeFromSuperview];
    }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    if (p.y < 200) {
        [UIView animateWithDuration:0.3 animations:^{
            [_datePicker setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 216)];
            [_backView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 50)];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}
@end
