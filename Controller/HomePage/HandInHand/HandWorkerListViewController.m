//
//  HandWorkerListViewController.m
//  TheWorker
//
//  Created by yanghao on 8/23/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "HandWorkerListViewController.h"
#import "HandPersonTableViewCell.h"
#import "SingleChooseListView.h"
#import "SexChooseListView.h"
#import "ProvinceCityView.h"
#import "WorkerDetailViewController.h"
#import "WorkerHandInViewModel.h"
#import "HandInModel.h"
@interface HandWorkerListViewController (){
    NSInteger  curSelectSexIndex;
    NSInteger  curSelectCityIndex;
    NSInteger  curSelectAgeIndex;
}
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIButton *ageBtn;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (nonatomic, retain) WorkerHandInViewModel     *viewModel;
@property (nonatomic, assign) NSInteger     pageIndex;
@property (nonatomic, retain) NSNumber     *sexIndex;
@property (nonatomic, retain) NSNumber     *minIndex;
@property (nonatomic, retain) NSNumber     *maxIndex;
@property (nonatomic, retain) NSNumber     *zoneIndex;
@property (nonatomic, retain) NSMutableArray *itemArr;
@end

@implementation HandWorkerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    curSelectAgeIndex = -1;
    curSelectCityIndex = -1;
    curSelectSexIndex = -1;
    self.zoneIndex = 0;
    [self.sexBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.cityBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.ageBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.sexBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [self.cityBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [self.ageBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"HandPersonTableViewCell" bundle:nil] forCellReuseIdentifier:@"HandPersonTableViewCell"];

    [self.sexBtn setTitleColor:[UIColor colorWithHexString:@"ef5f7d"] forState:UIControlStateSelected];
    [self.cityBtn setTitleColor:[UIColor colorWithHexString:@"ef5f7d"] forState:UIControlStateSelected];
    [self.ageBtn setTitleColor:[UIColor colorWithHexString:@"ef5f7d"] forState:UIControlStateSelected];
    self.itemArr = [[NSMutableArray alloc] init];
    
    __weak typeof(self)weakSelf = self;
    self.viewModel = [[WorkerHandInViewModel alloc] init];
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
        if ([(NSArray *)returnValue count] < 10) {
            [weakSelf.itemTableView.mj_footer removeFromSuperview];
        }
        else{
            weakSelf.itemTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(footerRefreshing)];
        }

        
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    [self setupRefresh];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [self.viewModel fetchWorkerHandInPersonListWith:[self getToken] page:++ self.pageIndex min_age:self.minIndex max_age:self.maxIndex zone_code:self.zoneIndex sex:self.sexIndex];
}

- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}

- (IBAction)sexAction:(id)sender {
    [[self.view viewWithTag:999] removeFromSuperview];
    if (self.sexBtn.selected) {
        self.sexBtn.selected = NO;
        return;
    }
    self.sexBtn.selected = YES;
    self.cityBtn.selected = NO;
    self.ageBtn.selected = NO;
    
    SexChooseListView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"SexChooseListView" owner:self options:nil] firstObject];
    chooseView.tag = 999;
    chooseView.currentSelectIndex = curSelectSexIndex;
    chooseView.frame = CGRectMake(0, self.itemTableView.frame.origin.y - 10, ScreenWidth, ScreenHeight - self.itemTableView.frame.origin.y + 10);
    chooseView.selectedBtnImgStr = @"icon_red_hook";
    chooseView.selectedMaleItemBtnImgStr = @"icon_male_selected";
    chooseView.selectedFeMaleItemBtnImgStr = @"icon_female_selected";
    chooseView.normalMaleItemBtnImgStr = @"icon_male_unselected";
    chooseView.normalFemaleItemBtnImgStr = @"icon_female_unselected-";
    chooseView.colorStr = @"ef5f7d";
    [chooseView initView:@[@{@"name": @"全部"},
                           @{@"name": @"只看男生"},
                           @{@"name": @"只看女生"}]
     ];
    [chooseView setReturnBlock:^(NSInteger index,NSArray *itemArr){
        self.sexBtn.selected = NO;
        curSelectSexIndex = index;
        if (curSelectSexIndex == 1) {
            self.sexIndex = @(1);
        }else if (curSelectSexIndex == 2){
            self.sexIndex = @(0);
        }else{
            self.sexIndex = @(2);
        }
        [self.sexBtn setTitle:itemArr[index][@"name"] forState:UIControlStateNormal];
        [self.sexBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        [self setupRefresh];
    }];
    [chooseView setRemoveBlock:^{
        self.sexBtn.selected = NO;
    }];
    [self.view addSubview:chooseView];
}
- (IBAction)cityAction:(id)sender {
    [[self.view viewWithTag:999] removeFromSuperview];
    if (self.cityBtn.selected) {
        self.cityBtn.selected = NO;
        return;
    }
    self.sexBtn.selected = NO;
    self.cityBtn.selected = YES;
    self.ageBtn.selected = NO;
    
    ProvinceCityView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"ProvinceCityView" owner:self options:nil] firstObject];
    chooseView.tag = 999;
    chooseView.frame = CGRectMake(0, self.itemTableView.frame.origin.y - 10, ScreenWidth, ScreenHeight - self.itemTableView.frame.origin.y + 10);
    chooseView.showAll = YES;
    [chooseView initView];
    [chooseView setReturnBlock:^(NSInteger provinceIndex,NSInteger CityIndex,NSArray *cityArr){
        self.cityBtn.selected = NO;
        if (provinceIndex == -1) {
            [self.cityBtn setTitle:@"全国" forState:UIControlStateNormal];
            self.zoneIndex = 0;
        }
        else{
            [self.cityBtn setTitle:cityArr[CityIndex][@"Name"] forState:UIControlStateNormal];
            self.zoneIndex = cityArr[CityIndex][@"Code"];
        }
        [self.cityBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        [self setupRefresh];
    }];
    [chooseView setRemoveBlock:^{
        self.cityBtn.selected = NO;
    }];
    [self.view addSubview:chooseView];
}
- (IBAction)ageAction:(id)sender {
    [[self.view viewWithTag:999] removeFromSuperview];
    if (self.ageBtn.selected) {
        self.ageBtn.selected = NO;
        return;
    }
    self.sexBtn.selected = NO;
    self.cityBtn.selected = NO;
    self.ageBtn.selected = YES;
    SingleChooseListView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"SingleChooseListView" owner:self options:nil] firstObject];
    chooseView.tag = 999;
    chooseView.currentSelectIndex = curSelectAgeIndex;
    chooseView.frame = CGRectMake(0, self.itemTableView.frame.origin.y - 10, ScreenWidth, ScreenHeight - self.itemTableView.frame.origin.y + 10);
    chooseView.selectedBtnImgStr = @"icon_red_hook";
    chooseView.colorStr = @"ef5f7d";
    [chooseView initView:@[@{@"name": @"全部"},
                           @{@"name": @"20岁以下"},
                           @{@"name": @"20-24岁"},
                           @{@"name": @"25-30岁"},
                           @{@"name": @"31-34岁"},
                           @{@"name": @"35-40岁"},
                           @{@"name": @"40岁以上"}]
     ];
    [chooseView setReturnBlock:^(NSInteger index,NSArray *itemArr){
        self.ageBtn.selected = NO;
        curSelectAgeIndex = index;
        
        [self.ageBtn setTitle:itemArr[index][@"name"] forState:UIControlStateNormal];
        [self.ageBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        if (index == 1) {
            NSString*string = itemArr[index][@"name"];
            string = [string substringWithRange:NSMakeRange(0, 2)];//截取范围类的字符串
            self.minIndex = 0;
            self.maxIndex = [NSNumber numberWithInteger:[string integerValue]];
        }else if (index == 6){
            NSString*string = itemArr[index][@"name"];
            string = [string substringWithRange:NSMakeRange(0, 2)];//截取范围类的字符串
            self.minIndex = [NSNumber numberWithInteger:[string integerValue]];
            self.maxIndex = 0;
        }else if (index == 0){
            self.minIndex = 0;
            self.maxIndex = 0;
        }else{
            NSString*string = itemArr[index][@"name"];
            NSString *string1 = [string substringWithRange:NSMakeRange(0, 2)];//截取范围类的字符串
            NSString *string2 = [string substringWithRange:NSMakeRange(3, 2)];//截取范围类的字符串
            self.minIndex = [NSNumber numberWithInteger:[string1 integerValue]];
            self.maxIndex = [NSNumber numberWithInteger:[string2 integerValue]];
        }
        [self setupRefresh];
    }];
    [chooseView setRemoveBlock:^{
        self.ageBtn.selected = NO;
    }];
    [self.view addSubview:chooseView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.itemArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HandPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HandPersonTableViewCell"];
    [cell initCell:self.itemArr[indexPath.section]];
    return cell;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.f;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WorkerDetailViewController *detail = [[WorkerDetailViewController alloc] init];
    HandInModel *model = self.itemArr[indexPath.section];
    detail.handInId = model.Id;
    [self.navigationController pushViewController:detail animated:YES];

}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, ScreenWidth, 10);
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
