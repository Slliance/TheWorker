//
//  MyIntegralViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/24.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyIntegralViewController.h"
#import "MyIntegralTableViewCell.h"
#import "WelfareViewController.h"
#import "WalletViewModel.h"
#import "WalletModel.h"
@interface MyIntegralViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *labelScore;
@property (weak, nonatomic) IBOutlet UIButton *btnConvert;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, retain) NSMutableArray *itemArr;
@property (nonatomic ,retain) WalletViewModel *integralModel;
@property (nonatomic, retain) WalletViewModel *viewModel;
@end

@implementation MyIntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemArr = [[NSMutableArray alloc]init];
    [self.btnConvert.layer setBorderColor:[UIColor colorWithHexString:@"ffffff"].CGColor];
    [self.btnConvert.layer setBorderWidth:1];
    [self.btnConvert.layer setMasksToBounds:YES];
    [self.btnConvert.layer setCornerRadius:4.f];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"MyIntegralTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyIntegralTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
    __weak typeof(self)weakSelf = self;
    self.viewModel = [[WalletViewModel alloc]init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        WalletModel *model = returnValue;
        weakSelf.labelScore.text = [NSString stringWithFormat:@"%@",model.score];
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    [self.viewModel fetchWalletInfomationWithToken:[self getToken]];
    
    self.integralModel = [[WalletViewModel alloc]init];
    
    [self.integralModel setBlockWithReturnBlock:^(id returnValue) {
        
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
//        if (self.itemArr.count == 0) {
//            weakSelf.noDataView.hidden = NO;
//            weakSelf.itemTableView.hidden = YES;
//        }else{
//            weakSelf.noDataView.hidden = YES;
//            weakSelf.itemTableView.hidden = NO;
//        }

        [weakSelf.itemArr addObjectsFromArray:returnValue];
        [weakSelf.itemTableView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
        [weakSelf.itemTableView.mj_header endRefreshing];
//        if (self.itemArr.count == 0) {
//            weakSelf.noDataView.hidden = NO;
//            weakSelf.itemTableView.hidden = YES;
//        }
//        else{
//            weakSelf.noDataView.hidden = YES;
//            weakSelf.itemTableView.hidden = NO;
//        }

    }];
    [self setupRefresh];
    
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)convertAction:(id)sender {
    WelfareViewController *vc = [[WelfareViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
    [self.viewModel fetchWalletInfomationWithToken:[self getToken]];
    [self.integralModel fetchIntegralWithToken:[self getToken] page:@(++ self.pageIndex) size:@(10)];
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyIntegralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIntegralTableViewCell"];
    [cell initCellWithData:self.itemArr[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 33.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, 33);
    headerView.backgroundColor = [UIColor whiteColor];
    UIImageView *headImageView = [[UIImageView alloc]init];
    headImageView.image = [UIImage imageNamed:@"icon_integral_record"];
    headImageView.frame = CGRectMake(10, 8,12, 15);
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(35, 0, 60, 34);
    label.text = @"积分记录";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"666666"];
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.frame = CGRectMake(0, 33, ScreenWidth, 1);
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"e9e9e9"];
    [headerView addSubview:lineLabel];
    [headerView addSubview:headImageView];
    [headerView addSubview:label];


    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    WithdrawDetailViewController *vc = [[WithdrawDetailViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
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
