//
//  NewFriendViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/20.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "NewFriendViewController.h"
#import "FriendDetailViewController.h"
#import "OnlySearchHeadView.h"
#import "AddressBookTableViewCell.h"
#import "FriendViewModel.h"
#import "SearchFriendResultViewController.h"
#import "AddressBookFriendModel.h"
@interface NewFriendViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (nonatomic, retain) OnlySearchHeadView *headView;
@property (nonatomic, retain) FriendViewModel *viewModel;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, retain) NSMutableArray *itemArr;
@end

@implementation NewFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemArr = [[NSMutableArray alloc] init];
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"OnlySearchHeadView" owner:self options:nil]firstObject];
    [self.headView initSearchViewWithType:0];
    __weak typeof(self)weakSelf = self;
    [self.headView setReturnSearchBlock:^(NSString *name) {
        SearchFriendResultViewController *vc = [[SearchFriendResultViewController alloc] init];
        //        vc.searchKey = name;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    self.itemTableView.tableHeaderView = self.headView;
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.itemTableView registerNib:[UINib nibWithNibName:@"AddressBookTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressBookTableViewCell"];
    // Do any additional setup after loading the view from its nib.
    
    self.viewModel = [[FriendViewModel alloc] init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        if (self.pageIndex == 1) {
            [weakSelf.itemArr removeAllObjects];
            [weakSelf.itemTableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
        
        if ([(NSArray *)returnValue count] < 10) {
            [weakSelf.itemTableView.mj_footer removeFromSuperview];
        }
        else{
            weakSelf.itemTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(footerRefreshing)];
        }
        [weakSelf.itemArr addObjectsFromArray:returnValue];
        [weakSelf.itemTableView reloadData];
    } WithErrorBlock:^(id errorCode) {
        if (self.pageIndex == 1) {
            [weakSelf.itemTableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
        
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
//    [self setupRefresh];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupRefresh];
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
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
    [self.viewModel fetchFriendApplyListWithToken:[self getToken] page:@(++ self.pageIndex)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressBookTableViewCell"];
    [cell initCellWithData:self.itemArr[indexPath.row] isHidden:0];
    [cell setReturnAgreeApplyBlock:^(NSString *str){
        FriendViewModel *viewModel = [[FriendViewModel alloc] init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [self headerRefreshing];
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        
        [viewModel handleFriendApplyWithToken:[self getToken] Id:str type:@(1)];
    }];
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGR:)];
    //    设定最小的长按时间 按不够这个时间不响应手势
    longPressGR.minimumPressDuration = 0.5;
    [cell addGestureRecognizer:longPressGR];
    longPressGR.view.tag = indexPath.row;
    return cell;
}

#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 66.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FriendDetailViewController *vc = [[FriendDetailViewController alloc] init];
    AddressBookFriendModel *model = self.itemArr[indexPath.row];
    vc.mobile = [NSString stringWithFormat:@"%@",model.mobile];
    vc.status = 2;
    if ([model.status integerValue] == 1) {
        vc.applyId = [NSString stringWithFormat:@"%@",model.Id];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)longPressGR:(UILongPressGestureRecognizer *)lpGR{
    
    if(lpGR.state==UIGestureRecognizerStateBegan){
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"提示"                                                                             message: @""                                                                           preferredStyle:UIAlertControllerStyleAlert];
        //修改title
        NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"提示"];
        [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1d1d1d"] range:NSMakeRange(0, 2)];
        [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 2)];
        [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
        
        //修改message
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"是否删除该条申请记录!"];
        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(0, 7)];
        [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 7)];
        [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
        
        //添加Button
        UIAlertAction *okAction = [UIAlertAction actionWithTitle: @"确认" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //获取目标cell
            NSInteger row = lpGR.view.tag;
            FriendViewModel *viewModel = [[FriendViewModel alloc]init];
            [viewModel setBlockWithReturnBlock:^(id returnValue) {
                //删除操作
                [self.itemArr removeObjectAtIndex:row];
                [self.itemTableView reloadData];
                [self showJGProgressWithMsg:@"删除成功"];
            } WithErrorBlock:^(id errorCode) {
                
            }];
            AddressBookFriendModel *model = self.itemArr[row];
            [viewModel deleteFriendApplyWithToken:[self getToken] Id:[NSString stringWithFormat:@"%@",model.Id]];
            
        }];
        
        UIAlertAction *cancelAction =  [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil];
        
        [cancelAction setValue:[UIColor colorWithHexString:@"999999"] forKey:@"titleTextColor"];
        [okAction setValue:[UIColor colorWithHexString:@"6398f1"] forKey:@"titleTextColor"];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController: alertController animated: YES completion: nil];
        
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
