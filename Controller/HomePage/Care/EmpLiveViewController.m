//
//  EmpLiveViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/21.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "EmpLiveViewController.h"
#import "InfoListTableViewCell.h"
#import "ChooseInfoTableViewCell.h"
#import "InfoDetailViewController.h"
#import "ProvinceCityZoneView.h"
#import "SingleChooseListView.h"
#import "CareViewModel.h"
@interface EmpLiveViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIView *liveHeadView;

@property (nonatomic, retain) UIButton *areaBtn;
@property (nonatomic, retain) UIButton *priceBtn;
@property (nonatomic, retain) UIButton *HallRoomBtn;
@property (nonatomic, assign) NSInteger priceSelectedIndex;
@property (nonatomic, assign) NSInteger zoneCode;
@property (nonatomic, assign) NSInteger roomSelectedIndex;
@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, assign) NSInteger priceId;
@property (nonatomic, assign) NSInteger provinceIndex;
@property (nonatomic, assign) NSInteger cityIndex;
@property (nonatomic, assign) NSInteger zoneIndex;

@property (nonatomic, retain) CareViewModel *viewModel;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, retain) NSMutableArray *itemArr;
@end

@implementation EmpLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemArr = [[NSMutableArray alloc]init];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"InfoListTableViewCell" bundle:nil] forCellReuseIdentifier:@"InfoListTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self initHeadView];
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
    [self.viewModel fetchWorkerLiveListWithToken:[self getToken] page:@(++ self.pageIndex) size:@(10) zone_code:@(self.zoneCode) room_id:@(self.roomId) price_id:@(self.priceId)];
}

-(void)initHeadView{
    self.areaBtn = [[UIButton alloc]init];
    self.areaBtn.frame = CGRectMake(0, 0, ScreenWidth/3, 45);
    [self.areaBtn setTitle:@"区域" forState:UIControlStateNormal];
    [self.areaBtn setImage:[UIImage imageNamed:@"gray_arrows_down"] forState:UIControlStateNormal];
    [self.areaBtn setImage:[UIImage imageNamed:@"icon_bue_arrow_down"] forState:UIControlStateSelected];
    [self.areaBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.areaBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [self.areaBtn setTitleColor:[UIColor colorWithHexString:@"6398f1"] forState:UIControlStateSelected];
    [self.areaBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.areaBtn addTarget:self action:@selector(headViewAreaClickedAction) forControlEvents:UIControlEventTouchUpInside];
    //        self.areaBtn.tag = 101;
    //        self.areaBtn.selected = NO;
    //icon_bue_arrow_down
    self.priceBtn = [[UIButton alloc]init];
    self.priceBtn.frame = CGRectMake(ScreenWidth/3, 0, ScreenWidth/3, 45);
    self.priceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.priceBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [self.priceBtn setTitleColor:[UIColor colorWithHexString:@"6398f1"] forState:UIControlStateSelected];
    [self.priceBtn setTitle:@"租金" forState:UIControlStateNormal];
    [self.priceBtn setImage:[UIImage imageNamed:@"gray_arrows_down"] forState:UIControlStateNormal];
    [self.priceBtn setImage:[UIImage imageNamed:@"icon_bue_arrow_down"] forState:UIControlStateSelected];
    
    [self.priceBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.priceBtn addTarget:self action:@selector(headViewPriceClickedAction) forControlEvents:UIControlEventTouchUpInside];
    //        self.priceBtn.tag = 102;
    //        self.priceBtn.selected = self.priceIsSelected;
    
    self.HallRoomBtn = [[UIButton alloc]init];
    self.HallRoomBtn.frame = CGRectMake(2*ScreenWidth/3, 0, ScreenWidth/3, 45);
    self.HallRoomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.HallRoomBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [self.HallRoomBtn setTitleColor:[UIColor colorWithHexString:@"6398f1"] forState:UIControlStateSelected];
    [self.HallRoomBtn setTitle:@"厅室" forState:UIControlStateNormal];
    [self.HallRoomBtn setImage:[UIImage imageNamed:@"gray_arrows_down"] forState:UIControlStateNormal];
    [self.HallRoomBtn setImage:[UIImage imageNamed:@"icon_bue_arrow_down"] forState:UIControlStateSelected];
    [self.HallRoomBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.HallRoomBtn addTarget:self action:@selector(headViewHallRoomClickedAction) forControlEvents:UIControlEventTouchUpInside];
    //        self.HallRoomBtn.tag = 103;
    //        self.HallRoomBtn.selected = self.roomIsSelected;
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.frame = CGRectMake(0, 44, ScreenWidth, 1);
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self.liveHeadView addSubview:lineLabel];
    [self.liveHeadView addSubview:self.areaBtn];
    [self.liveHeadView addSubview:self.priceBtn];
    [self.liveHeadView addSubview:self.HallRoomBtn];
    
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArr.count;
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
    InfoDetailViewController *vc = [[InfoDetailViewController alloc]init];
    ArticleModel *model = self.itemArr[indexPath.row];
    vc.articleModel = model;
    vc.bannerUrl = model.detail_url;
    vc.articleId = model.Id;
    vc.isCollect = [model.is_collect integerValue];
    
    vc.type = @(5);
    [vc setReturnReloadBlock:^{
        [self headerRefreshing];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)headViewAreaClickedAction{
    [[self.view viewWithTag:999] removeFromSuperview];
    
    if (self.areaBtn.selected) {
        self.areaBtn.selected = NO;
        return;
    }
    self.HallRoomBtn.selected = NO;
    self.areaBtn.selected = YES;
    self.priceBtn.selected = NO;
    
    ProvinceCityZoneView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"ProvinceCityZoneView" owner:self options:nil] firstObject];
    chooseView.tag = 999;
    chooseView.frame = CGRectMake(0, self.itemTableView.frame.origin.y, ScreenWidth, ScreenHeight - self.itemTableView.frame.origin.y + 10);
    
    chooseView.showAll = YES;
    [chooseView initView];
//    chooseView.curProvinceIndex = self.provinceIndex;
//    chooseView.curCityIndex = self.cityIndex;
//    chooseView.curZoneIndex = self.zoneIndex;
    [chooseView setReturnBlock:^(NSInteger provinceIndex,NSInteger CityIndex,NSInteger ZoneIndex,NSArray *zoneArr){
//        self.provinceIndex = provinceIndex;
//        self.cityIndex = CityIndex;
//        self.zoneIndex = ZoneIndex;
        self.areaBtn.selected = NO;
        if (provinceIndex == -1) {
//            self.provinceIndex = -1;
            [self.areaBtn setTitle:@"全国" forState:UIControlStateNormal];
            self.zoneCode = 0;
        }else{
            self.zoneCode = [zoneArr[ZoneIndex][@"Code"] integerValue];
            [self.areaBtn setTitle:zoneArr[ZoneIndex][@"Name"] forState:UIControlStateNormal];
        }
        
        [self.areaBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        [self headerRefreshing];
    }];
    [chooseView setRemoveBlock:^{
        self.areaBtn.selected = NO;
    }];
    [self.view addSubview:chooseView];
    
}
-(void)headViewPriceClickedAction{
    [[self.view viewWithTag:999] removeFromSuperview];
    if (self.priceBtn.selected) {
        self.priceBtn.selected = NO;
        return;
    }
    self.HallRoomBtn.selected = NO;
    self.areaBtn.selected = NO;
    self.priceBtn.selected = YES;
    SingleChooseListView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"SingleChooseListView" owner:self options:nil] firstObject];
    chooseView.tag = 999;
    chooseView.currentSelectIndex = self.priceSelectedIndex;
    chooseView.frame = CGRectMake(0, self.itemTableView.frame.origin.y, ScreenWidth, ScreenHeight - self.itemTableView.frame.origin.y + 10);
    chooseView.selectedBtnImgStr = @"icon_tick";
    chooseView.colorStr = @"6398f1";
    id baseData = [UserDefaults readUserDefaultObjectValueForKey:base_data];
    NSDictionary *dic = baseData[@"care"];
    NSArray *priceArr = dic[@"price"];
    [chooseView initView:priceArr];
    [chooseView setReturnBlock:^(NSInteger index,NSArray *itemArr){
        self.priceBtn.selected = NO;
        self.priceSelectedIndex = [itemArr[index][@"price_id"] integerValue] - 1;
        self.priceId = [itemArr[index][@"price_id"] integerValue];
        [self.priceBtn setTitle:itemArr[index][@"title"] forState:UIControlStateNormal];
        [self.priceBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        [self headerRefreshing];
    }];
    [chooseView setRemoveBlock:^{
        self.priceBtn.selected = NO;
    }];
    [self.view addSubview:chooseView];
}
-(void)headViewHallRoomClickedAction{
    
    [[self.view viewWithTag:999] removeFromSuperview];
    if (self.HallRoomBtn.selected) {
        self.HallRoomBtn.selected = NO;
        return;
    }
    self.priceBtn.selected = NO;
    self.areaBtn.selected = NO;
    self.HallRoomBtn.selected = YES;
    SingleChooseListView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"SingleChooseListView" owner:self options:nil] firstObject];
    chooseView.tag = 999;
    chooseView.currentSelectIndex = self.roomSelectedIndex;
    chooseView.frame = CGRectMake(0, self.itemTableView.frame.origin.y, ScreenWidth, ScreenHeight - self.itemTableView.frame.origin.y + 10);
    chooseView.selectedBtnImgStr = @"icon_tick";
    chooseView.colorStr = @"6398f1";
    id baseData = [UserDefaults readUserDefaultObjectValueForKey:base_data];
    NSDictionary *dic = baseData[@"care"];
    NSArray *roomArr = dic[@"room"];
    [chooseView initView:roomArr];
    [chooseView setReturnBlock:^(NSInteger index,NSArray *itemArr){
        self.HallRoomBtn.selected = NO;
        self.roomSelectedIndex = [itemArr[index][@"room_id"] integerValue] - 1;
        self.roomId = [itemArr[index][@"room_id"] integerValue];
        [self.HallRoomBtn setTitle:itemArr[index][@"title"] forState:UIControlStateNormal];
        [self.HallRoomBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        [self headerRefreshing];
        
    }];
    [chooseView setRemoveBlock:^{
        self.HallRoomBtn.selected = NO;
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
