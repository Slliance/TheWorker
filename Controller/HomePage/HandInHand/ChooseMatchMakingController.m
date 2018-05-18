//
//  ChooseMatchMakingController.m
//  TheWorker
//
//  Created by apple on 2018/4/27.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "ChooseMatchMakingController.h"
#import "HandInHandInformationController.h"
#import "MatchMakingInformationView.h"
#import "MatchMakingInformationController.h"
#import <ZLSwipeableView.h>
#import "ChooseMatchMakingCell.h"
#import "HandWorkerListViewController.h"
#import "V_SlideCard.h"
#import "M_TanTan.h"
#import "V_TanTan.h"
#import "WorkerHandInViewModel.h"
#import "SexChooseListView.h"
#import "SingleChooseListView.h"

@interface ChooseMatchMakingController ()<ZLSwipeableViewDelegate, ZLSwipeableViewDataSource,UITableViewDelegate,UITableViewDataSource,V_SlideCardDataSource, V_SlideCardDelegate, UICollectionViewDelegate>
{
    NSInteger _pageNo;//数据页码
    CGFloat _buttonWidth;
    CGFloat _buttonBorderWidth;
    NSInteger  curSelectSexIndex;
    NSInteger  curSelectDistanceIndex;
    NSInteger  curSelectAgeIndex;
}
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic) NSUInteger colorIndex;
@property (nonatomic, strong) NSArray *titles;
@property(nonatomic,strong)UIImageView *bgImageView;
@property(nonatomic,strong)UIImageView *backgroundImage;
@property(nonatomic,strong)MatchMakingInformationView *matchView;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIButton *editBtn;
@property (nonatomic, strong) V_SlideCard *slideCard;
//@property (nonatomic, strong) NSMutableArray *listData;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UIButton *changeBtn;
@property (strong, nonatomic)  UIButton *sexBtn;
@property (strong, nonatomic)  UIButton *ageBtn;
@property(nonatomic,strong)UILabel *lineLabel;
@property (nonatomic, retain) WorkerHandInViewModel     *viewModel;
@property (nonatomic, assign) NSInteger     pageIndex;
@property (nonatomic, retain) NSNumber     *sexIndex;
@property (nonatomic, retain) NSNumber     *minIndex;
@property (nonatomic, retain) NSNumber     *maxIndex;
@property (nonatomic, retain) NSNumber     *zoneIndex;
@property (nonatomic, retain) NSNumber     *distanceIndex;
@property (nonatomic, retain) NSMutableArray *itemArr;
@end

@implementation ChooseMatchMakingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.backBtn];
    [self.bgImageView addSubview:self.editBtn];
    [self.bgImageView addSubview:self.backgroundImage];
    [self.bgImageView addSubview:self.slideCard];//加入滑动组件
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.changeBtn];
    self.tableview.hidden = YES;
    self.sexBtn.hidden = YES;
    self.ageBtn.hidden = YES;
    self.lineLabel.hidden = YES;
    self.tableview.separatorColor = [UIColor whiteColor];
    [self.view addSubview:self.sexBtn];
    [self.view addSubview:self.ageBtn];
    [self.view addSubview:self.lineLabel];
    [self.sexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(50);
    }];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.sexBtn.mas_bottom);
    }];

    [self.ageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(50);
    }];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(114);
    }];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView);
        make.bottom.equalTo(self.bgImageView.mas_top).offset(64);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImageView);
        make.bottom.equalTo(self.bgImageView.mas_top).offset(64);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
   
    [self.backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView).offset(7);
        make.top.equalTo(self.bgImageView).offset(64);
        make.right.equalTo(self.bgImageView).offset(-7);
        make.bottom.equalTo(self.bgImageView).offset(-7);
    }];
   
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-37);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
        make.width.height.mas_equalTo(50);
    }];
    [self reloadUI];
}
-(void)reloadUI{
    curSelectAgeIndex = -1;
    curSelectDistanceIndex = -1;
    curSelectSexIndex = -1;
    self.zoneIndex = 0;
    [self.sexBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.ageBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.sexBtn setTitleColor:DSColorFromHex(0x4D4D4D) forState:UIControlStateNormal];
    [self.ageBtn setTitleColor:DSColorFromHex(0x4D4D4D) forState:UIControlStateNormal];
    [self.sexBtn setTitleColor:[UIColor colorWithHexString:@"ef5f7d"] forState:UIControlStateSelected];
    [self.ageBtn setTitleColor:[UIColor colorWithHexString:@"ef5f7d"] forState:UIControlStateSelected];
    self.itemArr = [[NSMutableArray alloc] init];
    __weak typeof(self)weakSelf = self;
    self.viewModel = [[WorkerHandInViewModel alloc] init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        if (self.pageIndex == 1) {
            [weakSelf.itemArr removeAllObjects];
            [weakSelf.tableview.mj_header endRefreshing];
        }
        else{
            [weakSelf.tableview.mj_footer endRefreshing];
        }
        [weakSelf.itemArr addObjectsFromArray:returnValue];
        
        [weakSelf.tableview reloadData];
        [weakSelf.slideCard reloadData];
        if ([(NSArray *)returnValue count] < 10) {
            [weakSelf.tableview.mj_footer removeFromSuperview];
        }
        else{
            weakSelf.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(footerRefreshing)];
        }
        
        
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    [self setupRefresh];
    
    
    
    
}
/**
 *  设置刷新
 */
-(void)setupRefresh
{
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    [self.tableview.mj_header beginRefreshing];
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

-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}
-(UIButton *)sexBtn{
    if (!_sexBtn) {
        _sexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sexBtn setTitle:@"性别" forState:UIControlStateNormal];
        [_sexBtn addTarget:self action:@selector(pressSexBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_sexBtn setImage:[UIImage imageNamed:@"gray_arrows_down"] forState:UIControlStateNormal];
        _sexBtn.backgroundColor = [UIColor whiteColor];
        [_sexBtn setTitleColor:DSColorFromHex(0x999999) forState:UIControlStateNormal];
        _sexBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _sexBtn;
}
-(UIButton *)ageBtn{
    if (!_ageBtn) {
        _ageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ageBtn setTitle:@"年龄" forState:UIControlStateNormal];
        [_ageBtn addTarget:self action:@selector(pressYearBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_ageBtn setImage:[UIImage imageNamed:@"gray_arrows_down"] forState:UIControlStateNormal];
        _ageBtn.backgroundColor = [UIColor whiteColor];
        [_ageBtn setTitleColor:DSColorFromHex(0x999999) forState:UIControlStateNormal];
        _ageBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _ageBtn;
}

-(UIButton *)changeBtn{
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn setImage:[UIImage imageNamed:@"btn_switching_lists"] forState:UIControlStateNormal];
        [_changeBtn setImage:[UIImage imageNamed:@"btn_switching_block"] forState:UIControlStateSelected];
        [_changeBtn addTarget:self action:@selector(pressChangeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeBtn;
}
-(UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = DSColorFromHex(0xE5E5E5);
    }
    return _lineLabel;
}
#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    if (self.colorIndex >= self.colors.count || self.colorIndex >= self.titles.count) {
        self.colorIndex = 0;
    }
    
    MatchMakingInformationView *view = [[MatchMakingInformationView alloc] init];
    view.frame = CGRectMake(37, 142, ScreenWidth-70,538);
    view.backgroundColor = [UIColor redColor];
    view.bgImageView.image = [UIImage imageNamed:@"photo"];
    self.colorIndex++;
    return view;
}

#pragma mark - event response

- (void)likeOrHateAction:(UIButton *)sender {
    // 按钮点击缩放效果
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.08;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.9];
    pulse.toValue= [NSNumber numberWithFloat:1.1];
    [sender.layer addAnimation:pulse forKey:nil];
    
    if (sender.tag == 520) {
        [self.slideCard animateTopCardToDirection:PanDirectionRight];
    } else {
        [self.slideCard animateTopCardToDirection:PanDirectionLeft];
    }
}

#pragma mark - V_SlideCardDataSource
- (void)loadNewDataInSlideCard:(V_SlideCard *)slideCard {
    _pageNo ++;
   [self.viewModel fetchWorkerHandInPersonListWith:[self getToken] page:++ self.pageIndex min_age:self.minIndex max_age:self.maxIndex zone_code:self.zoneIndex sex:self.sexIndex];
    [self.slideCard reloadData];
}

- (void)slideCard:(V_SlideCard *)slideCard loadNewDataInCell:(V_SlideCardCell *)cell atIndex:(NSInteger)index {
 
        V_TanTan *tantanCell = (V_TanTan *)cell;
        HandInModel *item = self.itemArr[index];
        tantanCell.dataItem = item;
   
}

- (NSInteger)numberOfItemsInSlideCard:(V_SlideCard *)slideCard {
    return self.itemArr.count;
}

#pragma mark - V_SlideCardDelegate

- (void)slideCard:(V_SlideCard *)slideCard topCell:(V_SlideCardCell *)cell didPanPercent:(CGFloat)percent withDirection:(PanDirection)direction atIndex:(NSInteger)index {
        V_TanTan *tantanCell = (V_TanTan *)cell;
        if (direction == PanDirectionRight) {
            tantanCell.iv_like.alpha = percent;
//            self.btn_like.layer.borderWidth = _buttonBorderWidth * (1 - percent);
        } else {
            tantanCell.iv_hate.alpha = percent;
//            self.btn_hate.layer.borderWidth = _buttonBorderWidth * (1 - percent);
        }
    
}

- (void)slideCard:(V_SlideCard *)slideCard topCell:(V_SlideCardCell *)cell willScrollToDirection:(PanDirection)direction atIndex:(NSInteger)index {
   
        V_TanTan *tantanCell = (V_TanTan *)cell;
        if (direction == PanDirectionRight) {
            tantanCell.iv_like.alpha = 1;
        } else {
            tantanCell.iv_hate.alpha = 1;
        }
}

- (void)slideCard:(V_SlideCard *)slideCard topCell:(V_SlideCardCell *)cell didChangedStateWithDirection:(PanDirection)direction atIndex:(NSInteger)index {
   
        V_TanTan *tantanCell = (V_TanTan *)cell;
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//            self.btn_like.layer.borderWidth = _buttonBorderWidth;
//            self.btn_hate.layer.borderWidth = _buttonBorderWidth;
            tantanCell.iv_like.alpha = 0;
            tantanCell.iv_hate.alpha = 0;
        } completion:nil];
   
}

- (void)slideCard:(V_SlideCard *)slideCard didResetFrameInCell:(V_SlideCardCell *)cell atIndex:(NSInteger)index {
   
        V_TanTan *tantanCell = (V_TanTan *)cell;
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//            self.btn_like.layer.borderWidth = _buttonBorderWidth;
//            self.btn_hate.layer.borderWidth = _buttonBorderWidth;
            tantanCell.iv_like.alpha = 0;
            tantanCell.iv_hate.alpha = 0;
        } completion:nil];
}

- (void)slideCard:(V_SlideCard *)slideCard didSelectCell:(V_SlideCardCell *)cell atIndex:(NSInteger)index {
   
        V_TanTan *tantanCell = (V_TanTan *)cell;
        NSLog(@"tantan userName = %@", tantanCell.dataItem.nickname);
    
}

#pragma mark - private methods

- (void)leftBarButtonClick {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightBarButtonClick { }

#pragma mark - getter

- (V_SlideCard *)slideCard {
    if (_slideCard == nil) {
        _slideCard = [[V_SlideCard alloc] initWithFrame:CGRectMake(0, 95, ScreenWidth, ScreenHeight-64-60)];
        _slideCard.cellScaleSpace = 0.06;
        _slideCard.cellCenterYOffset = - 100;
        
        _slideCard.cellSize = CGSizeMake(ScreenWidth-67, ScreenHeight-64-60);
        NSString *cellClassName = @"";
        cellClassName = @"V_TanTan";
        _slideCard.panDistance = 150;
        [_slideCard registerCellClassName:cellClassName];
        _slideCard.dataSource = self;
        _slideCard.delegate = self;
    }
    return _slideCard;
}

//- (NSMutableArray *)listData {
//    if (_listData == nil) {
//        _listData = [[NSMutableArray alloc] init];
//        _listData = [[self getDataSourceWithPageNo:0] copy];
//    }
//    return _listData;
//}

//- (NSMutableArray *)getDataSourceWithPageNo:(NSInteger)pageNo {
//    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
//
//    for (NSInteger i = 0; i < 10; i++) {
//        NSString *imageName = [NSString stringWithFormat:@"tantan%d%lu", 0,i];
//        NSString *nickName = [NSString stringWithFormat:@"姓名%lu%lu", pageNo,i];
//
//        [itemArray addObject:[[M_TanTan alloc] initWithImage:imageName andName:nickName andConstellation:@"某星座" andJob:@"职位" andDistance:[NSString stringWithFormat:@"%lu%lukm", pageNo,i] andAge:@"23岁"]];
//    }
//    return itemArray;
//}








-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = [UIImage imageNamed:@"bg_gradient"];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}
-(UIImageView *)backgroundImage{
    if (!_backgroundImage) {
        _backgroundImage = [[UIImageView alloc]init];
        _backgroundImage.image = [UIImage imageNamed:@"pic_frame"];
        _backgroundImage.userInteractionEnabled = YES;
    }
    return _backgroundImage;
}
-(MatchMakingInformationView *)matchView{
    if (!_matchView) {
        _matchView = [[MatchMakingInformationView alloc]init];
//        _matchView.alpha = 0.6;
        _matchView.userInteractionEnabled = YES;
        _matchView.backgroundColor = [UIColor whiteColor];
        [_matchView.inputBtn addTarget:self action:@selector(pressInputBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _matchView;
}
-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
-(UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setImage:[UIImage imageNamed:@"holdinghands_icon_edit"] forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(pressEditBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

-(void)pressInputBtn:(UIButton*)sender{
    MatchMakingInformationController *informationVC = [[MatchMakingInformationController alloc]init];
    [self.navigationController pushViewController:informationVC animated:YES];
}
-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)pressEditBtn{
    HandInHandInformationController *changeVc = [[HandInHandInformationController alloc]init];
    [self.navigationController pushViewController:changeVc animated:YES];
}
-(void)pressSexBtn:(UIButton*)sender{
    [[self.view viewWithTag:999] removeFromSuperview];
    if (self.sexBtn.selected) {
        self.sexBtn.selected = NO;
        return;
    }
    self.sexBtn.selected = YES;
    self.ageBtn.selected = NO;
    
    SexChooseListView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"SexChooseListView" owner:self options:nil] firstObject];
    chooseView.tag = 999;
    chooseView.currentSelectIndex = curSelectSexIndex;
    chooseView.frame = CGRectMake(0, self.tableview.frame.origin.y - 10, ScreenWidth, ScreenHeight - self.tableview.frame.origin.y + 10);
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

-(void)pressYearBtn:(UIButton*)sender{
    [[self.view viewWithTag:999] removeFromSuperview];
    if (self.ageBtn.selected) {
        self.ageBtn.selected = NO;
        return;
    }
    self.sexBtn.selected = NO;
    
    self.ageBtn.selected = YES;
    SingleChooseListView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"SingleChooseListView" owner:self options:nil] firstObject];
    chooseView.tag = 999;
    chooseView.currentSelectIndex = curSelectAgeIndex;
    chooseView.frame = CGRectMake(0, self.tableview.frame.origin.y - 10, ScreenWidth, ScreenHeight - self.tableview.frame.origin.y + 10);
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
-(void)presslistBtn{
    HandWorkerListViewController * listVC = [[HandWorkerListViewController alloc]init];
    [self.navigationController pushViewController:listVC animated:YES];
}
-(void)pressChangeBtn:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        self.slideCard.hidden = YES;
        self.backgroundImage.hidden = YES;
        self.tableview.hidden = NO;
        self.sexBtn.hidden = NO;
        self.ageBtn.hidden = NO;
        self.lineLabel.hidden = NO;
    }else{
        self.slideCard.hidden = NO;
        self.tableview.hidden = YES;
        self.backgroundImage.hidden = NO;
        self.sexBtn.hidden = YES;
        self.ageBtn.hidden = YES;
        self.lineLabel.hidden = YES;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"ChooseMatchMakingCell";
    ChooseMatchMakingCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[ChooseMatchMakingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    HandInModel *model = self.itemArr[indexPath.row];
    [cell setHandmodel:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
