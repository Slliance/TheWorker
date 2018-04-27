//
//  HandInHandInformationController.m
//  TheWorker
//
//  Created by apple on 2018/4/27.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "HandInHandInformationController.h"

@interface HandInHandInformationController ()<UIScrollViewDelegate,UITextFieldDelegate>
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
///居住地
@property(nonatomic,strong)UILabel *addressLabel;
///出生日期
@property(nonatomic,strong)UILabel *birthdayLabel;
///身高
@property(nonatomic,strong)UILabel *heightLabel;
///月收入
@property(nonatomic,strong)UILabel *incomeLabel;
///婚姻状况
@property(nonatomic,strong)UILabel *marriageLabel;
///添加照片
@property(nonatomic,strong)UILabel *photoLabel;
@end

@implementation HandInHandInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
    self.navView.titleLabel.text = @"基本信息";
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    [self.view addSubview:self.bgScrollow];
    [self.view addSubview:self.finishBtn];
    [self.bgScrollow addSubview:self.nikeNameLabel];
    [self.bgScrollow addSubview:self.nikeNameField];
    [self.bgScrollow addSubview:self.nikeNameBtn];
    [self.bgScrollow addSubview:self.sexLabel];
    [self.bgScrollow addSubview:self.maleBtn];
    [self.bgScrollow addSubview:self.femalemaleBtn];
    [self.bgScrollow addSubview:self.addressLabel];
    [self.bgScrollow addSubview:self.birthdayLabel];
    [self.bgScrollow addSubview:self.heightLabel];
    [self.bgScrollow addSubview:self.incomeLabel];
    [self.bgScrollow addSubview:self.marriageLabel];
    [self.bgScrollow addSubview:self.photoLabel];
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
    [self.photoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollow).offset(12);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.marriageLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(80);
    }];
    [self.nikeNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollow).offset(92);
        make.top.equalTo(self.bgScrollow).offset(24);
        make.width.mas_equalTo(ScreenWidth-197);
        make.height.mas_equalTo(40);
    }];
    [self.maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollow).offset(92);
        make.top.equalTo(self.nikeNameField.mas_bottom).offset(10);
        make.width.mas_equalTo(40);
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
        [_maleBtn addTarget:self action:@selector(pressMaleBtn:) forControlEvents:UIControlEventTouchUpInside];
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
        [_femalemaleBtn addTarget:self action:@selector(pressFemaleBtn:) forControlEvents:UIControlEventTouchUpInside];
        _femalemaleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _maleBtn;
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
-(void)pressFinishBtn:(UIButton*)sender{
    NSLog(@"");
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
