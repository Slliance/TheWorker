//
//  SearchJobViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/20.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "SearchJobViewController.h"
#import "WantedJobTableViewCell.h"
#import "WantedJobDetailViewController.h"
#import "JobViewModel.h"
@interface SearchJobViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, retain) NSMutableArray *itemArr;
@property (nonatomic, retain) JobViewModel *viewModel;
@end

@implementation SearchJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemArr = [[NSMutableArray alloc]init];
    self.txtSearchBar.text = self.searchKey;
    self.txtSearchBar.layer.masksToBounds = YES;
    self.txtSearchBar.layer.cornerRadius = 15.f;
    self.txtSearchBar.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    self.txtSearchBar.layer.borderWidth = 1;
    UIImageView *LeftViewNum = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_search_gray"]];
    //图片的显示模式
    LeftViewNum.contentMode= UIViewContentModeCenter;
    //图片的位置和大小
    LeftViewNum.frame= CGRectMake(20,0,30,30);
    //左视图默认是不显示的 设置为始终显示
    self.txtSearchBar.leftViewMode= UITextFieldViewModeAlways;
    self.txtSearchBar.leftView= LeftViewNum;
    self.txtSearchBar.returnKeyType = UIReturnKeySearch;
    self.txtSearchBar.delegate = self;
    [self.itemTableView registerNib:[UINib nibWithNibName:@"WantedJobTableViewCell" bundle:nil] forCellReuseIdentifier:@"WantedJobTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self setNeedsStatusBarAppearanceUpdate];

    self.viewModel = [[JobViewModel alloc]init];
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
        if ([weakSelf.itemArr count]<10) {
            [weakSelf.itemTableView.mj_footer removeFromSuperview];
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
//2、当前页面不在导航控制器中，需重写preferredStatusBarStyle，如下：
-(UIStatusBarStyle)preferredStatusBarStyle {
    
    //     return UIStatusBarStyleLightContent; //白色
    
    return UIStatusBarStyleDefault; //黑色
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
    [self.viewModel searchJobWithKey:self.txtSearchBar.text page:@(++ self.pageIndex) size:@(10)];
}

- (IBAction)cancelAction:(id)sender {
    [self backBtnAction:sender];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WantedJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WantedJobTableViewCell"];
    [cell initCellWithData:self.itemArr[indexPath.row]];
    return cell;
}

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
    [self.navigationController pushViewController:vc animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self setupRefresh];
    return YES;
}

@end
