//
//  RentMyPersonViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/14.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RentMyPersonViewController.h"
#import "MyRentPersonTableViewCell.h"
#import "MyRentPersonView.h"
#import "MyRentDetailViewController.h"
#import "SubmitObjectionViewController.h"
#import "MyRentViewModel.h"
#import "RentOrderModel.h"
#import "DisagreeAlertView.h"
#import "RentRemarkView.h"
#define menu_max   999
@interface RentMyPersonViewController ()
{
    NSMutableArray          *menuArr;
    NSInteger               currentSelectMenuIndex;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *menuScrollView;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel;
@property (nonatomic, retain) NSMutableArray *itemArr;
@property (nonatomic, retain) MyRentViewModel *viewModel;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation RentMyPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];currentSelectMenuIndex = 0;
    menuArr = [[NSMutableArray alloc] init];
    [menuArr addObject:@"全部"];
    [menuArr addObject:@"待同意"];
    [menuArr addObject:@"待见面"];
    [menuArr addObject:@"待评价"];
    [menuArr addObject:@"有异议"];
    [menuArr addObject:@"已拒绝"];
    [menuArr addObject:@"已评价"];
    [self initMenuScrollView];
    self.itemArr = [[NSMutableArray alloc] init];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"MyRentPersonTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyRentPersonTableViewCell"];
    self.viewModel = [[MyRentViewModel alloc] init];
    
    __weak typeof(self)weakSelf = self;
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
        if ([self.itemArr count]<10) {
            [weakSelf.itemTableView.mj_footer removeFromSuperview];
        }
        
        if (self.itemArr.count == 0) {
            //            weakSelf.noDataView.hidden = NO;
            //            weakSelf.itemTableView.hidden = YES;
        }else{
            //            weakSelf.noDataView.hidden = YES;
            //            weakSelf.itemTableView.hidden = NO;
        }
        
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
        [weakSelf.itemTableView.mj_header endRefreshing];
        if (self.itemArr.count == 0) {
            //            weakSelf.noDataView.hidden = NO;
            //            weakSelf.itemTableView.hidden = YES;
        }
        else{
            //            weakSelf.noDataView.hidden = YES;
            //            weakSelf.itemTableView.hidden = NO;
        }
        
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
    //    0=全部，1-申请中/待同意，2-已同意/待见面，3-拒绝,4-待评价，5-异常，6-完成，7-取消,8=已评价
    NSInteger currentIndex = currentSelectMenuIndex;
    if (currentSelectMenuIndex == 3) {
        currentIndex = 4;
    }else if (currentSelectMenuIndex == 4){
        currentIndex = 5;
    }else if (currentSelectMenuIndex == 5){
        currentIndex = 3;
    }
    [self.viewModel fetchMyRentOrderWithToken:[self getToken] status:@(currentIndex) tag:@(2) page:@(++ self.pageIndex)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
-(void)initMenuScrollView{
    float menux = 0.f;
    float menuy = 0.f;
    float menuheight = 50.f;
    for (NSInteger i = 0; i < menuArr.count; i ++) {
        CGSize size = [menuArr[i] sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(200, 20)];
        UIButton *menu = [UIButton buttonWithType:UIButtonTypeCustom];
        menu.frame = CGRectMake(menux, menuy, size.width + 30, menuheight);
        menux += menu.frame.size.width + 30;
        [menu setTitle:menuArr[i] forState:UIControlStateNormal];
        menu.titleLabel.font = [UIFont systemFontOfSize:15];
        [menu setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [menu setTitleColor:[UIColor colorWithHexString:@"ef5f7d"] forState:UIControlStateSelected];
        [menu addTarget:self action:@selector(menuSelect:) forControlEvents:UIControlEventTouchUpInside];
        menu.tag = i + menu_max;
        if (menu.tag == currentSelectMenuIndex + menu_max) {
            menu.selected = YES;
            [self menuSelect:menu];
        }
        [self.menuScrollView addSubview:menu];
    }
    [self.menuScrollView setContentSize:CGSizeMake(menux, 50)];
}
-(void)menuSelect:(UIButton *)menu{
    UIButton *lastSelectMenu = [self.menuScrollView viewWithTag:currentSelectMenuIndex + menu_max];
    lastSelectMenu.selected = NO;
    self.menuLabel.backgroundColor = [UIColor colorWithHexString:@"ef5f7d"];
    self.menuLabel.frame = CGRectMake(menu.frame.origin.x + menu.frame.size.width / 2 - 15, 48, 30, 2);
    menu.selected = YES;
    currentSelectMenuIndex = menu.tag - menu_max;
    [self headerRefreshing];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.itemArr.count;
    //    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyRentPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyRentPersonTableViewCell"];
    [cell initCellWith:self.itemArr[indexPath.section]];
    return cell;
    
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyRentDetailViewController *vc = [[MyRentDetailViewController alloc] init];
    RentOrderModel *model = self.itemArr[indexPath.section];
    vc.rentId = model.Id;
    vc.type = @(2);
    [self.navigationController pushViewController: vc animated:YES];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, ScreenWidth, 10);
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    MyRentPersonView *myRentPersonView = [[[NSBundle mainBundle] loadNibNamed:@"MyRentPersonView" owner:self options:nil] firstObject];
    [myRentPersonView setFirstReturnBlock:^(NSInteger state){
        if (state == 1) {//state==1 不同意见面
            DisagreeAlertView *alertView = [[[NSBundle mainBundle] loadNibNamed:@"DisagreeAlertView" owner:self options:nil]firstObject];
            [alertView initViewWith:@"不同意原因写在这里"];
            alertView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            [alertView setReturnBlock:^(NSString *str) {
                NSLog(@"str");
                MyRentViewModel *viewModel = [[MyRentViewModel alloc] init];
                [viewModel setBlockWithReturnBlock:^(id returnValue) {
                    [self setupRefresh];
                } WithErrorBlock:^(id errorCode) {
                    [self showJGProgressWithMsg:errorCode];
                }];
                RentOrderModel *model = self.itemArr[section];
                [viewModel handleMyRentOrderWithToken:[self getToken] Id:model.Id arrange:@(2) refundReason:str];
            }];
            [self.view addSubview: alertView];
        }
        if (state == 2) {//state==2 已见面
            MyRentViewModel *viewModel = [[MyRentViewModel alloc] init];
            [viewModel setBlockWithReturnBlock:^(id returnValue) {
                [self setupRefresh];
            } WithErrorBlock:^(id errorCode) {
                [self showJGProgressWithMsg:errorCode];
            }];
            RentOrderModel *model = self.itemArr[section];
            [viewModel comfirmMeetWithToken:[self getToken] Id:model.Id type:@(2)];
        }
        
    }];
    [myRentPersonView setSecondReturnBlock:^(NSInteger state){
        if (state == 1) {//state==1 同意见面
            //租我的人，同意
                MyRentViewModel *viewModel = [[MyRentViewModel alloc] init];
                [viewModel setBlockWithReturnBlock:^(id returnValue) {
                    [self setupRefresh];
                } WithErrorBlock:^(id errorCode) {
                    [self showJGProgressWithMsg:errorCode];
                }];
                RentOrderModel *model = self.itemArr[section];
                [viewModel handleMyRentOrderWithToken:[self getToken] Id:model.Id arrange:@(1) refundReason:@""];
        }
        if (state == 2) {//state==2 未见面
            SubmitObjectionViewController *vc = [[SubmitObjectionViewController alloc] init];
            [vc setReturnBlock:^{
                [self setupRefresh];
            }];
            vc.isUserOrRent = 2;
            RentOrderModel *model = self.itemArr[section];
            vc.orderId = model.Id;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (state == 4 || state == 5) {//state==4,5 评价
            RentRemarkView *remarkView = [[[NSBundle mainBundle] loadNibNamed:@"RentRemarkView" owner:self options:nil]firstObject];
            [remarkView initView];
            remarkView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            [remarkView setReturnBlock:^(NSString *str,NSInteger point) {
                if (str.length == 0) {
                    [self showJGProgressWithMsg:@"请输入评价"];
                    return ;
                }
                MyRentViewModel *viewModel = [[MyRentViewModel alloc] init];
                [viewModel setBlockWithReturnBlock:^(id returnValue) {
                    [self showJGProgressWithMsg:@"评价成功"];
                    [self setupRefresh];
                } WithErrorBlock:^(id errorCode) {
                    [self showJGProgressWithMsg:errorCode];
                }];
                RentOrderModel *model = self.itemArr[section];
                [viewModel remarkMyRentWithToken:[self getToken] Id:model.Id point:@(point) remark:str type:2];
            }];
            [self.view addSubview: remarkView];
        }
    }];
    RentOrderModel *model = self.itemArr[section];
    [myRentPersonView initView:model type:2];
    return myRentPersonView;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50.f;
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
