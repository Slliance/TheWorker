//
//  CreatResumeViewController.m
//  TheWorker
//
//  Created by apple on 2018/5/3.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "CreatResumeViewController.h"

@interface CreatResumeViewController ()

@end

@implementation CreatResumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
    switch (self.resumeType) {
        case ResumeTypeCreate:
            self.navView.titleLabel.text = @"创建简历";
            break;
        case ResumeTypePreview:
            self.navView.titleLabel.text = @"预览";
            break;
        case ResumeTypeChange:
            self.navView.titleLabel.text = @"修改简历";
            break;
        default:
            break;
    }
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(64);
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
