//
//  MyTeamViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 14/12/2017.
//  Copyright © 2017 huying. All rights reserved.
//

#import "MyTeamViewController.h"
#import "MyTeamTableViewCell.h"
#import "MyGradeViewModel.h"
#import "MyTeamDetailViewController.h"
@interface MyTeamViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnGradeOne;
@property (weak, nonatomic) IBOutlet UIButton *btnGradeTwo;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (nonatomic, assign) NSInteger selectType;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, retain) NSNumber *number1;
@property (nonatomic, retain) NSNumber *number2;
@property (nonatomic, retain) NSMutableArray *itemArr;
@property (nonatomic, retain) MyGradeViewModel *viewModel;
@end

@implementation MyTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectType = 1;
    self.itemArr = [[NSMutableArray alloc] init];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"MyTeamTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyTeamTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        [weakSelf.itemArr addObjectsFromArray:returnValue[0]];
        weakSelf.number1 = returnValue[1];
        weakSelf.number2 = returnValue[2];
        [weakSelf.btnGradeOne setTitle:[NSString stringWithFormat:@"一级团队(%@人)",weakSelf.number1] forState:UIControlStateNormal];
        [weakSelf.btnGradeTwo setTitle:[NSString stringWithFormat:@"二级团队(%@人)",weakSelf.number2] forState:UIControlStateNormal];

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
    [self.viewModel fetchMyTeamWithToken:[self getToken] page:@(++ self.pageIndex) type:@(self.selectType)];
}

-(void)viewDidAppear:(BOOL)animated{
    self.blueLabel.center = self.btnGradeOne.center;
    CGRect rect = self.blueLabel.frame;
    rect.origin.y = 42;
    self.blueLabel.frame = rect;
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:nil];
}
- (IBAction)chooseGradeOne:(id)sender {
//    self.btnGradeOne.selected = YES;
//    self.btnGradeTwo.selected = NO;
    self.blueLabel.center = self.btnGradeOne.center;
    CGRect rect = self.blueLabel.frame;
    rect.origin.y = 42;
    self.blueLabel.frame = rect;
    self.selectType = 1;
    [self.itemTableView.mj_header beginRefreshing];
}

- (IBAction)chooseGradeTwo:(id)sender {
//    self.btnGradeTwo.selected = YES;
//    self.btnGradeOne.selected = NO;
    self.blueLabel.center = self.btnGradeTwo.center;
    CGRect rect = self.blueLabel.frame;
    rect.origin.y = 42;
    self.blueLabel.frame = rect;
    self.selectType = 2;
    [self.itemTableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTeamTableViewCell"];
    [cell initCellWithData:self.itemArr[indexPath.row] type:self.selectType];
    return cell;
}
#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56.f;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 10;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.0001f;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectType == 1) {
        MyTeamModel *model = self.itemArr[indexPath.row];
        MyTeamDetailViewController *vc = [[MyTeamDetailViewController alloc] init];
        vc.mobile = model.mobile;
        vc.number = model.num;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
