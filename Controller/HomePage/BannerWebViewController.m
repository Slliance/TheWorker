//
//  BannerWebViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/26.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BannerWebViewController.h"

@interface BannerWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *bannerWebView;

@end

@implementation BannerWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlStr = [NSString stringWithFormat:@"%@",self.bannerUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.bannerWebView loadRequest:[NSURLRequest requestWithURL:url]];
    self.bannerWebView.scalesPageToFit = YES;
    self.bannerWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)shareAction:(id)sender {
    
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
