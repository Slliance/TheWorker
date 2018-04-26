//
//  InfomationListViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/10.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BusinessInfoListViewController.h"
#import "InfoListTableViewCell.h"
#import "InfoDetailViewController.h"
#import "WorkerBusinessViewModel.h"
@interface BusinessInfoListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (nonatomic, retain) NSMutableArray *articleArr;
@property (nonatomic, assign) NSInteger     pageIndex;
@property (nonatomic, retain) WorkerBusinessViewModel      *viewModel;

@end

@implementation BusinessInfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.articleArr = [[NSMutableArray alloc]init];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"InfoListTableViewCell" bundle:nil] forCellReuseIdentifier:@"InfoListTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
    __weak typeof (self)weakSelf = self;
    
    self.viewModel = [[WorkerBusinessViewModel alloc] init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        if (self.pageIndex == 1) {
            [weakSelf.articleArr removeAllObjects];
            [weakSelf.itemTableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
        [weakSelf.articleArr addObjectsFromArray:returnValue];
        
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
    [self.viewModel fetchBusinessInfoListWithToken:[self getToken] page:@(++ self.pageIndex)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.articleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoListTableViewCell"];
    [cell initCell:self.articleArr[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88.f;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InfoDetailViewController *vc = [[InfoDetailViewController alloc]init];
    ArticleModel *model = self.articleArr[indexPath.row];
    vc.articleModel = model;
    vc.bannerUrl = model.detail_url;
    vc.articleId = model.Id;
    vc.isCollect = [model.is_collect integerValue];
    vc.type = @(7);
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
