//
//  MyFansViewController.m
//  TheWorker
//
//  Created by yanghao on 9/2/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "MyFansViewController.h"
#import "RentPersonFansTableViewCell.h"
#import "RentPersonViewModel.h"
#import "RentPersonInfoViewController.h"
#import "FansModel.h"
#import "UserModel.h"
#import "FriendInfomationViewController.h"
@interface MyFansViewController ()
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (nonatomic, retain) NSMutableArray *itemArr;
@property (nonatomic, retain) RentPersonViewModel *viewModel;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation MyFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemArr = [[NSMutableArray alloc] init];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"RentPersonFansTableViewCell" bundle:nil] forCellReuseIdentifier:@"RentPersonFansTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.viewModel = [[RentPersonViewModel alloc] init];
    
    __weak typeof(self)weakSelf = self;
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        
        if (self.pageIndex == 1) {
            [weakSelf.itemArr removeAllObjects];
            [weakSelf.itemTableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
        FansModel *model = returnValue;
        [weakSelf.itemArr addObjectsFromArray:model.follow_list];
        [weakSelf.itemTableView reloadData];
        if ([self.itemArr count]<10) {
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
    
    // Do any additional setup after loading the view from its nib.
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
    UserModel *usermodel = [[UserModel alloc] initWithDict:[UserDefaults readUserDefaultObjectValueForKey:user_info]];
    [self.viewModel fetchRentPersonFansListWithToken:[self getToken] Id:usermodel.Id page:@(++ self.pageIndex) size:@(10)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.itemArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RentPersonFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RentPersonFansTableViewCell"];
    [cell initCellWith:self.itemArr[indexPath.row]];
    return cell;
    
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.itemArr.count - 1) {
        return 69.f;
    }
    return 70.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FansModel *model = self.itemArr[indexPath.row];
    FriendInfomationViewController *vc = [[FriendInfomationViewController alloc] init];
    vc.Id = model.uid;
    vc.flag = 1;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}
@end
