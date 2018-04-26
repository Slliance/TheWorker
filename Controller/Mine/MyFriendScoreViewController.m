//
//  MyFriendScoreViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/5.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyFriendScoreViewController.h"
#import "FriendScoreTableViewCell.h"
#import "MyGradeViewModel.h"
#import "UserModel.h"
@interface MyFriendScoreViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UILabel *friendAmountLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnFirstGrade;
@property (weak, nonatomic) IBOutlet UIButton *btnSecondGrade;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;
@property (nonatomic, assign) NSInteger selectType;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic ,retain) MyGradeViewModel *viewModel;
@property (nonatomic, retain) NSMutableArray *itemArr;

@end

@implementation MyFriendScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemArr = [[NSMutableArray alloc] init];
    self.selectType = 1;
    [self.itemTableView registerNib:[UINib nibWithNibName:@"FriendScoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"FriendScoreTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    UserModel *userModel = [[UserModel alloc] initWithDict:userinfo];
    self.friendAmountLabel.text = [NSString stringWithFormat:@"%@",userModel.friend_amount];
    // Do any additional setup after loading the view from its nib.
    __weak typeof (self)weakSelf = self;
    self.viewModel = [[MyGradeViewModel alloc] init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        
        if (self.pageIndex == 1) {
            [weakSelf.itemArr removeAllObjects];
            [weakSelf.itemTableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
        [weakSelf.itemArr addObjectsFromArray:returnValue[0]];
        if ([weakSelf.itemArr count]<10) {
            [weakSelf.itemTableView.mj_footer removeFromSuperview];
        }
        
        NSNumber *number1 = returnValue[1];
        NSNumber *number2 = returnValue[2];
        
                [weakSelf.btnFirstGrade setTitle:[NSString stringWithFormat:@"直接邀请(%@人)",number1] forState:UIControlStateNormal];
        
                [weakSelf.btnSecondGrade setTitle:[NSString stringWithFormat:@"间接邀请(%@人)",number2] forState:UIControlStateNormal];
        
        
        [weakSelf.itemTableView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
        [weakSelf.itemTableView.mj_header endRefreshing];
        
    }];
    
    [self setupRefresh];
    
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
    
    [self.viewModel fetchMyFriendAmount:[self getToken] page:@(++ self.pageIndex) level:@(self.selectType)];
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)inviteFriend:(id)sender {
    NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    UserModel *userModel = [[UserModel alloc] initWithDict:userinfo];

    [self shareWithPageUrl:userModel.share shareTitle:userModel.share_title shareDes:userModel.share_content thumImage:userModel.show_img];

}
-(void)viewDidAppear:(BOOL)animated{
    self.blueLabel.center = self.btnFirstGrade.center;
    CGRect rect = self.blueLabel.frame;
    rect.origin.y = 88;
    self.blueLabel.frame = rect;
}
- (IBAction)chooseSecond:(id)sender {
//    self.btnSecondGrade.selected = YES;
//    self.btnFirstGrade.selected = NO;
    self.blueLabel.center = self.btnSecondGrade.center;
    CGRect rect = self.blueLabel.frame;
    rect.origin.y = 88;
    self.blueLabel.frame = rect;
    self.selectType = 2;
    [self.itemTableView.mj_header beginRefreshing];
}

- (IBAction)chooseFirst:(id)sender {
//    self.btnFirstGrade.selected = YES;
//    self.btnSecondGrade.selected = NO;
    self.blueLabel.center = self.btnFirstGrade.center;
    CGRect rect = self.blueLabel.frame;
    rect.origin.y = 88;
    self.blueLabel.frame = rect;
    self.selectType = 1;
    [self.itemTableView.mj_header beginRefreshing];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendScoreTableViewCell"];
    [cell initCellWithData:self.itemArr[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62.f;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 33.f;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *headView = [[UIView alloc]init];
//    headView.frame = CGRectMake(0, 0, ScreenWidth, 33);
//    headView.backgroundColor = [UIColor whiteColor];
//    UIImageView *headImageView = [[UIImageView alloc]init];
//    headImageView.image = [UIImage imageNamed:@"icon_invitation_record"];
//    headImageView.frame = CGRectMake(10, 10,14, 13);
//    UILabel *label = [[UILabel alloc]init];
//    label.frame = CGRectMake(35, 0, 60, 34);
//    label.text = @"邀请记录";
//    label.font = [UIFont systemFontOfSize:13];
//    label.textColor = [UIColor colorWithHexString:@"666666"];
//    UILabel *lineLabel = [[UILabel alloc]init];
//    lineLabel.frame = CGRectMake(0, 33, ScreenWidth, 1);
//    lineLabel.backgroundColor = [UIColor colorWithHexString:@"e9e9e9"];
//    [headView addSubview:lineLabel];
//    [headView addSubview:headImageView];
//    [headView addSubview:label];
//    return headView;
//}

@end
