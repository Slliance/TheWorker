//
//  WorkerDetailViewController.m
//  TheWorker
//
//  Created by yanghao on 8/29/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "WorkerDetailViewController.h"

#import "WorkerDetailHeadView.h"
#import "WorkerDetailTableViewCell.h"
#import "RentPersonViewModel.h"
#import "WorkerHandInViewModel.h"
#import "HandInModel.h"
#import "CollectViewModel.h"
#import "FriendViewModel.h"
#import "MSWeakTimer.h"
#import "UserModel.h"
@interface WorkerDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnCollect;
@property (weak, nonatomic) IBOutlet UIButton *btnAddFriend;

@property (nonatomic, retain) WorkerDetailHeadView *headView;
@property (nonatomic, retain) HandInModel *handInModel;
@property (nonatomic, retain) MSWeakTimer           *bannerTimer;
@property (nonatomic, retain) NSMutableArray *itemArr;
@end

@implementation WorkerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemArr = [[NSMutableArray alloc]init];
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"WorkerDetailHeadView" owner:self options:nil] firstObject];
    [self.itemTableView setTableHeaderView:self.headView];
    __weak typeof (self)weakSelf = self;
    
    [self.headView setEndDeceleratingBlock:^{
        NSLog(@"");
        weakSelf.bannerTimer = [MSWeakTimer scheduledTimerWithTimeInterval:5 target:weakSelf.headView selector:@selector(timerStart) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
    }];
    [self.headView setBeginDraggingBlock:^{
        NSLog(@"");
        [weakSelf.bannerTimer invalidate];
    }];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"WorkerDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"WorkerDetailTableViewCell"];
    [self reloadView];
    [HYNotification addLoginNotification:self action:@selector(reloadView)];
    // Do any additional setup after loading the view from its nib.
}
-(void)reloadView{
    WorkerHandInViewModel *viewModel = [[WorkerHandInViewModel alloc] init];
    self.handInModel = [[HandInModel alloc] init];
    __weak typeof (self)weakSelf = self;
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self.itemArr removeAllObjects];
        self.handInModel = returnValue;
       
        [self.headView initBannerView:self.handInModel.imgs];
        [self.itemArr addObject:self.handInModel.declaration];
        [self.itemArr addObject:self.handInModel.introduce];
        self.labelTitle.text = self.handInModel.nickname;
        if ([self.handInModel.is_collect integerValue] == 1) {
            self.btnCollect.selected = YES;
        }
        if ([self.handInModel.is_friend integerValue] == 1) {
            self.btnAddFriend.selected = YES;
        }
        [self.itemTableView reloadData];
        weakSelf.bannerTimer = [MSWeakTimer scheduledTimerWithTimeInterval:5 target:weakSelf.headView selector:@selector(timerStart) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchWorkerHandInDetailWith:[self getToken] Id:self.handInId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}

- (IBAction)collectAction:(id)sender {
    if (![self isLogin]) {
        [self skiptoLogin];
        return;
    }
    if (self.btnCollect.selected == YES) {
        CollectViewModel *viewModel = [[CollectViewModel alloc]init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [self showJGProgressWithMsg:@"取消收藏成功"];
            self.btnCollect.selected = NO;
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel userCollectWithToken:[self getToken] articleId:[NSString stringWithFormat:@"%@",self.handInModel.Id] collectType:@(9)];
    }else{
        CollectViewModel *viewModel = [[CollectViewModel alloc]init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [self showJGProgressWithMsg:@"添加收藏成功"];
            self.btnCollect.selected = YES;
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel userCollectWithToken:[self getToken] articleId:[NSString stringWithFormat:@"%@",self.handInModel.Id] collectType:@(9)];
    }
}
- (IBAction)addFriendAction:(id)sender {
    if (![self isLogin]) {
        [self skiptoLogin];
        return;
    }
    if (self.btnAddFriend.selected == YES) {
        FriendViewModel *viewModel = [[FriendViewModel alloc] init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            self.btnAddFriend.selected = NO;
            
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel deleteFriendWithToken:[self getToken] Id:self.handInModel.uid];
    }else{
        RentPersonViewModel *viewModel = [[RentPersonViewModel alloc] init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [self showJGProgressWithMsg:@"好友请求已发送"];
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel addFriendWithToken:[self getToken] Id:[NSString stringWithFormat:@"%@",self.handInModel.uid]];
    }
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.itemArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkerDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkerDetailTableViewCell"];
    [cell initView:self.itemArr[indexPath.section]];
    return cell;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [WorkerDetailTableViewCell getCellHeight:self.itemArr[indexPath.row]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 24.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, ScreenWidth, 24);
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *icon = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 4, 16)];
    icon.backgroundColor = [UIColor colorWithHexString:@"ef5f7d"];
    [view addSubview:icon];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 24)];
    if (section == 0) {
        titleLabel.text = @"爱情宣言";
    }
    else{
        titleLabel.text = @"自我介绍";
    }
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [view addSubview:titleLabel];
    return view;
}


@end
