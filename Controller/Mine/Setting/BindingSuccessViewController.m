//
//  BindingSuccessViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/31.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BindingSuccessViewController.h"

@interface BindingSuccessViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelMailBox;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@end

@implementation BindingSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnBack.layer.masksToBounds = YES;
    self.btnBack.layer.cornerRadius = 4.f;
    [self.btnBack.layer setBorderWidth:1];
    [self.btnBack.layer setBorderColor:[UIColor colorWithHexString:@"6398f1"].CGColor];
    self.labelMailBox.text = self.emailStr;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backToMainPage:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
