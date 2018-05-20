//
//  CommonAlertView.m
//  TheWorker
//
//  Created by apple on 2018/5/14.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "CommonAlertView.h"
#import "CommonAlertViewCell.h"

@implementation CommonAlertView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        
        
    }
    return self;
}

-(void)setCommonType:(CommonAlertViewType)commonType{
    _commonType = commonType;
    switch (commonType) {
        case CommonTypeLogin:
        {
            self.layer.cornerRadius = 8;
            self.clipsToBounds = YES;
            self.backgroundColor = [UIColor whiteColor];
            [self addSubview:self.sexLabel];
            [self addSubview:self.yearLabel];
            [self addSubview:self.maleBtn];
            [self addSubview:self.femalemaleBtn];
            [self addSubview:self.yearBtn];
            [self addSubview:self.sureBtn];
            self.sexLabel.frame = CGRectMake(46, 48, 70, 14);
            self.maleBtn.frame = CGRectMake(116, 48, 40, 14);
            self.femalemaleBtn.frame = CGRectMake(180, 48, 40, 14);
            self.yearLabel.frame = CGRectMake(46, 88, 70, 40);
            self.yearBtn.frame = CGRectMake(116, 88, 189, 40);
            self.sureBtn.frame = CGRectMake(101, 175, 150, 40);
            [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        }
            break;
        case CommonTypeCoupon:
        {
            [self addSubview:self.checkUpImge];
            [self.checkUpImge addSubview:self.dismissBtn];
            [self.checkUpImge addSubview:self.sureBtn];
            [self.checkUpImge addSubview:self.tableview];
            self.checkUpImge.frame = CGRectMake(0, 0, 340, 396);
            self.tableview.frame = CGRectMake(25, 96, 290, 220);
            self.dismissBtn.frame = CGRectMake(325, 5, 20, 20);
            self.sureBtn.frame = CGRectMake(95, 326, 150, 40);
            [_sureBtn setTitle:@"一键领取" forState:UIControlStateNormal];
        }
            break;
            
        case CommonTypeCouponfinished:
        {
           
            [self addSubview:self.checkUpImge];
            [self.checkUpImge addSubview:self.dismissBtn];
            [self.checkUpImge addSubview:self.sureBtn];
            self.checkUpImge.frame = CGRectMake(0, 0, 340, 396);
            self.dismissBtn.frame = CGRectMake(325, 5, 20, 20);
            self.sureBtn.frame = CGRectMake(95, 289, 150, 40);
            [_sureBtn setTitle:@"查看卡包" forState:UIControlStateNormal];
             self.checkUpImge.image = [UIImage imageNamed:@"login_popuped"];
        }
            break;
        case CommonTypeApplyForJob:
        {
            [self addSubview:self.checkUpImge];
            [self.checkUpImge addSubview:self.dismissBtn];
            [self.checkUpImge addSubview:self.sureBtn];
            _checkUpImge.image = [UIImage imageNamed:@"jobsearch_popup"];
            self.checkUpImge.frame = CGRectMake(0, 0, 334, 307);
            self.dismissBtn.frame = CGRectMake(306, -10, 20, 20);
            self.sureBtn.frame = CGRectMake(91, 214, 150, 40);
            [_sureBtn setTitle:@"查看详情" forState:UIControlStateNormal];
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
-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.showsVerticalScrollIndicator = NO;
        
    }
    return _tableview;
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
        [_yearBtn.selectedBtn addTarget:self action:@selector(pressYearBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yearBtn;
}


-(UIImageView *)checkUpImge{
    if (!_checkUpImge) {
        _checkUpImge = [[UIImageView alloc]init];
        _checkUpImge.image = [UIImage imageNamed:@"login_popup"];
        _checkUpImge.userInteractionEnabled = YES;
    }
    return _checkUpImge;
}

-(UIButton *)dismissBtn{
    if (!_dismissBtn) {
        _dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismissBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_dismissBtn addTarget:self action:@selector(dismissBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBtn;
}
-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.backgroundColor = DSColorFromHex(0xFFCE00);
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sureBtn setTitleColor:DSColorFromHex(0x4D4D4D) forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(pressSureBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
-(void)pressYearBtn:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(selectedYearBtn)]) {
        [self.delegate selectedYearBtn];
    }
}
-(void)dismissBtn:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(selecteddismissBtn)]) {
        [self.delegate selecteddismissBtn];
    }
}
-(void)pressSureBtn:(UIButton*)sender{
    switch (self.commonType) {
        case CommonTypeLogin:
        {
            NSString * sex ;
            if (_tmpBtn == _maleBtn) {
                sex = @"1";
            }else if (_tmpBtn==_femalemaleBtn){
                sex = @"0";
            }else{
               
            }
            if ([self.delegate respondsToSelector:@selector(commitCommonTypeLogin:Sex:)]) {
                [self.delegate commitCommonTypeLogin:_yearBtn.titleLabel.text Sex:sex];
            }
        }
            break;
        case CommonTypeCoupon:
        {
            
            if ([self.delegate respondsToSelector:@selector(commitCommonTypeCoupon)]) {
                [self.delegate commitCommonTypeCoupon];
            }
        }
            break;
        case CommonTypeCouponfinished:
        {
            if ([self.delegate respondsToSelector:@selector(commitCheckPackage)]) {
                [self.delegate commitCheckPackage];
            }
        }
            break;
        case CommonTypeApplyForJob:
        {
            if ([self.delegate respondsToSelector:@selector(commitApplyForJob)]) {
                [self.delegate commitApplyForJob];
            }
        }
            break;
        default:
            break;
    }
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
-(void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [_tableview reloadData];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"CommonAlertViewCell";
    CommonAlertViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[CommonAlertViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (indexPath.row%2==0) {
        cell.bgImage.image = [UIImage imageNamed:@"bg_voucher_1"];
        cell.nameLabel.textColor = DSColorFromHex(0xF3B252);
    }else{
        cell.bgImage.image = [UIImage imageNamed:@"bg_voucher_2"];
        cell.nameLabel.textColor = DSColorFromHex(0xFA8238);
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:self.dataArr[indexPath.row]];
    return cell;
}
@end
