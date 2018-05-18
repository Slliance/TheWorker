//
//  HandInHandSViewController.m
//  TheWorker
//
//  Created by apple on 2018/4/26.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "HandInHandSViewController.h"
#import "HandInHandInformationController.h"
#import "ChooseMatchMakingController.h"

@interface HandInHandSViewController ()
@property(nonatomic,strong)UIImageView *bgImageView;

@property(nonatomic,strong)UIButton *startBtn;

@end

@implementation HandInHandSViewController
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = [UIImage imageNamed:@"hand_bg"];
        
    }
    return _bgImageView;
}

-(UIButton *)startBtn{
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setImage:[UIImage imageNamed:@"hand_button"] forState:UIControlStateNormal];
        [_startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startBtn addTarget:self action:@selector(pressStartBtn:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _startBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    self.navView.titleLabel.text = @"员工牵手";
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.startBtn];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide).offset(44);
    }];
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(227);
        make.height.mas_equalTo(227);
        make.centerX.equalTo(self.bgImageView);
        make.bottom.equalTo(self.bgImageView.mas_bottom).offset(-220);
    }];
   
}
-(void)pressBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)pressStartBtn:(UIButton *)sender{
    ChooseMatchMakingController *informationVC  = [[ChooseMatchMakingController alloc]init];
    [self.navigationController pushViewController:informationVC animated:YES];

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
