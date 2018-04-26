//
//  WithdrawRecordViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "WithdrawRecordViewController.h"
#import "WithdrawRecordTableViewCell.h"
#import "WithdrawDetailViewController.h"
#import "WalletViewModel.h"
#define menu_max   999
@interface WithdrawRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray          *menuArr;
    NSInteger               currentSelectMenuIndex;
    
}
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UIScrollView *menuScrollView;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel;

@property (nonatomic, retain) WalletViewModel *viewModel;
@property (nonatomic, retain) NSMutableArray *itemArr;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation WithdrawRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    menuArr = [[NSMutableArray alloc] init];
    [menuArr addObject:@"全部"];
    [menuArr addObject:@"审核中"];
    [menuArr addObject:@"已通过"];
    [menuArr addObject:@"已退回"];
    [self initMenuScrollView];
    self.itemArr = [[NSMutableArray alloc]init];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"WithdrawRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"WithdrawRecordTableViewCell"];
    
    __weak typeof (self)weakSelf = self;
    self.viewModel = [[WalletViewModel alloc] init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        [weakSelf.itemArr addObjectsFromArray:returnValue];
        [weakSelf.itemTableView reloadData];
        if (self.pageIndex == 1) {
            [weakSelf.itemTableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }

        if ([returnValue count]<10) {
            [weakSelf.itemTableView.mj_footer removeFromSuperview];
        }
        if (self.itemArr.count == 0) {
            weakSelf.noDataView.hidden = NO;
            weakSelf.itemTableView.hidden = YES;
        }else{
            weakSelf.noDataView.hidden = YES;
            weakSelf.itemTableView.hidden = NO;
        }
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
        [weakSelf.itemTableView.mj_header endRefreshing];
        if (self.itemArr.count == 0) {
            weakSelf.noDataView.hidden = NO;
            weakSelf.itemTableView.hidden = YES;
        }
        else{
            weakSelf.noDataView.hidden = YES;
            weakSelf.itemTableView.hidden = NO;
        }
    }];
    
    [self setupRefresh];
    // Do any additional setup after loading the view from its nib.
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
    if (currentSelectMenuIndex) {
        [self.viewModel fetchWithdrawRecordWithToken:[self getToken] page:@(++ self.pageIndex) size:@(10) type:@(currentSelectMenuIndex-1)];
    }else{
        [self.viewModel fetchWithdrawRecordWithToken:[self getToken] page:@(++ self.pageIndex) size:@(10) type:@(-1)];
    }
}

-(void)initMenuScrollView{
    float menux = 0.f;
    float menuy = 0.f;
    float menuheight = 50.f;
    for (NSInteger i = 0; i < menuArr.count; i ++) {
        UIButton *menu = [UIButton buttonWithType:UIButtonTypeCustom];
        menu.frame = CGRectMake(menux, menuy, ScreenWidth/4, menuheight);
        menux += menu.frame.size.width;
        [menu setTitle:menuArr[i] forState:UIControlStateNormal];
        menu.titleLabel.font = [UIFont systemFontOfSize:15];
        [menu setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [menu setTitleColor:[UIColor colorWithHexString:@"6398f1"] forState:UIControlStateSelected];
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
    self.menuLabel.backgroundColor = [UIColor colorWithHexString:@"6398f1"];
    self.menuLabel.frame = CGRectMake(menu.frame.origin.x + menu.frame.size.width / 2 - 15, 48, 30, 2);
    menu.selected = YES;
    currentSelectMenuIndex = menu.tag - menu_max;
    [self headerRefreshing];
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WithdrawRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WithdrawRecordTableViewCell"];
    [cell initCellWithData:self.itemArr[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WithdrawDetailViewController *vc = [[WithdrawDetailViewController alloc]init];
    vc.recordModel = self.itemArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
