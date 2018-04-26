//
//  EmployeeFoodViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/17.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "EmployeeFoodViewController.h"
#import "InfoListTableViewCell.h"
#import "ChooseAreaTableViewCell.h"
#import "InfoDetailViewController.h"
#import "ProvinceView.h"
#import "CareViewModel.h"
@interface EmployeeFoodViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIView *foodHeadView;

@property (nonatomic, retain) UIButton *provinceBtn;
@property (nonatomic, retain) UIButton *cityBtn;
@property (nonatomic, retain) UIButton *areaBtn;
@property (nonatomic, retain) UITableView *locationTableView;
@property (nonatomic, retain) UIView *tableBgView;

@property (nonatomic, retain) NSArray *provinceArr;
@property (nonatomic, retain) NSArray *cityArr;
@property (nonatomic, retain) NSArray *areaArr;
@property (nonatomic, retain) NSMutableArray *selectedArr;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, assign) NSInteger areaId;
@property (nonatomic, assign) NSInteger zoneCode;
@property (nonatomic, retain) CareViewModel *viewModel;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, retain) NSMutableArray *itemArr;
@end

@implementation EmployeeFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemArr = [[NSMutableArray alloc]init];
    FMDBHandle *handle = [FMDBHandle sharedManager];
    
    [handle copySqliteFileToDocmentWithFileName:sql_file_name];

    [self.itemTableView registerNib:[UINib nibWithNibName:@"InfoListTableViewCell" bundle:nil] forCellReuseIdentifier:@"InfoListTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableBgView = [[UIView alloc]init];
    self.tableBgView.frame = CGRectMake(0, 110, ScreenWidth, ScreenHeight-110);
    self.tableBgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f];
    self.tableBgView.hidden = YES;
    [self.view addSubview:self.tableBgView];
    self.locationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 405) style:UITableViewStylePlain];
    self.locationTableView.delegate = self;
    self.locationTableView.dataSource = self;
    [self.locationTableView registerNib:[UINib nibWithNibName:@"ChooseAreaTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChooseAreaTableViewCell"];
    self.locationTableView.hidden = YES;
    [self.tableBgView addSubview:self.locationTableView];
    self.provinceId = -1;
    self.cityId = -1;
    self.areaId = 0;
    __weak typeof (self)weakSelf = self;
    
    self.viewModel = [[CareViewModel alloc] init];
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

    [self initFoodHeadView];
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
    [self footerRefreshing];
}
/**
 *  上拉刷新
 */
-(void)footerRefreshing
{
    [self.viewModel fetchWorkerFoodListWithToken:[self getToken] page:@(++ self.pageIndex) size:@(10) zone_code:@(self.zoneCode)];
}


-(void)initFoodHeadView{
        self.provinceBtn = [[UIButton alloc]init];
        self.provinceBtn.frame = CGRectMake(0, 0, ScreenWidth/3, 45);
        [self.provinceBtn setTitle:@"省份" forState:UIControlStateNormal];
        [self.provinceBtn setImage:[UIImage imageNamed:@"gray_arrows_down"] forState:UIControlStateNormal];
        [self.provinceBtn setImage:[UIImage imageNamed:@"icon_bue_arrow_down"] forState:UIControlStateSelected];
        [self.provinceBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.provinceBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [self.provinceBtn setTitleColor:[UIColor colorWithHexString:@"6398f1"] forState:UIControlStateSelected];
        [self.provinceBtn addTarget:self action:@selector(headViewProClickedAction) forControlEvents:UIControlEventTouchUpInside];
        self.provinceBtn.tag = 101;
        self.provinceBtn.selected = NO;
        
        [self.provinceBtn setImagePositionWithType:SSImagePositionTypeRight spacing:10.f];
        
        //icon_bue_arrow_down
        self.cityBtn = [[UIButton alloc]init];
        self.cityBtn.frame = CGRectMake(ScreenWidth/3, 0, ScreenWidth/3, 45);
        self.cityBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.cityBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [self.cityBtn setTitleColor:[UIColor colorWithHexString:@"6398f1"] forState:UIControlStateSelected];
        [self.cityBtn setTitle:@"城市" forState:UIControlStateNormal];
        [self.cityBtn setImage:[UIImage imageNamed:@"gray_arrows_down"] forState:UIControlStateNormal];
        [self.cityBtn setImage:[UIImage imageNamed:@"icon_bue_arrow_down"] forState:UIControlStateSelected];
        [self.cityBtn setImagePositionWithType:SSImagePositionTypeRight spacing:10.f];
        
        [self.cityBtn addTarget:self action:@selector(headViewCityClickedAction) forControlEvents:UIControlEventTouchUpInside];
        self.cityBtn.tag = 102;
        self.cityBtn.selected = NO;
        
        self.areaBtn = [[UIButton alloc]init];
        self.areaBtn.frame = CGRectMake(2*ScreenWidth/3, 0, ScreenWidth/3, 45);
        self.areaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.areaBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [self.areaBtn setTitleColor:[UIColor colorWithHexString:@"6398f1"] forState:UIControlStateSelected];
        [self.areaBtn setTitle:@"区域" forState:UIControlStateNormal];
        [self.areaBtn setImage:[UIImage imageNamed:@"gray_arrows_down"] forState:UIControlStateNormal];
        [self.areaBtn setImage:[UIImage imageNamed:@"icon_bue_arrow_down"] forState:UIControlStateSelected];
        [self.areaBtn setImagePositionWithType:SSImagePositionTypeRight spacing:10.f];
        
        [self.areaBtn addTarget:self action:@selector(headViewAreaClickedAction) forControlEvents:UIControlEventTouchUpInside];
        self.areaBtn.tag = 103;
        self.areaBtn.selected = NO;
        UILabel *lineLabel = [[UILabel alloc]init];
        lineLabel.frame = CGRectMake(0, 44, ScreenWidth, 1);
        lineLabel.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
        [self.foodHeadView addSubview:lineLabel];
        [self.foodHeadView addSubview:self.provinceBtn];
        [self.foodHeadView addSubview:self.cityBtn];
        [self.foodHeadView addSubview:self.areaBtn];


}

- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.itemTableView) {
        return self.itemArr.count;
    }
    return self.selectedArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        InfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoListTableViewCell"];
    [cell initCell:self.itemArr[indexPath.row]];
        return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88.f;
   
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        InfoDetailViewController *vc = [[InfoDetailViewController alloc]init];
        ArticleModel *model = self.itemArr[indexPath.row];
        vc.bannerUrl = model.detail_url;
        vc.articleId = model.Id;
        vc.isCollect = [model.is_collect integerValue];
        vc.type = @(4);
        vc.articleModel = model;
        [vc setReturnReloadBlock:^{
            [self headerRefreshing];
        }];
        [self.navigationController pushViewController:vc animated:YES];
}
//区
-(void)headViewAreaClickedAction{
    if (self.provinceId == -1) {
        [self showJGProgressWithMsg:@"请选择省份"];
        return;
    }
    if (self.cityId == -1) {
        [self showJGProgressWithMsg:@"请选择城市"];
        return;
    }
    [[self.view viewWithTag:999] removeFromSuperview];
    
    if (self.areaBtn.selected) {
        self.areaBtn.selected = NO;
        return;
    }
    self.cityBtn.selected = NO;
    self.areaBtn.selected = YES;
    self.provinceBtn.selected = NO;
    
    ProvinceView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"ProvinceView" owner:self options:nil] firstObject];
    chooseView.tag = 999;
    chooseView.code = self.cityArr[self.cityId][@"Code"];
    chooseView.curProvinceIndex = self.areaId;
    chooseView.frame = CGRectMake(0, self.itemTableView.frame.origin.y, ScreenWidth, ScreenHeight - self.itemTableView.frame.origin.y + 10);
    [chooseView initView];
    [chooseView setReturnBlock:^(NSInteger provinceIndex,NSArray *zoneArr){
        self.areaBtn.selected = NO;
        [self.areaBtn setTitle:zoneArr[provinceIndex][@"Name"] forState:UIControlStateNormal];
        [self.areaBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        self.areaId = provinceIndex;
        self.zoneCode = [zoneArr[provinceIndex][@"Code"] integerValue];
        [self headerRefreshing];
    }];
    chooseView.showIcon = YES;
    chooseView.iconColorStr = @"6398f1";
    [chooseView setRemoveBlock:^{
        self.areaBtn.selected = NO;
    }];
    [self.view addSubview:chooseView];
}
//市
-(void)headViewCityClickedAction{
    if (self.provinceId == -1) {
        [self showJGProgressWithMsg:@"请选择省份"];
        return;
    }
    [[self.view viewWithTag:999] removeFromSuperview];
    
    if (self.cityBtn.selected) {
        self.cityBtn.selected = NO;
        return;
    }
    self.provinceBtn.selected = NO;
    self.cityBtn.selected = YES;
    self.areaBtn.selected = NO;
    
    ProvinceView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"ProvinceView" owner:self options:nil] firstObject];
    chooseView.tag = 999;
    chooseView.code = self.provinceArr[self.provinceId][@"Code"];
    chooseView.curProvinceIndex = self.cityId;
    chooseView.frame = CGRectMake(0, self.itemTableView.frame.origin.y, ScreenWidth, ScreenHeight - self.itemTableView.frame.origin.y + 10);
    [chooseView initView];
    [chooseView setReturnBlock:^(NSInteger provinceIndex,NSArray *zoneArr){
        self.cityBtn.selected = NO;
        [self.cityBtn setTitle:zoneArr[provinceIndex][@"Name"] forState:UIControlStateNormal];
        [self.cityBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        if (self.cityId != provinceIndex) {
            [self.areaBtn setTitle:@"区域" forState:UIControlStateNormal];
            self.areaId = 0;
            [self.areaBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        }
        self.zoneCode = [zoneArr[provinceIndex][@"Code"] integerValue];
        [self headerRefreshing];
        self.cityId = provinceIndex;
        self.cityArr = zoneArr;
    }];
    chooseView.showIcon = YES;
    chooseView.iconColorStr = @"6398f1";
    [chooseView setRemoveBlock:^{
        self.cityBtn.selected = NO;
    }];
    [self.view addSubview:chooseView];

}
//省
-(void)headViewProClickedAction{
    [[self.view viewWithTag:999] removeFromSuperview];
    
    if (self.provinceBtn.selected) {
        self.provinceBtn.selected = NO;
        return;
    }
    self.cityBtn.selected = NO;
    self.provinceBtn.selected = YES;
    self.areaBtn.selected = NO;
    
    ProvinceView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"ProvinceView" owner:self options:nil] firstObject];
    chooseView.tag = 999;
    chooseView.code = @"0";
    if (self.provinceId == -1) {
        self.provinceId = 0;
    }
    chooseView.curProvinceIndex = self.provinceId;
    chooseView.frame = CGRectMake(0, self.itemTableView.frame.origin.y, ScreenWidth, ScreenHeight - self.itemTableView.frame.origin.y + 10);
    [chooseView initView];
    [chooseView setReturnBlock:^(NSInteger provinceIndex,NSArray *zoneArr){
        self.provinceBtn.selected = NO;
        [self.provinceBtn setTitle:zoneArr[provinceIndex][@"Name"] forState:UIControlStateNormal];
        [self.provinceBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        if (self.provinceId != provinceIndex) {
            [self.cityBtn setTitle:@"城市" forState:UIControlStateNormal];
            [self.areaBtn setTitle:@"区域" forState:UIControlStateNormal];
            self.cityId = -1;
            [self.cityBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
            [self.areaBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        }
        self.zoneCode = [zoneArr[provinceIndex][@"Code"] integerValue];
        [self headerRefreshing];
        self.provinceId = provinceIndex;
        self.provinceArr = zoneArr;
    }];
    chooseView.showIcon = YES;
    chooseView.iconColorStr = @"6398f1";
    [chooseView setRemoveBlock:^{
        self.provinceBtn.selected = NO;
    }];
    [self.view addSubview:chooseView];
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
