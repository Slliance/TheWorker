//
//  H_YearMonthDay_PickerView.m
//  JJRC
//
//  Created by cl z on 13-1-25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "H_YearMonthDay_PickerView.h"

@implementation H_YearMonthDay_PickerView
@synthesize pickerView = _pickerView,backView = _backView,delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.3f;
        [self addSubview:backView];
        
        yearMuArr = [[NSMutableArray  alloc]init];
        for (int i = 1900; i < 2200; i ++) {
            [yearMuArr addObject:[NSString stringWithFormat:@"%i 年",i]];
        }
        monthMuArr = [[NSMutableArray alloc] init];
        for (int i = 1; i <=12; i++) {
            [monthMuArr addObject:[NSString stringWithFormat:@"%i 月",i]];
        }
        dayMuArr = [[NSMutableArray alloc] init];
        for (int i = 1; i <=31; i++) {
            [dayMuArr addObject:[NSString stringWithFormat:@"%i 日",i]];
        }
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 216)];
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_pickerView];
        
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
        
        UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 60 - 10, 6, 60, 38)];
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [doneBtn setBackgroundImage:[UIImage imageNamed:@"H_btn_1"] forState:UIControlStateNormal];
        [doneBtn setBackgroundImage:[UIImage imageNamed:@"H_btn_2"] forState:UIControlStateHighlighted];
        [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:doneBtn];
        
        [self addSubview:_backView];
        
        [UIView animateWithDuration:0.3 animations:^{
            [_pickerView setFrame:CGRectMake(0, ScreenHeight - 216 - 64, ScreenWidth, 216)];
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
        [_pickerView setFrame:CGRectMake(0,ScreenHeight - 64, ScreenWidth, 216)];
        [_backView setFrame:CGRectMake(0, ScreenHeight - 64, ScreenWidth, 50)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)doneAction
{
    [UIView animateWithDuration:0.3 animations:^{
        [_pickerView setFrame:CGRectMake(0, ScreenHeight - 64, ScreenWidth, 216)];
        [_backView setFrame:CGRectMake(0, ScreenHeight - 64, ScreenWidth, 50)];
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        NSString *year = [[yearMuArr objectAtIndex:[_pickerView selectedRowInComponent:0]] substringToIndex:4];
        NSString *month = [[monthMuArr objectAtIndex:[_pickerView selectedRowInComponent:1]] substringWithRange:NSMakeRange(0, 2)];
        NSString *day = [[dayMuArr objectAtIndex:[_pickerView selectedRowInComponent:2]] substringWithRange:NSMakeRange(0, 2)];
        month =  [month stringByReplacingOccurrencesOfString:@" " withString:@""];
        [self.delegate getYearMonthDay:self date:[NSString stringWithFormat:@"%@-%@-%@",year,month,day]];
        [self removeFromSuperview];
    }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    if (p.y < ScreenHeight - 216 - 64 - 50) {
        [UIView animateWithDuration:0.3 animations:^{
            [_pickerView setFrame:CGRectMake(0, ScreenHeight - 64, ScreenWidth, 216)];
            [_backView setFrame:CGRectMake(0, ScreenHeight - 64, ScreenWidth, 50)];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}
-(void)setSelectedRowInYearAndMonth:(NSInteger)_yearIndex monthIndex:(NSInteger)_monthIndex dayIndex:(NSInteger)_dayIndex{
    [_pickerView selectRow:_yearIndex inComponent:0 animated:NO];
    [_pickerView selectRow:_monthIndex inComponent:1 animated:NO];
    [_pickerView selectRow:_dayIndex inComponent:2 animated:NO];
}
#pragma mark - UIPickerViewDelegate


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (component == 0) {
        view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        UILabel *labelOnComponent=[[UILabel alloc] initWithFrame:view.frame];
        labelOnComponent.font = [UIFont fontWithName:@"Helvetica" size:13];
        labelOnComponent.backgroundColor = [UIColor clearColor];
        labelOnComponent.text = [yearMuArr objectAtIndex:row];
        labelOnComponent.textAlignment = NSTextAlignmentCenter;
        [view addSubview:labelOnComponent];
        view.backgroundColor = [UIColor clearColor];
    }
    if (component == 1) {
        view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        UILabel *labelOnComponent=[[UILabel alloc] initWithFrame:view.frame];
        labelOnComponent.font = [UIFont fontWithName:@"Helvetica" size:14];
        labelOnComponent.backgroundColor = [UIColor clearColor];
        labelOnComponent.text = [monthMuArr objectAtIndex:row];
        labelOnComponent.textAlignment = NSTextAlignmentCenter;
        [view addSubview:labelOnComponent];
        view.backgroundColor = [UIColor clearColor];
    }
    if (component == 2) {
        view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        UILabel *labelOnComponent=[[UILabel alloc] initWithFrame:view.frame];
        labelOnComponent.font = [UIFont systemFontOfSize:13];
        labelOnComponent.backgroundColor = [UIColor clearColor];
        labelOnComponent.text = [dayMuArr objectAtIndex:row];
        labelOnComponent.textAlignment = NSTextAlignmentCenter;
        [view addSubview:labelOnComponent];
        view.backgroundColor = [UIColor clearColor]; 
    }
    return view;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 1 || component == 0) { 
        [_pickerView reloadComponent:2];
        
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    int row;
    switch (component) {
        case 0:
        {
            row = 300;
        }
            break;       
        case 1:
        {
            row = 12;
        }
            break;    
            
        default:
        {
            NSInteger currMonth = [[[monthMuArr objectAtIndex:[_pickerView selectedRowInComponent:1]] substringToIndex:1]intValue];
            if (currMonth == 1 || currMonth == 3 || currMonth == 5 ||currMonth == 7 || currMonth == 8 || currMonth == 10 ||currMonth == 12) {
                row = 31;
            }
            else if (currMonth == 2) {
                NSInteger currYear = [[[yearMuArr objectAtIndex:[_pickerView selectedRowInComponent:0]] substringToIndex:4] intValue];
                if (currYear % 4 == 0) {
                    row = 29;
                }
                else
                {
                    row = 28;
                }
            }
            else
            {
                row = 30;
            }
        }
            break;
    }
    
    return row;
}



@end
