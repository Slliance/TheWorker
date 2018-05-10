//
//  MyResumeViewController.m
//  TheWorker
//
//  Created by apple on 2018/5/3.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "MyResumeViewController.h"
#import "FillApplicationViewController.h"
#import "MyResumeViewModel.h"


@interface MyResumeViewController ()
@property(nonatomic,strong)UILabel *readyLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIButton *creatBtn;
@property(nonatomic,strong)UIButton *previewBtn;
@property(nonatomic,strong)UIButton *changeBtn;
@property(nonatomic,strong)UIButton *deleteBtn;
@property(nonatomic,strong)MyResumeViewModel *viewModel;
@end

@implementation MyResumeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    UserModel *userModel = [[UserModel alloc] initWithDict:userinfo];
    if ([userModel.resume isEqualToString:@"1"]) {
        self.previewBtn.hidden = NO;
        self.changeBtn.hidden = NO;
        self.deleteBtn.hidden = NO;
        self.readyLabel.hidden = YES;
        self.contentLabel.hidden = YES;
        self.creatBtn.hidden = YES;
    }else{
        self.previewBtn.hidden = YES;
        self.changeBtn.hidden = YES;
        self.deleteBtn.hidden = YES;
        self.readyLabel.hidden = NO;
        self.contentLabel.hidden = NO;
        self.creatBtn.hidden = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.readyLabel];
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.creatBtn];
    [self.view addSubview:self.previewBtn];
    [self.view addSubview:self.changeBtn];
    [self.view addSubview:self.deleteBtn];
    
    self.navView.titleLabel.text = @"我的简历";
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    [self.readyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(154);
        make.height.mas_equalTo(20);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.readyLabel.mas_bottom).offset(20);
        
    }];
    [self.creatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(82);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(40);
    }];
    [self.previewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom).offset(128);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(40);
    }];
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.previewBtn.mas_bottom).offset(20);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(40);
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.changeBtn.mas_bottom).offset(20);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(40);
    }];
}
-(UILabel *)readyLabel{
    if (!_readyLabel) {
        _readyLabel = [[UILabel alloc]init];
        _readyLabel.text = @"她们都在员工的名义创建简历呢！";
        _readyLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
        _readyLabel.textAlignment = NSTextAlignmentCenter;
        _readyLabel.textColor = DSColorFromHex(0x4D4D4D);
    }
   return  _readyLabel;
}
-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.text = @"你还没有？";
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:30];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = DSColorFromHex(0x4D4D4D);
    }
    return  _contentLabel;
}
-(UIButton *)creatBtn{
    if (!_creatBtn) {
        _creatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_creatBtn setTitle:@"创建简历" forState:UIControlStateNormal];
        [_creatBtn setTitleColor:DSColorFromHex(0x4D4D4D) forState:UIControlStateNormal];
        [_creatBtn addTarget:self action:@selector(pressCreatBtn:) forControlEvents:UIControlEventTouchUpInside];
        _creatBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _creatBtn.backgroundColor = DSColorFromHex(0xFFCE00);
    }
    return _creatBtn;
}

-(UIButton *)previewBtn{
    if (!_previewBtn) {
        _previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_previewBtn setTitleColor:DSColorFromHex(0x4D4D4D) forState:UIControlStateNormal];
        [_previewBtn addTarget:self action:@selector(pressPreviewBtn:) forControlEvents:UIControlEventTouchUpInside];
        _previewBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _previewBtn.backgroundColor = DSColorFromHex(0xFFCE00);
    }
    return _previewBtn;
}
-(UIButton *)changeBtn{
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn setTitle:@"修改" forState:UIControlStateNormal];
        [_changeBtn setTitleColor:DSColorFromHex(0x4D4D4D) forState:UIControlStateNormal];
        [_changeBtn addTarget:self action:@selector(pressChangeBtn:) forControlEvents:UIControlEventTouchUpInside];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _changeBtn.backgroundColor = DSColorFromHex(0xFFCE00);
    }
    return _changeBtn;
}
-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:DSColorFromHex(0x4D4D4D) forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(pressDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _deleteBtn.backgroundColor = DSColorFromHex(0xFFCE00);
    }
    return _deleteBtn;
}

-(void)pressCreatBtn:(UIButton*)sender{
    FillApplicationViewController *VC = [[FillApplicationViewController alloc]init];
    VC.resumeType = 0;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)pressPreviewBtn:(UIButton*)sender{
    FillApplicationViewController *VC = [[FillApplicationViewController alloc]init];
    VC.resumeType = 1;
    [self.navigationController pushViewController:VC animated:YES];
    
}
-(void)pressChangeBtn:(UIButton*)sender{
    FillApplicationViewController *VC = [[FillApplicationViewController alloc]init];
    VC.resumeType = 2;
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)pressDeleteBtn:(UIButton*)sender{
       [self deleteMyResume];
}
-(void)pressBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
}
///删除简历
-(void)deleteMyResume{
    self.viewModel = [[MyResumeViewModel alloc]init];
    [self.viewModel deleteResumeToken:[self getToken]];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
    
    } WithErrorBlock:^(id errorCode) {
        
    }];
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
