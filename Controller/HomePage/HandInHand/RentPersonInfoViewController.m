//
//  RentPersonInfoViewController.m
//  TheWorker
//
//  Created by yanghao on 8/21/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "RentPersonInfoViewController.h"
#import "RentPersonInfoHeadView.h"
#import "RentPersonInfoTableViewCell.h"
#import "RentPersonInfoSectionHeadView.h"
#import "RentPersonFansTableViewCell.h"
#import "RentImmediatelyViewController.h"
#import "RentPersonViewModel.h"
#import "RentPersonModel.h"
#import "FansModel.h"
#import "UserModel.h"
#import "FriendViewModel.h"
#import "SkillModel.h"
@interface RentPersonInfoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnAddFriend;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;

@property (nonatomic, retain) RentPersonInfoHeadView *headView;
@property (nonatomic, assign) NSInteger     currItemIndex;
@property (nonatomic, retain) RentPersonModel *personModel;
@property (nonatomic, retain) RentPersonViewModel *fansViewModel;
@property (nonatomic, retain) NSMutableArray *itemArr;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation RentPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemArr = [[NSMutableArray alloc] init];
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"RentPersonInfoHeadView" owner:self options:nil] firstObject];
    [self.headView initBannerView:self.imgArr];
    __weak typeof (self)weakSelf = self;
    [self.headView setEndDeceleratingBlock:^{
        NSLog(@"");
//        weakSelf.bannerTimer = [MSWeakTimer scheduledTimerWithTimeInterval:5 target:weakSelf.headView selector:@selector(timerStart) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
    }];
    [self.headView setBeginDraggingBlock:^{
        NSLog(@"");
//        [weakSelf.bannerTimer invalidate];
    }];
    self.personModel = [[RentPersonModel alloc] init];
    self.itemTableView.tableHeaderView = self.headView;
    [self.headView setTagBlock:^(NSInteger blockTag) {
        weakSelf.currItemIndex = blockTag;
        
        if (blockTag == 1) {
            [weakSelf headerRefreshing];
        }else{
            [weakSelf.itemTableView reloadData];
        }
        
    }];
        self.fansViewModel = [[RentPersonViewModel alloc] init];
        [self.fansViewModel setBlockWithReturnBlock:^(id returnValue) {
            FansModel *model = returnValue;
            if (self.pageIndex == 1) {
                [weakSelf.itemArr removeAllObjects];
                [weakSelf.itemTableView.mj_header endRefreshing];
            }
            else{
                [weakSelf.itemTableView.mj_footer endRefreshing];
            }
            if ([model.follow_list count]<10) {
                [weakSelf.itemTableView.mj_footer removeFromSuperview];
            }
            
            [weakSelf.itemArr addObjectsFromArray:model.follow_list];
            [weakSelf.itemTableView reloadData];
        } WithErrorBlock:^(id errorCode) {
            [weakSelf showJGProgressWithMsg:errorCode];
        }];
    
    [self setupRefresh];
    [self.itemTableView setTableHeaderView:self.headView];
    
    [self.itemTableView registerNib:[UINib nibWithNibName:@"RentPersonInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"RentPersonInfoTableViewCell"];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"RentPersonFansTableViewCell" bundle:nil] forCellReuseIdentifier:@"RentPersonFansTableViewCell"];

    RentPersonViewModel *viewModel = [[RentPersonViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        
        self.personModel = returnValue;
        NSDictionary *userInfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
        UserModel *userModel = [[UserModel alloc] initWithDict:userInfo];
        if ([userModel.Id isEqualToString:self.personModel.uid]) {
            self.btnFollow.hidden = YES;
        }else{
            self.btnFollow.hidden = NO;
        }
        [self.headView initViewWithModel:self.personModel];
        
        
        //判断是否关注
        if ([self.personModel.is_follow integerValue] == 1) {
            self.btnFollow.selected = YES;
            [self.btnFollow setImage:[UIImage imageNamed:@"icon_followed"] forState:UIControlStateSelected];
        }else{
            self.btnFollow.selected = NO;
            [self.btnFollow setImage:[UIImage imageNamed:@"icon_attention"] forState:UIControlStateNormal];
        
        }
        
        //判断是否好友
        if ([self.personModel.is_friend integerValue] == 1) {
            self.btnAddFriend.selected = YES;
            [self.btnAddFriend setTitle:@"删除好友" forState:UIControlStateSelected];
        }else{
            self.btnAddFriend.selected = NO;
            [self.btnAddFriend setTitle:@"加为好友" forState:UIControlStateNormal];
        }
        [self.itemTableView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchRentPersonInfomationWithToken:[self getToken] Id:self.uid];
    
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
    [self.fansViewModel fetchRentPersonFansListWithToken:[self getToken] Id:self.uid page:@(++ self.pageIndex) size:@(10)];
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}

- (IBAction)rentImmediately:(id)sender {
    if (![self isLogin]) {
        [self skiptoLogin];
        return;
    }
    NSDictionary *userInfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    UserModel *userModel = [[UserModel alloc] initWithDict:userInfo];
    if ([userModel.Id isEqualToString:self.personModel.uid]) {
        [self showJGProgressWithMsg:@"不能租赁自己"];
        
    }else{
        RentImmediatelyViewController *vc = [[RentImmediatelyViewController alloc]init];
        vc.personModel = self.personModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (IBAction)shareAction:(id)sender {
    NSArray *array = self.personModel.server;
    NSString *contentStr = @"";
    for (int i = 0; i < array.count; i ++) {
        SkillModel *model = array[i];
        NSString *str = [NSString stringWithFormat:@"%@ %@元/小时",model.name,model.price];
        if (i == 0) {
            contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@",str]];
        }else{
            contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"、%@",str]];
        }
        
    }
    [self shareWithPageUrl:self.personModel.share shareTitle:self.personModel.nickname shareDes:contentStr thumImage:[NSString stringWithFormat:@"%@%@",BaseUrl,self.personModel.showimg]];
//    [self shareWithPageUrl:[NSString stringWithFormat:@"%@%@",BaseUrl,URL_SHARE_GENERAL] shareTitle:@"员工的名义" shareDes:@"员工的名义"  thumImage:nil];
}
- (IBAction)followAction:(id)sender {
    if (![self isLogin]) {
        [self skiptoLogin];
        return;
    }
    RentPersonViewModel *followViewModel = [[RentPersonViewModel alloc] init];
    [followViewModel setBlockWithReturnBlock:^(id returnValue) {
        if (self.btnFollow.selected == YES) {
            self.btnFollow.selected = NO;
            [self showJGProgressWithMsg:@"取消关注成功"];
            [self.btnFollow setImage:[UIImage imageNamed:@"icon_attention"] forState:UIControlStateNormal];
            [self headerRefreshing];
        }else{
            self.btnFollow.selected = YES;
            [self.btnFollow setImage:[UIImage imageNamed:@"icon_followed"] forState:UIControlStateNormal];
            [self showJGProgressWithMsg:@"关注成功"];
            [self headerRefreshing];
        }
        
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [followViewModel followPersonWithToken:[self getToken] Id:self.uid];
}
- (IBAction)addFriendAction:(id)sender {
    if (![self isLogin]) {
        [self skiptoLogin];
        return;
    }
    
    if (self.btnAddFriend.selected == YES) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"确定删除好友？"
                                                                          preferredStyle:UIAlertControllerStyleAlert ];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            FriendViewModel *viewModel = [[FriendViewModel alloc] init];
            [viewModel setBlockWithReturnBlock:^(id returnValue) {
                self.btnAddFriend.selected = NO;
                [self.btnAddFriend setTitle:@"加为好友" forState:UIControlStateNormal];
            } WithErrorBlock:^(id errorCode) {
                [self showJGProgressWithMsg:errorCode];
            }];
            [viewModel deleteFriendWithToken:[self getToken] Id:self.uid];
            
        }];
        [alertController addAction:OKAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        NSDictionary *userInfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
        UserModel *userModel = [[UserModel alloc] initWithDict:userInfo];
        if ([userModel.Id isEqualToString:self.personModel.uid]) {
            [self showJGProgressWithMsg:@"不能添加自己为好友"];

        }else{
            RentPersonViewModel *viewModel = [[RentPersonViewModel alloc] init];
            [viewModel setBlockWithReturnBlock:^(id returnValue) {
                [self showJGProgressWithMsg:@"好友请求已发送"];
            } WithErrorBlock:^(id errorCode) {
                [self showJGProgressWithMsg:errorCode];
            }];
            [viewModel addFriendWithToken:[self getToken] Id:self.uid];
        }
        
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.currItemIndex == 0) {
        return 3;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.currItemIndex == 0) {
        NSArray *arr = @[self.personModel];
        return arr.count;
    }
    return self.itemArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.currItemIndex == 0) {
        RentPersonInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RentPersonInfoTableViewCell"];
        [cell initCell:self.personModel section:indexPath.section];
        return cell;
    }
    RentPersonFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RentPersonFansTableViewCell"];
    [cell initCellWith:self.itemArr[indexPath.row]];
    return cell;

}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.currItemIndex == 0) {
        return [RentPersonInfoTableViewCell getHeightCell:self.personModel section:indexPath.section];
    }
    return 70.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.currItemIndex == 0) {
        return 44.f;
    }
    return 1.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.currItemIndex == 0) {
        if (section == 2) {
            return 10.f;
        }
        return 0.1f;
    }
    return 10.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.currItemIndex == 0) {
        RentPersonInfoSectionHeadView *headView = [[[NSBundle mainBundle] loadNibNamed:@"RentPersonInfoSectionHeadView" owner:self options:nil] firstObject];
        
        [headView initViewWithSection:section];
        return headView;
    }
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, ScreenWidth, 1);
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, ScreenWidth, 10);
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
