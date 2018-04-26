//
//  myPickView.m
//  WLT
//
//  Created by cl z on 12-12-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "H_PCZ_PickerView.h"


@implementation H_PCZ_PickerView

@synthesize pickerView = _pickerView;
@synthesize backView = _backView;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        provinceMuArr = [[NSMutableArray alloc] init];
        zoneMuArr = [[NSMutableArray alloc]init];
        cityMuArr = [[NSMutableArray alloc]init];
        [self performSelector:@selector(initMyView)];
    }
    return self;
}
//-(FMDatabase *)getDB
//{
//    FMDatabase *db = [FMDatabase databaseWithPath:[[NSBundle mainBundle]pathForResource:@"area.sqlite" ofType:nil]];
//    [db open];
//    return db;
//}
-(void)initMyView
{
    FMDBHandle *handle = [FMDBHandle sharedManager];
    
    [handle copySqliteFileToDocmentWithFileName:sql_file_name];

    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.3f;
    [self addSubview:backView];
    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 64, ScreenWidth, 216)];
    [_pickerView setDataSource:self];
    [_pickerView setDelegate:self];
    _pickerView.showsSelectionIndicator = YES;
//    _pickerView.backgroundColor = [UIColor whiteColor];
     _pickerView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    [self addSubview:_pickerView];


    _backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 64, ScreenWidth, 50)];
    [_backView setUserInteractionEnabled:YES];
    _backView.backgroundColor = [UIColor whiteColor];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 8, 65, 34)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    cancelBtn.backgroundColor = [UIColor colorWithHexString:NAGA_BACKGROUND_COLOR];
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 4.f;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:cancelBtn];
    
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 65 - 15, 8, 65, 34)];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
//    doneBtn.backgroundColor = [UIColor colorWithHexString:NAGA_BACKGROUND_COLOR];
    doneBtn.layer.masksToBounds = YES;
    doneBtn.layer.cornerRadius = 4.f;
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [doneBtn setTitleColor:[UIColor colorWithHexString:@"6398f1"] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:doneBtn];
    
    [self addSubview:_backView];
    
    NSArray *provinceArr = [[FMDBHandle sharedManager] searchDataWithSql:sql_get_province fileName:sql_file_name];
    [provinceMuArr addObjectsFromArray:provinceArr];
    
    NSString *code = provinceArr[0][@"Code"];
    
    NSArray *cityArr = [[FMDBHandle sharedManager] searchDataWithSql:[NSString stringWithFormat:sql_get_city_by_code,code] fileName:sql_file_name];
    
    [cityMuArr addObjectsFromArray:cityArr];
    
    NSString *cityCode = cityArr[0][@"Code"];
    NSArray *zoneArr = [[FMDBHandle sharedManager] searchDataWithSql:[NSString stringWithFormat:sql_get_city_by_code,cityCode] fileName:sql_file_name];
    
    [zoneMuArr addObjectsFromArray:zoneArr];
    
    [UIView animateWithDuration:0.3 animations:^{
        [_pickerView setFrame:CGRectMake(0, ScreenHeight - 64-216, ScreenWidth, 216)];
        [_backView setFrame:CGRectMake(0, ScreenHeight - 64-216-50, ScreenWidth, 50)];
    } completion:^(BOOL finished) {
        
    }];
}
-(void)cancelAction
{
    [UIView animateWithDuration:0.3 animations:^{
        [_pickerView setFrame:CGRectMake(0, ScreenHeight - 64, ScreenWidth, 216)];
        [_backView setFrame:CGRectMake(0, ScreenHeight - 64, ScreenWidth, 216)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)doneAction
{
    NSMutableString *addressStr = [[NSMutableString alloc] init];
    NSString *areaCode = [[NSString alloc] init];
    NSString *provinceStr = [[provinceMuArr objectAtIndex:[_pickerView selectedRowInComponent:0]] objectForKey:@"Name"];
    areaCode = [[provinceMuArr objectAtIndex:[_pickerView selectedRowInComponent:0]] objectForKey:@"Code"];
    [addressStr appendString:provinceStr];
    NSString *cityStr = @"";
    if (cityMuArr.count) {
        cityStr = [[cityMuArr objectAtIndex:[_pickerView selectedRowInComponent:1]] objectForKey:@"Name"];
        areaCode = [[cityMuArr objectAtIndex:[_pickerView selectedRowInComponent:1]] objectForKey:@"Code"];
        [addressStr appendString:@"/"];
        [addressStr appendString:cityStr];
    }
    NSString *zoneStr = @"";
    if (zoneMuArr.count) {
        zoneStr = [[zoneMuArr objectAtIndex:[_pickerView selectedRowInComponent:2]] objectForKey:@"Name"];
        areaCode = [[zoneMuArr objectAtIndex:[_pickerView selectedRowInComponent:2]] objectForKey:@"Code"];
        [addressStr appendString:@"/"];
        [addressStr appendString:zoneStr];
    }

    [UIView animateWithDuration:0.3 animations:^{
        [_pickerView setFrame:CGRectMake(0, ScreenHeight - 64, ScreenWidth, 216)];
        [_backView setFrame:CGRectMake(0, ScreenHeight - 64, ScreenWidth, 216)];
    } completion:^(BOOL finished) {
        
        [self.delegate getChooseIndex:self addressStr:addressStr areaCode:areaCode];
        [self removeFromSuperview];
    }];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    NSInteger row = 0;
    switch (component) {
        case 0:
        {
            row = [provinceMuArr count];
        }
            break;       
        case 1:
        {
            NSArray *cityarr = [[FMDBHandle sharedManager] searchDataWithSql:[NSString stringWithFormat:sql_get_city_by_code,[provinceMuArr[[pickerView selectedRowInComponent:0]] objectForKey:@"Code"]] fileName:sql_file_name];
            [cityMuArr removeAllObjects];
            [cityMuArr addObjectsFromArray:cityarr];

            row = cityMuArr.count;
        }
            break;    
        case 2:
        {
            if (cityMuArr.count) {
                NSArray *zonearr = [[FMDBHandle sharedManager] searchDataWithSql:[NSString stringWithFormat:sql_get_city_by_code,[cityMuArr[[pickerView selectedRowInComponent:1]] objectForKey:@"Code"]] fileName:sql_file_name];
                [zoneMuArr removeAllObjects];
                [zoneMuArr addObjectsFromArray:zonearr];
                
                row = zoneMuArr.count;
            }

        }
            break;
        default:
            break;
    }
    
    return row;
}
#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
        {
            [cityMuArr removeAllObjects];
            [zoneMuArr removeAllObjects];
            
            NSArray *cityarr = [[FMDBHandle sharedManager] searchDataWithSql:[NSString stringWithFormat:sql_get_city_by_code,[provinceMuArr[row] objectForKey:@"Code"]] fileName:sql_file_name];

            [cityMuArr addObjectsFromArray:cityarr];

            [_pickerView reloadComponent:1];
            [_pickerView reloadComponent:2];
            [_pickerView selectRow:0 inComponent:1 animated:YES];
            [_pickerView selectRow:0 inComponent:2 animated:YES];

        }
            break;
        case 1:
        {
            [zoneMuArr removeAllObjects];
            NSArray *zonearr = [[FMDBHandle sharedManager] searchDataWithSql:[NSString stringWithFormat:sql_get_city_by_code,[cityMuArr[row] objectForKey:@"Code"]] fileName:sql_file_name];

            [zoneMuArr addObjectsFromArray:zonearr];
            
            
            [_pickerView reloadComponent:2];
            [_pickerView selectRow:0 inComponent:2 animated:YES];

        }
            break;
            
        default:
            break;
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth / 3, 40)];
    
    UILabel *labelOnComponent=[[UILabel alloc] initWithFrame:view.frame];
    labelOnComponent.font = [UIFont systemFontOfSize:13];
    labelOnComponent.textAlignment = NSTextAlignmentCenter;
    labelOnComponent.backgroundColor = [UIColor clearColor];
    switch (component) {
        case 0:
        {
            labelOnComponent.text=[[provinceMuArr objectAtIndex:row] objectForKey:@"Name"];
        }
            break;
        case 1:
        {
            labelOnComponent.text=[[cityMuArr objectAtIndex:row] objectForKey:@"Name"];
        }
            break;
        case 2:
        {
            labelOnComponent.text=[[zoneMuArr objectAtIndex:row] objectForKey:@"Name"];
        }
            break;
            
        default:
            break;
    }
    
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
    if (p.y < ScreenHeight - 64 - 216 - 50) {
        [UIView animateWithDuration:0.3 animations:^{
            [_pickerView setFrame:CGRectMake(0, ScreenHeight - 64, ScreenWidth, 216)];
            [ _backView setFrame:CGRectMake(0, ScreenHeight - 64, ScreenWidth, 216)];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

@end
