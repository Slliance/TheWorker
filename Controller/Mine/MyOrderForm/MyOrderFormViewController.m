//
//  MyOrderFormViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/2.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyOrderFormViewController.h"
#import "ScoreOrderTableViewCell.h"
#import "OrderTableViewCell.h"
#import "MyOrderDetailViewController.h"
#import "OrderViewModel.h"
#import "OrderGoodsModel.h"
#import <objc/runtime.h>
#import "ScoreOrderDetailViewController.h"
#import "ShoppingCarViewModel.h"
#import "MyShoppingCartViewController.h"
#import "RemarkViewController.h"
#import "ApplyRefundViewController.h"
#import "RefundViewController.h"
#import "ChooseTypeView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "LookLogisticsViewController.h"
#import "WalletViewModel.h"
#import "WalletModel.h"
#define menu_max   999
static char btn_char;
@interface MyOrderFormViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray          *menuArr;
    NSInteger               currentSelectMenuIndex;
    
}
@property (weak, nonatomic) IBOutlet UIView *btnBgView;
@property (weak, nonatomic) IBOutlet UIButton *btnScore;
@property (weak, nonatomic) IBOutlet UIButton *btnSale;
@property (weak, nonatomic) IBOutlet UIScrollView *categoryScrollView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (nonatomic, retain) NSArray *cateArr;
@property (nonatomic, assign) NSInteger leftIndex;
@property (nonatomic, assign) NSInteger rightIndex;

@property (nonatomic, retain) OrderViewModel *orderViewModel;
@property (nonatomic, retain) OrderViewModel *scoreOrderViewModel;
@property (nonatomic, retain) ChooseTypeView *typeView;
@property (nonatomic, assign) NSInteger     pageIndex;
@property (nonatomic, retain) NSMutableArray *itemArr;
@property (nonatomic, assign) NSInteger     scorePageIndex;
@property (nonatomic, retain) NSMutableArray *scoreItemArr;

@end

@implementation MyOrderFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemArr = [[NSMutableArray alloc] init];
    self.scoreItemArr = [[NSMutableArray alloc] init];
    self.btnBgView.layer.borderColor = [UIColor colorWithHexString:@"6398f1"].CGColor;
    self.btnBgView.layer.borderWidth = 1;
    self.btnBgView.layer.masksToBounds = YES;
    self.btnBgView.layer.cornerRadius = 16.5f;
    self.btnScore.layer.masksToBounds = YES;
    self.btnScore.layer.cornerRadius = 15.f;
    self.btnSale.layer.masksToBounds = YES;
    self.btnSale.layer.cornerRadius = 15.f;
    menuArr = [[NSMutableArray alloc] init];
    self.cateArr = @[@[@"全部",@"待领取",@"已领取"],@[@"全部",@"待付款",@"待发货",@"待收货",@"已完成",@"售后服务"]];
    if (self.skipForm == 0) {
        self.leftIndex = 0;
        self.rightIndex = 0;
        self.btnScore.selected = YES;
        self.btnSale.selected = NO;
        [self.btnScore setBackgroundColor:[UIColor colorWithHexString:@"6398f1"]];
        [self.btnSale setBackgroundColor:[UIColor whiteColor]];
        [self initMenuScrollView:0];
    }else{
        self.leftIndex = 1;
        self.rightIndex = 1;
        self.btnScore.selected = NO;
        self.btnSale.selected = YES;
        [self.btnSale setBackgroundColor:[UIColor colorWithHexString:@"6398f1"]];
        [self.btnScore setBackgroundColor:[UIColor whiteColor]];
        [self initMenuScrollView:1];
    }
    
    [self.itemTableView registerNib:[UINib nibWithNibName:@"ScoreOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"ScoreOrderTableViewCell"];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"OrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof (self)weakSelf = self;
    self.orderViewModel = [[OrderViewModel alloc] init];
    [self.orderViewModel setBlockWithReturnBlock:^(id returnValue) {
        if (self.pageIndex == 1) {
            [weakSelf.itemTableView.mj_header endRefreshing];
            if ([returnValue count] == 10) {
                weakSelf.itemTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(footerRefreshing)];
            }
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
        if ([returnValue count] < 10) {
            [weakSelf.itemTableView.mj_footer removeFromSuperview];
        }
        [weakSelf.itemArr addObjectsFromArray:returnValue];
        [weakSelf.itemTableView reloadData];
        
        
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    
    self.scoreOrderViewModel = [[OrderViewModel alloc] init];
    [self.scoreOrderViewModel setBlockWithReturnBlock:^(id returnValue) {
        if (self.scorePageIndex == 1) {
            [weakSelf.itemTableView.mj_header endRefreshing];
            if ([returnValue count] == 10) {
                weakSelf.itemTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(footerRefreshing)];
            }
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
        if ([returnValue count] < 10) {
            [weakSelf.itemTableView.mj_footer removeFromSuperview];
        }
        [weakSelf.scoreItemArr addObjectsFromArray:returnValue];
        [weakSelf.itemTableView reloadData];
        
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    
    [self setupRefresh];
    [HYNotification  addAliPayResultNotification:self action:@selector(payResult:)];
    [HYNotification addWeixinPayResultNotification:self action:@selector(weixinPay:)];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)payResult:(NSNotification *)notifi{
    //    PayResultViewModel *viewModel = [[PayResultViewModel alloc]init];
    NSDictionary *userInfo = [notifi userInfo];
    [self handlePayResult:userInfo];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
-(void)weixinPay:(NSNotification *)notifi{
    NSDictionary *userInfo = [notifi userInfo];
    if ([[userInfo objectForKey:@"weixinpay"] isEqualToString:@"success"]) {
        [self.itemTableView.mj_header beginRefreshing];        
    }
    [self showJGProgressWithMsg:[userInfo objectForKey:@"strMsg"]];
}
//处理支付结果
-(void)handlePayResult:(NSDictionary *)resultDic{
    NSNumber *resultStatus = [resultDic objectForKey:@"resultStatus"];
    if ([resultStatus integerValue] == 9000) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showJGProgressWithMsg:@"支付成功"];
            //            [self.delegate paySuccess];
            [self.itemTableView.mj_header beginRefreshing];
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


/**
 *  设置刷新
 */
-(void)setupRefresh
{
    self.itemTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    [self.itemTableView.mj_header beginRefreshing];
}
/**
 *  下拉刷新
 */
-(void)headerRefreshing
{
    if (self.btnScore.selected) {
        self.scorePageIndex = 0;
        [self.scoreItemArr removeAllObjects];
        
    }
    else{
        self.pageIndex = 0;
        [self.itemArr removeAllObjects];
    }
    [self.itemTableView reloadData];
    [self footerRefreshing];
}
/**
 *  上拉刷新
 */
-(void)footerRefreshing
{
    if (self.btnScore.selected) {
        NSInteger state = 0;
        if (self.leftIndex == 0) {
            state = 2;
        }
        else if (self.leftIndex == 1)
        {
            state = 0;
        }
        else{
            state = 1;
        }
        [self.scoreOrderViewModel fetchMyScoreOrderList:[self getToken] status:state page:++ self.scorePageIndex];
        
    }
    else{
        [self.orderViewModel fetchMyOrderList:[self getToken] page:++ self.pageIndex status:self.rightIndex];
    }
}


- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)chooseLeft:(id)sender {
    self.btnScore.selected = YES;
    self.btnSale.selected = NO;
    [self.btnScore setBackgroundColor:[UIColor colorWithHexString:@"6398f1"]];
    [self.btnSale setBackgroundColor:[UIColor whiteColor]];
    [self initMenuScrollView:0];
    [self.itemTableView reloadData];
    
}
- (IBAction)chooseRight:(id)sender {
    self.btnSale.selected = YES;
    self.btnScore.selected = NO;
    [self.btnSale setBackgroundColor:[UIColor colorWithHexString:@"6398f1"]];
    [self.btnScore setBackgroundColor:[UIColor whiteColor]];
    [self initMenuScrollView:1];
    [self.itemTableView reloadData];
}

-(void)initMenuScrollView:(NSInteger)row{
    
    for (UIButton *button in self.categoryScrollView.subviews) {
        if (button.tag >= 999) {
            [button removeFromSuperview];
        }
    }
    [menuArr removeAllObjects];
    [menuArr addObjectsFromArray:self.cateArr[row]];
    float menux = 0.f;
    float menuy = 0.f;
    float menuheight = 43.f;
    for (NSInteger i = 0; i < menuArr.count; i ++) {
        CGSize size = [menuArr[i] sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(200, 20)];
        
        UIButton *menu = [UIButton buttonWithType:UIButtonTypeCustom];
        menu.frame = CGRectMake(menux, menuy, size.width + 30, menuheight);
        if (menuArr.count < 4) {
            menu.frame = CGRectMake(menux, menuy, (ScreenWidth - 30) / 3, menuheight);
        }
        menux += menu.frame.size.width + 30;
        [menu setTitle:menuArr[i] forState:UIControlStateNormal];
        menu.titleLabel.font = [UIFont systemFontOfSize:15];
        [menu setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [menu setTitleColor:[UIColor colorWithHexString:@"6398f1"] forState:UIControlStateSelected];
        [menu addTarget:self action:@selector(menuSelect:) forControlEvents:UIControlEventTouchUpInside];
        menu.tag = i + menu_max;
        if (menu.tag == currentSelectMenuIndex + menu_max) {
            menu.selected = YES;
            [self menuSelect:menu];
        }
        [self.categoryScrollView addSubview:menu];
    }
    [self.categoryScrollView setContentSize:CGSizeMake(menux, 0)];
}
-(void)menuSelect:(UIButton *)menu{
    UIButton *lastSelectMenu = [self.categoryScrollView viewWithTag:currentSelectMenuIndex + menu_max];
    lastSelectMenu.selected = NO;
    self.categoryLabel.backgroundColor = [UIColor colorWithHexString:@"6398f1"];
    self.categoryLabel.frame = CGRectMake(menu.frame.origin.x + menu.frame.size.width / 2 - 15, 43, 30, 2);
    menu.selected = YES;
    currentSelectMenuIndex = menu.tag - menu_max;
    if (self.btnScore.selected) {
        self.leftIndex = currentSelectMenuIndex;
    }
    else{
        self.rightIndex = currentSelectMenuIndex;
    }
    [self.itemTableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sectionCount = 0;
    if (self.btnScore.selected) {
        sectionCount = self.scoreItemArr.count;
    }
    else{
        sectionCount = self.itemArr.count;
    }
    return sectionCount;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.btnScore.selected) {
        OrderGoodsModel *goodsModel = self.itemArr[section];
        return goodsModel.goods.count;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.btnScore.selected == NO) {
        
        OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTableViewCell"];
        OrderGoodsModel *goodsModel = self.itemArr[indexPath.section];
        [cell initViewWith:goodsModel.goods[indexPath.row]];
        return cell;
        
    }
    ScoreOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreOrderTableViewCell"];
    [cell initCellWithData:self.scoreItemArr[indexPath.section]];
    return cell;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.btnScore.selected == NO) {
        return 45;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.btnScore.selected == NO) {
        OrderGoodsModel *goodsModel = self.itemArr[section];
        switch ([goodsModel.order_status integerValue]) {
            case 1://待付款
            {
                
            }
                break;
            case 2://待付款
            {
                
            }
                break;
            case 3://待付款
            {
                
            }
                break;
            case 4://待付款
            {
                
            }
                break;
            case 5://待付款
            {
                if ([goodsModel.refund_status integerValue] == 1) {
                    
                    switch ([goodsModel.status integerValue]) {
                        case 0:
                        {
                            return 34.f;
                        }
                            break;
                        case 1:
                        {
                            return 34.f;
                        }
                            break;
                        case 2:
                        {
                            return 103;
                        }
                            break;
                            
                        case 3:
                        {
                            return 34.f;
                        }
                            break;
                            
                        case 4:
                        {
                            return 103;
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
            }
                break;
                
            default:
                break;
                
        }
        return 103;
    }
    return 0.0001f;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    //    view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.btnScore.selected) {
        OrderGoodsModel *model = self.itemArr[indexPath.section];
        if (self.rightIndex == 5 && [model.refund_status integerValue] == 1) {
            RefundViewController *vc = [[RefundViewController alloc] init];
            vc.model = model;
            vc.type = 2;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            MyOrderDetailViewController *vc = [[MyOrderDetailViewController alloc]init];
            vc.orderGoodsModel = self.itemArr[indexPath.section];
            vc.goodsModel = model.goods[indexPath.row];
            [vc setRefreshBlock:^{
                [self.itemTableView.mj_header beginRefreshing];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else{
        ScoreOrderDetailViewController *vc = [[ScoreOrderDetailViewController alloc] init];
        vc.scoreOrderModel = self.scoreItemArr[indexPath.section];
        vc.isConverted = [vc.scoreOrderModel.status integerValue];
        [vc setReturnBlock:^{
            [self headerRefreshing];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    if (self.btnScore.selected == NO) {
        OrderGoodsModel *goodsModel = self.itemArr[section];
        view.frame = CGRectMake(0, 10, ScreenWidth, 35);
        view.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(10, 19, 18, 18);
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 9.f;
        [imageView setImageWithString:goodsModel.logo placeHoldImageName:@"bg_no_pictures"];
        //        [imageView setImageWithURL:[NSURL URLWithString:goodsModel.logo]];
        [view addSubview:imageView];
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(35, 19, 200, 18);
        label.text = goodsModel.store_name;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithHexString:@"666666"];
        UIView *bottomView = [[UIView alloc]init];
        bottomView.frame = CGRectMake(0, 0, ScreenWidth, 10);
        bottomView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [view addSubview:bottomView];
        [view addSubview:label];
        
        UILabel *labelStatus = [[UILabel alloc]init];
        labelStatus.frame = CGRectMake(ScreenWidth - 115, 19, 100, 18);
        if (self.rightIndex == 5 && [goodsModel.refund_status integerValue] == 1) {
            
            switch ([goodsModel.status integerValue]) {
                case 0:
                {
                    labelStatus.text = @"申请中";
                }
                    break;
                case 1:
                {
                    labelStatus.text = @"申请中";
                }
                    break;
                case 2:
                {
                    labelStatus.text = @"驳回";
                }
                    break;
                    
                case 3:
                {
                    labelStatus.text = @"已通过";
                }
                    break;
                    
                case 4:
                {
                    labelStatus.text = @"驳回";
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        switch (self.rightIndex) {
            case 0://全部
            {
                OrderGoodsModel *goodsModel = self.itemArr[section];
                
                switch ([goodsModel.order_status integerValue]) {
                    case 1://待付款
                    {
                        labelStatus.text = @"待付款";
                    }
                        break;
                    case 2://待发货
                    {
                        labelStatus.text = @"待发货";
                    }
                        break;
                    case 3://待收货
                    {
                        labelStatus.text = @"待收货";
                    }
                        break;
                    case 4://已完成
                    {
                        labelStatus.text = @"已完成";
                        
                    }
                        break;
                        
                    case 5://售后
                    {
                        if ([goodsModel.refund_status integerValue] == 1) {
                            
                            switch ([goodsModel.status integerValue]) {
                                case 0:
                                {
                                    labelStatus.text = @"申请中";
                                }
                                    break;
                                case 1:
                                {
                                    labelStatus.text = @"申请中";
                                }
                                    break;
                                case 2:
                                {
                                    labelStatus.text = @"驳回";
                                }
                                    break;
                                    
                                case 3:
                                {
                                    labelStatus.text = @"已通过";
                                }
                                    break;
                                    
                                case 4:
                                {
                                    labelStatus.text = @"驳回";
                                }
                                    break;
                                    
                                default:
                                    break;
                            }
                        }
                        
                    }
                        break;
                        
                    default:
                        break;
                }            }
                break;
            case 1://待付款
            {
                labelStatus.text = @"待付款";
            }
                break;
            case 2://待发货
            {
                labelStatus.text = @"待发货";
            }
                break;
            case 3://待收货
            {
                labelStatus.text = @"待收货";
            }
                break;
            case 4://已完成
            {
                labelStatus.text = @"已完成";
                
            }
                break;
                
            default:
                break;
        }
        labelStatus.textAlignment = NSTextAlignmentRight;
        labelStatus.font = [UIFont systemFontOfSize:13];
        labelStatus.textColor = [UIColor redColor];
        [view addSubview:labelStatus];
        
    }
    return view;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    if (self.btnScore.selected == NO) {
        OrderGoodsModel *goodsModel = self.itemArr[section];
        
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, 0, ScreenWidth, 44);
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(10, 9, ScreenWidth-20, 18);
        label.text = [NSString stringWithFormat:@"共%lu件商品，实付金额￥%.2f（含运费￥%.2f）",(unsigned long)goodsModel.goods.count,[goodsModel.price floatValue],[goodsModel.trans_price floatValue]];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithHexString:@"666666"];
        label.textAlignment = NSTextAlignmentRight;
        UIView *bottomView = [[UIView alloc]init];
        bottomView.frame = CGRectMake(0, 34, ScreenWidth, 1);
        bottomView.backgroundColor = [UIColor colorWithHexString:@"e9e9e9"];
        
        CGFloat btn_width = 75.f;
        switch ([goodsModel.order_status integerValue]) {
            case 1://待付款
            {
                UIButton *btn2 = [[UIButton alloc]init];
                btn2.frame = CGRectMake(ScreenWidth - (btn_width + 10) * 2, 60, btn_width, 30);
                [btn2 setTitle:@"取消订单" forState:UIControlStateNormal];
                [btn2 setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
                [btn2.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [btn2.layer setBorderColor:[UIColor colorWithHexString:@"cccccc"].CGColor];
                [btn2.layer setBorderWidth:1];
                [btn2.layer setMasksToBounds:YES];
                [btn2.layer setCornerRadius:4.f];
                objc_setAssociatedObject(btn2, &btn_char, goodsModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [btn2 addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
                
                UIButton *btn1 = [[UIButton alloc]init];
                btn1.frame = CGRectMake(ScreenWidth - (btn_width + 10), 60, btn_width, 30);
                [btn1 setTitle:@"确认付款" forState:UIControlStateNormal];
                [btn1 setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                [btn1.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [btn1 setBackgroundColor:[UIColor colorWithHexString:@"f1a036"]];
                [btn1.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
                [btn1.layer setBorderWidth:1];
                [btn1.layer setMasksToBounds:YES];
                [btn1.layer setCornerRadius:4.f];
                objc_setAssociatedObject(btn1, &btn_char, goodsModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [btn1 addTarget:self action:@selector(startPay:) forControlEvents:UIControlEventTouchUpInside];
                
                [view addSubview:btn1];
                [view addSubview:btn2];
            }
                break;
            case 2://待发货
            {
                UIButton *btn = [[UIButton alloc]init];
                btn.frame = CGRectMake(ScreenWidth - (btn_width + 10), 60, 75, 30);
                [btn setTitle:@"再次购买" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithHexString:@"f1a036"] forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [btn.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
                [btn.layer setBorderWidth:1];
                [btn.layer setMasksToBounds:YES];
                [btn.layer setCornerRadius:4.f];
                objc_setAssociatedObject(btn, &btn_char, goodsModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [btn addTarget:self action:@selector(buyAgain:) forControlEvents:UIControlEventTouchUpInside];
                
                [view addSubview:btn];
                
            }
                break;
            case 3://待收货
            {
                UIButton *btn = [[UIButton alloc]init];
                btn.frame = CGRectMake(ScreenWidth - (btn_width + 10) * 3, 60, 75, 30);
                [btn setTitle:@"再次购买" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithHexString:@"f1a036"] forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [btn.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
                [btn.layer setBorderWidth:1];
                [btn.layer setMasksToBounds:YES];
                [btn.layer setCornerRadius:4.f];
                objc_setAssociatedObject(btn, &btn_char, goodsModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [btn addTarget:self action:@selector(buyAgain:) forControlEvents:UIControlEventTouchUpInside];
                
                [view addSubview:btn];
                
                
                UIButton *btn2 = [[UIButton alloc]init];
                btn2.frame = CGRectMake(ScreenWidth - (btn_width + 10) * 2, 60, btn_width, 30);
                [btn2 setTitle:@"查看物流" forState:UIControlStateNormal];
                [btn2 setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
                [btn2.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [btn2.layer setBorderColor:[UIColor colorWithHexString:@"cccccc"].CGColor];
                [btn2.layer setBorderWidth:1];
                [btn2.layer setMasksToBounds:YES];
                [btn2.layer setCornerRadius:4.f];
                objc_setAssociatedObject(btn2, &btn_char, goodsModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [btn2 addTarget:self action:@selector(lookForLogistics:) forControlEvents:UIControlEventTouchUpInside];
                
                
                UIButton *btn1 = [[UIButton alloc]init];
                btn1.frame = CGRectMake(ScreenWidth - (btn_width + 10), 60, btn_width, 30);
                [btn1 setTitle:@"确认收货" forState:UIControlStateNormal];
                [btn1 setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                [btn1.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [btn1 setBackgroundColor:[UIColor colorWithHexString:@"f1a036"]];
                [btn1.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
                [btn1.layer setBorderWidth:1];
                [btn1.layer setMasksToBounds:YES];
                [btn1.layer setCornerRadius:4.f];
                objc_setAssociatedObject(btn1, &btn_char, goodsModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [btn1 addTarget:self action:@selector(confirmReceipt:) forControlEvents:UIControlEventTouchUpInside];
                
                [view addSubview:btn1];
                [view addSubview:btn2];
                
            }
                break;
            case 4://已完成
            {
                
                
                UIButton *btn = [[UIButton alloc]init];
                btn.frame = CGRectMake(ScreenWidth - (btn_width + 10) * 2, 60, 75, 30);
                [btn setTitle:@"再次购买" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithHexString:@"f1a036"] forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [btn.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
                [btn.layer setBorderWidth:1];
                [btn.layer setMasksToBounds:YES];
                [btn.layer setCornerRadius:4.f];
                objc_setAssociatedObject(btn, &btn_char, goodsModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [btn addTarget:self action:@selector(buyAgain:) forControlEvents:UIControlEventTouchUpInside];
                
                UIButton *btn2 = [[UIButton alloc]init];
                btn2.frame = CGRectMake(ScreenWidth - (btn_width + 10) * 2, 60, btn_width, 30);
                [btn2 setTitle:@"申请售后" forState:UIControlStateNormal];
                [btn2 setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
                [btn2.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [btn2.layer setBorderColor:[UIColor colorWithHexString:@"cccccc"].CGColor];
                [btn2.layer setBorderWidth:1];
                [btn2.layer setMasksToBounds:YES];
                [btn2.layer setCornerRadius:4.f];
                objc_setAssociatedObject(btn2, &btn_char, goodsModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                btn2.tag = 4;
                [btn2 addTarget:self action:@selector(applySaleService:) forControlEvents:UIControlEventTouchUpInside];
                
                
                [view addSubview:btn];
                //                [view addSubview:btn2];
                
                UIButton *btn1 = [[UIButton alloc]init];
                btn1.frame = CGRectMake(ScreenWidth - (btn_width + 10), 60, btn_width, 30);
                [btn1 setTitle:@"去评价" forState:UIControlStateNormal];
                [btn1 setTitle:@"已评价" forState:UIControlStateDisabled];
                [btn1 setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                [btn1.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [btn1 setBackgroundColor:[UIColor colorWithHexString:@"f1a036"]];
                [btn1.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
                [btn1.layer setBorderWidth:1];
                [btn1.layer setMasksToBounds:YES];
                [btn1.layer setCornerRadius:4.f];
                objc_setAssociatedObject(btn1, &btn_char, goodsModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [btn1 addTarget:self action:@selector(commentOrder:) forControlEvents:UIControlEventTouchUpInside];
                
                [view addSubview:btn1];
                if ([goodsModel.point integerValue] == 0) {
                    btn1.enabled = YES;
                    
                }
                else{
                    //                    btn2.frame = CGRectMake(ScreenWidth - (btn_width + 10) * 2, 60, btn_width, 30);
                    //                    btn.frame = CGRectMake(ScreenWidth - (btn_width + 10) * 1, 60, 75, 30);
                    btn1.enabled = NO;
                    
                }
            }
                break;
            case 5://售后服务
            {
                
                
                
                if ([goodsModel.refund_status integerValue] == 1) {
                    if ([goodsModel.status integerValue] == 2 || [goodsModel.status integerValue] == 4 ) {
                        UIButton *btn2 = [[UIButton alloc]init];
                        btn2.frame = CGRectMake(ScreenWidth - (btn_width + 10) * 1, 60, btn_width, 30);
                        [btn2 setTitle:@"申请售后" forState:UIControlStateNormal];
                        [btn2 setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
                        [btn2.titleLabel setFont:[UIFont systemFontOfSize:13]];
                        [btn2.layer setBorderColor:[UIColor colorWithHexString:@"cccccc"].CGColor];
                        [btn2.layer setBorderWidth:1];
                        [btn2.layer setMasksToBounds:YES];
                        [btn2.layer setCornerRadius:4.f];
                        objc_setAssociatedObject(btn2, &btn_char, goodsModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                        [btn2 addTarget:self action:@selector(applySaleService:) forControlEvents:UIControlEventTouchUpInside];
                        btn2.tag = 5;
                        [view addSubview:btn2];
                    }
                    
                }
                label.text = [NSString stringWithFormat:@"共%lu件商品，实付金额￥%.2f（不含运费）",(unsigned long)goodsModel.goods.count,[goodsModel.refund_price floatValue]];
                
            }
                break;
                
            default:
                break;
        }
        
        [view addSubview:bottomView];
        [view addSubview:label];
    }
    return view;
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
        OrderGoodsModel *goodsModel = objc_getAssociatedObject(sender, &btn_char);
        OrderViewModel *cancelViewModel = [[OrderViewModel alloc] init];
        [cancelViewModel setBlockWithReturnBlock:^(id returnValue) {
            [weakSelf.itemTableView.mj_header beginRefreshing];
        } WithErrorBlock:^(id errorCode) {
            [weakSelf showJGProgressWithMsg:errorCode];
        }];
        
        [cancelViewModel cancelOrder:goodsModel.Id token:[self getToken]];
        
    }];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//确认支付
-(void)startPay:(id)sender{
    __weak typeof (self)weakSelf = self;
    OrderGoodsModel *goodsModel = objc_getAssociatedObject(sender, &btn_char);
    self.typeView = [[[NSBundle mainBundle] loadNibNamed:@"ChooseTypeView" owner:self options:nil]firstObject];
    
    self.typeView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    WalletViewModel *walletViewModel = [[WalletViewModel alloc]init];
    [walletViewModel setBlockWithReturnBlock:^(id returnValue) {
        WalletModel *model = returnValue;
        NSNumber *allMoney = model.amount;
        if ([allMoney doubleValue] < [goodsModel.price doubleValue]) {
            [self.typeView initViewWithPrice:[allMoney doubleValue] type:0];
        }else{
            [self.typeView initViewWithPrice:[allMoney doubleValue] type:0];
        }
        
        [self.view addSubview:self.typeView];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [walletViewModel fetchWalletInfomationWithToken:[self getToken]];
    [self.typeView setReturnTypeBlock:^(NSInteger type) {
        
        OrderViewModel *viewModel = [[OrderViewModel alloc] init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [weakSelf.typeView removeFromSuperview];
            if (type == 1) {
                [weakSelf headerRefreshing];
            }else if(type == 2){
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
                
            }
            
            
        } WithErrorBlock:^(id errorCode) {
            [weakSelf showJGProgressWithMsg:errorCode];
        }];
        [viewModel payOrderPay:@[goodsModel.Id] type:type token:[weakSelf getToken]];
    }];
    [self.view addSubview:self.typeView];
    
    
    
}

//再次购买
-(void)buyAgain:(id)sender{
    OrderGoodsModel *goodsModel = objc_getAssociatedObject(sender, &btn_char);
    
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
    [viewModel buyAgain:goodsModel.Id token:[self getToken] type:2];
}

//查看物流
-(void)lookForLogistics:(id)sender{
    
    OrderGoodsModel *goodsModel = objc_getAssociatedObject(sender, &btn_char);
    if (!goodsModel.trans_order_no) {
        [self showJGProgressWithMsg:@"暂无物流信息"];
        return;
    }
    
    LookLogisticsViewController *vc = [[LookLogisticsViewController alloc] init];
    vc.logisticsOrderNo = goodsModel.trans_order_no;
    vc.logisticsCompanyName = goodsModel.company;
    [self.navigationController pushViewController:vc animated:YES];
    
}


//确认收货
-(void)confirmReceipt:(id)sender{
    
    __weak typeof (self)weakSelf = self;
    OrderGoodsModel *goodsModel = objc_getAssociatedObject(sender, &btn_char);
    OrderViewModel *viewModel = [[OrderViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        //        UIButton *btn = [weakSelf.categoryScrollView viewWithTag:menu_max + 3];
        //        [weakSelf menuSelect:btn];
        [weakSelf.itemTableView.mj_header beginRefreshing];
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    
    [viewModel confirmGet:goodsModel.Id token:[self getToken]];
    
}


//去评价
-(void)commentOrder:(id)sender{
    __weak typeof (self)weakSelf = self;
    OrderGoodsModel *goodsModel = objc_getAssociatedObject(sender, &btn_char);
    RemarkViewController *vc = [[RemarkViewController alloc] init];
    vc.model = goodsModel;
    [vc setFinishBlock:^{
        [weakSelf.itemTableView.mj_header beginRefreshing];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

//申请售后
-(void)applySaleService:(UIButton *)sender{
    OrderGoodsModel *goodsModel = objc_getAssociatedObject(sender, &btn_char);
    ApplyRefundViewController *vc = [[ApplyRefundViewController alloc] init];
    vc.model = goodsModel;
    vc.type = 2; //1=单个商品退款，2=整个订单退款
    if (sender.tag == 4) {
        vc.applyOnce = NO;
    }
    else{
        vc.applyOnce = YES;
    }
    [vc setFinishBlock:^{
        [self.itemTableView.mj_header beginRefreshing];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
