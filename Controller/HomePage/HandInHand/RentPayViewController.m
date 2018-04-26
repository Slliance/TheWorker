//
//  RentPayViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RentPayViewController.h"
#import "ChoosePayTypeTableViewCell.h"
#import "OrderSuccessViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PayViewModel.h"
#import "WalletViewModel.h"
#import "WalletModel.h"
@interface RentPayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *labelMoney;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@property (nonatomic,retain) NSMutableArray *selectedArr;
@property (nonatomic, retain) NSNumber *allMoney;
@end

@implementation RentPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnPay.layer.masksToBounds = YES;
    self.btnPay.layer.cornerRadius = 4.f;
    self.labelMoney.text = [NSString stringWithFormat:@"支付总额：￥%.2f",[self.price doubleValue]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:self.labelMoney.text];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"ff6666"] range:NSMakeRange(5, self.labelMoney.text.length-5)];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(5, 1)];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(6, self.labelMoney.text.length-6)];
//    [attStr addAttribute:NSStrokeWidthAttributeName value: range:<#(NSRange)#>]
    [self.labelMoney setAttributedText:attStr];
    [self.labelMoney sizeToFit];
    self.selectedArr = [[NSMutableArray alloc]init];
    [self.selectedArr addObject:@(0)];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"ChoosePayTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChoosePayTypeTableViewCell"];
    if ([self.itemTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.itemTableView setSeparatorInset:UIEdgeInsetsMake(44, 15, 0, 15)];
        
    }
    
    WalletViewModel *viewModel = [[WalletViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        WalletModel *model = returnValue;
        self.allMoney = model.amount;
//        if ([self.allMoney doubleValue] < [self.price doubleValue]) {
//            [self.selectedArr removeAllObjects];
//            [self.selectedArr addObject:@(1)];
//        }
        [self.itemTableView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchWalletInfomationWithToken:[self getToken]];
    
    [HYNotification  addAliPayResultNotification:self action:@selector(payResult:)];
    // Do any additional setup after loading the view from its nib.
}
-(void)payResult:(NSNotification *)notifi{
    //    PayResultViewModel *viewModel = [[PayResultViewModel alloc]init];
    NSDictionary *userInfo = [notifi userInfo];
    NSNumber *resultStatus = [userInfo objectForKey:@"resultStatus"];
    if ([resultStatus integerValue] == 9000) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showJGProgressWithMsg:@"支付成功"];
            //            [self.delegate paySuccess];
            OrderSuccessViewController *vc = [[OrderSuccessViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            NSString *allString = userInfo[@"result"];
            NSString *dic = [allString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            NSData *JSONData = [dic dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
            //            NSDictionary *alipay = responseJSON[@"alipay_trade_app_pay_response"];
            //            NSString *outNo = alipay[@"out_trade_no"];
            //            NSString *trade = alipay[@"trade_no"];
            //            [viewModel loadResultWithTradeNo:trade outNo:outNo];
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
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)payAction:(id)sender {
    if (self.selectedArr.count == 0) {
        [self showJGProgressWithMsg:@"请选择支付类型"];
        return;
    }
    NSInteger type = [self.selectedArr[0] integerValue] + 1;
    if (type == 3) {
        [self showJGProgressWithMsg:@"微信暂未接入"];
        return;
    }
    __weak typeof (self)weakSelf = self;
    
    PayViewModel *payModel = [[PayViewModel alloc]init];
    [payModel setBlockWithReturnBlock:^(id returnValue) {
        [weakSelf dissJGProgressLoadingWithTag:200];
        if (type == 1) {
            OrderSuccessViewController *vc = [[OrderSuccessViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *strDic = returnValue;
                NSString *orderStr = strDic[@"alipay"];
                NSLog(@"===%@====",orderStr);
                //应用注册scheme,在Info.plist定义URL types
                NSString *appScheme = @"TheWorkerScheme";
                // NOTE: 调用支付结果开始支付
                [[AlipaySDK defaultService] payOrder:orderStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    
                }];
                return;
                //            }else if (self.btnWechat.selected){
                //                NSDictionary *dic =  [returnValue firstObject];
                //
                //                NSDictionary *wxpayInfo = [dic objectForKey:@"app_request"];
                //                PayReq *request = [[PayReq alloc] init];
                //
                //                request.partnerId = [wxpayInfo objectForKey:@"partnerid"];
                //                request.prepayId= [wxpayInfo objectForKey:@"prepayid"];
                //                request.package = @"Sign=WXPay";
                //
                //                request.nonceStr= [wxpayInfo objectForKey:@"noncestr"];
                //
                //                request.timeStamp = [[wxpayInfo objectForKey:@"timestamp"] intValue];
                //
                //                request.sign= [wxpayInfo objectForKey:@"sign"];
                //
                //                [WXApi sendReq:request];
                //                NSLog(@"微信支付");
                //            }
                //            [weakSelf showJGProgressWithMsg:@"支付成功"];
                
                //            [weakSelf backAction:nil];
            });
        }
        
    } WithErrorBlock:^(id errorCode) {
        [weakSelf dissJGProgressLoadingWithTag:200];
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    [payModel goodsPayWithToken:[self getToken] Id:self.rentId type:@(type)];
    [weakSelf showJGProgressLoadingWithTag:200];

}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChoosePayTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChoosePayTypeTableViewCell"];
    BOOL select = NO;
  
    if ([self.selectedArr containsObject:@(indexPath.row)]) {
        select = YES;
    }
    [cell initCellWithData:indexPath.row :select money:self.allMoney];
    return cell;
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.selectedArr removeAllObjects];
    [self.selectedArr addObject:@(indexPath.row)];
    [self.itemTableView reloadData];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    UILabel *lineLable = [[UILabel alloc]init];
    lineLable.frame = CGRectMake(0, 20, 5, 15);
    lineLable.backgroundColor = [UIColor colorWithHexString:@"ef5f7d"];
    [view addSubview:lineLable];
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.frame = CGRectMake(15, 20, 100, 15);
    textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    textLabel.text = @"选择支付方式";
    textLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:textLabel];

    return view;
}


@end
