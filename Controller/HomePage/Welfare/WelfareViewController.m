//
//  WelfareViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/14.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "WelfareViewController.h"
#import "WelfareHeadView.h"
#import "InfoListTableViewCell.h"
#import "InfoDetailViewController.h"
#import "PoorEmployeeViewController.h"
#import "WelFareInfoListViewController.h"
#import "ActiveEmoloyeeViewController.h"
#import "WorkerWelfareViewModel.h"
#import "MSWeakTimer.h"

@interface WelfareViewController ()
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (nonatomic, retain) WelfareHeadView *headView;
@property (nonatomic, retain) NSMutableArray        *bannerArr;
@property (nonatomic, retain) NSMutableArray        *articleArr;
@property (nonatomic, retain) WorkerWelfareViewModel *viewModel;
@property (nonatomic, retain) MSWeakTimer *bannerTimer;
@end

@implementation WelfareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bannerArr = [[NSMutableArray alloc] init];
    self.articleArr = [[NSMutableArray alloc] init];
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"WelfareHeadView" owner:self options:nil] firstObject];

    self.itemTableView.tableHeaderView = self.headView;
    __weak typeof(self)weakSelf = self;
    
    [self.headView setReturnTagBlock:^(NSInteger blockTag) {
        switch (blockTag) {
            case 0:{
                PoorEmployeeViewController *vc = [[PoorEmployeeViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            
                break;
            }
            case 1:{
                ActiveEmoloyeeViewController *vc = [[ActiveEmoloyeeViewController alloc]init];
                
                vc.hidesBottomBarWhenPushed = YES;
                vc.employeetype = 2;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2:{
                ActiveEmoloyeeViewController *vc = [[ActiveEmoloyeeViewController alloc]init];
                
                vc.hidesBottomBarWhenPushed = YES;
                vc.employeetype = 3;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                break;
            }
            default:
                break;
        }
    }];
    
    
    [self.itemTableView registerNib:[UINib nibWithNibName:@"InfoListTableViewCell" bundle:nil] forCellReuseIdentifier:@"InfoListTableViewCell"];
    self.viewModel = [[WorkerWelfareViewModel alloc]init];
    
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        weakSelf.itemTableView.hidden = NO;
        [weakSelf.bannerArr removeAllObjects];
        [weakSelf.articleArr removeAllObjects];
        [weakSelf.bannerArr addObjectsFromArray:returnValue[0]];
        [weakSelf.articleArr addObjectsFromArray:returnValue[1]];
        [weakSelf.itemTableView reloadData];
        if (weakSelf.bannerArr.count != 0) {
            [weakSelf.itemTableView setTableHeaderView:weakSelf.headView];
            [weakSelf.headView initBannerViewWith:weakSelf.bannerArr];
        }
        [weakSelf.itemTableView.mj_header endRefreshing];
    } WithErrorBlock:^(id errorCode) {
        [weakSelf.itemTableView.mj_header endRefreshing];
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
    //    self.pageIndex = 0;
    [self footerRefreshing];
}
/**
 *  上拉刷新
 */
-(void)footerRefreshing
{
    [self.viewModel getWorkerWelfareInfomationWith:[self getToken]];
}
-(void)viewDidAppear:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"openTimer" object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"我走了");
    [HYNotification postDestoryNotification:nil];
}

- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
    
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
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 34.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        InfoDetailViewController *vc = [[InfoDetailViewController alloc]init];
    ArticleModel *model = self.articleArr[indexPath.row];
    vc.articleModel = model;
    vc.bannerUrl = model.detail_url;
    vc.articleId = model.Id;
    vc.isCollect = [model.is_collect integerValue];
    vc.type = @(8);
    vc.articleModel = model;
    [vc setReturnReloadBlock:^{
        [self footerRefreshing];
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: vc animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(0, 0, ScreenWidth, 34);
        view.backgroundColor = [UIColor whiteColor];
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(ScreenWidth-60, 0, 50, 34);
        [btn setTitle:@"更多" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_more-"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        [btn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -65)];
        [btn addTarget:self action:@selector(skipToEmplloyeeInfo) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *headImageView = [[UIImageView alloc]init];
        headImageView.image = [UIImage imageNamed:@"icon_employee_information"];
        headImageView.frame = CGRectMake(10, 9,15, 15);
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(35, 0, 60, 34);
        label.text = @"福利信息";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithHexString:@"666666"];
        UILabel *lineLabel = [[UILabel alloc]init];
        lineLabel.frame = CGRectMake(0, 33, ScreenWidth, 1);
        lineLabel.backgroundColor = [UIColor colorWithHexString:@"e9e9e9"];
        [view addSubview:lineLabel];
        [view addSubview:btn];
        [view addSubview:headImageView];
        [view addSubview:label];
        return view;
}

-(void)skipToEmplloyeeInfo{
    WelFareInfoListViewController *vc = [[WelFareInfoListViewController alloc]init];
    [vc setReturnReloadBlock:^{
        [self footerRefreshing];
    }];
    vc.hidesBottomBarWhenPushed = YES;
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
