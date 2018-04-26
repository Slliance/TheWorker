//
//  JobWantedInfoViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/29.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "JobWantedInfoViewController.h"
#import "WantedJobTableViewCell.h"
#import "JobInfoHeaderView.h"
#import "WantedJobDetailViewController.h"
#import "JobViewModel.h"
@interface JobWantedInfoViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray          *menuArr;
    NSInteger               currentSelectMenuIndex;
    
}
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *menuScrollView;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel;
@property (weak, nonatomic) IBOutlet UIView *noDataView;

@property (nonatomic, retain) NSMutableArray *itemArr;
@property (nonatomic, retain) JobViewModel *viewModel;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation JobWantedInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemArr = [[NSMutableArray alloc]init];
    if (self.jobType == 1) {
        self.titleLabel.text = @"长期工招聘信息";
    }else if (self.jobType == 2){
        self.titleLabel.text = @"兼职工招聘信息";
    }else{
        self.titleLabel.text = @"紧急工招聘信息";
    }
    menuArr = [[NSMutableArray alloc] init];
    [menuArr addObject:@"大型工厂类招聘"];
    [menuArr addObject:@"其他行业类招聘"];
    [self initMenuScrollView];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"WantedJobTableViewCell" bundle:nil] forCellReuseIdentifier:@"WantedJobTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    currentSelectMenuIndex = 0;
    [self reloadView];
    // Do any additional setup after loading the view from its nib.
}

-(void)reloadView{
    
    self.viewModel = [[JobViewModel alloc] init];
    __weak typeof(self)weakSelf = self;
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        [weakSelf.itemArr addObjectsFromArray:returnValue];
        [weakSelf.itemTableView reloadData];
        if (self.pageIndex == 1) {
            [weakSelf.itemTableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
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

    
}

-(void)initMenuScrollView{
    float menux = 0.f;
    float menuy = 0.f;
    float menuheight = 50.f;
    for (NSInteger i = 0; i < menuArr.count; i ++) {
        UIButton *menu = [UIButton buttonWithType:UIButtonTypeCustom];
        menu.frame = CGRectMake(menux, menuy, ScreenWidth/2, menuheight);
        menux += menu.frame.size.width;
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
    self.menuLabel.frame = CGRectMake(menu.frame.origin.x + 20, 47, ScreenWidth/2-40, 2);
    menu.selected = YES;
    currentSelectMenuIndex = menu.tag - 800;
    [self reloadView];
//    [self headerRefreshing];
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
    [self.viewModel fetchJobCategoryWithJobType:@(self.jobType) page:@( ++ self.pageIndex) size:@(10) trade:@(currentSelectMenuIndex+1) zoneCode:nil];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WantedJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WantedJobTableViewCell"];
    [cell initCellWithData:self.itemArr[indexPath.row]];
    return cell;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 76.f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    WantedJobDetailViewController *vc = [[WantedJobDetailViewController alloc]init];
    JobModel *model = self.itemArr[indexPath.row];
    vc.jobModel = model;
    [vc setReturnReloadBlock:^(JobModel *model) {
        self.itemArr[indexPath.row] = model;
        [self.itemTableView reloadData];
    }];
    [self.navigationController pushViewController: vc animated:YES];
    
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
