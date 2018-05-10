//
//  WantedJobDetailViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/29.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "WantedJobDetailViewController.h"
#import "FillApplicationViewController.h"
#import "JobViewModel.h"
#import "CollectViewModel.h"
#import "UserModel.h"
@interface WantedJobDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnIWantJob;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UIView *jobView;
@property (weak, nonatomic) IBOutlet UIView *companyView;
@property (weak, nonatomic) IBOutlet UILabel *labelIntroduction;
@property (weak, nonatomic) IBOutlet UIScrollView *jobScrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *wagesLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnClickCount;
@property (weak, nonatomic) IBOutlet UILabel *usefulTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *workTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *workAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnCollect;
@property (weak, nonatomic) IBOutlet UIWebView *introductionWebView;

@end

@implementation WantedJobDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnIWantJob.layer.masksToBounds = YES;
    self.btnIWantJob.layer.cornerRadius = 4.f;
    JobViewModel *viewModel = [[JobViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        self.jobModel = returnValue;
        [self initView];
        [self CaculateFrame];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchJobDetailWithJobId:self.jobModel.Id token:[self getToken]];

    
    // Do any additional setup after loading the view from its nib.
}

-(void)initView{
    if ([self.jobModel.is_collect integerValue] == 1) {
        self.btnCollect.selected = YES;
    }
    self.titleLabel.text = self.jobModel.title;
    self.wagesLabel.text = [NSString stringWithFormat:@"%@-%@元/月",self.jobModel.min_wages,self.jobModel.max_wages];
    self.timeLabel.text = self.jobModel.updatetime;
    self.companyLabel.text = self.jobModel.name;
    [self.btnClickCount setTitle:[NSString stringWithFormat:@"%@次",self.jobModel.click_count] forState:UIControlStateNormal];
    self.usefulTimeLabel.text = self.jobModel.valid_time;
    self.workTimeLabel.text = self.jobModel.work_time;
    self.workAddressLabel.text = self.jobModel.address;
    self.amountLabel.text = [NSString stringWithFormat:@"%@",self.jobModel.count];
    NSString *discreble = [NSString stringWithFormat:@"<div style=\"font-size:13px; color:#737373;\"> %@</div>",self.jobModel.discreble];
    NSAttributedString * attrStr1 = [[NSAttributedString alloc] initWithData:[discreble dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    NSString *describale = [NSString stringWithFormat:@"<div style=\"font-size:13px; color:#737373;\"> %@</div>",self.jobModel.company_describale];
    NSAttributedString * attrStr2 = [[NSAttributedString alloc] initWithData:[describale dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    self.labelDescription.attributedText = attrStr1;
    self.labelIntroduction.attributedText = attrStr2;
    self.introductionWebView.backgroundColor = [UIColor whiteColor];
    [self.introductionWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.jobModel.company_describale]]];
//    [self.introductionWebView loadHTMLString:describale baseURL:[NSURL URLWithString:BaseUrl]];
}
//收藏
- (IBAction)collectAction:(id)sender {
    if (![self isLogin]) {
        [self skiptoLogin];
        return;
    }
    if (self.btnCollect.selected == YES) {
        CollectViewModel *viewModel = [[CollectViewModel alloc]init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [self showJGProgressWithMsg:@"取消收藏成功"];
            self.btnCollect.selected = NO;
            
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel userCollectWithToken:[self getToken] articleId:[NSString stringWithFormat:@"%@",self.jobModel.Id] collectType:@(3)];
    }else{
        CollectViewModel *viewModel = [[CollectViewModel alloc]init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [self showJGProgressWithMsg:@"添加收藏成功"];
            self.btnCollect.selected = YES;
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel userCollectWithToken:[self getToken] articleId:[NSString stringWithFormat:@"%@",self.jobModel.Id] collectType:@(3)];
    }

}
///分享
- (IBAction)pressShareBtn:(id)sender {
    if ([self isLogin]) {
        NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
        UserModel *userModel = [[UserModel alloc] initWithDict:userinfo];
        
        [self shareWithPageUrl:userModel.share shareTitle:userModel.share_title shareDes:userModel.share_content thumImage:userModel.show_img];
    }else{
        [self skiptoLogin];
    }
}
- (IBAction)backAction:(id)sender {
    NSInteger count = [self.jobModel.click_count integerValue] + 1;
    self.jobModel.click_count = @(count);
    self.returnReloadBlock(self.jobModel);
    [self backBtnAction:sender];
}
- (IBAction)wantJobAction:(id)sender {
    if (![self isLogin]) {
        [self skiptoLogin];
        return;
    }
    FillApplicationViewController *vc = [[FillApplicationViewController alloc]init];
    vc.workId = self.jobModel.Id;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)CaculateFrame{

    CGSize addressSize = [self.workAddressLabel.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ScreenWidth-95, 40)];
    CGRect rectAdd = self.workAddressLabel.frame;
    rectAdd.size.height = addressSize.height;
    self.workAddressLabel.frame = rectAdd;
    
    CGSize jobSize = [self.labelDescription.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ScreenWidth-20, 3000)];
    CGRect desRect = self.labelDescription.frame;
    desRect.size.height = jobSize.height;
    CGRect jobRect = self.jobView.frame;
    jobRect.size.height = desRect.origin.y+jobSize.height+13;
    self.labelDescription.frame = desRect;
    self.jobView.frame = jobRect;
    
    CGSize introSize = [self.labelIntroduction.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ScreenWidth-20, 3000)];
    CGRect introRect = self.labelIntroduction.frame;
    introRect.size.height = introSize.height;
    CGRect comRect = self.companyView.frame;
    comRect.origin.y = jobRect.origin.y+jobRect.size.height+13;
    comRect.size.height = 250;
    self.labelIntroduction.frame = introRect;
    self.companyView.frame = comRect;
    CGRect newFrame = self.introductionWebView.frame;
        newFrame.size.height = 200;
        self.introductionWebView.frame = newFrame;
    self.jobScrollView.contentSize = CGSizeMake(ScreenWidth, comRect.origin.y+comRect.size.height + 10);

}

//
////第一种方法
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
////    CGSize actualSize = [self.introductionWebView sizeThatFits:CGSizeZero];
////    CGRect newFrame = self.introductionWebView.frame;
////    newFrame.size.height = actualSize.height;
////    self.introductionWebView.frame = newFrame;
////    CGFloat webViewHeight=[self.introductionWebView.scrollView contentSize].height;
////
////    CGRect newFrame = self.introductionWebView.frame;
////    newFrame.size.height = webViewHeight;
////    self.introductionWebView.frame = newFrame;
//
//    CGFloat webViewHeight = 0.0f;
//
//    if([self.introductionWebView.subviews count] > 0)
//    {
//        UIView *scrollerView = self.introductionWebView.subviews[0];
//
//        if([scrollerView.subviews count] >
//           0)
//        {
//            UIView *webDocView = scrollerView.subviews.lastObject;
//            if ([webDocView isKindOfClass:[NSClassFromString(@"UIWebDocumentView")class]])
//            {
//                webViewHeight = webDocView.frame.size.height;//获取文档的高度
//
//                self.introductionWebView.frame=webDocView.frame;
//
//                //更新UIWebView 的高度
//            }
//
//        }
//    }
//    CGRect newFrame = self.introductionWebView.frame;
//    self.jobScrollView.contentSize = CGSizeMake(ScreenWidth, newFrame.origin.y+newFrame.size.height);
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
