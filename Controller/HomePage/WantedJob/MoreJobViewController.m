//
//  MoreJobViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/30.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MoreJobViewController.h"
#import "ProvinceCityZoneView.h"
#import "SingleChooseListView.h"
#import "WantedJobTableViewCell.h"
#import "WantedJobDetailViewController.h"
#import "JobViewModel.h"
@interface MoreJobViewController ()
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UIButton *btnArea;
@property (weak, nonatomic) IBOutlet UIButton *btnJobType;
@property (weak, nonatomic) IBOutlet UIButton *btnTrade;
@property (nonatomic, assign) NSInteger typeSelectIndex;
@property (nonatomic, assign) NSInteger tradeSelectIndex;
@property (nonatomic, assign) NSInteger zoneSelectIndex;

@property (nonatomic, retain) NSMutableArray *itemArr;
@property (nonatomic, retain) JobViewModel *viewModel;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation MoreJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemArr = [[NSMutableArray alloc]init];

    [self.itemTableView registerNib:[UINib nibWithNibName:@"WantedJobTableViewCell" bundle:nil] forCellReuseIdentifier:@"WantedJobTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self.btnArea setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.btnJobType setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.btnTrade setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    
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

    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}

- (IBAction)chooseAreaAction:(id)sender {
     [[self.view viewWithTag:999] removeFromSuperview];
    
    if (self.btnArea.selected) {
        self.btnArea.selected = NO;
        return;
    }
    self.btnTrade.selected = NO;
    self.btnArea.selected = YES;
    self.btnJobType.selected = NO;
    
    ProvinceCityZoneView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"ProvinceCityZoneView" owner:self options:nil] firstObject];
    chooseView.tag = 999;
    chooseView.frame = CGRectMake(0, self.itemTableView.frame.origin.y, ScreenWidth, ScreenHeight - self.itemTableView.frame.origin.y + 10);
    chooseView.showAll = YES;
    [chooseView initView];
    [chooseView setReturnBlock:^(NSInteger provinceIndex,NSInteger CityIndex,NSInteger ZoneIndex,NSArray *zoneArr){
        
        self.btnArea.selected = NO;
        if (provinceIndex == -1) {
            [self.btnArea setTitle:@"全国" forState:UIControlStateNormal];
            self.zoneSelectIndex = 0;
        }
        else{
            [self.btnArea setTitle:zoneArr[ZoneIndex][@"Name"] forState:UIControlStateNormal];
            self.zoneSelectIndex = [zoneArr[ZoneIndex][@"Code"] integerValue];

        }
        [self.btnArea setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        [self headerRefreshing];
    }];
    [chooseView setRemoveBlock:^{
        self.btnArea.selected = NO;
    }];
    [self.view addSubview:chooseView];
    
}
- (IBAction)chooseJobType:(id)sender {
    [[self.view viewWithTag:999] removeFromSuperview];
    if (self.btnJobType.selected) {
        self.btnJobType.selected = NO;
        return;
    }
    self.btnTrade.selected = NO;
    self.btnArea.selected = NO;
    self.btnJobType.selected = YES;
    SingleChooseListView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"SingleChooseListView" owner:self options:nil] firstObject];
    chooseView.tag = 999;
    chooseView.currentSelectIndex = self.typeSelectIndex;
    chooseView.frame = CGRectMake(0, self.itemTableView.frame.origin.y, ScreenWidth, ScreenHeight - self.itemTableView.frame.origin.y + 10);
    chooseView.selectedBtnImgStr = @"icon_tick";
    chooseView.colorStr = @"6398f1";
    [chooseView initView:@[@{@"name": @"全部工种"},
                           @{@"name": @"长期工"},
                           @{@"name": @"兼职工"},
                           @{@"name": @"紧急工"}]
     ];
    [chooseView setReturnBlock:^(NSInteger index,NSArray *itemArr){
        self.btnJobType.selected = NO;
        self.typeSelectIndex = index;
        [self.btnJobType setTitle:itemArr[index][@"name"] forState:UIControlStateNormal];
        [self.btnJobType setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        [self headerRefreshing];
    }];
    [chooseView setRemoveBlock:^{
        self.btnJobType.selected = NO;
    }];
    [self.view addSubview:chooseView];
}

- (IBAction)chooseTradeType:(id)sender {
    [[self.view viewWithTag:999] removeFromSuperview];
    if (self.btnTrade.selected) {
        self.btnTrade.selected = NO;
        return;
    }
    self.btnJobType.selected = NO;
    self.btnArea.selected = NO;
    self.btnTrade.selected = YES;
    SingleChooseListView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"SingleChooseListView" owner:self options:nil] firstObject];
    chooseView.tag = 999;
    chooseView.currentSelectIndex = self.tradeSelectIndex;
    chooseView.frame = CGRectMake(0, self.itemTableView.frame.origin.y, ScreenWidth, ScreenHeight - self.itemTableView.frame.origin.y + 10);
    chooseView.selectedBtnImgStr = @"icon_tick";
    chooseView.colorStr = @"6398f1";
    [chooseView initView:@[@{@"name": @"全部行业"},
                           @{@"name": @"大型工厂"},
                           @{@"name": @"其他行业"}]
     ];
    [chooseView setReturnBlock:^(NSInteger index,NSArray *itemArr){
        self.btnTrade.selected = NO;
        self.tradeSelectIndex = index;
        [self.btnTrade setTitle:itemArr[index][@"name"] forState:UIControlStateNormal];
        [self.btnTrade setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        [self headerRefreshing];
    }];
    [chooseView setRemoveBlock:^{
        self.btnTrade.selected = NO;
    }];
    [self.view addSubview:chooseView];
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
    NSLog(@"%ld",(long)self.zoneSelectIndex);
    [self.viewModel fetchJobCategoryWithJobType:@(self.typeSelectIndex) page:@( ++ self.pageIndex) size:@(10) trade:@(self.tradeSelectIndex) zoneCode:@(self.zoneSelectIndex)];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
