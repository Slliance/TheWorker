//
//  NTESSessionListViewController.m
//  NIMDemo
//
//  Created by chris on 15/2/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESSessionListViewController.h"
#import "NTESSessionViewController.h"
#import "LoginViewController.h"
#import "FriendDetailViewController.h"
#import "UserModel.h"
@interface NTESSessionListViewController ()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *noDataView;
@property (nonatomic,strong) UIView *noLoginView;
@end

@implementation NTESSessionListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    if (userinfo) {
//        self.recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
//        if (!self.recentSessions.count) {
//            self.recentSessions = [NSMutableArray array];
//        }
        self.noDataView.hidden = self.recentSessions.count;
        self.noLoginView.hidden = YES;
        [self setupRefresh];
    }else{
        self.noDataView.hidden = YES;
        self.noLoginView.hidden = NO;
    }
}


- (void)viewDidLoad{
    [super viewDidLoad];
//
//    self.emptyTipLabel = [[UILabel alloc] init];
//    self.emptyTipLabel.text = @"没有会话";
//    self.emptyTipLabel.textColor = [UIColor lightGrayColor];
//    self.emptyTipLabel.font = [UIFont systemFontOfSize:13];
//    self.emptyTipLabel.textAlignment = NSTextAlignmentCenter;
//    self.emptyTipLabel.frame = CGRectMake(0, 100, ScreenWidth, 20);
////    [self.emptyTipLabel sizeToFit];
//    self.emptyTipLabel.hidden = self.recentSessions.count;
//    [self.view addSubview:self.emptyTipLabel];
    self.noDataView = [[UIView alloc] init];
    CGPoint point = self.view.center;
    self.noDataView.frame = CGRectMake(point.x - 63, point.y - 80-64, 126, 160);
//    self.noDataView.center = self.view.center;
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake(0, 0, 126, 126);
    imgView.image = [UIImage imageNamed:@"icon_no_news"];
    [self.noDataView addSubview:imgView];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"暂无消息";
    label.textColor = [UIColor colorWithHexString:@"333333"];
    label.font = [UIFont systemFontOfSize:15];
    label.frame = CGRectMake(0, 140, 126, 20);
    label.textAlignment = NSTextAlignmentCenter;
    [self.noDataView addSubview:label];
    label.center = imgView.center;
    CGRect rect = label.frame;
    rect.origin.y = 140;
    label.frame = rect;
    [self.view addSubview:self.noDataView];
    self.noDataView.hidden = self.recentSessions.count;
    self.noLoginView = [[UIView alloc] init];
    self.noLoginView.frame = CGRectMake(point.x - 63, point.y - 90-64, 126, 180);
    //    self.noDataView.center = self.view.center;
    UIImageView *imgView1 = [[UIImageView alloc] init];
    imgView1.frame = CGRectMake(0, 0, 126, 126);
    imgView1.image = [UIImage imageNamed:@"icon_no_login"];
    [self.noLoginView addSubview:imgView1];
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"btn_sign_in2"] forState:UIControlStateNormal];
    button.frame = CGRectMake(11, 138, 104, 34);
    [button addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.noLoginView addSubview:button];
//    [self.view addSubview:self.noLoginView];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
}

/**
 *  设置刷新
 */
-(void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    [self.tableView.mj_header beginRefreshing];
}
/**
 *  下拉刷新
 */
-(void)headerRefreshing
{
    [self footerRefreshing];
}
/**
 *  上拉刷新
 */
-(void)footerRefreshing
{
    [self refresh];
    [self.tableView.mj_header endRefreshing];
}

- (void)onSelectedAvatar:(NIMRecentSession *)recent
             atIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    UserModel *userModel = [[UserModel alloc] initWithDict:userinfo];
    if (![userModel.mobile isEqualToString:recent.session.sessionId]) {
        
        FriendDetailViewController *vc = [[FriendDetailViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.mobile = recent.session.sessionId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)loginAction{
    LoginViewController *vc = [[LoginViewController alloc] init];
    vc.loginType = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
//修改编辑按钮文字

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return @"删除";
}

- (void)refresh{
    [super refresh];
    self.noDataView.hidden = self.recentSessions.count;
    [HYNotification postMsgCountUpdateNotification:nil];
}

- (void)onSelectedRecent:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath{
    NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:recent.session];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
