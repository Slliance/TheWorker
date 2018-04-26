//
//  InfoDetailViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/10.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "InfoDetailViewController.h"
#import "CollectViewModel.h"


@interface InfoDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnCollect;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;

@end

@implementation InfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlStr = [NSString stringWithFormat:@"%@",self.bannerUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.infoWebView loadRequest:[NSURLRequest requestWithURL:url]];
    self.infoWebView.scalesPageToFit = YES;
    self.infoWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    if (self.isCollect == 1) {
        [self.btnCollect setImage:[UIImage imageNamed:@"icon_have_been_evaluated"] forState:UIControlStateNormal];
        self.btnCollect.selected = YES;
    }
    [HYNotification addLoginNotification:self action:@selector(loginAction:)];
    // Do any additional setup after loading the view from its nib.
}

-(void)loginAction:(HYNotification *)noti{
    CollectViewModel *viewModel = [[CollectViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel isCollectWithToken:[self getToken] articleId:self.articleId collectType:self.type];
}
- (IBAction)backAction:(id)sender {
    self.returnReloadBlock();
    [self backBtnAction:sender];
}
- (IBAction)collectAction:(id)sender {
    if (![self isLogin]) {
        [self skiptoLogin];
        return;
    }
    if (self.btnCollect.selected == YES) {
        CollectViewModel *viewModel = [[CollectViewModel alloc]init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [self dissJGProgressLoadingWithTag:200];
            [self showJGProgressWithMsg:@"取消收藏成功"];
            [self.btnCollect setImage:[UIImage imageNamed:@"icon_collection"] forState:UIControlStateNormal];
            self.btnCollect.selected = NO;
        } WithErrorBlock:^(id errorCode) {
            [self dissJGProgressLoadingWithTag:200];
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel userCollectWithToken:[self getToken] articleId:self.articleId collectType:self.type];
        [self showJGProgressLoadingWithTag:200];
        
    }else{
        CollectViewModel *viewModel = [[CollectViewModel alloc]init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [self dissJGProgressLoadingWithTag:200];
            [self showJGProgressWithMsg:@"添加收藏成功"];
            [self.btnCollect setImage:[UIImage imageNamed:@"icon_have_been_evaluated"] forState:UIControlStateNormal];
            self.btnCollect.selected = YES;
        } WithErrorBlock:^(id errorCode) {
            [self dissJGProgressLoadingWithTag:200];
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel userCollectWithToken:[self getToken] articleId:self.articleId collectType:self.type];
        [self showJGProgressLoadingWithTag:200];
        
    }
   
    
}
- (IBAction)shareAction:(id)sender {

    NSString *contentstr = [NSString stringWithFormat:@"<div style=\"font-size:13px; color:#737373;\"> %@</div>",self.articleModel.content];
    NSString *string = [self filterHTML:contentstr];
    if (string.length > 20) {
        string = [string substringToIndex:19];
    }else{
        string = string;
    }
    if ([string isEqualToString:@"null"]) {
        string = @"";
    }
    if (self.articleModel.show_img) {

        if (!string || [string containsString:@"null"]) {
            [self shareWithPageUrl:self.bannerUrl shareTitle:self.articleModel.title shareDes : @"" thumImage:[NSString stringWithFormat:@"%@%@",BaseUrl,self.articleModel.show_img]];
        }
        else{
            [self shareWithPageUrl:self.bannerUrl shareTitle:self.articleModel.title shareDes : string thumImage:[NSString stringWithFormat:@"%@%@",BaseUrl,self.articleModel.show_img]];
        }
    }
    else if (self.articleModel.img){

        if (!string || [string containsString:@"null"]) {
            [self shareWithPageUrl:self.bannerUrl shareTitle:self.articleModel.title shareDes : @"" thumImage:[NSString stringWithFormat:@"%@%@",BaseUrl,self.articleModel.img]];
        }
        else{
            [self shareWithPageUrl:self.bannerUrl shareTitle:self.articleModel.title shareDes : string thumImage:[NSString stringWithFormat:@"%@%@",BaseUrl,self.articleModel.img]];
        }
        
    }
}
//去掉 HTML 字符串中的标签
- (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
//    [self showJGProgressLoadingWithTag:200];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    [self dissJGProgressLoadingWithTag:200];
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
