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
#import "PicModel.h"
#import "UploadImgViewModel.h"
#import "WorkerHandInViewModel.h"
#import "HandInModel.h"
#import "IDMPhoto.h"
#import "IDMPhotoBrowser.h"
#import "UIView+CTExtensions.h"
#import "PGDatePickManager.h"
#import "CZHAddressPickerView.h"
#import "CGXPickerView.h"
#import "WorkerHandInViewModel.h"

@interface HandInHandInformationController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
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
//@property(nonatomic,strong)CommonChooseBtn *countyBtn;
@property(nonatomic,strong)CommonChooseBtn *cityBtn;


///出生日期
@property(nonatomic,strong)UILabel *birthdayLabel;
@property(nonatomic,strong)CommonChooseBtn *yearBtn;

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
@property(nonatomic,strong)UIView *photoView;
@property (nonatomic, retain) NSMutableArray *imageUrlArray;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (nonatomic, assign) NSInteger imgOrImgUrl;//显示图片的方式
@property (nonatomic, assign) NSInteger imageNums;
@property (nonatomic, assign) NSInteger fateStatus;
@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *area;
@end

@implementation HandInHandInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageNums = 0;
     self.fateStatus = 1;
    self.imgOrImgUrl = 0;
    self.imageArray = [[NSMutableArray alloc] init];
    self.imageUrlArray = [[NSMutableArray alloc] init];
    [self.imageArray addObject:@"1"];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesBegan:withEvent:)];
    [self.bgScrollow addGestureRecognizer:tapGR];
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
    
    [self.bgScrollow addSubview:self.birthdayLabel];
    [self.bgScrollow addSubview:self.yearBtn];
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
    [self.bgScrollow addSubview:self.photoView];
    [self setContentLayout];
}

-(void)setContentLayout{

    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    self.finishBtn.frame = CGRectMake(0, ScreenHeight-49, ScreenWidth, 49);

    self.nikeNameLabel.frame = CGRectMake(12, 24, 80, 40);
    self.sexLabel.frame = CGRectMake(12, self.nikeNameLabel.ctBottom+10, 80, 40);

    self.addressLabel.frame = CGRectMake(12, self.sexLabel.ctBottom+10, 80, 40);

    self.birthdayLabel.frame = CGRectMake(12, self.addressLabel.ctBottom+10, 80, 40);

    self.heightLabel.frame = CGRectMake(12, self.birthdayLabel.ctBottom+10, 80, 40);

    self.incomeLabel.frame = CGRectMake(12, self.heightLabel.ctBottom+10, 80, 40);

    self.marriageLabel.frame = CGRectMake(12, self.incomeLabel.ctBottom+10, 80, 40);

    self.declarationLoveLabel.frame = CGRectMake(12, self.marriageLabel.ctBottom+10, 80, 40);

    self.declarationLoveTextview.frame = CGRectMake(92, self.marriageLabel.ctBottom+10, ScreenWidth-104, 70);

    self.photoLabel.frame = CGRectMake(12, self.declarationLoveTextview.ctBottom+10, 80, 40);

    self.photoView.frame = CGRectMake(92, self.declarationLoveTextview.ctBottom+10, ScreenWidth-92-12, 260);
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
        make.width.mas_equalTo(ScreenWidth-104);
        make.height.mas_equalTo(40);
    }];
    
    [self.yearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollow).offset(92);
        make.top.equalTo(self.cityBtn.mas_bottom).offset(10);
        make.width.mas_equalTo(ScreenWidth-104);
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
    [self initScrollView];
}
-(UIScrollView *)bgScrollow{
    if (!_bgScrollow) {
        _bgScrollow = [[UIScrollView alloc]init];
        _bgScrollow.delegate = self;
        _bgScrollow.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-49);
        _bgScrollow.contentSize = CGSizeMake(0, ScreenHeight+200);
        _bgScrollow.bounces = NO;
        _bgScrollow.showsHorizontalScrollIndicator = NO;
        _bgScrollow.showsVerticalScrollIndicator = NO;
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
        _yearBtn.titleLabel.text = @"2018-05-02";
        [_yearBtn.selectedBtn addTarget:self action:@selector(pressYearBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yearBtn;
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
-(UIView *)photoView{
    if (!_photoView) {
        _photoView = [[UIView alloc]init];
        _photoView.userInteractionEnabled = YES;
//        _photoView.backgroundColor = [UIColor redColor];
    }
    return _photoView;
}
#pragma Action
-(void)pressNikeNameBtn:(UIButton*)sender{
    
    NSInteger num;
    num = (arc4random() % 6) + 3;
    self.nikeNameField.text = [self randomCreatChinese:num];
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
    CZHWeakSelf(self);
    [CZHAddressPickerView areaPickerViewWithProvince:self.province city:self.city area:self.area areaBlock:^(NSString *province, NSString *city, NSString *area) {
        CZHStrongSelf(self);
        self.province = province;
        self.city = city;
        self.area = area;
        
        _cityBtn.titleLabel.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,area];
        _cityBtn.titleLabel.textColor = DSColorFromHex(0x4D4D4D);
    }];
}

-(void)pressYearBtn:(UIButton*)sednder{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *nowStr = [fmt stringFromDate:now];
    __weak typeof(self) weakSelf = self;
    [CGXPickerView showDatePickerWithTitle:@"出生年月" DateType:UIDatePickerModeDate DefaultSelValue:nil MinDateStr:@"1900-01-01 00:00:00" MaxDateStr:nowStr IsAutoSelect:YES Manager:nil ResultBlock:^(NSString *selectValue) {
        NSLog(@"%@",selectValue);
        
        weakSelf.yearBtn.titleLabel.text = selectValue;
        weakSelf.yearBtn.titleLabel.textColor = DSColorFromHex(0x4D4D4D);
    }];
    
}

-(void)pressFinishBtn:(UIButton*)sender{
    [self comitData];
}
-(void)comitData{
    WorkerHandInViewModel *viewmodel = [[WorkerHandInViewModel alloc]init];
    AddFateReq *req = [[AddFateReq alloc]init];
    req.token = [self getToken];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *income = [numberFormatter numberFromString:self.incomeField.text];
    NSNumber *height = [numberFormatter numberFromString:self.heightField.text];
    req.monthly_income = income;
    req.height = height;
    req.birthday = self.yearBtn.titleLabel.text;
    req.nicheng = self.nikeNameField.text;
    req.live_address = _cityBtn.titleLabel.text;
    req.declaration = self.declarationLoveTextview.text;
    if (_tmpBtn == _maleBtn) {
        req.sex= @"1";
    }else if (_tmpBtn ==_femalemaleBtn){
        req.sex = @"0";
    }else{
        req.sex = @"2";
    }
    if (_marryBtn == _unmarriedBtn) {
        req.marital_status= @"1";
    }else if (_marryBtn ==_marriedBtn){
        req.marital_status = @"0";
    }else if(_marriedBtn ==_nurturedBtn){
        req.marital_status = @"2";
    }
    
    req.imgs = self.imageUrlArray;
    [viewmodel publishHandInHanInfoWithReq:req];
    [viewmodel setBlockWithReturnBlock:^(id returnValue) {
        PublicModel *publicModel = (PublicModel*)returnValue;
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self showJGProgressWithMsg:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            if (publicModel.message.length>0) {
                 [self showJGProgressWithMsg:publicModel.message];
            }
        }
    } WithErrorBlock:^(id errorCode) {
         
    }];
}
-(void)pressBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
}
///随机生成汉字

- (NSMutableString*)randomCreatChinese:(NSInteger)count{
    
    NSMutableString*randomChineseString =@"".mutableCopy;
    
    for(NSInteger i =0; i < count; i++){
        
        NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        //随机生成汉字高位
        
        NSInteger randomH =0xA1+arc4random()%(0xFE - 0xA1+1);
        
        //随机生成汉子低位
        
        NSInteger randomL =0xB0+arc4random()%(0xF7 - 0xB0+1);
        
        //组合生成随机汉字
        
        NSInteger number = (randomH<<8)+randomL;
        
        NSData*data = [NSData dataWithBytes:&number length:2];
        
        NSString*string = [[NSString alloc]initWithData:data encoding:gbkEncoding];
        
        [randomChineseString appendString:string];
        
        
    }
    
    return randomChineseString;
    
}


-(void)initScrollView{
    
    for (UIView *subview in self.photoView.subviews) {
        if (subview.tag > 800) {
            [subview removeFromSuperview];
        }
    }
    
    CGFloat w = 80;
    CGFloat sw =80;
    
    NSInteger imgCount = self.imageArray.count == 10 ? 9 : self.imageArray.count;
    CGRect picrect = self.declarationLoveTextview.frame;
//    picrect.size.height =  30 + (imgCount - 1) / 3 * sw+sw;
//    self.picView.frame = picrect;
    
//    CGRect myrect = self.myView.frame;
//    myrect.origin.y = self.picView.frame.origin.y + self.picView.frame.size.height + 15.f;
//    self.myView.frame = myrect;
//    self.imageScrollView.contentSize = CGSizeMake(ScreenWidth, 0);
//    [self.mainScrollView setContentSize:CGSizeMake(ScreenWidth, self.myView.frame.origin.y + self.myView.frame.size.height + 10)];
    for (int i = 0; i < self.imageArray.count; i ++) {
        if (i == 9 ) {
            return;
        }
        
        if (i == self.imageArray.count - 1) {
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(10*(i%3+1)+i % 3 * w, 10*(i/3+1)+i / 3 * w, w, w)];

            backview.tag = 801 + i;
            
    
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
           
            addBtn.frame = CGRectMake(0, 0, w, w);
            [addBtn setImage: [UIImage imageNamed:@"icon_increase"] forState:UIControlStateNormal];
            [addBtn setTitle:@"点击添加" forState:UIControlStateNormal];
            [addBtn setTitleColor:DSColorFromHex(0x999999) forState:UIControlStateNormal];
            addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            addBtn.backgroundColor = DSColorFromHex(0xEEEEEE);
            addBtn.imageEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, -60);
            addBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, -30, 0);
            
            [addBtn addTarget:self action:@selector(addImageAction:) forControlEvents:UIControlEventTouchUpInside];
            if (self.fateStatus != 0) {
                [backview addSubview:addBtn];
            }
            
            [self.photoView addSubview:backview];
            
        }
        else{
            
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(10*(i%3+1)+i % 3 * w, 10*(i/3+1)+i / 3 * w, w, w)];
            backview.tag = 801 + i;
            backview.backgroundColor = [UIColor blueColor];
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, w, w )];
            if (self.imgOrImgUrl == 0) {
                [imgview setImage:self.imageArray[i + 1]];
                
            }else{
                [imgview setImageWithString:self.imageUrlArray[i] placeHoldImageName:@"icon_increase"];
                //                [imgview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,self.imageUrlArray[i]]] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
            }
            
            
            [backview addSubview:imgview];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookPicture:)];
            [backview addGestureRecognizer:tap];
            
            CGRect backRect = backview.frame;
            UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [delBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 44 - 20, 44 - 27, 0)];
            delBtn.frame = CGRectMake(backRect.origin.x + backRect.size.width - 34.f, backRect.origin.y - 15, 44, 44);
            delBtn.tag = 801 + i;
            [delBtn setImage:[UIImage imageNamed:@"icon_cancel1"] forState:UIControlStateNormal];
            [delBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.photoView addSubview:backview];
            if (self.fateStatus != 0) {
                [self.photoView addSubview:delBtn];
            }
            
        }
    }
    
    
}
- (void)addImageAction:(id)sender {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    //添加Button
    [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self uploadImgs:UIImagePickerControllerSourceTypeCamera];
        
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"相册" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self uploadImgs:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }]];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];
}
- (void)uploadImgs:(UIImagePickerControllerSourceType)xtype{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = xtype;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
}

-(void)uploadImgToService:(UIImage *)img{
    //    __weak typeof(self) weakSelf = self;
    UploadImgViewModel *viewModel = [[UploadImgViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        PicModel *model = [returnValue firstObject];
        //        weakSelf.imgUrl = model.img_url;
        [self.imageArray addObject:img];
        [self.imageUrlArray addObject:model.img_url];
        [self initScrollView];
        //        self.iconImageView.image = img;
        [self dissJGProgressLoadingWithTag:200];
    } WithErrorBlock:^(id errorCode) {
        [self dissJGProgressLoadingWithTag:200];
    }];
    [viewModel uploadImgWithImage:img];
    [self showJGProgressLoadingWithTag:200];
}
#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        
        //        [weakSelf.imageArray addObject:image];
        [weakSelf uploadImgToService:image];
        //        [weakSelf initScrollView];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)deleteAction:(UIButton *)btn{
    [self.imageArray removeObjectAtIndex:btn.tag - 800];
    [self.imageUrlArray removeObjectAtIndex:btn.tag - 801];
    [self initScrollView];
}
//查看图片
-(void)lookPicture:(UITapGestureRecognizer *)ges{
    NSInteger index = ges.view.tag - 801;
    NSMutableArray *photosURL = [[NSMutableArray alloc] init];
    
    for ( int i = 0; i < self.imageUrlArray.count; i ++) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,self.imageUrlArray[i]]];
        [photosURL addObject:url];
    }
    
    // Create an array to store IDMPhoto objects
    NSMutableArray *photos = [NSMutableArray new];
    
    for (NSURL *url in photosURL) {
        IDMPhoto *photo = [IDMPhoto photoWithURL:url];
        [photos addObject:photo];
    }
    
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    [browser setInitialPageIndex:index];
    [self presentViewController:browser animated:YES completion:nil];
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
