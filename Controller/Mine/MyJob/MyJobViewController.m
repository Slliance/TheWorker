//
//  MyJobViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/28.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyJobViewController.h"
#import "JobDetailViewController.h"

#import "MyJobTableViewCell.h"

#import "JobViewModel.h"
#import "MyApplicationModel.h"
@interface MyJobViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray          *menuArr;
    NSInteger               currentSelectMenuIndex;
    
}
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UIScrollView *menuScrollView;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel;

@property (nonatomic, retain) UILabel *lineLabel;
@property (nonatomic, assign) NSInteger selectedTag;
@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, retain) NSMutableArray *itemArr;
@property (nonatomic, retain) JobViewModel *viewModel;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation MyJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"MyJobTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyJobTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.itemArr = [[NSMutableArray alloc]init];
  
    menuArr = [[NSMutableArray alloc] init];
    [menuArr addObject:@"全部"];
    [menuArr addObject:@"审核中"];
    [menuArr addObject:@"面试中"];
    [menuArr addObject:@"体检中"];
    [menuArr addObject:@"已入职"];
    [menuArr addObject:@"未通过"];
    [self initMenuScrollView];

    self.viewModel = [[JobViewModel alloc] init];
    __weak typeof(self)weakSelf = self;
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        if (self.pageIndex == 1) {
            [weakSelf.itemTableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
        [weakSelf.itemArr addObjectsFromArray:returnValue];
        [weakSelf.itemTableView reloadData];

        if (self.itemArr.count < 10) {
            [weakSelf.itemTableView.mj_footer removeFromSuperview];
        }else{
            weakSelf.itemTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(footerRefreshing)];
        }
//        if (self.itemArr.count == 0) {
//            weakSelf.noDataView.hidden = NO;
//            weakSelf.itemTableView.hidden = YES;
//        }else{
//            weakSelf.noDataView.hidden = YES;
//            weakSelf.itemTableView.hidden = NO;
//        }
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
        [weakSelf.itemTableView.mj_header endRefreshing];
//        if (self.itemArr.count == 0) {
//            weakSelf.noDataView.hidden = NO;
//            weakSelf.itemTableView.hidden = YES;
//        }
//        else{
//            weakSelf.noDataView.hidden = YES;
//            weakSelf.itemTableView.hidden = NO;
//        }
    }];
    [self setupRefresh];
    // Do any additional setup after loading the view from its nib.
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
        [menu setTitleColor:[UIColor colorWithHexString:@"6398f1"] forState:UIControlStateSelected];
        [menu addTarget:self action:@selector(menuSelect:) forControlEvents:UIControlEventTouchUpInside];
        menu.tag = i + 800;
        if (menu.tag == currentSelectMenuIndex + 800) {
            menu.selected = YES;
            [self menuSelect:menu];
        }
        [self.menuScrollView addSubview:menu];
    }
    [self.menuScrollView setContentSize:CGSizeMake(menux, 50)];
}
-(void)menuSelect:(UIButton *)menu{
    UIButton *lastSelectMenu = [self.menuScrollView viewWithTag:currentSelectMenuIndex + 800];
    lastSelectMenu.selected = NO;
    self.menuLabel.backgroundColor = [UIColor colorWithHexString:@"6398f1"];
    self.menuLabel.frame = CGRectMake(menu.frame.origin.x + menu.frame.size.width / 2 - 15, 47, 30, 2);
    menu.selected = YES;
    currentSelectMenuIndex = menu.tag - 800;
//    [self reloadView];
        [self headerRefreshing];
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
    NSInteger currentStatus = 0;
    //1-申请中，2-同意，3-拒绝，4-体检中，5-已入职
    switch (currentSelectMenuIndex) {
        case 1:
            currentStatus = 1;
            break;
        case 2:
            currentStatus = 2;
            break;
        case 3:
            currentStatus = 4;
            break;
        case 4:
            currentStatus = 5;
            break;
        case 5:
            currentStatus = 3;
            break;
        default:
            break;
    }
    [self.viewModel fetchMyJobApplyWithToken:[self getToken] size:nil page:@( ++ self.pageIndex) status:@(currentStatus)];
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyJobTableViewCell"];
    [cell initCellWithData:self.itemArr[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JobDetailViewController *vc = [[JobDetailViewController alloc]init];
    MyApplicationModel *model = self.itemArr[indexPath.row];
    vc.idStr = model.Id;
    [self.navigationController pushViewController:vc animated:YES];
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
