//
//  SearchFriendResultViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "SearchFriendResultViewController.h"
#import "FriendDetailViewController.h"
#import "AddFriendTableViewCell.h"
#import "FriendViewModel.h"
#import "RentPersonViewModel.h"
#import "FriendModel.h"
#import "OnlySearchHeadView.h"
@interface SearchFriendResultViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, retain) NSMutableArray *itemArr;
@property (nonatomic, retain) FriendViewModel *viewModel;
@property (nonatomic, retain) OnlySearchHeadView *headView;
@end

@implementation SearchFriendResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemArr = [[NSMutableArray alloc]init];
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"OnlySearchHeadView" owner:self options:nil]firstObject];
    [self.headView initSearchViewWithType:1];
    __weak typeof(self)weakSelf = self;
    [self.headView setReturnSearchBlock:^(NSString *name) {
        weakSelf.searchKey = name;
        [weakSelf headerRefreshing];
    }];
    self.itemTableView.tableHeaderView = self.headView;
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.itemTableView registerNib:[UINib nibWithNibName:@"AddFriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddFriendTableViewCell"];
    self.viewModel = [[FriendViewModel alloc]init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        
        if (self.pageIndex == 1) {
            [weakSelf.itemTableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
        if ([weakSelf.itemArr count]<10) {
            [weakSelf.itemTableView.mj_footer removeFromSuperview];
        }
        [weakSelf.itemArr addObjectsFromArray:returnValue];
        [weakSelf.itemTableView reloadData];
        
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
        [weakSelf.itemTableView.mj_header endRefreshing];
        
        
    }];
//    [self setupRefresh];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    [self.viewModel searchUserWithName:self.searchKey token:[self getToken] page:@(++ self.pageIndex)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddFriendTableViewCell"];
    [cell initCellWithData:self.itemArr[indexPath.row]];
    [cell setReturnAddBlcok:^(NSString *uid) {
        RentPersonViewModel *viewModel = [[RentPersonViewModel alloc] init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [self showJGProgressWithMsg:@"好友请求已发送"];
            [self.navigationController popViewControllerAnimated:YES];
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel addFriendWithToken:[self getToken] Id:uid];
    }];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FriendDetailViewController *vc = [[FriendDetailViewController alloc] init];
    AddressBookFriendModel *model = self.itemArr[indexPath.row];
    vc.mobile = [NSString stringWithFormat:@"%@",model.mobile];
    [self.navigationController pushViewController:vc animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self setupRefresh];
    return YES;
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
