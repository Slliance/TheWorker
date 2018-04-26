//
//  HandInHandSViewController.m
//  TheWorker
//
//  Created by apple on 2018/4/26.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "HandInHandSViewController.h"
#import "NavgationView.h"
@interface HandInHandSViewController ()
@property(nonatomic,strong)UIImageView *bgImageView;
@property(nonatomic,strong)NavgationView *navView;
@end

@implementation HandInHandSViewController
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = [UIImage imageNamed:@"handInhand_banner"];
        
    }
    return _bgImageView;
}
-(NavgationView *)navView{
    if (!_navView) {
        _navView = [[NavgationView alloc]init];
    }
    return _navView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.bgImageView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide).offset(44);
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
