//
//  ChooseMatchMakingController.m
//  TheWorker
//
//  Created by apple on 2018/4/27.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "ChooseMatchMakingController.h"
#import "HandInHandInformationController.h"
#import "MatchMakingInformationView.h"
#import "MatchMakingInformationController.h"


@interface ChooseMatchMakingController ()
@property(nonatomic,strong)UIImageView *bgImageView;
@property(nonatomic,strong)UIImageView *backgroundImage;
@property(nonatomic,strong)MatchMakingInformationView *matchView;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIButton *editBtn;
@end

@implementation ChooseMatchMakingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.backBtn];
    [self.bgImageView addSubview:self.editBtn];
    [self.bgImageView addSubview:self.backgroundImage];
    [self.backgroundImage addSubview:self.matchView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView);
        make.bottom.equalTo(self.bgImageView.mas_top).offset(64);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImageView);
        make.bottom.equalTo(self.bgImageView.mas_top).offset(64);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    [self.backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView).offset(7);
        make.top.equalTo(self.bgImageView).offset(64);
        make.right.equalTo(self.bgImageView).offset(-7);
        make.bottom.equalTo(self.bgImageView).offset(-7);
    }];
    [self.matchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(31);
        make.right.equalTo(self.view).offset(-31);
        make.bottom.equalTo(self.view).offset(-85);
        make.height.mas_equalTo(200);
    }];
}
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = [UIImage imageNamed:@"bg_gradient"];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}
-(UIImageView *)backgroundImage{
    if (!_backgroundImage) {
        _backgroundImage = [[UIImageView alloc]init];
        _backgroundImage.image = [UIImage imageNamed:@"pic_frame"];
        _backgroundImage.userInteractionEnabled = YES;
    }
    return _backgroundImage;
}
-(MatchMakingInformationView *)matchView{
    if (!_matchView) {
        _matchView = [[MatchMakingInformationView alloc]init];
//        _matchView.alpha = 0.6;
        _matchView.userInteractionEnabled = YES;
        _matchView.backgroundColor = [UIColor whiteColor];
        [_matchView.inputBtn addTarget:self action:@selector(pressInputBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _matchView;
}
-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
-(UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setImage:[UIImage imageNamed:@"holdinghands_icon_edit"] forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}
-(void)pressInputBtn:(UIButton*)sender{
    MatchMakingInformationController *informationVC = [[MatchMakingInformationController alloc]init];
    [self.navigationController pushViewController:informationVC animated:YES];
}
-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)pressEditBtn{
    HandInHandInformationController *changeVc = [[HandInHandInformationController alloc]init];
    [self.navigationController pushViewController:changeVc animated:YES];
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
