//
//  CareGoodsDetailsViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/21.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "CareGoodsDetailsViewController.h"
#import "ServiceViewController.h"
#import "OrderFormViewController.h"
#import "ShopListDetailViewController.h"
#import "MyShoppingCartViewController.h"
#import "LoginViewController.h"

#import "ChooseGoodsCategoryView.h"
#import "GoodsHeadView.h"
#import "ChooseGoodsDetailFootView.h"
#import "ChooseGoodsDetailInfoTableViewCell.h"
#import "GoodsDetailTableViewCell.h"
#import "RemarkTableViewCell.h"

#import "GoodsViewModel.h"
#import "StoreModel.h"
#import "StoreGoodsModel.h"
#import "CollectViewModel.h"
#import "ShoppingCarViewModel.h"



#define content_height (ScreenHeight - 64 - 49)

@interface CareGoodsDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnGoods;
@property (weak, nonatomic) IBOutlet UIButton *btnDetail;
@property (weak, nonatomic) IBOutlet UIButton *btnRemark;
@property (weak, nonatomic) IBOutlet UILabel *labelGoods;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UILabel *labelMax;

@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnService;
@property (weak, nonatomic) IBOutlet UIButton *btnShop;
@property (weak, nonatomic) IBOutlet UIButton *btnCollect;
@property (weak, nonatomic) IBOutlet UILabel *cutLineOne;
@property (weak, nonatomic) IBOutlet UILabel *cutLineTwo;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,assign )   NSInteger count;
@property (nonatomic, retain) StoreGoodsModel *goodsModel;
@property (nonatomic, retain) StoreGoodsModel *xGoodsModel;//商品基本信息
@property (nonatomic, retain) StoreGoodsModel *goodsPropertyModel;
@property (nonatomic, retain) GoodsHeadView *headView;
@property (nonatomic, retain) ChooseGoodsCategoryView *shoppingCarView;
@property (nonatomic, retain) NSMutableArray *remarkArr;
@property (nonatomic, copy) NSString *propertyStr;//已选择类型

@property (nonatomic, retain) NSMutableArray *rowArr;
@property (nonatomic, retain) NSMutableArray *columnArr;
@property (nonatomic, retain) NSMutableDictionary *carDic;

@property (nonatomic, retain) UIWebView *htmlWebView;
@property (nonatomic, retain) GoodsViewModel *remarkViewModel;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation CareGoodsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.remarkArr = [[NSMutableArray alloc]init];
    self.rowArr = [[NSMutableArray alloc] init];
    self.columnArr = [[NSMutableArray alloc] init];
    self.carDic = [[NSMutableDictionary alloc] init];
    self.pageIndex = 0;
    if (self.count == 0) {
        self.labelCount.hidden = YES;
    }
    
    
    [self.mainScrollView setContentSize:CGSizeMake(ScreenWidth, content_height * 3)];
    
    self.htmlWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, content_height, ScreenWidth, content_height)];
    
    [self.mainScrollView addSubview:self.htmlWebView];
    
    self.commentTableView.frame = CGRectMake(0, content_height * 2, ScreenWidth, content_height);
    
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"GoodsHeadView" owner:self options:nil] firstObject];
    
    //    __weak typeof (self)weakSelf = self;
    [self.headView setEndDeceleratingBlock:^{
        NSLog(@"");
        //        weakSelf.bannerTimer = [MSWeakTimer scheduledTimerWithTimeInterval:5 target:weakSelf.headview selector:@selector(timerStart) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
    }];
    [self.headView setBeginDraggingBlock:^{
        NSLog(@"");
        //        [weakSelf.bannerTimer invalidate];
    }];
    self.itemTableView.tableHeaderView = self.headView;
    [self.itemTableView registerNib:[UINib nibWithNibName:@"GoodsDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoodsDetailTableViewCell"];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"ChooseGoodsDetailInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChooseGoodsDetailInfoTableViewCell"];
    
    [self.commentTableView registerNib:[UINib nibWithNibName:@"RemarkTableViewCell" bundle:nil] forCellReuseIdentifier:@"RemarkTableViewCell"];
    
    [self.btnService setImagePositionWithType:SSImagePositionTypeTop spacing:5.f];
    [self.btnShop setImagePositionWithType:SSImagePositionTypeTop spacing:5.f];
    [self.btnCollect setImagePositionWithType:SSImagePositionTypeTop spacing:5.f];
    self.labelCount.layer.masksToBounds = YES;
    self.labelCount.layer.cornerRadius = 6.5f;
    self.labelMax.layer.cornerRadius = 6.5f;
    self.labelMax.layer.masksToBounds = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    CGFloat lineX = 83*(ScreenWidth/375);
    self.cutLineOne.frame = CGRectMake(lineX, 0, 1, 49);
    self.cutLineTwo.frame = CGRectMake(lineX*2, 0, 1, 49);
   
    [self fetchGoodsData];
    self.itemTableView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    self.commentTableView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [HYNotification addLoginNotification:self action:@selector(loginAction:)];
    // Do any additional setup after loading the view from its nib.
    
    
    
}

-(void)fetchGoodsData{
    self.propertyStr = @"已选择：";
    //获取商品信息
    __weak typeof (self)weakSelf = self;
    self.goodsModel = [[StoreGoodsModel alloc]init];
    self.xGoodsModel = [[StoreGoodsModel alloc]init];
    GoodsViewModel *viewModel = [[GoodsViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        self.goodsModel = returnValue;
        self.xGoodsModel = returnValue;
        [weakSelf.htmlWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.goodsModel.goods_detail]]];
        [self.headView initBannerView:self.goodsModel.goods_img];
        if ([self.goodsModel.is_collect integerValue] == 1) {
            self.btnCollect.selected = YES;
        }else{
            self.btnCollect.selected = NO;
        }
        self.labelCount.text = [NSString stringWithFormat:@"%ld",(long)[self.goodsModel.shop_num integerValue]];
        if ([self.goodsModel.shop_num integerValue] > 0) {
            self.labelCount.hidden = NO;
        }else{
            self.labelCount.hidden = YES;
        }
        
        self.count = [self.goodsModel.shop_num integerValue];
        if (self.count > 99) {
            self.labelCount.hidden = YES;
            self.labelMax.hidden = NO;
            self.labelMax.text = @"99+";
        }
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:self.goodsModel.property];
        NSMutableArray *muPropertyArr = [[NSMutableArray alloc]init];
        NSMutableArray *muPropertyIdArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < arr.count; i ++) {
            GoodsPropertyModel *goodsPropertyModel  = (GoodsPropertyModel *)arr[i];
            [self.rowArr addObject:@(i)];
            [self.columnArr addObject:@(0)];
            for (int j = 0 ; j < goodsPropertyModel.property.count; j ++) {
                GoodsPropertyModel *subModel = goodsPropertyModel.property[j];
                if ([subModel.checked integerValue] == 1) {
                    NSString *goodsName = subModel.name;
                    NSString *goodsId = subModel.property_id;
                    [muPropertyArr addObject:@[goodsPropertyModel.name,goodsName]];
                    [muPropertyIdArr addObject:goodsId];
                }
                
            }
        }
        for (int i = 0; i < muPropertyArr.count; i ++) {
            NSArray *array = muPropertyArr[i];
            NSString *str =[NSString stringWithFormat:@"%@%@%@%@%@%@",@"\"",array[0],@"\"",@"\"",array[1],@"\""];
            self.propertyStr = [self.propertyStr stringByAppendingString:str];
        }
        [self.carDic setObject:muPropertyIdArr forKey:@"property_id"];
        [self.carDic setObject:@(1) forKey:@"count"];
        GoodsViewModel *propertyViewModel = [[GoodsViewModel alloc] init];
        [propertyViewModel setBlockWithReturnBlock:^(id returnValue) {
            self.goodsPropertyModel = returnValue;
        } WithErrorBlock:^(id errorCode) {
            
        }];
        [propertyViewModel fetchGoodsPropertyDetailWithToken:[weakSelf getToken] propertyId:self.carDic[@"property_id"] goodsId:[NSString stringWithFormat:@"%@",weakSelf.goodsModel.Id]];
        
        self.propertyStr = [self.propertyStr stringByAppendingString:[NSString stringWithFormat:@" %@件",@(1)]];
        
        NSLog(@"=====/n%@/n=====",muPropertyArr);
        //
        [self.itemTableView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchGoodsDetailWithToken:[self getToken] goodsId:self.goodsId];
    
    
    //获取商品评价信息
    self.remarkViewModel = [[GoodsViewModel alloc]init];
    [self.remarkViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        [weakSelf.remarkArr addObjectsFromArray:returnValue];
        [weakSelf.commentTableView.mj_footer endRefreshing];
        if ([returnValue count]<10) {
            [weakSelf.itemTableView.mj_footer removeFromSuperview];
        }
        [weakSelf.commentTableView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    [self setupRefresh];
    
}

//初始化规格
-(void)initProperty:(NSInteger)count{
    self.propertyStr = @"已选择：";
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:self.xGoodsModel.property];
    NSMutableArray *muPropertyArr = [[NSMutableArray alloc]init];
    NSMutableArray *muPropertyIdArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < arr.count; i ++) {
        GoodsPropertyModel *goodsPropertyModel  = (GoodsPropertyModel *)arr[i];
        for (int j = 0 ; j < goodsPropertyModel.property.count; j ++) {
            GoodsPropertyModel *subModel = goodsPropertyModel.property[j];
            if ([subModel.checked integerValue] == 1) {
                NSString *goodsName = subModel.name;
                NSString *goodsId = subModel.property_id;
                [muPropertyArr addObject:@[goodsPropertyModel.name,goodsName]];
                [muPropertyIdArr addObject:goodsId];
            }
            
        }
    }
    for (int i = 0; i < muPropertyArr.count; i ++) {
        NSArray *array = muPropertyArr[i];
        NSString *str =[NSString stringWithFormat:@"%@%@%@%@%@%@",@"\"",array[0],@"\"",@"\"",array[1],@"\""];
        self.propertyStr = [self.propertyStr stringByAppendingString:str];
    }
    [self.carDic setObject:muPropertyIdArr forKey:@"property_id"];
    [self.carDic setObject:@(count) forKey:@"count"];
    
    self.propertyStr = [self.propertyStr stringByAppendingString:[NSString stringWithFormat:@" %@件",@(count)]];
    
    
}

-(void)loginAction:(HYNotification *)noti{
  
}

/**
 *  设置刷新
 */
-(void)setupRefresh
{
//    self.commentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    self.commentTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    [self.commentTableView.mj_footer beginRefreshing];
}
/**
 *  下拉刷新
 */
-(void)headerRefreshing
{
    self.pageIndex = 0;
    [self footerRefreshing];
}
/**
 *  上拉刷新
 */
-(void)footerRefreshing
{
    [self.remarkViewModel fetchGoodsRemarkToken:[self getToken] goodsId:self.goodsId page:@(++ self.pageIndex) size:@(10)];
    
}

//当前页面不在导航控制器中，需重写preferredStatusBarStyle，如下：

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    //     return UIStatusBarStyleLightContent; //白色
    
    return UIStatusBarStyleDefault; //黑色
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
//分享
- (IBAction)shareAction:(id)sender {
    
    NSDictionary *userDic = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    if (!userDic) {
        LoginViewController *vc = [[LoginViewController alloc]init];
        vc.loginType = 1;
        [self presentViewController:vc animated:YES completion:nil];
        return;
    }
    else{
        [self shareWithPageUrl:self.goodsModel.share shareTitle:self.goodsModel.name shareDes:@"" thumImage:self.goodsModel.show_img];
    }
}
//跳转购物车
- (IBAction)shoppingCartAction:(id)sender {
    if (![self isLogin]) {
        [self skiptoLogin];
        return;
    }
    MyShoppingCartViewController *vc = [[MyShoppingCartViewController alloc]init];
    [vc setReturnReloadGoodsBlock:^{
        [self fetchGoodsData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
//直接加入购物车
- (IBAction)addToShoppingCart:(id)sender {
    if (![self isLogin]) {
        [self skiptoLogin];
        return;
    }
//    if (![self.goodsPropertyModel.sku integerValue]) {
//        [self showJGProgressWithMsg:@"库存不足，请重新选择规格"];
//        return;
//    }

    ShoppingCarViewModel *viewModel = [[ShoppingCarViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        self.labelCount.hidden = NO;
        self.count += 1;
        self.labelCount.text = [NSString stringWithFormat:@"%ld",(long)self.count];
        if (self.count > 99) {
            self.labelCount.hidden = YES;
            self.labelMax.hidden = NO;
            self.labelMax.text = @"99+";
        }
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel addToShoppingCarWithToken:[self getToken] Id:[NSString stringWithFormat:@"%@", self.goodsModel.Id] num:self.carDic[@"count"] property:self.carDic[@"property_id"]];
    
}
//从规格选择框加入购物车
-(void)addToShoppingCarWithDic:(NSDictionary *)dic{
    if (![self isLogin]) {
        [self skiptoLogin];
        return;
    }
    
    NSLog(@"%@",dic);
    self.labelCount.hidden = NO;
    self.count += [dic[@"count"] integerValue];
    self.labelCount.text = [NSString stringWithFormat:@"%ld",(long)self.count];
    if (self.count > 99) {
        self.labelCount.hidden = YES;
        self.labelMax.hidden = NO;
        self.labelMax.text = @"99+";
    }
    NSArray *array = dic[@"property_name"];//获取属性的名字
    self.propertyStr = @"已选择：";
    for (int i = 0; i < array.count; i ++) {//遍历数组
       self.propertyStr = [self.propertyStr stringByAppendingString:[NSString stringWithFormat:@" %@",array[i]]];//拼接字符串
    }
    self.propertyStr = [self.propertyStr stringByAppendingString:[NSString stringWithFormat:@" %@件",dic[@"count"]]];
    [self.itemTableView reloadData];
    ShoppingCarViewModel *viewModel = [[ShoppingCarViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {

    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel addToShoppingCarWithToken:[self getToken] Id:[NSString stringWithFormat:@"%@",self.goodsModel.Id] num:dic[@"count"] property:dic[@"property_id"]];
}
//立即购买
-(void)buyNowWithDic:(NSDictionary *)dic{
    if (![self isLogin]) {
        [self skiptoLogin];
        return;
    }
    if (![self.goodsPropertyModel.sku integerValue]) {
        [self showJGProgressWithMsg:@"库存不足，请重新选择规格"];
        return;
    }
    NSArray *goodsArray = @[self.goodsModel,dic];
    OrderFormViewController *vc = [[OrderFormViewController alloc]init];
    [vc setReturnReloadBlock:^{
        [self fetchGoodsData];
    }];
    vc.isCar = 0;
    vc.goodsArray = goodsArray;
    vc.goodsPropertyModel = self.goodsPropertyModel;
    [self.navigationController pushViewController:vc animated:YES];
}
//商品
- (IBAction)goodsAction:(id)sender {
    if (self.btnGoods.selected == NO) {
        self.btnGoods.selected = YES;
        self.btnDetail.selected = NO;
        self.btnRemark.selected = NO;
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             CGRect rect = self.labelGoods.frame;
                             rect.origin.x = self.btnGoods.frame.origin.x + 5;
                             self.labelGoods.frame = rect;
                             self.mainScrollView.contentOffset = CGPointMake(0, 0);
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    
}
//商品详情
- (IBAction)detailAction:(id)sender {
    if (self.btnDetail.selected == NO) {
        self.btnDetail.selected = YES;
        self.btnGoods.selected = NO;
        self.btnRemark.selected = NO;
        [UIView animateWithDuration:0.3
                         animations:^{
                             CGRect rect = self.labelGoods.frame;
                             rect.origin.x = self.btnDetail.frame.origin.x + 5;
                             self.labelGoods.frame = rect;
                             self.mainScrollView.contentOffset = CGPointMake(0, content_height);
                         } completion:^(BOOL finished) {
                             
                         }];
        
    }
    
}
//评价
- (IBAction)remarkAction:(id)sender {
    if (self.btnRemark.selected == NO) {
        self.btnRemark.selected = YES;
        self.btnDetail.selected = NO;
        self.btnGoods.selected = NO;
        [UIView animateWithDuration:0.3
                         animations:^{
                             CGRect rect = self.labelGoods.frame;
                             rect.origin.x = self.btnRemark.frame.origin.x + 5;
                             self.labelGoods.frame = rect;
                             self.mainScrollView.contentOffset = CGPointMake(0, content_height * 2);
                         } completion:^(BOOL finished) {
                             
                         }];
        
    }
    
}
//客服
- (IBAction)lookingForService:(id)sender {
    ServiceViewController *vc = [[ServiceViewController alloc]init];
    StoreModel *model = self.goodsModel.store;
    vc.storeModel = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//进入店铺
- (IBAction)enterShop:(id)sender {
    ShopListDetailViewController *vc = [[ShopListDetailViewController alloc]init];
    StoreModel *model = self.goodsModel.store;
    vc.storeId = model.store_id;
    [self.navigationController pushViewController:vc animated:YES];
}
//收藏
- (IBAction)collectAction:(id)seknder {
    if (![self isLogin]) {
        [self skiptoLogin];
        return;
    }
    if (self.btnCollect.selected == YES) {
        CollectViewModel *viewModel = [[CollectViewModel alloc]init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [self showJGProgressWithMsg:@"取消收藏成功"];
            self.btnCollect.selected = NO;
            [self.btnCollect setTitle:@"我要收藏" forState:UIControlStateNormal];
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel userCollectWithToken:[self getToken] articleId:[NSString stringWithFormat:@"%@",self.goodsModel.Id] collectType:@(2)];
    }else{
        CollectViewModel *viewModel = [[CollectViewModel alloc]init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [self showJGProgressWithMsg:@"添加收藏成功"];
            self.btnCollect.selected = YES;
            [self.btnCollect setTitle:@"取消收藏" forState:UIControlStateSelected];
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel userCollectWithToken:[self getToken] articleId:[NSString stringWithFormat:@"%@",self.goodsModel.Id] collectType:@(2)];
    }
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([tableView isEqual:self.itemTableView]) {
        return 2;
    }
    
    return self.remarkArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.itemTableView]) {
        if (section == 0) {
            return 1;
        }else if (section == 1){
            return 3;
        }
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.itemTableView]) {
        
        if (indexPath.section == 0) {
            GoodsDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailTableViewCell" ];
            [cell initCellWithData:self.xGoodsModel];
            return cell;
        }else if (indexPath.section == 1){
            
            ChooseGoodsDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseGoodsDetailInfoTableViewCell"];
            if (indexPath.row == 0) {
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell initCellWithData:[NSString stringWithFormat:@"%@",self.propertyStr]];
            }
            else{
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (indexPath.row == 1) {
                    [cell initCellWithData:[NSString stringWithFormat:@"运费：￥%.2f",[self.goodsModel.trans_price floatValue]]];
                }
                else{
                    [cell initCellWithData:[NSString stringWithFormat:@"商品编号：%@",self.goodsModel.goods_number]];
                }
            }
            return cell;
        }
    }
    RemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemarkTableViewCell"];
        [cell initCellWithData:self.remarkArr[indexPath.section]];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.itemTableView]) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return 72;
            }
        }else if (indexPath.section == 1){
            return 40;
        }
    }
    
    return [RemarkTableViewCell getCellHeight:self.remarkArr[indexPath.section]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat footHeight = 0.01f;
    if ([tableView isEqual:self.itemTableView]) {
        if (section == 1)
        {
            footHeight = 40.f;
        }
    }
    return footHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:self.itemTableView]) {
        if (section == 0) {
            return 0.01f;
        }
        else if (section == 1)
        {
            return 20.f;
        }
        return 10.f;
    }
    return 10.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self)weakSelf = self;
    if ([tableView isEqual:self.itemTableView]) {
        if (indexPath.section == 1 && indexPath.row == 0) {
            //选择规格
            self.shoppingCarView = [[[NSBundle mainBundle] loadNibNamed:@"ChooseGoodsCategoryView" owner:self options:nil] firstObject];
            UIView *bgview = [[UIView alloc]init];
            bgview.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            bgview.backgroundColor = [UIColor clearColor];
            self.shoppingCarView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);

            [self.shoppingCarView initCellWithData:self.goodsPropertyModel count:[self.carDic[@"count"] integerValue]];
            
            [self.shoppingCarView setCancelBlock:^(NSInteger count){
                bgview.hidden = YES;
                [weakSelf initProperty:count];
                [weakSelf.itemTableView reloadData];

            }];
            [self.shoppingCarView setConfirmAddBlock:^(NSDictionary *dic) {
                if ([dic[@"sku"] integerValue] < [dic[@"count"] integerValue]) {
                    [weakSelf showJGProgressWithMsg:@"库存不足"];
                }
                else{
                    bgview.hidden = YES;
                    [weakSelf addToShoppingCarWithDic:dic];
                }
                
            }];
            [self.shoppingCarView setConfirmBuyBlock:^(NSDictionary *dic) {
                NSLog(@"%@%@",dic[@"count"],dic[@"property_id"]);
                
                if ([dic[@"sku"] integerValue] < [dic[@"count"] integerValue]) {
                    [weakSelf showJGProgressWithMsg:@"库存不足"];
                }
                else{
                    bgview.hidden = YES;
                    [weakSelf buyNowWithDic:dic];
                }
            }];
            
            [self.shoppingCarView setChooseBlock:^(NSArray *rowArr,NSArray *columnArr){
                [weakSelf.rowArr removeAllObjects];
                [weakSelf.columnArr removeAllObjects];
                [weakSelf.rowArr addObjectsFromArray:rowArr];
                [weakSelf.columnArr addObjectsFromArray:columnArr];
            }];
            [self.shoppingCarView setFetchInfoBlock:^(NSArray *idArr,NSInteger count) {
                GoodsViewModel *viewModel = [[GoodsViewModel alloc] init];
                [viewModel setBlockWithReturnBlock:^(id returnValue) {
                    weakSelf.goodsPropertyModel = returnValue;
                    [weakSelf.shoppingCarView initCellWithData:returnValue count:[weakSelf.carDic[@"count"] integerValue]];
                    weakSelf.xGoodsModel = returnValue;
                    [weakSelf initProperty:count];
                    [weakSelf.itemTableView reloadData];
                } WithErrorBlock:^(id errorCode) {
                    
                }];
                [viewModel fetchGoodsPropertyDetailWithToken:[weakSelf getToken] propertyId:idArr goodsId:[NSString stringWithFormat:@"%@",weakSelf.goodsModel.Id]];
            }];
//            [self.shoppingCarView setSelectRowIndex:self.rowArr column:self.columnArr];
            [bgview addSubview:self.shoppingCarView];
            [self.view addSubview:bgview];
            
        }
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:self.itemTableView]) {
        UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenHeight, 20)];
        headview.backgroundColor = [UIColor clearColor];
        return headview;
    }
    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenHeight, 10)];
    headview.backgroundColor = [UIColor clearColor];
    return headview;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]init];
    if ([tableView isEqual:self.itemTableView]) {
        if (section == 1) {
            ChooseGoodsDetailFootView *footView = [[[NSBundle mainBundle] loadNibNamed:@"ChooseGoodsDetailFootView" owner:self options:nil] firstObject];
            
            footView.frame = CGRectMake(0, 0, ScreenWidth, 40);
            
            return footView;
        }
        return footView;
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.mainScrollView]) {
        
        NSInteger index = fabs(scrollView.contentOffset.y) / scrollView.frame.size.height;
        if (index == 0) {
            self.btnGoods.selected = YES;
            self.btnDetail.selected = NO;
            self.btnRemark.selected = NO;
            
            [UIView animateWithDuration:0.3
                             animations:^{
                                 CGRect rect = self.labelGoods.frame;
                                 rect.origin.x = self.btnGoods.frame.origin.x + 5;
                                 self.labelGoods.frame = rect;
                             } completion:^(BOOL finished) {
                                 
                             }];
        }
        else if (index == 1){
            self.btnGoods.selected = NO;
            self.btnDetail.selected = YES;
            self.btnRemark.selected = NO;
            
            [UIView animateWithDuration:0.3
                             animations:^{
                                 CGRect rect = self.labelGoods.frame;
                                 rect.origin.x = self.btnDetail.frame.origin.x + 5;
                                 self.labelGoods.frame = rect;
                             } completion:^(BOOL finished) {
                                 
                             }];
            
        }
        else{
            self.btnGoods.selected = NO;
            self.btnDetail.selected = NO;
            self.btnRemark.selected = YES;
            
            [UIView animateWithDuration:0.3
                             animations:^{
                                 CGRect rect = self.labelGoods.frame;
                                 rect.origin.x = self.btnRemark.frame.origin.x + 5;
                                 self.labelGoods.frame = rect;
                             } completion:^(BOOL finished) {
                                 
                             }];
        }
    }
    
}

@end
