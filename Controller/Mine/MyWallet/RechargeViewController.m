//
//  RechargeViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RechargeViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "PayViewModel.h"
@interface RechargeViewController ()<WXApiDelegate>

@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UIButton *btnAlipay;
@property (weak, nonatomic) IBOutlet UIButton *btnWechat;
@property (weak, nonatomic) IBOutlet UIButton *btnRecharge;
@property (nonatomic, assign) NSInteger type;
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self chooseAlipay:nil];
    self.inputTextView.layer.masksToBounds = YES;
    self.inputTextView.layer.cornerRadius = 4.f;
    [self.inputTextView.layer setBorderColor:[UIColor colorWithHexString:@"f0f0f0"].CGColor];
    [self.inputTextView.layer setBorderWidth:1];
    self.btnRecharge.layer.masksToBounds = YES;
    self.btnRecharge.layer.cornerRadius = 4.f;
    if (self.isWork) {
        self.titleLabel.text = @"充值工币";
        self.typeLabel.text = @"100工币";
    }else{
        self.titleLabel.text = @"充值余额";
        self.typeLabel.text = @"元";
    }
    [HYNotification  addAliPayResultNotification:self action:@selector(alipayResult:)];
    [HYNotification addWeixinPayResultNotification:self action:@selector(weixinPay:)];

    // Do any additional setup after loading the view from its nib.
}
-(void)alipayResult:(NSNotification *)notifi{
    [self handlePayResult:notifi.userInfo];
}
//处理支付结果
-(void)handlePayResult:(NSDictionary *)resultDic{
    NSNumber *resultStatus = [resultDic objectForKey:@"resultStatus"];
    if ([resultStatus integerValue] == 9000) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showJGProgressWithMsg:@"支付成功"];
            self.returnReloadBlock();
            [self backAction:nil];
        });
    }
    else{
        NSString *returnStr = @"";
        switch ([resultStatus integerValue]) {
            case 8000:
                returnStr=@"订单正在处理中";
                break;
            case 4000:
                returnStr=@"订单支付失败";
                break;
            case 6001:
                returnStr=@"支付取消";
                break;
            case 6002:
                returnStr=@"网络连接出错";
                break;
                
            default:
                returnStr=@"支付失败";
                break;
        }
        [self showJGProgressWithMsg:returnStr];
        
    }
}

-(void)weixinPay:(NSNotification *)notifi{
    NSDictionary *userInfo = [notifi userInfo];
    if ([[userInfo objectForKey:@"weixinpay"] isEqualToString:@"success"]) {
        self.returnReloadBlock();
        [self backAction:nil];
        
    }
    [self showJGProgressWithMsg:[userInfo objectForKey:@"strMsg"]];
}

- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)chooseAlipay:(id)sender {
    if (self.btnAlipay.selected == NO) {
        self.type = 1;
        self.btnAlipay.selected = YES;
        self.btnWechat.selected = NO;
    }
//    icon_circle_selected
}
- (IBAction)chooseWechat:(id)sender {
    if (self.btnWechat.selected == NO) {
        self.type = 2;
        self.btnWechat.selected = YES;
        self.btnAlipay.selected = NO;
    }
}
- (IBAction)rechargeAction:(id)sender {
    if (self.inputTextView.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入金额"];
        return;
    }
    __weak typeof (self)weakSelf = self;
    
    PayViewModel *payModel = [[PayViewModel alloc]init];
    [payModel setBlockWithReturnBlock:^(id returnValue) {
        [weakSelf dissJGProgressLoadingWithTag:200];
        
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.btnAlipay.selected == YES) {
                    NSDictionary *strDic = returnValue;
                    NSString *orderStr = strDic[@"alipay"];
                    NSLog(@"===%@====",orderStr);
                    //应用注册scheme,在Info.plist定义URL types
                    NSString *appScheme = @"TheWorkerScheme";
                    // NOTE: 调用支付结果开始支付
                    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                        [weakSelf handlePayResult:resultDic];
                    }];
                }else{
                    NSDictionary *wxpayInfo =  returnValue;
                    
                    PayReq *request = [[PayReq alloc] init];
                    
                    request.partnerId = [wxpayInfo objectForKey:@"partnerid"];
                    request.prepayId= [wxpayInfo objectForKey:@"prepayid"];
                    request.package = @"Sign=WXPay";
                    
                    request.nonceStr= [wxpayInfo objectForKey:@"noncestr"];
                    
                    request.timeStamp = [[wxpayInfo objectForKey:@"timestamp"] intValue];
                    
                    request.sign= [wxpayInfo objectForKey:@"sign"];
                    
                    [WXApi sendReq:request];
                    NSLog(@"微信支付");
                }

            });

    } WithErrorBlock:^(id errorCode) {
        [weakSelf dissJGProgressLoadingWithTag:200];
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    [payModel rechargeWithToken:[self getToken] money:self.inputTextView.text type:@(self.type)];
    [weakSelf showJGProgressLoadingWithTag:200];
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
