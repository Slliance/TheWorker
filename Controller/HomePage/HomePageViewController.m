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
#import "MyResumeViewController.h"
#import "ActivityDescriptionController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#define KCURRENTCITYINFODEFAULTS [NSUserDefaults standardUserDefaults]
@interface HomePageViewController ()<JFLocationDelegate, JFCityViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate,UITextFieldDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *HomePageTableView;
@property (nonatomic, retain) HomeHeaderView *headView;

@property (strong, nonatomic)UIButton *homeLocationBtn;
@property(strong,nonatomic)UIImageView *duobianImage;
/** 城市定位管理器*/
@property (nonatomic, strong) JFLocation *locationManager;
/** 城市数据管理器*/
@property (nonatomic, strong) JFAreaDataManager *manager;
@property (strong, nonatomic) UITextField *homeSearchField;
@property (nonatomic, retain)HomeViewModel      *viewModel;

@property (nonatomic, retain) NSMutableArray        *bannerArr;
@property (nonatomic, retain) NSMutableArray        *banneroneArr;
@property (nonatomic, retain) NSMutableArray        *articleArr;
@property (nonatomic, retain) MSWeakTimer           *bannerTimer;
@property (weak, nonatomic) IBOutlet UIImageView *BgNavImage;
@property (nonatomic, strong) CLLocationManager *locationManagers;//定位管理
@property (nonatomic, strong) NSString *latitude;//纬度
@property (nonatomic, strong) NSString *longitude;//经度

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
-(UIButton *)homeLocationBtn{
    if (!_homeLocationBtn) {
        _homeLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_homeLocationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _homeLocationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_homeLocationBtn addTarget:self action:@selector(pressHomeLocation:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _homeLocationBtn;
}
-(UIImageView *)duobianImage{
    if (!_duobianImage) {
        _duobianImage = [[UIImageView alloc]init];
        _duobianImage.image = [UIImage imageNamed:@"多边形 1097"];
    }
    return _duobianImage;
}
-(UITextField *)homeSearchField{
    if (!_homeSearchField) {
        _homeSearchField = [[UITextField alloc]init];
        [_homeSearchField setBackground:[UIImage imageNamed:@"input_search"]];
        _homeSearchField.font = [UIFont systemFontOfSize:12];
        _homeSearchField.textColor = DSColorFromHex(0x4D4D4D);
    }
    return _homeSearchField;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    ///定位
    self.locationManagers = [[CLLocationManager alloc] init];
    self.locationManagers.delegate = self;
    self.locationManagers.desiredAccuracy = kCLLocationAccuracyBest;//选择定位经精确度
    self.locationManagers.distanceFilter = kCLDistanceFilterNone;
    //授权，定位功能必须得到用户的授权
    [self.locationManagers requestAlwaysAuthorization];
    [self.locationManagers requestWhenInUseAuthorization];
    
    [self.locationManagers startUpdatingLocation];
    
    self.BgNavImage.userInteractionEnabled = YES;
    self.locationManager = [[JFLocation alloc] init];
    _locationManager.delegate = self;
    _homeLocationBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
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
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
                case 1:
            {
                
                WantedJobViewController *vc = [[WantedJobViewController alloc]init];
                 vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
                case 2:
            {
                HandInHandSViewController *vc = [[HandInHandSViewController alloc]init];
                 vc.hidesBottomBarWhenPushed = YES;
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
    
    [self.BgNavImage addSubview:self.homeLocationBtn];
    [self.BgNavImage addSubview:self.duobianImage];
    [self.BgNavImage addSubview:self.homeSearchField];
    
    self.homeLocationBtn.frame = CGRectMake(12, 20, 46, 44);
    self.duobianImage.frame = CGRectMake(12+6+46, 39, 9, 6);
    self.homeSearchField.frame = CGRectMake(12+12+46+9, 27, ScreenWidth-43-46-24-9, 30);

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
-(void)pressHomeLocation:(UIButton*)sender {
    JFCityViewController *cityViewController = [[JFCityViewController alloc] init];
    cityViewController.delegate = self;
    [self presentViewController:cityViewController animated:YES completion:nil];
}
#pragma mark - JFCityViewControllerDelegate

- (void)cityName:(NSString *)name {
    
    [_homeLocationBtn setTitle:name forState:UIControlStateNormal];
    if (name.length>5) {
        
        self.homeLocationBtn.frame = CGRectMake(12, 20, 80, 44);
        self.duobianImage.frame = CGRectMake(12+6+80, 39, 9, 6);
        self.homeSearchField.frame = CGRectMake(12+12+80+9, 27, ScreenWidth-43-80-24-9, 30);
    }else{
        self.homeLocationBtn.frame = CGRectMake(12, 20, name.length*16, 44);
        self.duobianImage.frame = CGRectMake(12+6+name.length*16, 39, 9, 6);
        self.homeSearchField.frame = CGRectMake(12+12+name.length*16+9, 27, ScreenWidth-43-name.length*16-24-9, 30);
    }
}

#pragma mark --- JFLocationDelegate
//定位中...
- (void)locating {
    NSLog(@"定位中...");
    
}

//定位成功
- (void)currentLocation:(NSDictionary *)locationDictionary {
    NSString *city = [locationDictionary valueForKey:@"City"];
    [self.homeLocationBtn setTitle:city forState:UIControlStateNormal];
    if (![_homeLocationBtn.titleLabel.text isEqualToString:city]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"您定位到%@，确定切换城市吗？",city] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _homeLocationBtn.titleLabel.text = city;
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
        return 80.f;
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
        return 5.f;
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

        [self.navigationController pushViewController: vc animated:YES];
//        ActivityDescriptionController *activityVC = [[ActivityDescriptionController alloc]init];
//        activityVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:activityVC animated:YES];
    }else if (indexPath.section ==0){
//        ActivityDescriptionController *activityVC = [[ActivityDescriptionController alloc]init];
//        activityVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:activityVC animated:YES];
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *loc = [locations firstObject];
    
    //获得地理位置，把经纬度赋给我们定义的属性
    self.latitude = [NSString stringWithFormat:@"%f", loc.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f", loc.coordinate.longitude];
    //也可以存入NSUserDefaults，方便在工程中方便获取
    [[NSUserDefaults standardUserDefaults] setValue:self.latitude forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setValue:self.longitude forKey:@"longitude"];
    
    //根据获取的地理位置，获取位置信息
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError * _Nullable error) {
        
        for (CLPlacemark *place in placemarks) {
            
            NSLog(@"name,%@",place.name);                      // 位置名
            
            NSLog(@"thoroughfare,%@",place.thoroughfare);      // 街道
            
            NSLog(@"subThoroughfare,%@",place.subThoroughfare);// 子街道
            
            NSLog(@"locality,%@",place.locality);              // 市
            
            NSLog(@"subLocality,%@",place.subLocality);        // 区
            
            NSLog(@"country,%@",place.country);                // 国家
//            if ([JudgeIDAndBankCardisEmptyOrNull:_gpsCityName]) {
//                _gpsCityName=@"定位失败";
//            }
//            WRITE_DATA(place.locality,@"CITY_JC_NAME");
//            [self.mytableview reloadData];
            [_homeLocationBtn setTitle:place.locality forState:UIControlStateNormal];
             [kCurrentCityInfoDefaults setObject:place.locality forKey:@"locationCity"];
        }
        
    }];
    NSLog(@"纬度=%f，经度=%f",self.latitude,self.longitude);
    [self.locationManagers stopUpdatingLocation];
    
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
        NSLog(@"拒绝访问");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        NSLog(@"无法获取位置信息");
  }
}
@end
