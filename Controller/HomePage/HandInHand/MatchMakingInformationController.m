//
//  MatchMakingInformationController.m
//  TheWorker
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "MatchMakingInformationController.h"
#import "DetailMatchMakingHeadView.h"
#import "DeclarationOfLoveView.h"
#import "DetailMatchInformationView.h"

@interface MatchMakingInformationController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *bgScrollow;

@property(nonatomic,strong)DetailMatchMakingHeadView *headView;
@property(nonatomic,strong)DeclarationOfLoveView *loveView;
@property(nonatomic,strong)DetailMatchInformationView *informaiotnView;
@property(nonatomic,strong)UIButton *likeBtn;
@property(nonatomic,strong)UIButton *addFriendBtn;
@property(nonatomic,strong)UILabel *lineLabel;

@end

@implementation MatchMakingInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
    self.navView.titleLabel.text = @"查看资料";
    [self.view addSubview:self.bgScrollow];
    [self.bgScrollow addSubview:self.headView];
    [self.bgScrollow addSubview:self.loveView];
    [self.bgScrollow addSubview:self.informaiotnView];
    [self.view addSubview:self.likeBtn];
    [self.view addSubview:self.addFriendBtn];
    [self.likeBtn addSubview:self.lineLabel];
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
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.bgScrollow);
        make.height.mas_equalTo(140);
    }];
    [self.loveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.headView.mas_bottom).offset(5);
        make.height.mas_equalTo(95);
    }];
    [self.informaiotnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.loveView.mas_bottom).offset(5);
        make.height.mas_equalTo(795);
    }];
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(ScreenWidth/2);
    }];
    [self.addFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(ScreenWidth/2);
    }];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.right.equalTo(self.likeBtn.mas_right).offset(-1);
        make.top.equalTo(self.likeBtn).offset(3);
        make.width.mas_equalTo(1);
        make.bottom.equalTo(self.likeBtn.mas_bottom).offset(-3);
    }];
}
-(UIScrollView *)bgScrollow{
    if (!_bgScrollow) {
        _bgScrollow = [[UIScrollView alloc]init];
        _bgScrollow.delegate = self;
        _bgScrollow.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-49);
        _bgScrollow.contentSize = CGSizeMake(ScreenWidth, ScreenHeight+100);
        _bgScrollow.backgroundColor = DSColorFromHex(0xDCDCDC);
    }
    return _bgScrollow;
}
-(DetailMatchMakingHeadView *)headView{
    if (!_headView) {
        _headView = [[DetailMatchMakingHeadView alloc]init];
    }
    return _headView;
}
-(DeclarationOfLoveView *)loveView{
    if (!_loveView) {
        _loveView = [[DeclarationOfLoveView alloc]init];
    }
    return _loveView;
}
-(DetailMatchInformationView *)informaiotnView{
    if (!_informaiotnView) {
        _informaiotnView = [[DetailMatchInformationView alloc]init];
    }
    return _informaiotnView;
}
-(UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeBtn.backgroundColor = DSColorFromHex(0xFFCE00);
        [_likeBtn setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"icon_like_choose"] forState:UIControlStateSelected];
        [_likeBtn addTarget:self action:@selector(pressLikeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_likeBtn setTitle:@"我喜欢" forState:UIControlStateNormal];
        _likeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [_likeBtn setTitleColor:DSColorFromHex(0x4D4D4D) forState:UIControlStateNormal];
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _likeBtn;
}
-(UIButton *)addFriendBtn{
    if (!_addFriendBtn) {
        _addFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addFriendBtn.backgroundColor = DSColorFromHex(0xFFCE00);
        [_addFriendBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
        [_addFriendBtn setImage:[UIImage imageNamed:@"icon_friends"] forState:UIControlStateSelected];
        [_addFriendBtn addTarget:self action:@selector(pressAddBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_addFriendBtn setTitle:@"加好友" forState:UIControlStateNormal];
        [_addFriendBtn setTitle:@"已是好友" forState:UIControlStateSelected];
        [_addFriendBtn setTitleColor:DSColorFromHex(0x4D4D4D) forState:UIControlStateNormal];
        _addFriendBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _addFriendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _addFriendBtn;
}

-(UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = [UIColor whiteColor];
    }
    return _lineLabel;
}
-(void)pressLikeBtn:(UIButton*)sender{
    sender.selected = !sender.selected;
}
-(void)pressAddBtn:(UIButton*)sender{
    sender.selected = !sender.selected;
}
-(void)pressBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
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
