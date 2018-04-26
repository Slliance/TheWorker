//
//  MyOrderDetailViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/4.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyOrderDetailViewController.h"
#import "OrderDetailHeadView.h"
#import "OrderDetailTableViewCell.h"
#import "PayViewController.h"
#import "OrderNumberTableViewCell.h"
#import "RemarkViewController.h"
#import "ApplyRefundViewController.h"
#import "OrderViewModel.h"
#import "OrderGoodsModel.h"
#import "OrderDetailFinishTableViewCell.h"
#import "MyShoppingCartViewController.h"
#import "ChooseTypeView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LookLogisticsViewController.h"
#import "CareGoodsDetailsViewController.h"
#import "WalletViewModel.h"
#import "WalletModel.h"
#import "WXApi.h"

#import "GoodsViewModel.h"
#define btn_tag_max   999

@interface MyOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,WXApiDelegate>
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (nonatomic, retain) OrderDetailHeadView *headView;

@property (nonatomic, retain) OrderViewModel *viewModel;
@property (nonatomic, retain)   OrderGoodsModel *model;
@property (nonatomic, retain) ChooseTypeView *typeView;
@end

@implementation MyOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headView = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailHeadView" owner:self options:nil]firstObject];
    self.itemTableView.tableHeaderView = self.headView;
    [self.itemTableView registerNib:[UINib nibWithNibName:@"OrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailTableViewCell"];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"OrderDetailFinishTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailFinishTableViewCell"];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"OrderNumberTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderNumberTableViewCell"];
    
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof (self)weakSelf = self;
    self.viewModel = [[OrderViewModel alloc] init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        weakSelf.model = returnValue;
        [weakSelf initView];
        
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    
    [self.viewModel fetchOrderDetail:self.orderGoodsModel.Id token:[self getToken]];
    
    [HYNotification  addAliPayResultNotification:self action:@selector(payResult:)];
    [HYNotification addWeixinPayResultNotification:self action:@selector(weixinPay:)];

    // Do any additional setup after loading the view from its nib.
}

-(void)payResult:(NSNotification *)notifi{
    //    PayResultViewModel *viewModel = [[PayResultViewModel alloc]init];
    NSDictionary *userInfo = [notifi userInfo];
    [self handlePayResult:userInfo];
}

-(void)weixinPay:(NSNotification *)notifi{
    NSDictionary *userInfo = [notifi userInfo];
    if ([[userInfo objectForKey:@"weixinpay"] isEqualToString:@"success"]) {
        self.refreshBlock();
        [self backAction:nil];
        
    }
    [self showJGProgressWithMsg:[userInfo objectForKey:@"strMsg"]];
}
//处理支付结果
-(void)handlePayResult:(NSDictionary *)resultDic{
    NSNumber *resultStatus = [resultDic objectForKey:@"resultStatus"];
    if ([resultStatus integerValue] == 9000) {
        [self.viewModel fetchOrderDetail:self.orderGoodsModel.Id token:[self getToken]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showJGProgressWithMsg:@"支付成功"];
            //            [self.delegate paySuccess];
            self.refreshBlock();
            [self showJGProgressWithMsg:@"支付成功"];
            
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

- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)buyAgainAction:(id)sender {
    ApplyRefundViewController *vc = [[ApplyRefundViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)initView{
    [self.headView initView:self.model];
    [self.itemTableView reloadData];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    
    return self.model.goods.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        OrderNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderNumberTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initCellWithData:self.model];
        return cell;
    }
    if ([self.model.order_status integerValue] == 5 && self.model.goods.count > 1) {
        OrderDetailFinishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailFinishTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initCellWithData:self.model.goods[indexPath.row]];
        return cell;
    }
    OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailTableViewCell"];
    [cell initCellWithData:self.model.goods[indexPath.row] status:[self.model.order_status integerValue]];
    [cell setBuyAgainBlock:^(StoreGoodsModel *model){
        __weak typeof (self)weakSelf = self;
        OrderViewModel *viewModel = [[OrderViewModel alloc] init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            MyShoppingCartViewController *vc = [[MyShoppingCartViewController alloc] init];
            [vc setReturnReloadGoodsBlock:^{
                
            }];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel buyAgain:model.order_id token:[self getToken] type:1];
        
    }];
    [cell setApplySaleServiceBlock:^(StoreGoodsModel *model){
        ApplyRefundViewController *vc = [[ApplyRefundViewController alloc] init];
        vc.model = self.model;
        vc.storeModel = model;
        vc.type = 1;
        [vc setFinishBlock:^{
            [self.viewModel fetchOrderDetail:self.orderGoodsModel.Id token:[self getToken]];
        }];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    [cell setCommentOrderBlock:^(StoreGoodsModel *model){
        RemarkViewController *vc = [[RemarkViewController alloc] init];
        vc.storeModel = model;
        vc.model = self.orderGoodsModel;
        vc.isSmallOrder = YES;
        [vc setFinishBlock:^{
            [self.viewModel fetchOrderDetail:self.orderGoodsModel.Id token:[self getToken]];
        }];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 36;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 165;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 41;
    }
    if ([self.model.order_status integerValue] == 5 && self.model.goods.count > 1) {
        return 150;
    }
    return 105;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    if (section != 0) {
        view.frame = CGRectMake(0, 0, ScreenWidth, 36);
        view.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(10, 9, 18, 18);
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 9.f;
        [imageView setImageWithString:self.model.logo placeHoldImageName:@"bg_no_pictures"];
        //        [imageView setImageWithURL:[NSURL URLWithString:self.model.logo]];
        [view addSubview:imageView];
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(35, 9, 200, 18);
        label.text = self.model.store_name;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithHexString:@"666666"];
        [view addSubview:label];
        
        UILabel *labelState = [[UILabel alloc]init];
        labelState.frame = CGRectMake(ScreenWidth - 50, 9, 200, 18);
        switch ([self.model.order_status integerValue]) {
            case 1://待付款
            {
                labelState.text = @"待付款";
            }
                break;
            case 2://待发货
            {
                labelState.text = @"待发货";
            }
                break;
            case 3://待收货
            {
                labelState.text = @"待收货";
            }
                break;
            case 4://已完成
            {
                labelState.text = @"已完成";
                
            }
                break;
            case 5://售后服务
            {
                labelState.text = @"售后服务";
            }
                break;
            case 6://已完成,不可申请售后
            {
                labelState.text = @"已完成";
                
            }
                break;
            default:
                break;
        }
        
        labelState.textAlignment = NSTextAlignmentRight;
        labelState.font = [UIFont systemFontOfSize:13];
        labelState.textColor = [UIColor redColor];
        [view addSubview:labelState];
        
    }
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    if (section != 0) {
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, 0, ScreenWidth, 44);
        //下单时间
        UILabel *labelTime = [[UILabel alloc]init];
        labelTime.frame = CGRectMake(10, 15, ScreenWidth-20, 12);
        labelTime.text = [NSString stringWithFormat:@"下单时间：%@" ,self.model.createtime];
        labelTime.font = [UIFont systemFontOfSize:12];
        labelTime.textColor = [UIColor colorWithHexString:@"666666"];
        [view addSubview:labelTime];
        //应付总金额
        UILabel *labelPrice = [[UILabel alloc]init];
        labelPrice.frame = CGRectMake(10, 37 + 30, ScreenWidth-20, 17);
        labelPrice.text = [NSString stringWithFormat:@"应付总金额：￥%.2f（含运费￥%.2f）" ,[self.model.price floatValue],[self.model.trans_price floatValue]];
        labelPrice.font = [UIFont systemFontOfSize:13];
        labelPrice.textColor = [UIColor colorWithHexString:@"333333"];
        NSMutableAttributedString *attrP = [[NSMutableAttributedString alloc]initWithString:labelPrice.text];
        
        NSRange range = [labelPrice.text rangeOfString:[NSString stringWithFormat:@"%.2f",[self.model.price floatValue]]];
        [attrP setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} range:range];
        [labelPrice setAttributedText:attrP];
        [view addSubview:labelPrice];
        
        CGFloat btn_width = 75.f;
        CGFloat point_y = 120;
        switch ([self.model.order_status integerValue]) {
            case 1://待付款
            {
                UIButton *btn2 = [[UIButton alloc]init];
                btn2.frame = CGRectMake(ScreenWidth - (btn_width + 10) * 2, point_y, btn_width, 30);
                [btn2 setTitle:@"取消订单" forState:UIControlStateNormal];
                [btn2 setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
                [btn2.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [btn2.layer setBorderColor:[UIColor colorWithHexString:@"cccccc"].CGColor];
                [btn2.layer setBorderWidth:1];
                [btn2.layer setMasksToBounds:YES];
                [btn2.layer setCornerRadius:4.f];
                btn2.tag = btn_tag_max + 1;
                [btn2 addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
                
                UIButton *btn1 = [[UIButton alloc]init];
                btn1.frame = CGRectMake(ScreenWidth - (btn_width + 10), point_y, btn_width, 30);
                [btn1 setTitle:@"确认付款" forState:UIControlStateNormal];
                [btn1 setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                [btn1.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [btn1 setBackgroundColor:[UIColor colorWithHexString:@"f1a036"]];
                [btn1.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
                [btn1.layer setBorderWidth:1];
                [btn1.layer setMasksToBounds:YES];
                [btn1.layer setCornerRadius:4.f];
                [btn1 addTarget:self action:@selector(startPay:) forControlEvents:UIControlEventTouchUpInside];
                btn1.tag = btn_tag_max + 2;
                
                [view addSubview:btn1];
                [view addSubview:btn2];
            }
                break;
            case 2://待发货
            {
                UIButton *btn = [[UIButton alloc]init];
                btn.frame = CGRectMake(ScreenWidth - (btn_width + 10), point_y, 75, 30);
                [btn setTitle:@"再次购买" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithHexString:@"f1a036"] forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [btn.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
                [btn.layer setBorderWidth:1];
                [btn.layer setMasksToBounds:YES];
                [btn.layer setCornerRadius:4.f];
                [btn addTarget:self action:@selector(buyAgain:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = btn_tag_max + 3;
                
                [view addSubview:btn];
                
            }
                break;
            case 3://待收货
            {
                UIButton *btn = [[UIButton alloc]init];
                btn.frame = CGRectMake(ScreenWidth - (btn_width + 10) * 3, point_y, 75, 30);
                [btn setTitle:@"再次购买" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithHexString:@"f1a036"] forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [btn.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
                [btn.layer setBorderWidth:1];
                [btn.layer setMasksToBounds:YES];
                [btn.layer setCornerRadius:4.f];
                [btn addTarget:self action:@selector(buyAgain:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = btn_tag_max + 4;
                
                [view addSubview:btn];
                
                
                UIButton *btn2 = [[UIButton alloc]init];
                btn2.frame = CGRectMake(ScreenWidth - (btn_width + 10) * 2, point_y, btn_width, 30);
                [btn2 setTitle:@"查看物流" forState:UIControlStateNormal];
                [btn2 setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
                [btn2.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [btn2.layer setBorderColor:[UIColor colorWithHexString:@"cccccc"].CGColor];
                [btn2.layer setBorderWidth:1];
                [btn2.layer setMasksToBounds:YES];
                [btn2.layer setCornerRadius:4.f];
                [btn2 addTarget:self action:@selector(lookForLogistics:) forControlEvents:UIControlEventTouchUpInside];
                btn2.tag = btn_tag_max + 5;
                
                UIButton *btn1 = [[UIButton alloc]init];
                btn1.frame = CGRectMake(ScreenWidth - (btn_width + 10), point_y, btn_width, 30);
                [btn1 setTitle:@"确认收货" forState:UIControlStateNormal];
                [btn1 setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                [btn1.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [btn1 setBackgroundColor:[UIColor colorWithHexString:@"f1a036"]];
                [btn1.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
                [btn1.layer setBorderWidth:1];
                [btn1.layer setMasksToBounds:YES];
                [btn1.layer setCornerRadius:4.f];
                [btn1 addTarget:self action:@selector(confirmReceipt:) forControlEvents:UIControlEventTouchUpInside];
                btn1.tag = btn_tag_max + 6;
                
                [view addSubview:btn1];
                [view addSubview:btn2];
                
            }
                break;
            case 4://已完成
            {
                
                UIButton *btn = [[UIButton alloc]init];
                btn.frame = CGRectMake(ScreenWidth - (btn_width + 10) * 2, point_y, btn_width, 30);
                [btn setTitle:@"再次购买" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithHexString:@"f1a036"] forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [btn.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
                [btn.layer setBorderWidth:1];
                [btn.layer setMasksToBounds:YES];
                [btn.layer setCornerRadius:4.f];
                [btn addTarget:self action:@selector(buyAgain:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = btn_tag_max + 7;
                
                
                //                UIButton *btn2 = [[UIButton alloc]init];
                //                btn2.frame = CGRectMake(ScreenWidth - (btn_width + 10) * 2, point_y, btn_width, 30);
                //                [btn2 setTitle:@"申请售后" forState:UIControlStateNormal];
                //                [btn2 setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
                //                [btn2.titleLabel setFont:[UIFont systemFontOfSize:13]];
                //                [btn2.layer setBorderColor:[UIColor colorWithHexString:@"cccccc"].CGColor];
                //                [btn2.layer setBorderWidth:1];
                //                [btn2.layer setMasksToBounds:YES];
                //                [btn2.layer setCornerRadius:4.f];
                //                [btn2 addTarget:self action:@selector(applySaleService:) forControlEvents:UIControlEventTouchUpInside];
                //                [view addSubview:btn2];
                
                
                [view addSubview:btn];
                
                if ([self.model.point integerValue] == 0) {
                    UIButton *btn1 = [[UIButton alloc]init];
                    btn1.frame = CGRectMake(ScreenWidth - (btn_width + 10), point_y, btn_width, 30);
                    [btn1 setTitle:@"去评价" forState:UIControlStateNormal];
                    [btn1 setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                    [btn1.titleLabel setFont:[UIFont systemFontOfSize:13]];
                    [btn1 setBackgroundColor:[UIColor colorWithHexString:@"f1a036"]];
                    [btn1.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
                    [btn1.layer setBorderWidth:1];
                    [btn1.layer setMasksToBounds:YES];
                    [btn1.layer setCornerRadius:4.f];
                    [btn1 addTarget:self action:@selector(commentOrder:) forControlEvents:UIControlEventTouchUpInside];
                    btn1.tag = btn_tag_max + 8;
                    
                    [view addSubview:btn1];
                }
                else{
                    //                    btn2.frame = CGRectMake(ScreenWidth - (btn_width + 10) * 2, point_y, btn_width, 30);
                    btn.frame = CGRectMake(ScreenWidth - (btn_width + 10) * 1, point_y, btn_width, 30);
                    
                }
            }
                break;
            case 5://售后服务
            {
                UIButton *btn2 = [[UIButton alloc]init];
                btn2.frame = CGRectMake(ScreenWidth - (btn_width + 10) * 2, point_y, btn_width, 30);
                [btn2 setTitle:@"申请售后" forState:UIControlStateNormal];
                [btn2 setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
                [btn2.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [btn2.layer setBorderColor:[UIColor colorWithHexString:@"cccccc"].CGColor];
                [btn2.layer setBorderWidth:1];
                [btn2.layer setMasksToBounds:YES];
                [btn2.layer setCornerRadius:4.f];
                [btn2 addTarget:self action:@selector(applySaleService:) forControlEvents:UIControlEventTouchUpInside];
                btn2.tag = btn_tag_max + 9;
                
                UIButton *btn = [[UIButton alloc]init];
                btn.frame = CGRectMake(ScreenWidth - (btn_width + 10), point_y, 75, 30);
                [btn setTitle:@"再次购买" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithHexString:@"f1a036"] forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [btn.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
                [btn.layer setBorderWidth:1];
                [btn.layer setMasksToBounds:YES];
                [btn.layer setCornerRadius:4.f];
                [btn addTarget:self action:@selector(buyAgain:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = btn_tag_max + 10;
                
                [view addSubview:btn];
                
            }
                break;
                
            default:
                break;
        }
        
    }
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CareGoodsDetailsViewController *vc = [[CareGoodsDetailsViewController alloc] init];
    StoreGoodsModel *model = self.model.goods[indexPath.row];
    GoodsViewModel *viewModel = [[GoodsViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        vc.goodsId = model.goods_id;
        [self.navigationController pushViewController:vc animated:YES];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchGoodsDetailWithToken:[self getToken] goodsId:model.goods_id];
   
}

//取消订单
-(void)cancelOrder:(id)sender{
    __weak typeof (self)weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"确定要取消订单吗？"
                                                                      preferredStyle:UIAlertControllerStyleAlert ];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        OrderViewModel *cancelViewModel = [[OrderViewModel alloc] init];
        [cancelViewModel setBlockWithReturnBlock:^(id returnValue) {
            weakSelf.refreshBlock();
            [weakSelf backAction:nil];
            
        } WithErrorBlock:^(id errorCode) {
            [weakSelf showJGProgressWithMsg:errorCode];
        }];
        
        [cancelViewModel cancelOrder:self.model.Id token:[self getToken]];
        
    }];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

//确认支付
-(void)startPay:(id)sender{
    __weak typeof (self)weakSelf = self;
    self.typeView = [[[NSBundle mainBundle] loadNibNamed:@"ChooseTypeView" owner:self options:nil]firstObject];
    self.typeView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    WalletViewModel *viewModel = [[WalletViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        WalletModel *model = returnValue;
        NSNumber *allMoney = model.amount;
        if ([allMoney doubleValue] < [self.model.price doubleValue]) {
            [self.typeView initViewWithPrice:[allMoney doubleValue] type:1];
        }
        else{
            [self.typeView initViewWithPrice:[allMoney doubleValue] type:0];
        }
        [self.view addSubview:self.typeView];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchWalletInfomationWithToken:[self getToken]];
    [self.typeView setReturnTypeBlock:^(NSInteger type) {
        OrderViewModel *viewModel = [[OrderViewModel alloc] init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [weakSelf.typeView removeFromSuperview];
            if (type == 1) {
                
                [weakSelf.viewModel fetchOrderDetail:weakSelf.orderGoodsModel.Id token:[weakSelf getToken]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf showJGProgressWithMsg:@"支付成功"];
                    //            [self.delegate paySuccess];
                    weakSelf.refreshBlock();
                    [weakSelf showJGProgressWithMsg:@"支付成功"];
                    
                    [weakSelf backAction:nil];

                });
            }else if(type==2){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSDictionary *strDic = returnValue;
                    NSString *orderStr = strDic[@"alipay"];
                    NSLog(@"===%@====",orderStr);
                    //应用注册scheme,在Info.plist定义URL types
                    NSString *appScheme = @"TheWorkerScheme";
                    // NOTE: 调用支付结果开始支付
                    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                        [weakSelf handlePayResult:resultDic];
                    }];
                });
                
            }
            else{
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
         } WithErrorBlock:^(id errorCode) {
             [weakSelf showJGProgressWithMsg:errorCode];
         }];
        [viewModel payOrderPay:@[weakSelf.model.Id] type:type token:[weakSelf getToken]];
        
    }];
    [self.view addSubview:self.typeView];
    
}


//查看物流
-(void)lookForLogistics:(id)sender{
    if (!self.model.trans_order_no) {
        [self showJGProgressWithMsg:@"暂无物流信息"];
        return;
    }
    
    LookLogisticsViewController *vc = [[LookLogisticsViewController alloc] init];
    vc.logisticsOrderNo = self.model.trans_order_no;
    vc.logisticsCompanyName = self.model.company;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//确认收货
-(void)confirmReceipt:(id)sender{
    
    __weak typeof (self)weakSelf = self;
    OrderViewModel *viewModel = [[OrderViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        weakSelf.refreshBlock();
        [weakSelf backAction:nil];
        
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    
    [viewModel confirmGet:self.orderGoodsModel.Id token:[self getToken]];
    
}


//再次购买
-(void)buyAgain:(id)sender{
    
    __weak typeof (self)weakSelf = self;
    OrderViewModel *viewModel = [[OrderViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        MyShoppingCartViewController *vc = [[MyShoppingCartViewController alloc] init];
        [vc setReturnReloadGoodsBlock:^{
            
        }];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel buyAgain:self.model.Id token:[self getToken] type:2];
}

//去评价
-(void)commentOrder:(id)sender{
    RemarkViewController *vc = [[RemarkViewController alloc] init];
    OrderGoodsModel *orderModel = [[OrderGoodsModel alloc] initWithDict:[self.orderGoodsModel dictionaryRepresentation]];
    NSMutableArray *mugoods = [[NSMutableArray alloc] initWithArray:self.model.goods];
    for (int i = 0; i < self.model.goods.count; i ++) {
        StoreGoodsModel *goodModel = self.model.goods[i];
        if ([goodModel.score integerValue]) {
            [mugoods removeObjectAtIndex:i];
        }
    }
    orderModel.goods = mugoods;
    vc.model = orderModel;
    [vc setFinishBlock:^{
        [self.viewModel fetchOrderDetail:self.orderGoodsModel.Id token:[self getToken]];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

//申请售后
-(void)applySaleService:(id)sender{
    ApplyRefundViewController *vc = [[ApplyRefundViewController alloc] init];
    vc.model = self.model;
    vc.type = 2;
    [vc setFinishBlock:^{
        [self.viewModel fetchOrderDetail:self.orderGoodsModel.Id token:[self getToken]];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
