//
//  BusinessViewController.m
//  TheWorker
//
//  Created by yanghao on 8/18/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "BusinessViewController.h"
#import "BusinessHeadView.h"
#import "InfoListTableViewCell.h"
#import "BusinessBrandTableViewCell.h"
#import "InfoDetailViewController.h"
#import "BrandListViewController.h"
#import "BusinessInfoListViewController.h"
#import "WorkerBusinessViewModel.h"
#import "BannerWebViewController.h"
#import "PartnerModel.h"
@interface BusinessViewController ()
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (nonatomic, retain) BusinessHeadView *headView;
@property (nonatomic, retain) NSMutableArray *bannerArr;
@property (nonatomic, retain) NSMutableArray *articleArr;
@property (nonatomic, retain) NSMutableArray *parterArr;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) WorkerBusinessViewModel *viewModel;
@end

@implementation BusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bannerArr = [[NSMutableArray alloc]init];
    self.articleArr = [[NSMutableArray alloc]init];
    self.parterArr = [[NSMutableArray alloc]init];
    
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"BusinessHeadView" owner:self options:nil] firstObject];
    
    self.itemTableView.tableHeaderView = self.headView;
    
    __weak typeof(self)weakSelf = self;
    [self.headView setReturnTagBlock:^(NSInteger blockTag) {
        switch (blockTag) {
                case 0:{
                    
                    break;
                }
                case 1:{
                    
                    break;
                }
                case 2:{
                    
                    break;
                }
            default:
                break;
        }
    }];
    
    [self.itemTableView setTableHeaderView:self.headView];
    
    [self.itemTableView registerNib:[UINib nibWithNibName:@"InfoListTableViewCell" bundle:nil] forCellReuseIdentifier:@"InfoListTableViewCell"];
    
    
    [self.itemTableView registerClass:NSClassFromString(@"BusinessBrandTableViewCell")forCellReuseIdentifier:@"BusinessBrandTableViewCell"];
    self.viewModel = [[WorkerBusinessViewModel alloc] init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        weakSelf.itemTableView.hidden = NO;
        [weakSelf.bannerArr removeAllObjects];
        [weakSelf.articleArr removeAllObjects];
        [weakSelf.parterArr removeAllObjects];
        [weakSelf.bannerArr addObjectsFromArray:returnValue[0]];
        [weakSelf.articleArr addObjectsFromArray:returnValue[1]];
        [weakSelf.parterArr addObjectsFromArray:returnValue[2]];
        [weakSelf.itemTableView reloadData];
        [weakSelf.headView initBannerViewWith:weakSelf.bannerArr];
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
    [self.viewModel getWorkerBusinessDataWithToken:[self getToken]];
}



- (IBAction)backAction:(id)sender {
    
    [self backBtnAction:sender];
}
-(void)viewDidDisappear:(BOOL)animated{
    [HYNotification postDestoryNotification:nil];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.articleArr.count<=3) {
            return self.articleArr.count;
        }
        else
            return 3;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        InfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoListTableViewCell"];
        if (self.articleArr.count > 0) {
            [cell initCell:self.articleArr[indexPath.row]];
        }
        return cell;
    }
    BusinessBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessBrandTableViewCell"];
    [cell initCellWithData:self.parterArr];
    [cell setReturnSkipTagBlock:^(NSInteger index) {
        PartnerModel *model = self.parterArr[index];
        if (model.web_url.length > 5) {
            BannerWebViewController *vc = [[BannerWebViewController alloc] init];
            vc.bannerUrl = model.web_url;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 88.f;
    }
    return [BusinessBrandTableViewCell getCellHeightWithData:self.parterArr];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 34.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        InfoDetailViewController *vc = [[InfoDetailViewController alloc]init];
        ArticleModel *model = self.articleArr[indexPath.row];
        vc.articleModel = model;
        vc.bannerUrl = model.detail_url;
        vc.articleId = model.Id;
        vc.isCollect = [model.is_collect integerValue];
        vc.type = @(7);
        vc.articleModel = model;
        [vc setReturnReloadBlock:^{
            [self footerRefreshing];
        }];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: vc animated:YES];
    }else{
        

    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, ScreenWidth, 34);
    view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc]init];
    btn.tag = section;
    btn.frame = CGRectMake(ScreenWidth-60, 0, 50, 34);
    [btn setTitle:@"更多" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_more-"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:11];
    [btn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -65)];
    [btn addTarget:self action:@selector(skipToMore:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *headImageView = [[UIImageView alloc]init];
    headImageView.frame = CGRectMake(10, 9,15, 15);
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(35, 0, 60, 34);
    
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"666666"];
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.frame = CGRectMake(0, 33, ScreenWidth, 1);
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"e9e9e9"];
    [view addSubview:lineLabel];
    [view addSubview:btn];
    [view addSubview:headImageView];
    [view addSubview:label];
    if (section == 0) {
        label.text = @"创业资讯";
        headImageView.image = [UIImage imageNamed:@"icon_employee_information"];
    }
    else{
        label.text = @"合作伙伴";
        headImageView.image = [UIImage imageNamed:@"icon_cooperative_partner"];
    }
    return view;
}

-(void)skipToMore:(UIButton *)sender{
    if (sender.tag == 1) {
        BrandListViewController *vc = [[BrandListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        BusinessInfoListViewController *vc = [[BusinessInfoListViewController alloc]init];
        [vc setReturnReloadBlock:^{
            [self footerRefreshing];
        }];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
}

@end
