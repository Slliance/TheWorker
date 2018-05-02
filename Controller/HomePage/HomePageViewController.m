//
//  HomePageViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/10.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HomePageViewController.h"
#import "InfomationListViewController.h"
#import "HomeHeaderView.h"
#import "HomeScrollTableViewCell.h"
#import "InfoListTableViewCell.h"
#import "InfoDetailViewController.h"
#import "WelfareViewController.h"
#import "CareViewController.h"
#import "BusinessViewController.h"
#import "HandInHandSViewController.h"
#import "WantedJobViewController.h"
#import "HomeViewModel.h"
#import "BaseDataViewModel.h"
#import "MSWeakTimer.h"
#import "UserModel.h"
#import "SearchJobViewController.h"
#import "JFLocation.h"
#import "JFAreaDataManager.h"
#import "JFCityViewController.h"
#define KCURRENTCITYINFODEFAULTS [NSUserDefaults standardUserDefaults]
@interface HomePageViewController ()<JFLocationDelegate, JFCityViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *HomePageTableView;
@property (nonatomic, retain) HomeHeaderView *headView;
@property (weak, nonatomic) IBOutlet UILabel *homeLocationLabel;
/** 城市定位管理器*/
@property (nonatomic, strong) JFLocation *locationManager;
/** 城市数据管理器*/
@property (nonatomic, strong) JFAreaDataManager *manager;
@property (weak, nonatomic) IBOutlet UITextField *homeSearchField;
@property (nonatomic, retain)HomeViewModel      *viewModel;

@property (nonatomic, retain) NSMutableArray        *bannerArr;
@property (nonatomic, retain) NSMutableArray        *banneroneArr;
@property (nonatomic, retain) NSMutableArray        *articleArr;
@property (nonatomic, retain) MSWeakTimer           *bannerTimer;
@end

@implementation HomePageViewController
-(HomeHeaderView *)headView{
    if (!_headView) {
        _headView = [[HomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 350)];
    }
    return _headView;
}
- (JFAreaDataManager *)manager {
    if (!_manager) {
        _manager = [JFAreaDataManager shareInstance];
        [_manager areaSqliteDBData];
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[JFLocation alloc] init];
    _locationManager.delegate = self;
    self.tabBarController.delegate = self;
    self.bannerArr = [[NSMutableArray alloc] init];
    self.banneroneArr = [[NSMutableArray alloc] init];
    self.articleArr = [[NSMutableArray alloc] init];
    [self.headView initButtonView];
    self.HomePageTableView.tableHeaderView = self.headView;
   
     [self setTextFieldLeftView:self.homeSearchField :@" ":20];
    __weak typeof (self)weakSelf = self;
    [self.headView setEndDeceleratingBlock:^{
        NSLog(@"");
                weakSelf.bannerTimer = [MSWeakTimer scheduledTimerWithTimeInterval:5 target:weakSelf.headView selector:@selector(timerStart) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
    }];
    [self.headView setBeginDraggingBlock:^{
        NSLog(@"");
                [weakSelf.bannerTimer invalidate];
    }];
    
    [self.headView setSkipToWelfareBlock:^(NSInteger blockTag){
        switch (blockTag) {
                case 0:
            {
                WelfareViewController *vc = [[WelfareViewController alloc]init];
                weakSelf.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
                case 1:
            {
                
                WantedJobViewController *vc = [[WantedJobViewController alloc]init];
                weakSelf.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
                case 2:
            {
                HandInHandSViewController *vc = [[HandInHandSViewController alloc]init];
                weakSelf.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
            }
                break;
                case 3:
            {
                
                CareViewController *vc = [[CareViewController alloc]init];
                weakSelf.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            
            }
                break;
                case 4:
            {
                BusinessViewController *vc = [[BusinessViewController alloc]init];
                weakSelf.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
            }
                break;
            default:
                break;
        }
        
    }];
    
    
    [self.HomePageTableView registerNib:[UINib nibWithNibName:@"HomeScrollTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeScrollTableViewCell"];
    [self.HomePageTableView registerNib:[UINib nibWithNibName:@"InfoListTableViewCell" bundle:nil] forCellReuseIdentifier:@"InfoListTableViewCell"];
    self.viewModel = [[HomeViewModel alloc] init];
    weakSelf.bannerTimer = [MSWeakTimer scheduledTimerWithTimeInterval:5 target:weakSelf.headView selector:@selector(timerStart) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        [weakSelf.HomePageTableView.mj_header endRefreshing];
        [weakSelf.bannerArr removeAllObjects];
        [weakSelf.articleArr removeAllObjects];
        [weakSelf.banneroneArr removeAllObjects];
        [weakSelf.bannerArr addObjectsFromArray:returnValue[0]];
        [weakSelf.banneroneArr addObjectsFromArray:returnValue[1]];
        [weakSelf.articleArr addObjectsFromArray:returnValue[2]];
        [weakSelf.headView initBannerView:weakSelf.bannerArr];
        [weakSelf.HomePageTableView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [weakSelf.HomePageTableView.mj_header endRefreshing];
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    
    
//    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
//        if (self.pageIndex == 1) {
//            [weakSelf.storeArray removeAllObjects];
//            [weakSelf.itemTableView.mj_header endRefreshing];
//        }else{
//            [weakSelf.itemTableView.mj_footer endRefreshing];
//        }
//
//        [weakSelf.storeArray addObjectsFromArray:returnValue];
//        [weakSelf.itemTableView reloadData];
//    } WithErrorBlock:^(id errorCode) {
//        if (self.pageIndex == 1) {
//            [weakSelf.itemTableView.mj_header endRefreshing];
//        }else{
//            [weakSelf.itemTableView.mj_footer endRefreshing];
//        }
//        [weakSelf showJGProgressWithMsg:errorCode];
//    }];
    
    [self reloadUI];
    [self setupRefresh];
}

-(void)reloadUI{
    
    //左视图默认是不显示的 设置为始终显示
    self.homeSearchField.leftViewMode= UITextFieldViewModeAlways;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = DSColorFromHex(0x999999);
    //NSAttributedString:带有属性的文字（叫富文本，可以让你的文字丰富多彩）但是这个是不可变的带有属性的文字，创建完成之后就不可以改变了  所以需要可变的
    NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc]initWithString:@"请输入地区、职位关键字" attributes:attrs];
    self.homeSearchField.attributedPlaceholder = placeHolder;
    self.homeSearchField.returnKeyType=UIReturnKeySearch;
    self.homeSearchField.delegate = self;
    self.homeSearchField.layer.shadowColor =DSColorFromHex(0x4c4c4c).CGColor;
    
    self.homeSearchField.layer.shadowOffset = CGSizeMake(4, 4);
    
    self.homeSearchField.layer.shadowOpacity = 0.3f;
    
    self.homeSearchField.layer.shadowRadius = 4.0;
    
    self.homeSearchField.layer.cornerRadius = 15.0;
    
    self.homeSearchField.clipsToBounds = NO;
    UIImage *image = [UIImage imageNamed:@"icon- 首页"];
   self.tabBarItem.selectedImage=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

///定位
- (IBAction)homeLocation:(id)sender {
    JFCityViewController *cityViewController = [[JFCityViewController alloc] init];
    cityViewController.delegate = self;
    cityViewController.title = @"城市";
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cityViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}
#pragma mark - JFCityViewControllerDelegate

- (void)cityName:(NSString *)name {
    _homeLocationLabel.text = name;
}

#pragma mark --- JFLocationDelegate
//定位中...
- (void)locating {
    NSLog(@"定位中...");
}

//定位成功
- (void)currentLocation:(NSDictionary *)locationDictionary {
    NSString *city = [locationDictionary valueForKey:@"City"];
    if (![_homeLocationLabel.text isEqualToString:city]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"您定位到%@，确定切换城市吗？",city] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _homeLocationLabel.text = city;
            [KCURRENTCITYINFODEFAULTS setObject:city forKey:@"locationCity"];
            [KCURRENTCITYINFODEFAULTS setObject:city forKey:@"currentCity"];
            [self.manager cityNumberWithCity:city cityNumber:^(NSString *cityNumber) {
                [KCURRENTCITYINFODEFAULTS setObject:cityNumber forKey:@"cityNumber"];
            }];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

/// 拒绝定位
- (void)refuseToUsePositioningSystem:(NSString *)message {
    NSLog(@"%@",message);
}

/// 定位失败
- (void)locateFailure:(NSString *)message {
    NSLog(@"%@",message);
}
///首页分享
- (IBAction)pressHomeShareBtn:(id)sender {
    if ([self isLogin]) {
        NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
        UserModel *userModel = [[UserModel alloc] initWithDict:userinfo];
        
        [self shareWithPageUrl:userModel.share shareTitle:userModel.share_title shareDes:userModel.share_content thumImage:userModel.show_img];
    }else{
        [self skiptoLogin];
    }
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    id next = self.nextResponder;
    while (![next isKindOfClass:[UIViewController class]]) {
        next = [next nextResponder];
    }
    if (textField.text.length > 0) {
        SearchJobViewController *vc = [[SearchJobViewController alloc]init];
        vc.searchKey = textField.text;
        
        vc.hidesBottomBarWhenPushed = YES;
        HomePageViewController *homevc = (HomePageViewController *)next;
        [homevc.navigationController pushViewController:vc animated:YES];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}
/**
 *  设置刷新
 */
-(void)setupRefresh
{
    self.HomePageTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    [self.HomePageTableView.mj_header beginRefreshing];
}
/**
 *  下拉刷新
 */
-(void)headerRefreshing
{
//    self.pageIndex = 0;
    [self footerRefreshing];
}
/**
 *  上拉刷新
 */
-(void)footerRefreshing
{
      [self.viewModel fetchHomeDataWithToken:[self getToken]];
}
-(void)viewDidAppear:(BOOL)animated{
    BaseDataViewModel *viewModel = [[BaseDataViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [UserDefaults writeUserDefaultObjectValue:returnValue withKey:base_data];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchBaseData];
    [self headerRefreshing];
}

- (IBAction)testAction:(id)sender {
    InfomationListViewController *vc = [[InfomationListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        if (self.articleArr.count <= 2) {
            return self.articleArr.count;
        }
        return 2;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HomeScrollTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeScrollTableViewCell"];
        [cell initBannerView:self.banneroneArr];
        [cell setEndDeceleratingBlock:^{
            NSLog(@"");
            //        weakSelf.bannerTimer = [MSWeakTimer scheduledTimerWithTimeInterval:5 target:weakSelf.headview selector:@selector(timerStart) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
        }];
        [cell setBeginDraggingBlock:^{
            NSLog(@"");
            //        [weakSelf.bannerTimer invalidate];
        }];
        
        return cell;
    }
    InfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoListTableViewCell"];
    [cell initCell:self.articleArr[indexPath.row]];
    return cell;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100.f;
    }
    return 88.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 34.f;
    }
    return 0.0001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10.f;
    }
    return 0.0001f;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        InfoDetailViewController *vc = [[InfoDetailViewController alloc]init];
        ArticleModel *model = self.articleArr[indexPath.row];
        vc.articleModel = model;
        vc.bannerUrl = model.detail_url;
        vc.articleId = model.Id;
        vc.isCollect = [model.is_collect integerValue];
        vc.type = @(6);
        vc.articleModel = model;
        [vc setReturnReloadBlock:^{
            [self footerRefreshing];
        }];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: vc animated:YES];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    if (section == 1) {
        view.frame = CGRectMake(0, 0, ScreenWidth, 34);
        view.backgroundColor = [UIColor whiteColor];
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(ScreenWidth-60, 0, 50, 34);
        [btn setTitle:@"更多" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_more-"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        [btn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -65)];
        [btn addTarget:self action:@selector(skipToEmplloyeeInfo) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *headImageView = [[UIImageView alloc]init];
        headImageView.image = [UIImage imageNamed:@"资讯"];
        headImageView.frame = CGRectMake(10, 9,15, 15);
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(35, 0, 60, 34);
        label.text = @"员工资讯";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithHexString:@"666666"];
        UILabel *lineLabel = [[UILabel alloc]init];
        lineLabel.frame = CGRectMake(0, 33, ScreenWidth, 1);
        lineLabel.backgroundColor = [UIColor colorWithHexString:@"e9e9e9"];
        [view addSubview:lineLabel];
        [view addSubview:btn];
        [view addSubview:headImageView];
        [view addSubview:label];
    }
    return view;
}

-(void)skipToEmplloyeeInfo{
    InfomationListViewController *vc = [[InfomationListViewController alloc]init];
    [vc setReturnReloadBlock:^{
        [self footerRefreshing];
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if(tabBarController.selectedIndex == 0)    //"首页"
    {
        [HYNotification postDestoryNotification:nil];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    return YES;
}


@end
