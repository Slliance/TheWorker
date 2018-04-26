//
//  HandInHandViewController.m
//  TheWorker
//
//  Created by yanghao on 8/19/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "HandInHandViewController.h"
#import "HandInHandHeadView.h"
#import "WorkerLoveViewCell.h"
#import "WorkerLiveViewController.h"
#import "RentSelfViewController.h"
#import "HandWorkerListViewController.h"
#import "PublishMyInfoViewController.h"
#import "WorkerDetailViewController.h"
#import "WorkerHandInViewModel.h"
#import "HandInModel.h"
#import "UserModel.h"
#import "HandInHandMapViewController.h"
#import "UploadInfoViewController.h"
#import "NotVertificationViewController.h"
#import "VertificateDefeatViewController.h"
#import "VertificateResultViewController.h"
#import "UserViewModel.h"
@interface HandInHandViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (nonatomic, retain) HandInHandHeadView *headView;
@property (nonatomic, retain) NSMutableArray        *bannerArr;
@property (nonatomic, retain) NSMutableArray *itemArr;
@end

@implementation HandInHandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bannerArr = [[NSMutableArray alloc] init];
    self.itemArr = [[NSMutableArray alloc]init];
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"HandInHandHeadView" owner:self options:nil] firstObject];
    
    
    __weak typeof(self)weakSelf = self;
    [self.headView setReturnTagBlock:^(NSInteger blockTag) {
        switch (blockTag) {
                case 0:{
                    HandWorkerListViewController *vc = [[HandWorkerListViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                break;
                case 1:{
                    
                    RentSelfViewController *vc = [[RentSelfViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                    
                }
                break;
            default:
                break;
        }
    }];
    
    [self.itemTableView setTableHeaderView:self.headView];
    
    [self.itemTableView registerNib:[UINib nibWithNibName:@"WorkerLoveViewCell" bundle:nil] forCellReuseIdentifier:@"WorkerLoveViewCell"];
    
    //
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidDisappear:animated];
    WorkerHandInViewModel *viewModel = [[WorkerHandInViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        self.itemTableView.hidden = NO;
        [self.bannerArr removeAllObjects];
        [self.itemArr removeAllObjects];
        [self.bannerArr addObjectsFromArray:returnValue[0]];
        [self.itemArr addObjectsFromArray:returnValue[1]];
        [self.itemTableView reloadData];
        [self.headView initView:self.bannerArr];
        
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    
    [viewModel fetchWorkerHandInListWith:[self getToken]];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [HYNotification postDestoryNotification:nil];
}
- (IBAction)backAction:(id)sender {
    
    [self backBtnAction:sender];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkerLoveViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkerLoveViewCell"];
    [cell initCellWithData:self.itemArr];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [WorkerLoveViewCell getCellHeightWithData:self.itemArr];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 34.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    
    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [headBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:5.f];
    headBtn.frame = CGRectMake(10,0, 150, 34);
    [headBtn setImage:[UIImage imageNamed:@"icon_matchlist"] forState:UIControlStateDisabled];
    [headBtn setTitle:@"推荐相亲人员" forState:UIControlStateDisabled];
    headBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [headBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateDisabled];
    headBtn.enabled = NO;
    [view addSubview:headBtn];
    
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.frame = CGRectMake(0, 33, ScreenWidth, 1);
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"e9e9e9"];
    [view addSubview:lineLabel];
    [view addSubview:btn];
    return view;
}

-(void)skipToMore:(UIButton *)sender{
    
    HandWorkerListViewController *vc = [[HandWorkerListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)publishAction:(id)sender {
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
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if([userModel.auth integerValue] == 1){//审核中
            VertificateResultViewController *vc = [[VertificateResultViewController alloc] init];
            vc.type = 1;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([userModel.auth integerValue] == 2){//已通过
            PublishMyInfoViewController *vc = [[PublishMyInfoViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{//认证失败
            VertificateDefeatViewController *vc = [[VertificateDefeatViewController alloc] init];
            vc.type = 1;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
        [self dissJGProgressLoadingWithTag:200];
    }];
    [viewModel fetchUserInfomationWithToken:[self getToken]];
    [self showJGProgressLoadingWithTag:200];
    
    
}

@end
