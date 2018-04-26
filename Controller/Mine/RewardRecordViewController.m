//
//  RewardRecordViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/5.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RewardRecordViewController.h"
#import "RewardRecordTableViewCell.h"
#import "WalletViewModel.h"
@interface RewardRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic ,retain) WalletViewModel *viewModel;
@property (nonatomic, retain) NSMutableArray *itemArr;
@end

@implementation RewardRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"RewardRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"RewardRecordTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak typeof (self)weakSelf = self;
    self.viewModel = [[WalletViewModel alloc] init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        
        if (self.pageIndex == 1) {
            [weakSelf.itemArr removeAllObjects];
            [weakSelf.itemTableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
        if ([returnValue count]<10) {
            [weakSelf.itemTableView.mj_footer removeFromSuperview];
        }
        [weakSelf.itemArr addObjectsFromArray:returnValue];
        [weakSelf.itemTableView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
        [weakSelf.itemTableView.mj_header endRefreshing];
        
    }];
    
    [self setupRefresh];
    
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
    
    [self.viewModel fetchMyRewardRecordWithToken:[self getToken] page:@(++ self.pageIndex)];
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RewardRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RewardRecordTableViewCell"];
    [cell initCellWithData:self.itemArr[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
