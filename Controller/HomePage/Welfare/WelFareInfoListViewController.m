//
//  WelFareInfoListViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/15.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "WelFareInfoListViewController.h"
#import "InfoListTableViewCell.h"
#import "InfoDetailViewController.h"
#import "WorkerWelfareViewModel.h"
#import "ArticleModel.h"
@interface WelFareInfoListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (nonatomic, retain) NSMutableArray *articleArray;
@property (nonatomic, retain) WorkerWelfareViewModel *viewModel;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation WelFareInfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.articleArray = [[NSMutableArray alloc] init];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"InfoListTableViewCell" bundle:nil] forCellReuseIdentifier:@"InfoListTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // Do any additional setup after loading the view from its nib.
    WorkerWelfareViewModel *viewModel = [[WorkerWelfareViewModel alloc]init];
    

    __weak typeof (self)weakSelf = self;
    
    self.viewModel = [[WorkerWelfareViewModel alloc] init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        if (self.pageIndex == 1) {
            [weakSelf.articleArray removeAllObjects];
            [weakSelf.itemTableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
        [weakSelf.articleArray addObjectsFromArray:returnValue];
        
        [weakSelf.itemTableView reloadData];
        if ([(NSArray *)returnValue count] < 10) {
            [weakSelf.itemTableView.mj_footer removeFromSuperview];
        }
        else{
            weakSelf.itemTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(footerRefreshing)];
        }
        
    } WithErrorBlock:^(id errorCode) {
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
    [self.viewModel getArticleListWithToken:[self getToken] page:@(++ self.pageIndex)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    self.returnReloadBlock();
    [self backBtnAction:sender];
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
    vc.type = @(8);
    vc.articleModel = model;
    [vc setReturnReloadBlock:^{
//        [self headerRefreshing];
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
