//
//  ShopListViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/17.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ShopListViewController.h"
#import "ShopListTableViewCell.h"
#import "ShopListDetailViewController.h"
#import "GoodsViewModel.h"
#import "StoreModel.h"
@interface ShopListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;

@property (nonatomic, retain) NSMutableArray *storeArray;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, retain) GoodsViewModel *viewModel;
@end

@implementation ShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.storeArray = [[NSMutableArray alloc]init];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"ShopListTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopListTableViewCell"];
    // Do any additional setup after loading the view from its nib.
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSMutableArray*tempMarr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    NSLog(@"%@",tempMarr);
    __weak typeof(self)weakSelf = self;
    self.viewModel = [[GoodsViewModel alloc]init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        if (self.pageIndex == 1) {
            [weakSelf.storeArray removeAllObjects];
            [weakSelf.itemTableView.mj_header endRefreshing];
        }else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }

        [weakSelf.storeArray addObjectsFromArray:returnValue];
        [weakSelf.itemTableView reloadData];
    } WithErrorBlock:^(id errorCode) {
        if (self.pageIndex == 1) {
            [weakSelf.itemTableView.mj_header endRefreshing];
        }else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    
    [self setupRefresh];
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
    [self footerRefreshing];
}
/**
 *  上拉刷新
 */
-(void)footerRefreshing
{
    [self.viewModel fetchStoreListWithToken:[self getToken] page:@(++ self.pageIndex) size:@(10)];
}

- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.storeArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopListTableViewCell"];
    [cell initCellWithData:self.storeArray[indexPath.section]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShopListDetailViewController *vc = [[ShopListDetailViewController alloc]init];
    StoreModel *model = self.storeArray[indexPath.section];
    vc.storeId = model.Id;
    [self.navigationController pushViewController:vc animated:YES];
    
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
