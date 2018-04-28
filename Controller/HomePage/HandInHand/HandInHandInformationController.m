//
//  HandInHandInformationController.m
//  TheWorker
//
//  Created by apple on 2018/4/27.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "HandInHandInformationController.h"
#import "CommonChooseBtn.h"
#import "ChooseMatchMakingController.h"

@interface HandInHandInformationController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    BOOL _isMale;
    BOOL _isFemale;
}
@property(nonatomic,strong)UIButton *finishBtn;
@property(nonatomic,strong)UIScrollView *bgScrollow;
///昵称
@property(nonatomic,strong)UILabel *nikeNameLabel;
///
@property(nonatomic,strong)UITextField *nikeNameField;
///
@property(nonatomic,strong)UIButton *nikeNameBtn;
///性别
@property(nonatomic,strong)UILabel *sexLabel;
@property(nonatomic,strong)UIButton *maleBtn;
@property(nonatomic,strong)UIButton *femalemaleBtn;
@property(nonatomic,strong)UIButton *tmpBtn;
///居住地
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)CommonChooseBtn *countyBtn;
@property(nonatomic,strong)CommonChooseBtn *cityBtn;


///出生日期
@property(nonatomic,strong)UILabel *birthdayLabel;
@property(nonatomic,strong)CommonChooseBtn *yearBtn;
@property(nonatomic,strong)CommonChooseBtn *monthBtn;
@property(nonatomic,strong)CommonChooseBtn *dayBtn;
///身高
@property(nonatomic,strong)UILabel *heightLabel;
///
@property(nonatomic,strong)UITextField *heightField;
@property(nonatomic,strong)UILabel *heightUnitLabel;
///月收入
@property(nonatomic,strong)UILabel *incomeLabel;
@property(nonatomic,strong)UILabel *incomeUnitLabel;
///
@property(nonatomic,strong)UITextField *incomeField;
///婚姻状况
@property(nonatomic,strong)UILabel *marriageLabel;
@property(nonatomic,strong)UIButton *marryBtn;
@property(nonatomic,strong)UIButton *marriedBtn;
@property(nonatomic,strong)UIButton *unmarriedBtn;
@property(nonatomic,strong)UIButton *nurturedBtn;

///爱情宣言
@property(nonatomic,strong)UILabel *declarationLoveLabel;
@property(nonatomic,strong)UITextView *declarationLoveTextview;
///添加照片
@property(nonatomic,strong)UILabel *photoLabel;
@end

@implementation HandInHandInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
    self.navView.titleLabel.text = @"基本信息";
    [self.view addSubview:self.bgScrollow];
    [self.view addSubview:self.finishBtn];
    [self.bgScrollow addSubview:self.nikeNameLabel];
    [self.bgScrollow addSubview:self.nikeNameField];
    [self.bgScrollow addSubview:self.nikeNameBtn];
    [self.bgScrollow addSubview:self.sexLabel];
    [self.bgScrollow addSubview:self.maleBtn];
    [self.bgScrollow addSubview:self.femalemaleBtn];
    [self.bgScrollow addSubview:self.addressLabel];
    [self.bgScrollow addSubview:self.cityBtn];
    [self.bgScrollow addSubview:self.countyBtn];
    [self.bgScrollow addSubview:self.birthdayLabel];
    [self.bgScrollow addSubview:self.yearBtn];
    [self.bgScrollow addSubview:self.monthBtn];
    [self.bgScrollow addSubview:self.dayBtn];
    [self.bgScrollow addSubview:self.heightLabel];
    [self.bgScrollow addSubview:self.heightField];
     [self.bgScrollow addSubview:self.heightUnitLabel];
    [self.bgScrollow addSubview:self.incomeLabel];
    [self.bgScrollow addSubview:self.incomeField];
     [self.bgScrollow addSubview:self.incomeUnitLabel];
    [self.bgScrollow addSubview:self.marriageLabel];
    [self.bgScrollow addSubview:self.marriedBtn];
    [self.bgScrollow addSubview:self.unmarriedBtn];
    [self.bgScrollow addSubview:self.nurturedBtn];
    [self.bgScrollow addSubview:self.declarationLoveLabel];
    [self.bgScrollow addSubview:self.declarationLoveTextview];
    [self.bgScrollow addSubview:self.photoLabel];
    [self setContentLayout];
}

-(void)setContentLayout{
    [self.bgScrollow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(64);
        make.bottom.equalTo(self.view).offset(49);
    }];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(49);
        make.bottom.equalTo(self.view);
    }];
    [self.nikeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollow).offset(12);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.bgScrollow).offset(24);
        make.width.mas_equalTo(80);
    }];
    [self.sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollow).offset(12);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.nikeNameLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(80);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollow).offset(12);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.sexLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(80);
    }];
    [self.birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollow).offset(12);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(80);
    }];
    [self.heightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollow).offset(12);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.birthdayLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(80);
    }];
    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollow).offset(12);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.heightLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(80);
    }];
    [self.marriageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollow).offset(12);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.incomeLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(80);
    }];
    [self.declarationLoveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollow).offset(12);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.marriageLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(80);
    }];
    [self.declarationLoveTextview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollow).offset(92);
        make.top.equalTo(self.marriageLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(ScreenWidth-104);
        make.height.mas_equalTo(70);
    }];
    [self.photoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollow).offset(12);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.declarationLoveTextview.mas_bottom).offset(10);
        make.width.mas_equalTo(80);
    }];
    [self.nikeNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollow).offset(92);
        make.top.equalTo(self.bgScrollow).offset(24);
        make.width.mas_equalTo(ScreenWidth-197);
        make.height.mas_equalTo(40);
    }];
    [self.nikeNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nikeNameField.mas_right).offset(10);
        make.top.equalTo(self.bgScrollow).offset(24);
        make.width.mas_equalTo(83);
        make.height.mas_equalTo(40);
    }];
    [self.maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollow).offset(92);
        make.top.equalTo(self.nikeNameField.mas_bottom).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    [self.femalemaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maleBtn.mas_right).offset(30);
        make.top.equalTo(self.nikeNameField.mas_bottom).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    [self.cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollow).offset(92);
        make.top.equalTo(self.maleBtn.mas_bottom).offset(10);
        make.width.mas_equalTo(ScreenWidth/2-57);
        make.height.mas_equalTo(40);
    }];
    [self.countyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cityBtn.mas_right).offset(10);
        make.top.equalTo(self.maleBtn.mas_bottom).offset(10);
        make.width.mas_equalTo(ScreenWidth/2-57);
        make.height.mas_equalTo(40);
    }];
    [self.yearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollow).offset(92);
        make.top.equalTo(self.cityBtn.mas_bottom).offset(10);
        make.width.mas_equalTo(ScreenWidth/3-124/3);
        make.height.mas_equalTo(40);
    }];
    [self.monthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.yearBtn.mas_right).offset(10);
        make.top.equalTo(self.cityBtn.mas_bottom).offset(10);
        make.width.mas_equalTo(ScreenWidth/3-124/3);
        make.height.mas_equalTo(40);
    }];
    [self.dayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.monthBtn.mas_right).offset(10);
        make.top.equalTo(self.cityBtn.mas_bottom).offset(10);
        make.width.mas_equalTo(ScreenWidth/3-124/3);
        make.height.mas_equalTo(40);
    }];
    [self.heightField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollow).offset(92);
        make.top.equalTo(self.yearBtn.mas_bottom).offset(10);
        make.width.mas_equalTo(ScreenWidth-146);
        make.height.mas_equalTo(40);
    }];
    [self.incomeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollow).offset(92);
        make.top.equalTo(self.heightField.mas_bottom).offset(10);
        make.width.mas_equalTo(ScreenWidth-146);
        make.height.mas_equalTo(40);
    }];
    [self.heightUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.heightField.mas_right).offset(11);
        make.top.equalTo(self.yearBtn.mas_bottom).offset(10);
        make.width.mas_equalTo(54);
        make.height.mas_equalTo(40);
    }];
    [self.incomeUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.incomeField.mas_right).offset(11);
        make.top.equalTo(self.heightField.mas_bottom).offset(10);
        make.width.mas_equalTo(54);
        make.height.mas_equalTo(40);
    }];
    [self.marriedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollow).offset(92);
        make.top.equalTo(self.incomeField.mas_bottom).offset(10);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(40);
    }];
    [self.unmarriedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.marriedBtn.mas_right).offset(15);
        make.top.equalTo(self.incomeField.mas_bottom).offset(10);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(40);
    }];
    [self.nurturedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.unmarriedBtn.mas_right).offset(15);
        make.top.equalTo(self.incomeField.mas_bottom).offset(10);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(40);
    }];
}
-(UIScrollView *)bgScrollow{
    if (!_bgScrollow) {
        _bgScrollow = [[UIScrollView alloc]init];
        _bgScrollow.delegate = self;
        _bgScrollow.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-49);
        _bgScrollow.contentSize = CGSizeMake(ScreenWidth, ScreenHeight+100);
    }
    return _bgScrollow;
}
-(UILabel *)nikeNameLabel{
    if (!_nikeNameLabel) {
        _nikeNameLabel = [[UILabel alloc]init];
        _nikeNameLabel.text = @"昵称：";
        _nikeNameLabel.font = [UIFont systemFontOfSize:14];
        _nikeNameLabel.textAlignment = NSTextAlignmentLeft;
        _nikeNameLabel.textColor = DSColorFromHex(0x999999);
    }
    return _nikeNameLabel;
}
-(UITextField *)nikeNameField{
    if (!_nikeNameField) {
        _nikeNameField = [[UITextField alloc]init];
        _nikeNameField.delegate = self;
        _nikeNameField.placeholder = @"3到8个字符";
        _nikeNameField.font = [UIFont systemFontOfSize:14];
        _nikeNameField.layer.masksToBounds = YES;
        [self setTextFieldLeftView:_nikeNameField :nil :10];
        [_nikeNameField.layer setMasksToBounds:YES];
        [_nikeNameField.layer setBorderColor:DSColorFromHex(0x999999).CGColor];
        [_nikeNameField.layer setBorderWidth:1];
    }
    return _nikeNameField;
}
-(UIButton *)nikeNameBtn{
    if (!_nikeNameBtn) {
        _nikeNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nikeNameBtn setTitle:@"自动生成" forState:UIControlStateNormal];
        [_nikeNameBtn setTitleColor:DSColorFromHex(0x4D4D4D) forState:UIControlStateNormal];
        [_nikeNameBtn addTarget:self action:@selector(pressNikeNameBtn:) forControlEvents:UIControlEventTouchUpInside];
        _nikeNameBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _nikeNameBtn.backgroundColor = DSColorFromHex(0xFFCE00);
    }
    return _nikeNameBtn;
}
-(UILabel *)sexLabel{
    if (!_sexLabel) {
        _sexLabel = [[UILabel alloc]init];
        _sexLabel.text = @"性别：";
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
-(UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.text = @"居住地：";
        _addressLabel.font = [UIFont systemFontOfSize:14];
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.textColor = DSColorFromHex(0x999999);
    }
    return _addressLabel;
}
-(CommonChooseBtn *)cityBtn{
    if (!_cityBtn) {
        _cityBtn = [[CommonChooseBtn alloc]init];
        _cityBtn.titleLabel.text = @"城市";
         [_cityBtn.selectedBtn addTarget:self action:@selector(pressCityBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cityBtn;
}
-(CommonChooseBtn *)countyBtn{
    if (!_countyBtn) {
        _countyBtn = [[CommonChooseBtn alloc]init];
        _countyBtn.titleLabel.text = @"区/县";
        [_countyBtn.selectedBtn addTarget:self action:@selector(pressCountyBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _countyBtn;
}
-(UILabel *)birthdayLabel{
    if (!_birthdayLabel) {
        _birthdayLabel = [[UILabel alloc]init];
        _birthdayLabel.text = @"出生日期：";
        _birthdayLabel.font = [UIFont systemFontOfSize:14];
        _birthdayLabel.textAlignment = NSTextAlignmentLeft;
        _birthdayLabel.textColor = DSColorFromHex(0x999999);
    }
    return _birthdayLabel;
}
-(CommonChooseBtn *)yearBtn{
    if (!_yearBtn) {
        _yearBtn = [[CommonChooseBtn alloc]init];
        _yearBtn.titleLabel.text = @"年";
        [_yearBtn.selectedBtn addTarget:self action:@selector(pressYearBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yearBtn;
}
-(CommonChooseBtn *)monthBtn{
    if (!_monthBtn) {
        _monthBtn = [[CommonChooseBtn alloc]init];
        _monthBtn.titleLabel.text = @"月";
        [_monthBtn.selectedBtn addTarget:self action:@selector(pressMonthBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _monthBtn;
}
-(CommonChooseBtn *)dayBtn{
    if (!_dayBtn) {
        _dayBtn = [[CommonChooseBtn alloc]init];
        _dayBtn.titleLabel.text = @"日";
        [_dayBtn.selectedBtn addTarget:self action:@selector(pressDayBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dayBtn;
}
- (UILabel *)heightLabel{
    if (!_heightLabel) {
        _heightLabel = [[UILabel alloc]init];
        _heightLabel.text = @"身高：";
        _heightLabel.font = [UIFont systemFontOfSize:14];
        _heightLabel.textAlignment = NSTextAlignmentLeft;
        _heightLabel.textColor = DSColorFromHex(0x999999);
    }
    return _heightLabel;
}
-(UILabel *)heightUnitLabel{
    if (!_heightUnitLabel) {
        _heightUnitLabel = [[UILabel alloc]init];
        _heightUnitLabel.text = @"cm";
        _heightUnitLabel.font = [UIFont systemFontOfSize:14];
        _heightUnitLabel.textAlignment = NSTextAlignmentLeft;
        _heightUnitLabel.textColor = DSColorFromHex(0x999999);
    }
    return _heightUnitLabel;
}
-(UITextField *)heightField{
    if (!_heightField) {
        _heightField = [[UITextField alloc]init];
        _heightField.delegate = self;
        _heightField.font = [UIFont systemFontOfSize:14];
        _heightField.layer.masksToBounds = YES;
        [self setTextFieldLeftView:_heightField :nil :10];
        [_heightField.layer setMasksToBounds:YES];
        [_heightField.layer setBorderColor:DSColorFromHex(0x999999).CGColor];
        [_heightField.layer setBorderWidth:1];
    }
    return _heightField;
}
-(UILabel *)incomeLabel{
    if (!_incomeLabel) {
        _incomeLabel = [[UILabel alloc]init];
        _incomeLabel.text = @"月收入：";
        _incomeLabel.font = [UIFont systemFontOfSize:14];
        _incomeLabel.textAlignment = NSTextAlignmentLeft;
        _incomeLabel.textColor = DSColorFromHex(0x999999);
    }
    return _incomeLabel;
}
-(UILabel *)incomeUnitLabel{
    if (!_incomeUnitLabel) {
        _incomeUnitLabel = [[UILabel alloc]init];
        _incomeUnitLabel.text = @"元";
        _incomeUnitLabel.font = [UIFont systemFontOfSize:14];
        _incomeUnitLabel.textAlignment = NSTextAlignmentLeft;
        _incomeUnitLabel.textColor = DSColorFromHex(0x999999);
    }
    return _incomeUnitLabel;
}
-(UITextField *)incomeField{
    if (!_incomeField) {
        _incomeField = [[UITextField alloc]init];
        _incomeField.delegate = self;
        _incomeField.font = [UIFont systemFontOfSize:14];
        [self setTextFieldLeftView:_incomeField :nil :10];
        _incomeField.layer.masksToBounds = YES;
        [_incomeField.layer setMasksToBounds:YES];
        [_incomeField.layer setBorderColor:DSColorFromHex(0x999999).CGColor];
        [_incomeField.layer setBorderWidth:1];
    }
    return _incomeField;
}
-(UILabel *)marriageLabel{
    if (!_marriageLabel) {
        _marriageLabel = [[UILabel alloc]init];
        _marriageLabel.text = @"婚姻状况：";
        _marriageLabel.font = [UIFont systemFontOfSize:14];
        _marriageLabel.textAlignment = NSTextAlignmentLeft;
        _marriageLabel.textColor = DSColorFromHex(0x999999);
    }
    return _marriageLabel;
}

-(UIButton *)marriedBtn{
    if (!_marriedBtn) {
        _marriedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_marriedBtn setTitle:@"已婚" forState:UIControlStateNormal];
        [_marriedBtn setTitleColor:DSColorFromHex(0x4D4D4D) forState:UIControlStateSelected];
        [_marriedBtn setTitleColor:DSColorFromHex(0x999999) forState:UIControlStateNormal];
        [_marriedBtn setImage:[UIImage imageNamed:@"holdinghands_checkbox_male"] forState:UIControlStateNormal];
        [_marriedBtn setImage:[UIImage imageNamed:@"holdinghands_icon_check"] forState:UIControlStateSelected];
        [_marriedBtn addTarget:self action:@selector(pressMarryBtn:) forControlEvents:UIControlEventTouchUpInside];
        _marriedBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _marriedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _marriedBtn;
}
-(UIButton *)unmarriedBtn{
    if (!_unmarriedBtn) {
        _unmarriedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unmarriedBtn setTitle:@"未婚" forState:UIControlStateNormal];
        [_unmarriedBtn setTitleColor:DSColorFromHex(0x4D4D4D) forState:UIControlStateSelected];
        [_unmarriedBtn setTitleColor:DSColorFromHex(0x999999) forState:UIControlStateNormal];
        [_unmarriedBtn setImage:[UIImage imageNamed:@"holdinghands_checkbox_male"] forState:UIControlStateNormal];
        [_unmarriedBtn setImage:[UIImage imageNamed:@"holdinghands_icon_check"] forState:UIControlStateSelected];
        [_unmarriedBtn addTarget:self action:@selector(pressMarryBtn:) forControlEvents:UIControlEventTouchUpInside];
        _unmarriedBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _unmarriedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _unmarriedBtn;
}
-(UIButton *)nurturedBtn{
    if (!_nurturedBtn) {
        _nurturedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nurturedBtn setTitle:@"已育" forState:UIControlStateNormal];
        [_nurturedBtn setTitleColor:DSColorFromHex(0x4D4D4D) forState:UIControlStateSelected];
        [_nurturedBtn setTitleColor:DSColorFromHex(0x999999) forState:UIControlStateNormal];
        [_nurturedBtn setImage:[UIImage imageNamed:@"holdinghands_checkbox_male"] forState:UIControlStateNormal];
        [_nurturedBtn setImage:[UIImage imageNamed:@"holdinghands_icon_check"] forState:UIControlStateSelected];
        [_nurturedBtn addTarget:self action:@selector(pressMarryBtn:) forControlEvents:UIControlEventTouchUpInside];
        _nurturedBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _nurturedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _nurturedBtn;
}
-(UILabel *)declarationLoveLabel{
    if (!_declarationLoveLabel) {
        _declarationLoveLabel = [[UILabel alloc]init];
        _declarationLoveLabel.text = @"爱情宣言：";
        _declarationLoveLabel.font = [UIFont systemFontOfSize:14];
        _declarationLoveLabel.textAlignment = NSTextAlignmentLeft;
        _declarationLoveLabel.textColor = DSColorFromHex(0x999999);
    }
    return _declarationLoveLabel;
}
-(UITextView *)declarationLoveTextview{
    if (!_declarationLoveTextview) {
        _declarationLoveTextview = [[UITextView alloc]init];
        _declarationLoveTextview.delegate = self;
        _declarationLoveTextview.font = [UIFont systemFontOfSize:14.f];
        _declarationLoveTextview.layer.masksToBounds = YES;
        [_declarationLoveTextview.layer setMasksToBounds:YES];
        [_declarationLoveTextview.layer setBorderColor:DSColorFromHex(0x999999).CGColor];
        [_declarationLoveTextview.layer setBorderWidth:1];
        _declarationLoveTextview.editable = YES;
        _declarationLoveTextview.scrollEnabled = NO;
        _declarationLoveTextview.showsVerticalScrollIndicator = YES;
        _declarationLoveTextview.returnKeyType = UIReturnKeyDefault;
        _declarationLoveTextview.keyboardType = UIKeyboardTypeDefault;
    
    }
    return _declarationLoveTextview;
}
-(UILabel *)photoLabel{
    if (!_photoLabel) {
        _photoLabel = [[UILabel alloc]init];
        _photoLabel.text = @"添加照片：";
        _photoLabel.font = [UIFont systemFontOfSize:14];
        _photoLabel.textAlignment = NSTextAlignmentLeft;
        _photoLabel.textColor = DSColorFromHex(0x999999);
    }
    return _photoLabel;
}

-(UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:DSColorFromHex(0x4D4D4D) forState:UIControlStateNormal];
        [_finishBtn addTarget:self action:@selector(pressFinishBtn:) forControlEvents:UIControlEventTouchUpInside];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _finishBtn.backgroundColor = DSColorFromHex(0xFFCE00);
    }
    return _finishBtn;
}
#pragma Action
-(void)pressNikeNameBtn:(UIButton*)sender{
     NSLog(@"");
}
-(void)pressMaleOrFemaleBtn:(UIButton*)sender{
    if (_tmpBtn == nil){
        sender.selected = YES;
        _tmpBtn = sender;
    }
    else if (_tmpBtn !=nil && _tmpBtn == sender){
        sender.selected = YES;
        
    }
    else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
 
}
-(void)pressMarryBtn:(UIButton*)sender{
    if (_marryBtn == nil){
        sender.selected = YES;
        _marryBtn = sender;
    }
    else if (_marryBtn !=nil && _marryBtn == sender){
        sender.selected = YES;
        
    }
    else if (_marryBtn!= sender && _marryBtn!=nil){
        _marryBtn.selected = NO;
        sender.selected = YES;
        _marryBtn = sender;
    }
}
-(void)pressCityBtn:(UIButton*)sednder{
    NSLog(@"11");
}
-(void)pressCountyBtn:(UIButton *)sender{
    NSLog(@"22");
}
-(void)pressYearBtn:(UIButton*)sednder{
    NSLog(@"11");
}
-(void)pressMonthBtn:(UIButton*)sednder{
    NSLog(@"11");
}
-(void)pressDayBtn:(UIButton*)sednder{
    NSLog(@"11");
}
-(void)pressFinishBtn:(UIButton*)sender{
    ChooseMatchMakingController *matchVC = [[ChooseMatchMakingController alloc]init];
    [self.navigationController pushViewController:matchVC animated:YES];
}
-(void)pressBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
