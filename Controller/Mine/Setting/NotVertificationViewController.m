//
//  NotVertificationViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/31.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "NotVertificationViewController.h"
#import "UploadInfoViewController.h"
@interface NotVertificationViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnVertification;

@end

@implementation NotVertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnVertification.layer.masksToBounds = YES;
    self.btnVertification.layer.cornerRadius = 4.f;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)skipToVertification:(id)sender {
    UploadInfoViewController *vc = [[UploadInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
