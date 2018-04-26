//
//  H_YearMonth_PickerView.m
//  JJRC
//
//  Created by cl z on 13-1-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "H_YearMonth_PickerView.h"

@implementation H_YearMonth_PickerView
@synthesize pickerView = _pickerView,backView = _backView,delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.0f;
        yearMuArr = [[NSMutableArray  alloc]init];
        for (int i = 1900; i < 2200; i ++) {
            [yearMuArr addObject:[NSString stringWithFormat:@"%i 年",i]];
        }
        monthMuArr = [[NSMutableArray alloc] init];
        for (int i = 1; i <=12; i++) {
            [monthMuArr addObject:[NSString stringWithFormat:@"%i 月",i]];
        }
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 244+216,320, 216)];
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [self addSubview:_pickerView];
        
        //add btn
        _backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 244+216, 320, 50)];
        [_backView setUserInteractionEnabled:YES];
        [_backView setImage:[UIImage imageNamed:@"H_back.png"]];
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 6, 60, 38)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"H_btn_1.png"] forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"H_btn_2.png"] forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:cancelBtn];
        
        UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(250, 6, 60, 38)];
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [doneBtn setBackgroundImage:[UIImage imageNamed:@"H_btn_1.png"] forState:UIControlStateNormal];
        [doneBtn setBackgroundImage:[UIImage imageNamed:@"H_btn_2.png"] forState:UIControlStateHighlighted];
        [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:doneBtn];
        
        [self addSubview:_backView];
        
        [UIView animateWithDuration:0.3 animations:^{
            [_pickerView setFrame:CGRectMake(0, 244, 320, 216)];
            [_backView setFrame:CGRectMake(0, 244-50, 320, 50)];
            self.alpha = 0.8f;
        } completion:^(BOOL finished) {
            
        }];    

        
    }
    return self;
}

#pragma mark - Custom Methods
-(void)cancelAction
{
    [UIView animateWithDuration:0.3 animations:^{
        [_pickerView setFrame:CGRectMake(0, 244+216, 320, 216)];
        [_backView setFrame:CGRectMake(0, 244+216, 320, 50)];
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)doneAction
{
    [UIView animateWithDuration:0.3 animations:^{
        [_pickerView setFrame:CGRectMake(0, 244+216, 320, 216)];
        [_backView setFrame:CGRectMake(0, 244+216, 320, 50)];
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        NSString *year = [[yearMuArr objectAtIndex:[_pickerView selectedRowInComponent:0]] substringToIndex:4];
        NSString *month = [[monthMuArr objectAtIndex:[_pickerView selectedRowInComponent:1]] substringWithRange:NSMakeRange(0, 2)];
        month =  [month stringByReplacingOccurrencesOfString:@" " withString:@""];
        [self.delegate getYearMonth:self date:[NSString stringWithFormat:@"%@/%@",year,month]];
        [self removeFromSuperview];
    }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    if (p.y < 200) {
        [UIView animateWithDuration:0.3 animations:^{
            [_pickerView setFrame:CGRectMake(0, 244+216, 320, 216)];
            [_backView setFrame:CGRectMake(0, 244+216, 320, 50)];
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}
-(void)setSelectedRowInYearAndMonth:(NSInteger)_yearIndex monthIndex:(NSInteger)_monthIndex{
    [_pickerView selectRow:_yearIndex inComponent:0 animated:NO];
    [_pickerView selectRow:_monthIndex inComponent:1 animated:NO];
}
#pragma mark - UIPickerViewDelegate


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (component == 0) {
        view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        UILabel *labelOnComponent=[[UILabel alloc] initWithFrame:view.frame];
        labelOnComponent.font = [UIFont fontWithName:@"Helvetica" size:13];
        labelOnComponent.backgroundColor = [UIColor clearColor];
        labelOnComponent.text = [yearMuArr objectAtIndex:row];
        labelOnComponent.textAlignment = NSTextAlignmentCenter;
        [view addSubview:labelOnComponent];
        view.backgroundColor = [UIColor clearColor];
    }
    if (component == 1) {
        view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        UILabel *labelOnComponent=[[UILabel alloc] initWithFrame:view.frame];
        labelOnComponent.font = [UIFont fontWithName:@"Helvetica" size:13];
        labelOnComponent.backgroundColor = [UIColor clearColor];
        labelOnComponent.text = [monthMuArr objectAtIndex:row];
        labelOnComponent.textAlignment = NSTextAlignmentCenter;
        [view addSubview:labelOnComponent];
        view.backgroundColor = [UIColor clearColor];
    }

    return view;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
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
            break;
    }
    
    return row;
}

@end
