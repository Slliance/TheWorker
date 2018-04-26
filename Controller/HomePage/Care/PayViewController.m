//
//  PayViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/25.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "PayViewController.h"
#import "OrderHeaderView.h"
#import "OrderTableViewCell.h"
#import "PaySuccessViewController.h"

@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UILabel *labelAllPrice;
@property (nonatomic, retain) OrderHeaderView *headView;

@property (nonatomic, retain) StoreModel *storeModel;
@property (nonatomic, retain) NSMutableArray *property_id;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, assign) NSString *addressId;

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.property_id = [[NSMutableArray alloc]init];
    self.storeModel = [[StoreModel alloc]init];
    self.headView = [[[NSBundle mainBundle]loadNibNamed:@"OrderHeaderView" owner:self options:nil]firstObject];
    [self.headView initOrderViewWith:self.addressModel];
//    __weak typeof(self)weakSelf = self;
    [self.headView setReturnBlock:^{
        }];
    self.itemTableView.tableHeaderView = self.headView;
    [self.itemTableView registerNib:[UINib nibWithNibName:@"OrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.addressModel = [[AddressModel alloc] init];
    [self  analyticalData];
    
//    if (self.isCar == 0) {
        StoreGoodsModel *goodsModel = self.goodsArray[0];
        NSInteger money = [goodsModel.price floatValue] * self.num + [goodsModel.trans_price floatValue];
        self.labelAllPrice.text = [NSString stringWithFormat:@"￥%ld",(long)money];
//    }
    // Do any additional setup after loading the view from its nib.
}

-(void)analyticalData{
//    if (self.isCar == 0) {
        NSLog(@"%@/n%@",self.goodsArray[0],self.goodsArray[1]);
        NSDictionary *propertyDic = [[NSDictionary alloc]initWithDictionary:self.goodsArray[1]];
        self.num = [propertyDic[@"count"] integerValue];
        [self.property_id addObjectsFromArray:propertyDic[@"property_id"]];
        StoreGoodsModel *goodsModel = self.goodsArray[0];
        self.storeModel = goodsModel.store;
        self.goodsId = goodsModel.Id;
//    }
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)payAction:(id)sender {
    PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTableViewCell"];
    [cell initViewWithData:self.goodsArray];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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
//    if (self.isCar == 0) {
        label.text = self.storeModel.name;
    [imageView setImageWithString:self.storeModel.logo placeHoldImageName:@"bg_no_pictures"];
//        [imageView setImageWithURL:[NSURL URLWithString:self.storeModel.logo] placeholderImage:[UIImage imageNamed:placeholderImage_home_banner]];
//    }
    
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"666666"];
    UILabel *labelPay = [[UILabel alloc]init];
    labelPay.frame = CGRectMake(ScreenWidth-10-50, 9, 50, 18);
    labelPay.text = @"待付款";
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
//    if (self.isCar == 0) {
        StoreGoodsModel *goodsModel = self.goodsArray[0];
        NSInteger money = [goodsModel.price floatValue] * self.num + [goodsModel.trans_price floatValue];
        label.text = [NSString stringWithFormat:@"共%ld件商品，实付金额￥%ld（含运费￥%.2f）",(long)self.num,(long)money,[goodsModel.trans_price floatValue]];
//    }
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
