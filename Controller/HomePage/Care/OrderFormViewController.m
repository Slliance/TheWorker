//
//  OrderFormViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/22.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "OrderFormViewController.h"
#import "PayViewController.h"
#import "PaySuccessViewController.h"
#import "ShippingAddressViewController.h"

#import "OrderHeaderView.h"
#import "OrderTableViewCell.h"
#import "ChooseTypeView.h"

#import "AddressViewModel.h"
#import "AddressModel.h"
#import "OrderViewModel.h"
#import "StoreModel.h"
#import "StoreGoodsModel.h"
#import "OrderGoodsModel.h"
#import "OrderViewModel.h"
#import "WalletViewModel.h"
#import "WalletModel.h"

#import "UIImageView+Extension.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface OrderFormViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UILabel *labelAllMoney;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (nonatomic, retain) OrderHeaderView *headView;
@property (nonatomic, retain) AddressModel *addressModel;
@property (nonatomic, retain) StoreModel *storeModel;
@property (nonatomic, retain) NSMutableArray *property_id;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, copy)   NSString *goodsId;
@property (nonatomic, copy) NSString *addressId;
@property (nonatomic, assign) double allPrice;
@property (nonatomic, retain) NSMutableArray *storeArray;
@property (nonatomic, retain) NSMutableArray *orderIdArr;

@property (nonatomic, assign) BOOL isSubmit;
@end

@implementation OrderFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSubmit = YES;
    self.property_id = [[NSMutableArray alloc]init];
    self.storeModel = [[StoreModel alloc]init];
    self.storeArray = [[NSMutableArray alloc]init];
    self.orderIdArr = [[NSMutableArray alloc] init];
    self.headView = [[[NSBundle mainBundle]loadNibNamed:@"OrderHeaderView" owner:self options:nil]firstObject];
    
    __weak typeof(self)weakSelf = self;
    [self.headView setReturnBlock:^{
        ShippingAddressViewController *vc = [[ShippingAddressViewController alloc]init];
        vc.isChooseOrChange = 0;
        [vc setReturnAddressBlcok:^(AddressModel *model) {
            weakSelf.addressModel = model;
            [weakSelf.headView initViewWith:weakSelf.addressModel];
            weakSelf.addressId = model.Id;
        }];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    
    self.itemTableView.tableHeaderView = self.headView;
    [self.itemTableView registerNib:[UINib nibWithNibName:@"OrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.addressModel = [[AddressModel alloc] init];
    AddressViewModel *viewModel = [[AddressViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        self.addressModel = returnValue;
        [self.headView initViewWith:self.addressModel];
        if (self.addressModel.Id.length > 1) {
            self.addressId = self.addressModel.Id;
        }
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchMydefaultAddressWithToken:[self getToken]];
    [self  analyticalData];
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
        self.returnReloadBlock();
        [self backAction:nil];
        
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
            if (self.isCar == 1) {
                [self backAction:nil];
            }else{
                PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
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

-(void)analyticalData{
    if (self.isCar == 0) {
        NSDictionary *propertyDic = [[NSDictionary alloc]initWithDictionary:self.goodsArray[1]];
        self.num = [propertyDic[@"count"] integerValue];
        double price = [propertyDic[@"price"] doubleValue];
        double transPrice = [propertyDic[@"trans_price"] doubleValue];
        self.allPrice = price + transPrice;
        [self.property_id addObjectsFromArray:propertyDic[@"property_id"]];
        StoreGoodsModel *goodsModel = self.goodsArray[0];
        self.storeModel = goodsModel.store;
        self.goodsId = goodsModel.Id;
        
    }else{
        [self.storeArray addObjectsFromArray:self.goodsArray];
        for (int i = 0; i < self.storeArray.count; i ++) {
            OrderGoodsModel *model = self.storeArray[i];
            self.allPrice += [model.price floatValue];
            NSArray *array = model.goods;
            for (int j = 0; j < array.count; j ++) {
                StoreGoodsModel *subModel = array[j];
                self.num += [subModel.goods_number integerValue];
            }
            self.allPrice += [model.trans_price floatValue];
        }
    }
    if (self.isCar == 0) {
        StoreGoodsModel *goodsModel = self.goodsArray[0];
        NSDictionary *dic = self.goodsArray[1];
        double money = [dic[@"price"] floatValue] * self.num + [goodsModel.trans_price floatValue];
        self.labelAllMoney.text = [NSString stringWithFormat:@"￥%.2f",money];
    }else{
        self.labelAllMoney.text = [NSString stringWithFormat:@"%.2f",self.allPrice];
    }
}

- (IBAction)backAction:(id)sender {
    self.returnReloadBlock();
    [self backBtnAction:sender];
}
- (IBAction)convertAction:(id)sender {
    
    if (self.isSubmit == YES) {
        if (self.addressId.length == 0) {
            [self showJGProgressWithMsg:@"请选择收货地址"];
            return;
        }
        OrderViewModel *viewModel = [[OrderViewModel alloc]init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [self.btnSubmit setTitle:@"付款" forState:UIControlStateNormal];
            self.isSubmit = NO;
            [self.orderIdArr addObjectsFromArray:returnValue[@"Id"]];
            [self.itemTableView reloadData];
            [self.headView initOrderViewWith:self.addressModel];
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        
        if (self.isCar == 0) {
            [viewModel buyNowAddOrderWithToken:[self getToken] goodsId:self.goodsId num:@(self.num) property:self.property_id add_id:self.addressId];
        }else{//isCar = 1
            //
            [viewModel buyFromShoppingCarWithToken:[self getToken] shop_id:self.shopIdArray add_id:self.addressId];
        }
        
    }else{//isSubmit == NO
        WalletViewModel *viewModel = [[WalletViewModel alloc]init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            ChooseTypeView *typeView = [[[NSBundle mainBundle] loadNibNamed:@"ChooseTypeView" owner:self options:nil]firstObject];
            typeView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            WalletModel *model = returnValue;
            NSNumber *allMoney = model.amount;
            if ([allMoney doubleValue] < self.allPrice) {
                [typeView initViewWithPrice:[allMoney doubleValue] type:0];
            }else{
                [typeView initViewWithPrice:[allMoney doubleValue] type:0];
            }
            [typeView setReturnTypeBlock:^(NSInteger type) {
                [self payAction:type];
            }];
            [self.view addSubview:typeView];
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel fetchWalletInfomationWithToken:[self getToken]];
        
        
        
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isCar == 0) {
        return 1;
    }
    
    return self.storeArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isCar == 0) {
        return 1;
    }
    OrderGoodsModel *model = self.storeArray[section];
    NSArray *array = model.goods;
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTableViewCell"];
    if (self.isCar == 0) {
        [cell initViewWithData:self.goodsArray];
    }else{
        OrderGoodsModel *model = self.storeArray[indexPath.section];
        NSArray *array = model.goods;
        
        [cell initViewWith:array[indexPath.row]];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isCar == 0) {
        
        return [OrderTableViewCell getCellHeightWithArray:self.goodsArray];
    }else{
        OrderGoodsModel *model = self.storeArray[indexPath.section];
        NSArray *array = model.goods;
        return [OrderTableViewCell getCellHeightWithModel:array[indexPath.row]];
    }
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, ScreenWidth, 36);
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(10, 9, 18, 18);
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 9.f;
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(35, 9, 200, 18);
    if (self.isCar == 0) {
        label.text = self.storeModel.name;
        [imageView setImageWithString:self.storeModel.logo placeHoldImageName:@"bg_no_pictures"];
        //        [imageView setImageWithURL:[NSURL URLWithString:self.storeModel.logo] placeholderImage:[UIImage imageNamed:placeholderImage_home_banner]];
    }else{
        OrderGoodsModel *model = self.storeArray[section];
        label.text = model.name;
        [imageView setImageWithString:model.logo placeHoldImageName:@"bg_no_pictures"];
        //        [imageView setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:placeholderImage_home_banner]];
    }
    
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"666666"];
    UILabel *labelPay = [[UILabel alloc]init];
    labelPay.frame = CGRectMake(ScreenWidth-10-50, 9, 50, 18);
    labelPay.text = @"待付款";
    if (self.isSubmit == YES) {
        labelPay.hidden = YES;
    }else{
        labelPay.hidden = NO;
    }
    labelPay.font = [UIFont systemFontOfSize:13];
    labelPay.textColor = [UIColor colorWithHexString:@"ff6666"];
    [view addSubview:imageView];
    [view addSubview:label];
    [view addSubview:labelPay];
    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, ScreenWidth, 44);
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(10, 9, ScreenWidth-20, 18);
    if (self.isCar == 0) {
        
        StoreGoodsModel *goodsModel = self.goodsArray[0];
        NSDictionary *dic = self.goodsArray[1];
        double money = [dic[@"price"] floatValue] * self.num + [goodsModel.trans_price floatValue];
        label.text = [NSString stringWithFormat:@"共%ld件商品，实付金额￥%.2f（含运费￥%.2f）",(long)self.num,money,[goodsModel.trans_price floatValue]];
    }else{
        OrderGoodsModel *model = self.storeArray[section];
        double money = [model.price floatValue] + [model.trans_price floatValue];
        NSArray *goodsArray = model.goods;
        self.num = 0;
        for (int i = 0; i < goodsArray.count; i ++) {
            StoreGoodsModel *subModel = goodsArray[i];
            self.num += [subModel.goods_number integerValue];
        }
        label.text = [NSString stringWithFormat:@"共%ld件商品，实付金额￥%.2f（含运费￥%.2f）",(long)self.num,money,[model.trans_price floatValue]];
    }
    
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"666666"];
    label.textAlignment = NSTextAlignmentCenter;
    UIView *bottomView = [[UIView alloc]init];
    bottomView.frame = CGRectMake(0, 34, ScreenWidth, 10);
    bottomView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [view addSubview:bottomView];
    [view addSubview:label];
    
    return view;
}

-(void)payAction:(NSInteger)type{
    __weak typeof (self)weakSelf = self;
    
    OrderViewModel *payModel = [[OrderViewModel alloc]init];
    [payModel setBlockWithReturnBlock:^(id returnValue) {
        [weakSelf dissJGProgressLoadingWithTag:200];
        if (type == 1) {
            if (self.isCar == 1) {
                [self backAction:nil];
            }else{
                PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
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
        [weakSelf dissJGProgressLoadingWithTag:200];
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    [payModel payOrderPay:self.orderIdArr type:type token:[self getToken]];
    [weakSelf showJGProgressLoadingWithTag:200];
    
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
