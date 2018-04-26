//
//  H_Single_PickerView.m
//  WLT
//
//  Created by cl z on 12-12-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "H_Single_PickerView.h"

@implementation H_Single_PickerView
@synthesize pickerView = _pickerView;
@synthesize backView = _backView;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame arr:(NSArray *)_arr
{
    self = [super initWithFrame:frame];
    if (self) {
        getMuArr = [[NSMutableArray alloc]init];
        [getMuArr addObjectsFromArray:_arr];
        
        //init backgroundcolor
        self.backgroundColor = [UIColor clearColor];
        
        UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.3f;
        [self addSubview:backView];
        
        //add pickerview
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 216)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        [self addSubview:_pickerView];
        
        //add btn
        _backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 50)];
        [_backView setUserInteractionEnabled:YES];
        _backView.backgroundColor = [UIColor whiteColor];
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 6, 60, 38)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
//        cancelBtn.backgroundColor = [UIColor colorWithHexString:NAGA_BACKGROUND_COLOR];
        cancelBtn.layer.masksToBounds = YES;
        cancelBtn.layer.cornerRadius = 4.f;
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];

        [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:cancelBtn];
        
        UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 60 - 10, 6, 60, 38)];
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [doneBtn setTitleColor:[UIColor colorWithHexString:NAGA_BACKGROUND_COLOR] forState:UIControlStateNormal];
//        doneBtn.backgroundColor = [UIColor colorWithHexString:NAGA_BACKGROUND_COLOR];
        doneBtn.layer.masksToBounds = YES;
        doneBtn.layer.cornerRadius = 4.f;
        doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];

        [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:doneBtn];
        
        [self addSubview:_backView];
        
        [UIView animateWithDuration:0.3 animations:^{
            [_pickerView setFrame:CGRectMake(0, ScreenHeight - 216, ScreenWidth, 216)];
            [_backView setFrame:CGRectMake(0, ScreenHeight - 216 - 50, ScreenWidth, 50)];
        } completion:^(BOOL finished) {
            
        }];
    }
    return self;
}
#pragma mark - Custom Methods
-(void)cancelAction
{
    [UIView animateWithDuration:0.3 animations:^{
        [_pickerView setFrame:CGRectMake(0,ScreenHeight, ScreenWidth, 216)];
        [_backView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 50)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)doneAction
{
    [UIView animateWithDuration:0.3 animations:^{
        [_pickerView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 216)];
        [_backView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 50)];
    } completion:^(BOOL finished) {
        NSInteger currentIndex = [_pickerView selectedRowInComponent:0];
        NSString *keyStr = getMuArr[currentIndex][@"Name"] ? @"Name":@"name";
        [self.delegate SinglePickergetObjectWithArr:self arr:getMuArr index:currentIndex chooseStr:getMuArr[currentIndex][keyStr] chooseId:getMuArr[currentIndex][@"Id"]];
        
        [self removeFromSuperview];
    }];
}
#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return getMuArr.count;
}
#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    UILabel *labelOnComponent=[[UILabel alloc] initWithFrame:view.frame];
    labelOnComponent.font = [UIFont systemFontOfSize:14];
    labelOnComponent.backgroundColor = [UIColor clearColor];
        labelOnComponent.textAlignment = NSTextAlignmentCenter;
    NSString *keyStr = getMuArr[row][@"Name"] ? @"Name":@"name";
    labelOnComponent.text = getMuArr[row][keyStr];
    [view addSubview:labelOnComponent];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    if (p.y < ScreenHeight - 216 - 64 - 50) {
        [UIView animateWithDuration:0.3 animations:^{
            [_pickerView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 216)];
            [_backView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 50)];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}
@end
