//
//  WantedJobViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/29.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "WantedJobViewController.h"
#import "JobHeaderView.h"
#import "WantedJobTableViewCell.h"
#import "JobWantedInfoViewController.h"
#import "WantedJobDetailViewController.h"
#import "MoreJobViewController.h"
#import "JobViewModel.h"
@interface WantedJobViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (nonatomic, retain) JobHeaderView *headView;
@property (nonatomic, retain) NSMutableArray        *bannerArr;
@property (nonatomic, retain) NSMutableArray        *articleArr;
@property (nonatomic, retain) JobViewModel *viewModel;
@end

@implementation WantedJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bannerArr = [[NSMutableArray alloc]init];
    self.articleArr = [[NSMutableArray alloc]init];
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"JobHeaderView" owner:self options:nil] firstObject];
    __weak typeof(self)weakSelf = self;
    [self.headView setReturnTagBlock:^(NSInteger jobType) {
        NSLog(@"%ld",(long)jobType);
        JobWantedInfoViewController *vc = [[JobWantedInfoViewController alloc]init];
        vc.jobType = jobType;
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    self.itemTableView.tableHeaderView = self.headView;
    [self.itemTableView registerNib:[UINib nibWithNibName:@"WantedJobTableViewCell" bundle:nil] forCellReuseIdentifier:@"WantedJobTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
    self.viewModel = [[JobViewModel alloc]init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        weakSelf.itemTableView.hidden = NO;
        [weakSelf.itemTableView.mj_header endRefreshing];
        [weakSelf.bannerArr removeAllObjects];
        [weakSelf.articleArr removeAllObjects];
        [weakSelf.bannerArr addObjectsFromArray:returnValue[0]];
        [weakSelf.articleArr addObjectsFromArray:returnValue[1]];
        [weakSelf.itemTableView reloadData];
        [weakSelf.headView initViewWithData:weakSelf.bannerArr];
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
    [self.viewModel fetchJobMainPageInfomationWithToken:[self getToken]];
}

- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
    [HYNotification postDestoryNotification:nil];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.articleArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WantedJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WantedJobTableViewCell"];
    [cell initCellWithData:self.articleArr[indexPath.row]];
    return cell;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 76.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 34.f;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        WantedJobDetailViewController *vc = [[WantedJobDetailViewController alloc]init];
        JobModel *model = self.articleArr[indexPath.row];
        vc.jobModel = model;
        [vc setReturnReloadBlock:^(JobModel *model) {
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
        headImageView.image = [UIImage imageNamed:@"icon_latest_job_offer"];
        headImageView.frame = CGRectMake(10, 9,15, 15);
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(35, 0, 100, 34);
        label.text = @"最新招聘信息";
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
    MoreJobViewController *vc = [[MoreJobViewController alloc]init];
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
