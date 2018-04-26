//
//  AboutUsWebViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/26.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "AboutUsWebViewController.h"

@interface AboutUsWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation AboutUsWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.infoWebView.backgroundColor = [UIColor whiteColor];
    self.infoWebView.dataDetectorTypes = UIDataDetectorTypeLink;
    //取消右侧，下侧滚动条，去处上下滚动边界的黑色背景
    self.infoWebView.backgroundColor=[UIColor clearColor];
    for (UIView *_aView in [self.infoWebView subviews])
    {
        if ([_aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
            //右侧的滚动条
            
            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
            //下侧的滚动条
            
            for (UIView *_inScrollview in _aView.subviews)
            {
                if ([_inScrollview isKindOfClass:[UIImageView class]])
                {
                    _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                }
            }
        }
    }
//    self.infoWebView.scrollView.bounces = NO;
    self.titleLabel.text = self.titleStr;
    [self.infoWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/index.php/index/Web_view/protocol?type=%@",BaseUrl,self.urlStr]]]];
    // Do any additional setup after loading the view from its nib.
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
