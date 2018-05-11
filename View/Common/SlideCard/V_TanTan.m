//
//  V_TanTan.m
//  TanTanDemo
//
//  Created by zhujiamin on 2017/9/17.
//  Copyright © 2017年 zhujiamin. All rights reserved.
//

#import "V_TanTan.h"
#import "M_TanTan.h"

@interface V_TanTan ()

@property (nonatomic, strong) UIImageView   *iv_user;
@property (nonatomic, strong) UILabel       *lb_name;
@property (nonatomic, strong) UILabel       *lb_age;
@property (nonatomic, strong) UILabel       *lb_constellation;
@property (nonatomic, strong) UILabel       *lb_jobOrDistance;

@end

@implementation V_TanTan

- (void)initUI {
    [super initUI];

//    [self.contentView addSubview:self.iv_user];
//    [self.contentView addSubview:self.iv_like];
//    [self.contentView addSubview:self.iv_hate];
//
//    [self.contentView addSubview:self.lb_name];
//    [self.contentView addSubview:self.lb_age];
//    [self.contentView addSubview:self.lb_constellation];
//    [self.contentView addSubview:self.lb_jobOrDistance];
    [self setContentLayout];
}


- (void)setDataItem:(M_TanTan *)dataItem {
    _dataItem = dataItem;
    self.lb_name.text = dataItem.userName;
    self.iv_user.image = [UIImage imageNamed:dataItem.imageName];
    self.lb_age.text = dataItem.age;
    self.lb_constellation.text = dataItem.constellationName;
    self.lb_jobOrDistance.text = dataItem.jobName.length ? dataItem.jobName : dataItem.distance;
}

//#pragma mark - getter
//
//- (UIImageView *)iv_user {
//    if (_iv_user == nil) {
//        _iv_user = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 70)];
//    }
//    return _iv_user;
//}
//
//- (UIImageView *)iv_like {
//    if (_iv_like == nil) {
//        _iv_like = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
//        _iv_like.image = [UIImage imageNamed:@"likeLine"];
//        _iv_like.alpha = 0;
//    }
//    return _iv_like;
//}
//
//- (UIImageView *)iv_hate {
//    if (_iv_hate == nil) {
//        _iv_hate = [[UIImageView alloc]  initWithFrame:CGRectMake(self.frame.size.width - 20 - 60, 20, 60, 60)];
//        _iv_hate.image = [UIImage imageNamed:@"hateLine"];
//        _iv_hate.alpha = 0;
//    }
//    return _iv_hate;
//}
//
//- (UILabel *)lb_name {
//    if (_lb_name == nil) {
//        _lb_name = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.iv_user.frame), 100, 20)];
//        _lb_name.font = [UIFont boldSystemFontOfSize:16];
//        
//    }
//    return _lb_name;
//}
//
//- (UILabel *)lb_age {
//    if (_lb_age == nil) {
//        _lb_age = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.lb_name.frame), 30, 20)];
//        _lb_age.font = [UIFont systemFontOfSize:13];
//        _lb_age.textColor = [UIColor redColor];
//        
//    }
//    return _lb_age;
//}
//
//- (UILabel *)lb_constellation {
//    if (_lb_constellation == nil) {
//        _lb_constellation = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lb_age.frame), CGRectGetMaxY(self.lb_name.frame), 50, 20)];
//        _lb_constellation.font = [UIFont systemFontOfSize:11];
//        
//    }
//    return _lb_constellation;
//}
//
//- (UILabel *)lb_jobOrDistance {
//    if (_lb_jobOrDistance == nil) {
//        _lb_jobOrDistance = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.lb_age.frame), 30, 20)];
//        _lb_jobOrDistance.font = [UIFont systemFontOfSize:11];
//    }
//    return _lb_jobOrDistance;
//}

-(void)setContentLayout{
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.bgview];
    [self.bgview addSubview:self.sexImage];
    [self.bgview addSubview:self.nameLabel];
    [self.bgview addSubview:self.yearLabel];
    [self.bgview addSubview:self.distanceLabel];
    [self.bgview addSubview:self.loveLabel];
    [self.bgview addSubview:self.loveContentLabel];
    [self.bgview addSubview:self.inputBtn];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        //        make.width.mas_equalTo(305);
        //        make.height.mas_equalTo(538);
    }];
    [self.bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgImageView);
        make.height.mas_equalTo(200);
        make.bottom.equalTo(self.bgImageView.mas_bottom).offset(-60);
    }];
    [self.sexImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bgview).offset(15);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(15);
        
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexImage);
        make.right.equalTo(self.bgview).offset(-15);
        make.width.mas_equalTo(60);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgview).offset(15);
        make.left.equalTo(self.sexImage.mas_right).offset(10);
        make.right.equalTo(self.distanceLabel.mas_left).offset(-10);
    }];
    [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgview).offset(15);
        make.right.equalTo(self.bgview).offset(-15);
        make.top.equalTo(self.sexImage.mas_bottom).offset(18);
    }];
    [self.loveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgview).offset(15);
        make.right.equalTo(self.bgview).offset(-15);
        make.top.equalTo(self.yearLabel.mas_bottom).offset(30);
    }];
    [self.loveContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgview).offset(15);
        make.right.equalTo(self.bgview).offset(-15);
        make.top.equalTo(self.loveLabel.mas_bottom).offset(11);
    }];
    [self.inputBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
}
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image =[UIImage imageNamed:@"photo"];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}
-(UIView *)bgview{
    if (!_bgview) {
        _bgview = [[UIView alloc]init];
        _bgview.userInteractionEnabled = YES;
        _bgview.backgroundColor = [UIColor whiteColor];
        _bgview.alpha = 0.6;
    }
    return _bgview;
}
-(UIImageView *)sexImage{
    if (!_sexImage) {
        _sexImage = [[UIImageView alloc]init];
        _sexImage.image = [UIImage imageNamed:@"icon_female"];
    }
    return _sexImage;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor =DSColorFromHex(0x4D4D4D);
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"猜猜我是谁";
    }
    return _nameLabel;
}

-(UILabel *)yearLabel{
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc]init];
        _yearLabel.textColor =DSColorFromHex(0x4D4D4D);
        _yearLabel.font = [UIFont systemFontOfSize:12];
        _yearLabel.textAlignment = NSTextAlignmentLeft;
        _yearLabel.text = @"19岁  166cm  月收入5000元";
    }
    return _yearLabel;
}
-(UILabel *)distanceLabel{
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc]init];
        _distanceLabel.textColor =DSColorFromHex(0x1C6AF2);
        _distanceLabel.font = [UIFont systemFontOfSize:12];
        _distanceLabel.textAlignment = NSTextAlignmentLeft;
        _distanceLabel.text = @"距离900m";
    }
    return _distanceLabel;
}

-(UILabel *)loveLabel{
    if (!_loveLabel) {
        _loveLabel = [[UILabel alloc]init];
        _loveLabel.textColor =DSColorFromHex(0x999999);
        _loveLabel.font = [UIFont systemFontOfSize:12];
        _loveLabel.textAlignment = NSTextAlignmentLeft;
        _loveLabel.text = @"爱情宣言";
    }
    return _loveLabel;
}
-(UILabel *)loveContentLabel{
    if (!_loveContentLabel) {
        _loveContentLabel = [[UILabel alloc]init];
        _loveContentLabel.textColor =DSColorFromHex(0x4D4D4D);
        _loveContentLabel.font = [UIFont systemFontOfSize:12];
        _loveContentLabel.textAlignment = NSTextAlignmentLeft;
        _loveContentLabel.numberOfLines = 5;
        _loveContentLabel.text = @"sdfghjkl;'fghjklcvbnm,xcvbnm,.sdfghjlcdasdfghjkertyu";
    }
    return _loveContentLabel;
}

-(UIButton *)inputBtn{
    if (!_inputBtn) {
        _inputBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _inputBtn;
}
@end
