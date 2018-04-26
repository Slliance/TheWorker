//
//  MyCouponsViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyCouponsViewController.h"
#import "MyCouponTableViewCell.h"
#import "MyCouponGetTableViewCell.h"
#import "MyCouponUsedTableViewCell.h"
#import "MyCouponViewModel.h"
#import "InputBoxView.h"

@interface MyCouponsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *btnNot;
@property (weak, nonatomic) IBOutlet UIButton *btnYet;
@property (weak, nonatomic) IBOutlet UIButton *btnUsed;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (nonatomic,assign) NSInteger selectType;

@property (nonatomic, retain) MyCouponViewModel     *viewModel;
@property (nonatomic, assign) NSInteger     pageIndex;
@property (nonatomic, retain) NSMutableArray *itemArr;

@end

@implementation MyCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemArr = [[NSMutableArray alloc] init];
    self.selectType = 0;
    //    [self chooseNot:nil];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"MyCouponTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCouponTableViewCell"];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"MyCouponGetTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCouponGetTableViewCell"];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"MyCouponUsedTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCouponUsedTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof (self)weakSelf = self;
    self.viewModel = [[MyCouponViewModel alloc] init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
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
    
    
    
    [self setupRefresh];
    
    // Do any additional setup after loading the view from its nib.
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
    [self.viewModel fetchMyCouponList:self.selectType + 1 page:++ self.pageIndex token:[self getToken]];
}


- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)chooseNot:(id)sender {
    self.btnNot.selected = YES;
    self.btnYet.selected = NO;
    self.btnUsed.selected = NO;
    self.lineLabel.center = self.btnNot.center;
    CGRect rect = self.lineLabel.frame;
    rect.origin.y = 43;
    self.lineLabel.frame = rect;
    self.selectType = 0;
    [self.itemTableView.mj_header beginRefreshing];
}
- (IBAction)chooseYet:(id)sender {
    self.btnYet.selected = YES;
    self.btnNot.selected = NO;
    self.btnUsed.selected = NO;
    self.lineLabel.center = self.btnYet.center;
    CGRect rect = self.lineLabel.frame;
    rect.origin.y = 43;
    self.lineLabel.frame = rect;
    self.selectType = 1;
    [self.itemTableView.mj_header beginRefreshing];
}
- (IBAction)chooseUsed:(id)sender {
    self.btnUsed.selected = YES;
    self.btnYet.selected = NO;
    self.btnNot.selected = NO;
    self.lineLabel.center = self.btnUsed.center;
    CGRect rect = self.lineLabel.frame;
    rect.origin.y = 43;
    self.lineLabel.frame = rect;
    self.selectType = 2;
    [self.itemTableView.mj_header beginRefreshing];
    
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.itemArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectType == 0) {
        MyCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCouponTableViewCell"];
//        __weak typeof (self)weakSelf = self;
        [cell setGetBlock:^{

        }];
        [cell initCellWithDataType:self.itemArr[indexPath.section]];
        return cell;
    }else if(self.selectType == 1){
        MyCouponGetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCouponGetTableViewCell"];
        [cell initCellWithDataType:self.itemArr[indexPath.section]];
        return cell;
    }
    MyCouponUsedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCouponUsedTableViewCell"];
    [cell initCellWithDataType:self.itemArr[indexPath.section]];
    return cell;
}
#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectType == 0) {
        MyCouponViewModel *viewModel = [[MyCouponViewModel alloc] init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [self chooseYet:nil];

        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];

        CouponModel *gmodel = self.itemArr[indexPath.section];
        [viewModel getCoupon:gmodel.Id token:[self getToken]];

    }else if (self.selectType == 1) {
        //弹出输入商家编号弹窗
        
        InputBoxView *boxView = [[[NSBundle mainBundle] loadNibNamed:@"InputBoxView" owner:self options:nil] firstObject];
        [boxView initView];
        __weak typeof (self)weakSelf = self;
        [boxView setDoneBlock:^(NSString *content){
            if (content.length == 0) {
                [weakSelf showJGProgressWithMsg:@"请输入商家编号"];
            }
            else{
                
                MyCouponViewModel *viewModel = [[MyCouponViewModel alloc] init];
                [viewModel setBlockWithReturnBlock:^(id returnValue) {
                    [weakSelf chooseUsed:nil];
                    
                } WithErrorBlock:^(id errorCode) {
                    [weakSelf showJGProgressWithMsg:errorCode];
                }];
                
                CouponModel *gmodel = weakSelf.itemArr[indexPath.section];
                [viewModel useCoupon:gmodel.Id token:[weakSelf getToken] shopNO:content];
            }
            
        }];
        [[[UIApplication sharedApplication] windows].firstObject addSubview:boxView];
        
    }
}
@end
