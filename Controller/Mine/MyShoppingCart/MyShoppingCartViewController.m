//
//  MyShoppingCartViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/4.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyShoppingCartViewController.h"
#import "OrderFormViewController.h"

#import "MyCartTableViewCell.h"

#import "ShoppingCarViewModel.h"
#import "StoreGoodsModel.h"
#import "OrderViewModel.h"
@interface MyShoppingCartViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *btnEditing;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
@property (weak, nonatomic) IBOutlet UIButton *btnCalculate;
@property (weak, nonatomic) IBOutlet UIImageView *imageAllSelect;
@property (weak, nonatomic) IBOutlet UILabel *labelDescribe;
@property (weak, nonatomic) IBOutlet UILabel *labelAllPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelAlert;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;



@property (nonatomic, retain) NSMutableArray *dataArray;//请求下来的数组
@property (nonatomic, retain) NSMutableArray *selectArr;//选中的数组
@property (nonatomic, assign) NSInteger allPrice;
@property (nonatomic, assign) NSInteger allGoodsNum;
@property (nonatomic ,retain) NSMutableArray *itemArr;//数据源数组
@property (nonatomic ,assign) NSInteger pageIndex;
@property (nonatomic, retain) ShoppingCarViewModel *viewModel;

//是否存在库存不足的商品

@property (nonatomic, assign) BOOL  hasSku;  //默认为NO
@end

@implementation MyShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataArray = [[NSMutableArray alloc]init];
    self.selectArr = [[NSMutableArray alloc]init];
    self.itemArr = [[NSMutableArray alloc]init];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"MyCartTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCartTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
    
    __weak typeof (self)weakSelf = self;
    self.viewModel = [[ShoppingCarViewModel alloc] init];
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        [dataArray removeAllObjects];
        [weakSelf.itemArr removeAllObjects];
        [weakSelf.selectArr removeAllObjects];
        weakSelf.allGoodsNum = 0;
        [dataArray addObjectsFromArray:returnValue];
        for (int i = 0; i < dataArray.count; i ++) {
            StoreModel *model = dataArray[i];
            NSMutableArray *goodsArr = [[NSMutableArray alloc]init];
            [goodsArr addObjectsFromArray:model.goods];
            for (int j = 0; j < goodsArr.count; j ++ ) {
                [weakSelf.itemArr addObject:goodsArr[j]];
            }
        }
        
        [weakSelf.itemTableView reloadData];
        for (int i = 0; i < self.itemArr.count; i ++) {
            StoreGoodsModel *model = weakSelf.itemArr[i];
            if ([model.checked integerValue] == 1) {
                NSLog(@"i = %d",i);
                if ([model.sku integerValue]) {//有库存，才。。
                    [weakSelf.selectArr addObject:weakSelf.itemArr[i]];
                    weakSelf.allGoodsNum += [model.goods_number integerValue];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                    [weakSelf.itemTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                }
                else{
                    weakSelf.hasSku = YES;
                }
            }
        }
        if (self.selectArr.count == self.itemArr.count && self.itemArr.count) {
            weakSelf.btnSelect.selected = YES;
        }
        else{
            weakSelf.btnSelect.selected = NO;
        }
        [weakSelf.btnCalculate setTitle:[NSString stringWithFormat:@"结算(%ld)",(long)weakSelf.allGoodsNum] forState:UIControlStateNormal];
        double allPrice = 0;
        for (int i = 0; i < self.itemArr.count; i ++) {
            StoreGoodsModel *priceModel = weakSelf.itemArr[i];//priceModel计算总价的商品model
            if ([priceModel.checked integerValue] == 1 && [priceModel.sku integerValue]) {
                double price = [priceModel.price doubleValue] * [priceModel.goods_number integerValue];
                allPrice += price;
            }
            
        }
        weakSelf.labelAllPrice.text = [NSString stringWithFormat:@"总价：￥%2.f",allPrice];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:weakSelf.labelAllPrice.text];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"2a2a2a"] range:NSMakeRange(0, 3)];
        [weakSelf.labelAllPrice setAttributedText:attrStr];
        weakSelf.allPrice = allPrice;
        
        
        
        
        //        weakSelf.labelAllPrice.text = [NSString stringWithFormat:@"总价：￥%d",0];
        
        [weakSelf.dataArray removeAllObjects];
        for (int i = 0;  i < weakSelf.itemArr.count; i ++) {
            StoreGoodsModel *model = weakSelf.itemArr[i];
            [weakSelf.dataArray addObject:model.Id];
        }
        if (self.pageIndex == 1) {
            [weakSelf.itemTableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
        
        if ([returnValue count]<10) {
            [weakSelf.itemTableView.mj_footer removeFromSuperview];
        }
        if (self.itemArr.count == 0) {
            //            weakSelf.noDataView.hidden = NO;
            //            weakSelf.itemTableView.hidden = YES;
        }else{
            //            weakSelf.noDataView.hidden = YES;
            //            weakSelf.itemTableView.hidden = NO;
        }
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
        [weakSelf.itemTableView.mj_header endRefreshing];
        if (self.itemArr.count == 0) {
            //            weakSelf.noDataView.hidden = NO;
            //            weakSelf.itemTableView.hidden = YES;
        }
        else{
            //            weakSelf.noDataView.hidden = YES;
            //            weakSelf.itemTableView.hidden = NO;
        }
    }];
    
    [self setupRefresh];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self headerRefreshing];
    
}

/**
 *  设置刷新
 */
-(void)setupRefresh
{
    self.itemTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    self.itemTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    [self.itemTableView.mj_header beginRefreshing];
    
}
/**
 *  下拉刷新
 */
-(void)headerRefreshing
{
    self.pageIndex = 0;
    [self.itemArr removeAllObjects];
    [self.itemTableView reloadData];
    [self footerRefreshing];
}
/**
 *  上拉刷新
 */
-(void)footerRefreshing
{
    [self.viewModel fetchMyShoppingCarWithToken:[self getToken] page:@(++ self.pageIndex) size:@(10)];
}

- (IBAction)backAction:(id)sender {
    self.returnReloadGoodsBlock();
    [self backBtnAction:sender];
}
- (IBAction)editingAction:(id)sender {
    self.btnEditing.selected = !self.btnEditing.selected;
    if (self.btnEditing.selected) {
        self.labelAlert.hidden = YES;
        self.labelAllPrice.hidden = YES;
        self.labelDescribe.hidden = YES;
        self.btnCalculate.hidden = YES;
        self.btnDelete.hidden = NO;
    }else{
        self.labelAlert.hidden = NO;
        self.labelAllPrice.hidden = NO;
        self.labelDescribe.hidden = NO;
        self.btnCalculate.hidden = NO;
        self.btnDelete.hidden = YES;
    }
}
- (IBAction)selectAction:(id)sender {
    if (self.hasSku) {
        [self showJGProgressWithMsg:@"有商品库存不足，不能全选"];
        return;
    }
    self.btnSelect.selected = !self.btnSelect.selected;
    [self.selectArr removeAllObjects];
    if (self.btnSelect.selected) {
        for (int i = 0; i < self.itemArr.count; i ++) {
            StoreGoodsModel *model = self.itemArr[i];
            [self.selectArr addObject:model];
        }
        double allPrice = 0;
        self.allGoodsNum = 0;
        for (int i = 0; i < self.selectArr.count; i ++) {
            StoreGoodsModel *priceModel = self.selectArr[i];//priceModel计算总价的商品model
            double price = [priceModel.price doubleValue] * [priceModel.goods_number intValue];
            allPrice += price;
            self.allGoodsNum += [priceModel.goods_number integerValue];
        }
        
        [self.btnCalculate setTitle:[NSString stringWithFormat:@"结算(%ld)",(long)self.allGoodsNum] forState:UIControlStateNormal];
        self.labelAllPrice.text = [NSString stringWithFormat:@"总价：￥%.2f",allPrice];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:self.labelAllPrice.text];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"2a2a2a"] range:NSMakeRange(0, 3)];
        [self.labelAllPrice setAttributedText:attrStr];
        self.allPrice = allPrice;

    }
    else{
        [self.btnCalculate setTitle:@"结算0" forState:UIControlStateNormal];
        self.labelAllPrice.text = [NSString stringWithFormat:@"总价：￥%d",0];
    }
    [self.itemTableView reloadData];
}
- (IBAction)calculateAction:(id)sender {
    if (self.selectArr.count == 0) {
        
        return;
    }
    NSMutableArray *idMuArr = [[NSMutableArray alloc] init];
    OrderViewModel *viewModel = [[OrderViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        OrderFormViewController *vc = [[OrderFormViewController alloc]init];
        [vc setReturnReloadBlock:^{
            [self headerRefreshing];
        }];
        vc.isCar = 1;
        vc.goodsArray = (NSArray *)returnValue;
        vc.shopIdArray = idMuArr;
        [self.navigationController pushViewController:vc animated:YES];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    for (int i = 0; i < self.selectArr.count; i ++) {
        StoreGoodsModel *model = self.selectArr[i];
        [idMuArr addObject:model.Id];
    }
    
    [viewModel confirmOrderWithToken:[self getToken] shop_id:idMuArr];
    
    
    
}
- (IBAction)deleteAction:(id)sender {
    __weak typeof (self)weakSelf = self;

    //删除
    ShoppingCarViewModel *viewModel = [[ShoppingCarViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [weakSelf.selectArr removeAllObjects];
        [weakSelf headerRefreshing];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    
    NSMutableArray *idMuArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.selectArr.count; i ++) {
        StoreGoodsModel *model = self.selectArr[i];
        [idMuArr addObject:model.Id];
    }

    [viewModel deleteMyShoppingCarWithToken:[self getToken] shop:idMuArr];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCartTableViewCell"];
    [cell setReturnBlock:^(NSInteger maxOrMin,NSInteger count,NSString *shopId) {
        ShoppingCarViewModel *viewModel = [[ShoppingCarViewModel alloc]init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            self.allGoodsNum -= maxOrMin;
            self.allGoodsNum += count;
            StoreGoodsModel *model = [[StoreGoodsModel alloc] init];
            model = self.itemArr[indexPath.row];
            model.goods_number = @(count);
            [self.itemArr replaceObjectAtIndex:indexPath.row withObject:model];
            
            if ([self.selectArr containsObject:self.itemArr[indexPath.row]]) {
                [self.btnCalculate setTitle:[NSString stringWithFormat:@"结算(%ld)",(long)self.allGoodsNum] forState:UIControlStateNormal];
            }
            
            double allPrice = 0;
            for (int i = 0; i < self.selectArr.count; i ++) {
                StoreGoodsModel *priceModel = self.selectArr[i];//priceModel计算总价的商品model
                double price = [priceModel.price doubleValue] * [priceModel.goods_number intValue];
                allPrice += price;
            }
            
            self.labelAllPrice.text = [NSString stringWithFormat:@"总价：￥%.2f",allPrice];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:self.labelAllPrice.text];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"2a2a2a"] range:NSMakeRange(0, 3)];
            [self.labelAllPrice setAttributedText:attrStr];
            self.allPrice = allPrice;
            
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel updateMyShoppingCarWithToken:[self getToken] Id:shopId num:@(count)];
    }];
    [cell initCellWithData:self.itemArr[indexPath.row]];
    [cell setMsgBlock:^(NSString *msg) {
        [self showJGProgressWithMsg:msg];
    }];

    if ([self.selectArr containsObject:self.itemArr[indexPath.row]]) {
        cell.selectBtn.selected = YES;
    }
    else{
        cell.selectBtn.selected = NO;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

//选中时将选中行的在self.dataArray 中的数据添加到删除数组self.deleteArr中

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StoreGoodsModel *model = self.itemArr[indexPath.row];
    if (![model.sku integerValue] && !self.btnEditing.selected && !self.btnEditing.selected) {//如果库存为0，则不能点击
        return;
    }
    if ([self.selectArr containsObject:self.itemArr[indexPath.row]]) {
        [self.selectArr removeObject:self.itemArr[indexPath.row]];
    }
    else{
        [self.selectArr addObject:self.itemArr[indexPath.row]];
    }
    [tableView reloadData];

    if (!self.btnEditing.selected) {

        StoreGoodsModel *priceModel = self.itemArr[indexPath.row];
        ShoppingCarViewModel *viewModel = [[ShoppingCarViewModel alloc]init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            double allPrice = 0;
            self.allGoodsNum = 0;
            for (int i = 0; i < self.selectArr.count; i ++) {
                StoreGoodsModel *priceModel = self.selectArr[i];//priceModel计算总价的商品model
                double price = [priceModel.price doubleValue] * [priceModel.goods_number intValue];
                allPrice += price;
                self.allGoodsNum += [priceModel.goods_number integerValue];
            }
            
            [self.btnCalculate setTitle:[NSString stringWithFormat:@"结算(%ld)",(long)self.allGoodsNum] forState:UIControlStateNormal];
            self.labelAllPrice.text = [NSString stringWithFormat:@"总价：￥%.2f",allPrice];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:self.labelAllPrice.text];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"2a2a2a"] range:NSMakeRange(0, 3)];
            [self.labelAllPrice setAttributedText:attrStr];
            self.allPrice = allPrice;
            
            if (self.selectArr.count == self.itemArr.count) {
                self.btnSelect.selected = YES;
            }
            else{
                self.btnSelect.selected = NO;
            }
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel changeShopStateWithToken:[self getToken] Id:priceModel.Id];
        
        
    }
    else{
        if (self.selectArr.count == self.itemArr.count) {
            self.btnSelect.selected = YES;
        }
        else{
            self.btnSelect.selected = NO;
        }

    }
}
@end
