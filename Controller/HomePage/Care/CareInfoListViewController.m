//
//  CareInfoListViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/28.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "CareInfoListViewController.h"
#import "InfoListTableViewCell.h"
#import "InfoDetailViewController.h"
#import "CareViewModel.h"
@interface CareInfoListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;

@property (nonatomic, retain) NSMutableArray *articleArray;
@property (nonatomic, retain) CareViewModel *viewModel;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation CareInfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.articleArray = [[NSMutableArray alloc]init];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"InfoListTableViewCell" bundle:nil] forCellReuseIdentifier:@"InfoListTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.viewModel = [[CareViewModel alloc]init];
    __weak typeof(self)weakSelf = self;
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        [weakSelf.itemTableView reloadData];
        [weakSelf.articleArray addObjectsFromArray:returnValue];
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
        if (self.articleArray.count == 0) {
            weakSelf.noDataView.hidden = NO;
            weakSelf.itemTableView.hidden = YES;
        }else{
            weakSelf.noDataView.hidden = YES;
            weakSelf.itemTableView.hidden = NO;
        }
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
        [weakSelf.itemTableView.mj_header endRefreshing];
        if (self.articleArray.count == 0) {
            weakSelf.noDataView.hidden = NO;
            weakSelf.itemTableView.hidden = YES;
        }
        else{
            weakSelf.noDataView.hidden = YES;
            weakSelf.itemTableView.hidden = NO;
        }
    }];
    [self setupRefresh];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    self.returnReloadBlock();
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
    [self.articleArray removeAllObjects];
    [self.itemTableView reloadData];
    [self footerRefreshing];
}
/**
 *  上拉刷新
 */
-(void)footerRefreshing
{
    
    [self.viewModel fetchCareListWithToken:[self getToken] page:@(++ self.pageIndex) size:@(10)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.articleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoListTableViewCell"];
    [cell initCell:self.articleArray[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88.f;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InfoDetailViewController *vc = [[InfoDetailViewController alloc]init];
    ArticleModel *model = self.articleArray[indexPath.row];
    vc.articleModel = model;
    vc.bannerUrl = model.detail_url;
    vc.articleId = model.Id;
    vc.isCollect = [model.is_collect integerValue];
    if ([model.type integerValue] == 1) {
        vc.type = @(4);
    }else{
        vc.type = @(5);
    }
    vc.articleModel = model;
    [vc setReturnReloadBlock:^{
        [self headerRefreshing];
    }];
    [self.navigationController pushViewController: vc animated:YES];
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
