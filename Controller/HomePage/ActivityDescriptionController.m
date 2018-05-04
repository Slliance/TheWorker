//
//  ActivityDescriptionController.m
//  TheWorker
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "ActivityDescriptionController.h"

@interface ActivityDescriptionController ()
@property(nonatomic,strong)UIImageView *headImage;
@property(nonatomic,strong)UIButton *titlebtn;
@property(nonatomic,strong)UILabel *firstlabel;
@property(nonatomic,strong)UILabel *secondLabel;
@property(nonatomic,strong)UILabel *threeLabel;
@property(nonatomic,strong)UILabel *detailThreeLabel;
@property(nonatomic,strong)UILabel *fourLabel;
@property(nonatomic,strong)UILabel *detailFourLabel;
@property(nonatomic,strong)UILabel *fiveLabel;
@property(nonatomic,strong)UIButton *detailBtn;
@end

@implementation ActivityDescriptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
    self.navView.titleLabel.text = @"活动说明";
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    [self.view addSubview:self.headImage];
    [self.view addSubview:self.titlebtn];
    [self.view addSubview:self.firstlabel];
    [self.view addSubview:self.secondLabel];
    [self.view addSubview:self.threeLabel];
    [self.view addSubview:self.detailThreeLabel];
    [self.view addSubview:self.fourLabel];
    [self.view addSubview:self.detailFourLabel];
    [self.view addSubview:self.fiveLabel];
    [self.view addSubview:self.detailBtn];
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.height.mas_equalTo(250);
    }];
    [self.titlebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.headImage.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    [self.firstlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-22);
        make.top.equalTo(self.titlebtn.mas_bottom).offset(19);
        make.height.mas_equalTo(12);
    }];
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-22);
        make.top.equalTo(self.firstlabel.mas_bottom).offset(10);
        make.height.mas_equalTo(12);
    }];
    [self.threeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.width.mas_equalTo(13);
        make.top.equalTo(self.secondLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(12);
    }];
    [self.detailThreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.threeLabel.mas_right);
        make.right.equalTo(self.view).offset(-22);
        make.top.equalTo(self.secondLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(34);
    }];
    [self.fourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.width.mas_equalTo(13);
        make.top.equalTo(self.detailThreeLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(12);
    }];
    [self.detailFourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fourLabel.mas_right);
        make.right.equalTo(self.view).offset(-22);
        make.top.equalTo(self.detailThreeLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(34);
    }];
    [self.fiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-22);
        make.top.equalTo(self.detailFourLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(12);
    }];
    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(40);
    }];
}

-(UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc]init];
        _headImage.image = [UIImage imageNamed:@"pic"];
    }
    return _headImage;
}
-(UIButton *)titlebtn{
    if (!_titlebtn) {
        _titlebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titlebtn setTitle:@"三级分销模式介绍" forState:UIControlStateNormal];
        _titlebtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_titlebtn setTitleColor:DSColorFromHex(0x4D4D4D) forState:UIControlStateNormal];
        _titlebtn.enabled = NO;
        _titlebtn.backgroundColor = DSColorFromHex(0xECDED1);
    }
    return _titlebtn;
}
-(UIButton *)detailBtn{
    if (!_detailBtn) {
        _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_detailBtn setTitle:@"详细活动规则" forState:UIControlStateNormal];
        _detailBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_detailBtn setTitleColor:DSColorFromHex(0x4D4D4D) forState:UIControlStateNormal];
        _detailBtn.backgroundColor = DSColorFromHex(0xFFCE00);
    }
    return _detailBtn;
}
-(UILabel *)firstlabel{
    if (!_firstlabel) {
        _firstlabel = [[UILabel alloc]init];
        _firstlabel.text = @"1.一传十、十传百的效应；";
        _firstlabel.font = [UIFont systemFontOfSize:12];
        _firstlabel.textColor  = DSColorFromHex(0x4D4D4D);
        _firstlabel.textAlignment = NSTextAlignmentLeft;
    }
    return _firstlabel;
}
-(UILabel *)secondLabel{
    if (!_secondLabel) {
        _secondLabel = [[UILabel alloc]init];
        _secondLabel.text = @"2.可获得积分（免费兑换商品）；";
        _secondLabel.font = [UIFont systemFontOfSize:12];
        _secondLabel.textColor  = DSColorFromHex(0x4D4D4D);
        _secondLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _secondLabel;
}
- (UILabel *)threeLabel{
    if (!_threeLabel) {
        _threeLabel = [[UILabel alloc]init];
        _threeLabel.text = @"3.";
        _threeLabel.font = [UIFont systemFontOfSize:12];
        _threeLabel.textColor  = DSColorFromHex(0x4D4D4D);
        _threeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _threeLabel;
}
-(UILabel *)detailThreeLabel{
    if (!_detailThreeLabel) {
        _detailThreeLabel = [[UILabel alloc]init];
        _detailThreeLabel.font = [UIFont systemFontOfSize:12];
        _detailThreeLabel.textColor  = DSColorFromHex(0x4D4D4D);
        _detailThreeLabel.textAlignment = NSTextAlignmentLeft;
        _detailThreeLabel.numberOfLines = 0;
        NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle  setLineSpacing:5];
        NSString  *testString = @"推荐的所有会员，将来每成功就职一人，扫码人均可获得平台给予的最高2000元奖励，不限时间；";
        NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:testString];
        [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [testString length])];
        
        // 设置Label要显示的text
        [_detailThreeLabel  setAttributedText:setString];
    }
    return _detailThreeLabel;
}
-(UILabel *)fourLabel{
    if (!_fourLabel) {
        _fourLabel = [[UILabel alloc]init];
        _fourLabel.text = @"4.";
        _fourLabel.font = [UIFont systemFontOfSize:12];
        _fourLabel.textColor  = DSColorFromHex(0x4D4D4D);
        _fourLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _fourLabel;
}
-(UILabel *)detailFourLabel{
    if (!_detailFourLabel) {
        _detailFourLabel = [[UILabel alloc]init];
        _detailFourLabel.font = [UIFont systemFontOfSize:12];
        _detailFourLabel.textColor  = DSColorFromHex(0x4D4D4D);
        _detailFourLabel.textAlignment = NSTextAlignmentLeft;
        _detailFourLabel.numberOfLines = 0;
        NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle  setLineSpacing:5];
        NSString  *testString = @"通过自身邀请进来的好友，邀请人可终身享受所有会员在平台活跃的奖励；";
        NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:testString];
        [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [testString length])];
        
        // 设置Label要显示的text
        [_detailFourLabel  setAttributedText:setString];
    }
    return _detailFourLabel;
}
-(UILabel *)fiveLabel{
    if (!_fiveLabel) {
        _fiveLabel = [[UILabel alloc]init];
        _fiveLabel.text = @"5.详细介绍可点击详细活动规则查看。";
        _fiveLabel.font = [UIFont systemFontOfSize:12];
        _fiveLabel.textColor  = DSColorFromHex(0x4D4D4D);
        _fiveLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _fiveLabel;
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
