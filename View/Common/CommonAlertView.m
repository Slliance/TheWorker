//
//  CommonAlertView.m
//  TheWorker
//
//  Created by apple on 2018/5/14.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "CommonAlertView.h"

@implementation CommonAlertView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 8;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

-(void)setCommonType:(CommonAlertViewType)commonType{
    switch (self.commonType) {
        case CommonTypeLogin:
        {
            [self addSubview:self.sexLabel];
            [self addSubview:self.yearLabel];
            [self addSubview:self.maleBtn];
            [self addSubview:self.femalemaleBtn];
            [self addSubview:self.yearBtn];
            [self addSubview:self.sureBtn];
            self.sexLabel.frame = CGRectMake(15, 15, 80, 40);
            self.maleBtn.frame = CGRectMake(120, 15, 40, 40);
            self.femalemaleBtn.frame = CGRectMake(180, 15, 40, 40);
            self.yearLabel.frame = CGRectMake(15, 55, 80, 40);
            self.yearBtn.frame = CGRectMake(120, 55, 150, 40);
            self.sureBtn.frame = CGRectMake(120, 110, 100, 40);
            
        }
            break;
        case CommonTypeCoupon:
        {
            
        }
            break;
        case CommonTypeCouponFinished:
        {
            
        }
            break;
        default:
            break;
    }
}
-(UILabel *)sexLabel{
    if (!_sexLabel) {
        _sexLabel = [[UILabel alloc]init];
        _sexLabel.text = @"性别";
        _sexLabel.font = [UIFont systemFontOfSize:14];
        _sexLabel.textAlignment = NSTextAlignmentLeft;
        _sexLabel.textColor = DSColorFromHex(0x999999);
    }
    return _sexLabel;
}
-(UIButton *)maleBtn{
    if (!_maleBtn) {
        _maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_maleBtn setTitle:@"男" forState:UIControlStateNormal];
        [_maleBtn setTitleColor:DSColorFromHex(0x4D4D4D) forState:UIControlStateSelected];
        [_maleBtn setTitleColor:DSColorFromHex(0x999999) forState:UIControlStateNormal];
        [_maleBtn setImage:[UIImage imageNamed:@"holdinghands_checkbox_male"] forState:UIControlStateNormal];
        [_maleBtn setImage:[UIImage imageNamed:@"holdinghands_icon_check"] forState:UIControlStateSelected];
        [_maleBtn addTarget:self action:@selector(pressMaleOrFemaleBtn:) forControlEvents:UIControlEventTouchUpInside];
        _maleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _maleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _maleBtn;
}
-(UIButton *)femalemaleBtn{
    if (!_femalemaleBtn) {
        _femalemaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_femalemaleBtn setTitle:@"女" forState:UIControlStateNormal];
        [_femalemaleBtn setTitleColor:DSColorFromHex(0x4D4D4D) forState:UIControlStateSelected];
        [_femalemaleBtn setTitleColor:DSColorFromHex(0x999999) forState:UIControlStateNormal];
        [_femalemaleBtn setImage:[UIImage imageNamed:@"holdinghands_checkbox_male"] forState:UIControlStateNormal];
        [_femalemaleBtn setImage:[UIImage imageNamed:@"holdinghands_icon_check"] forState:UIControlStateSelected];
        [_femalemaleBtn addTarget:self action:@selector(pressMaleOrFemaleBtn:) forControlEvents:UIControlEventTouchUpInside];
        _femalemaleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _femalemaleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _femalemaleBtn;
}
-(UILabel *)yearLabel{
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc]init];
        _yearLabel.text = @"年龄";
        _yearLabel.font = [UIFont systemFontOfSize:14];
        _yearLabel.textAlignment = NSTextAlignmentLeft;
        _yearLabel.textColor = DSColorFromHex(0x999999);
    }
    return _yearLabel;
}
-(CommonChooseBtn *)yearBtn{
    if (!_yearBtn) {
        _yearBtn = [[CommonChooseBtn alloc]init];
        _yearBtn.titleLabel.text = @"2018-05-02";
        [_yearBtn.selectedBtn addTarget:self action:@selector(pressYearBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yearBtn;
}
-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.backgroundColor = DSColorFromHex(0xEEEEEE);
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(pressSureBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

-(void)pressSureBtn:(UIButton*)sender{
    
}
-(void)pressMaleOrFemaleBtn:(UIButton*)sender{
    if (self.tmpBtn == nil){
        sender.selected = YES;
        self.tmpBtn = sender;
    }
    else if (self.tmpBtn !=nil && self.tmpBtn == sender){
        sender.selected = YES;
        
    }
    else if (self.tmpBtn!= sender && self.tmpBtn!=nil){
        self.tmpBtn.selected = NO;
        sender.selected = YES;
        self.tmpBtn = sender;
    }
    
}
//- (void)showInfo:(NSString *)info{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = info;
//    hud.yOffset = -45;
//    [hud hide:YES afterDelay:2];
//}

@end
