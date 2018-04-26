//
//  RentSelfViewController.m
//  TheWorker
//
//  Created by yanghao on 8/21/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "RentSelfViewController.h"
#import "RentSelfTableViewCell.h"
#import "RentPersonInfoViewController.h"
#import "SetUserImgViewController.h"
#import "RentViewModel.h"
#import "RentModel.h"
#import "UserModel.h"
#import "UserViewModel.h"
#import "UploadInfoViewController.h"
#import "NotVertificationViewController.h"
#import "VertificateDefeatViewController.h"
#import "VertificateResultViewController.h"
@interface RentSelfViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelLine;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIButton *heightFaceBtn;
@property (weak, nonatomic) IBOutlet UIButton *recommendBtn;
@property (nonatomic, retain) RentViewModel *viewModel;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, retain) NSMutableArray *itemArr;
@property (nonatomic, assign) NSInteger selectType;

@end

@implementation RentSelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemArr = [[NSMutableArray alloc] init];
    [self heightFaceAction:nil];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"RentSelfTableViewCell" bundle:nil] forCellReuseIdentifier:@"RentSelfTableViewCell"];
    __weak typeof(self)weakSelf = self;
    self.viewModel = [[RentViewModel alloc] init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        if (self.pageIndex == 1) {
            [weakSelf.itemArr removeAllObjects];
            [weakSelf.itemTableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
        [weakSelf.itemArr addObjectsFromArray:returnValue];
        
        [weakSelf.itemTableView reloadData];
        if ([(NSArray *)returnValue count] < 10) {
            [weakSelf.itemTableView.mj_footer removeFromSuperview];
        }
        else{
            weakSelf.itemTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(footerRefreshing)];
        }
        
        
    } WithErrorBlock:^(id errorCode) {
        if (self.pageIndex == 1) {
            [weakSelf.itemArr removeAllObjects];
            [weakSelf.itemTableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
        [weakSelf showJGProgressWithMsg:errorCode];
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
    [self.itemTableView.mj_header beginRefreshing];
}
/**
 *  下拉刷新
 */
-(void)headerRefreshing
{
    self.pageIndex = 0;
    [self footerRefreshing];
}
/**
 *  上拉刷新
 */
-(void)footerRefreshing
{
    [self.viewModel fetchRentListWithToken:[self getToken] page:@(++ self.pageIndex) type:@(self.selectType)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}

- (IBAction)heightFaceAction:(id)sender {
    
    CGRect heightRect = self.heightFaceBtn.frame;
    
    CGRect rect = self.labelLine.frame;
    rect.origin.x = heightRect.origin.x + 20;
    rect.size.width = heightRect.size.width - 40;
    self.labelLine.frame = rect;
    self.heightFaceBtn.selected = YES;
    self.recommendBtn.selected = NO;
    self.selectType = 1;
    [self headerRefreshing];
}

- (IBAction)RecommendAction:(id)sender {
    CGRect heightRect = self.recommendBtn.frame;
    
    CGRect rect = self.labelLine.frame;
    rect.origin.x = heightRect.origin.x + 20;
    rect.size.width = heightRect.size.width - 40;
    self.labelLine.frame = rect;
    self.heightFaceBtn.selected = NO;
    self.recommendBtn.selected = YES;
    self.selectType = 2;
    [self headerRefreshing];
}
- (IBAction)rentSelfAction:(id)sender {
    if (![self isLogin]) {
        [self skiptoLogin];
        return;
    }
    UserViewModel *viewModel = [[UserViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self dissJGProgressLoadingWithTag:200];
        UserModel *userModel = returnValue;
        if ([userModel.auth integerValue] == 0) {//未提交
            NotVertificationViewController *vc = [[NotVertificationViewController alloc] init];
            //        vc.type = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }else if([userModel.auth integerValue] == 1){//审核中
            VertificateResultViewController *vc = [[VertificateResultViewController alloc] init];
            vc.type = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([userModel.auth integerValue] == 2){//已通过
            SetUserImgViewController *vc = [[SetUserImgViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{//认证失败
            VertificateDefeatViewController *vc = [[VertificateDefeatViewController alloc] init];
            vc.type = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
        [self dissJGProgressLoadingWithTag:200];
    }];
    [viewModel fetchUserInfomationWithToken:[self getToken]];
    [self showJGProgressLoadingWithTag:200];
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.itemArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RentSelfTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RentSelfTableViewCell"];
    [cell initCellWithModel:self.itemArr[indexPath.section]];
    return cell;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 246.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
        RentPersonInfoViewController *vc = [[RentPersonInfoViewController alloc] init];
        RentModel *model = self.itemArr[indexPath.section];
        vc.uid = model.uid;
        vc.imgArr = model.img;
        [self.navigationController pushViewController:vc animated:YES];

}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, ScreenWidth, 10);
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
