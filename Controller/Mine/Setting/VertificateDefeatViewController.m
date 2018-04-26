//
//  VertificateDefeatViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/31.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "VertificateDefeatViewController.h"
#import "UploadInfoViewController.h"
@interface VertificateDefeatViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnPop;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation VertificateDefeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btnBack.layer.masksToBounds = YES;
    self.btnBack.layer.cornerRadius = 4.f;
    [self.btnBack.layer setBorderWidth:1];
    [self.btnBack.layer setBorderColor:[UIColor colorWithHexString:@"6398f1"].CGColor];
    self.btnSubmit.layer.masksToBounds = YES;
    self.btnSubmit.layer.cornerRadius = 4.f;
    if (self.type == 0) {
        self.btnPop.hidden = YES;
    }else{
        self.btnPop.hidden = NO;
        self.btnBack.hidden = YES;
        self.btnSubmit.hidden = YES;
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.type != 0) {
        self.btnSubmit.hidden = NO;
        CGRect rect = self.btnSubmit.frame;
        self.btnSubmit.center = self.view.center;
        rect.origin.x = (ScreenWidth - rect.size.width) / 2;
        [self.btnSubmit setFrame:rect];
    }
    
}
- (IBAction)backToMainPage:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)submitAgain:(id)sender {
    UploadInfoViewController *vc = [[UploadInfoViewController alloc] init];
    vc.type = 0;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
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
