//
//  SaleRecordViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "SaleRecordViewController.h"
#import "SaleRecordTableViewCell.h"
#import "WalletViewModel.h"
@interface SaleRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIImageView *noDataImageView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic ,retain) WalletViewModel *viewModel;
@property (nonatomic, retain) NSMutableArray *itemArr;
@end

@implementation SaleRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemArr = [[NSMutableArray alloc]init];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"SaleRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"SaleRecordTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
    __weak typeof (self)weakSelf = self;
    self.viewModel = [[WalletViewModel alloc] init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        [weakSelf.itemArr addObjectsFromArray:returnValue];
        [weakSelf.itemTableView reloadData];
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
            weakSelf.noDataView.hidden = NO;
            weakSelf.itemTableView.hidden = YES;
        }else{
            weakSelf.noDataView.hidden = YES;
            weakSelf.itemTableView.hidden = NO;
        }
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
        [weakSelf.itemTableView.mj_header endRefreshing];
        if (self.itemArr.count == 0) {
            weakSelf.noDataView.hidden = NO;
            weakSelf.itemTableView.hidden = YES;
        }
        else{
            weakSelf.noDataView.hidden = YES;
            weakSelf.itemTableView.hidden = NO;
        }
    }];
    
    [self setupRefresh];
    
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
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
    
    [self.viewModel fetchSaleRecordWithToken:[self getToken] page:@(++ self.pageIndex) size:@(10)];
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SaleRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SaleRecordTableViewCell"];
    [cell initCellWithData:self.itemArr[indexPath.row]];
    return cell;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
