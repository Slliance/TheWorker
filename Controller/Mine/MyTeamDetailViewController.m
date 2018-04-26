//
//  MyTeamDetailViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 14/12/2017.
//  Copyright © 2017 huying. All rights reserved.
//

#import "MyTeamDetailViewController.h"
#import "MyGradeViewModel.h"
#import "MyTeamDetailTableViewCell.h"
@interface MyTeamDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, retain) NSMutableArray *itemArr;
@property (nonatomic, retain) MyGradeViewModel *viewModel;
@end

@implementation MyTeamDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemArr = [[NSMutableArray alloc] init];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"MyTeamDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyTeamDetailTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.amountLabel.text = [NSString stringWithFormat:@"%@人",self.number];
    self.titleLabel.text = [NSString stringWithFormat:@"%@的团队",self.mobile];
    __weak typeof (self)weakSelf = self;
    self.viewModel = [[MyGradeViewModel alloc] init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        
        if (self.pageIndex == 1) {
            [weakSelf.itemTableView.mj_header endRefreshing];
            if ([returnValue count] == 10) {
                weakSelf.itemTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(footerRefreshing)];
            }
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
        [weakSelf.itemArr addObjectsFromArray:returnValue];
        
        if ([weakSelf.itemArr count] < 10) {
            [weakSelf.itemTableView.mj_footer removeFromSuperview];
        }
        
        [weakSelf.itemTableView reloadData];
        
        
    } WithErrorBlock:^(id errorCode) {
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
    [self.itemArr removeAllObjects];
    [self.itemTableView reloadData];
    [self footerRefreshing];
}
/**
 *  上拉刷新
 */
-(void)footerRefreshing
{
    [self.viewModel fetchTeamDetailWithToken:[self getToken] mobile:self.mobile page:@(++ self.pageIndex)];
    
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:nil];
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyTeamDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTeamDetailTableViewCell"];
    [cell initCellWithData:self.itemArr[indexPath.row]];
    return cell;
}
#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 10;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.0001f;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
