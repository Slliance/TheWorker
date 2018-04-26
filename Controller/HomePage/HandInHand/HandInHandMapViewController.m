//
//  HandInHandMapViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/30.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HandInHandMapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "ReverseGeoCode.h"
#import <MapKit/MapKit.h>
#import "MapListTableViewCell.h"
@interface HandInHandMapViewController()<BMKLocationServiceDelegate,BMKGeneralDelegate,BMKMapViewDelegate,UITextFieldDelegate,BMKPoiSearchDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BMKLocationService          *_locService;
}
@property (nonatomic, retain) BMKMapView *mapView;
@property (nonatomic,strong) UIView * locationView;
@property (nonatomic,strong) UIImageView * locImageView;
@property (nonatomic, retain) UILabel *mainTitle;
@property (nonatomic, retain) UILabel *subTitle;
@property (nonatomic, retain) UITextField *txtSearch;
@property (nonatomic, retain) BMKPoiSearch *searcher;
@property (nonatomic, retain) NSString *cityStr;
@property (nonatomic, retain) UITableView *searchListTableView;
@property (nonatomic, retain) NSMutableArray *searchArray;
@end

@implementation HandInHandMapViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
//不使用时将delegate设置为 nil
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _locService.delegate = nil;
    _mapView.delegate = nil;
    self.txtSearch.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchArray = [[NSMutableArray alloc] init];
    self.mapModel = [[RentMapModel alloc] init];;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64.f)];
    topView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    //搜索框
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 50)];
    searchView.backgroundColor = [UIColor whiteColor];
    
    UILabel *labelTop = [[UILabel alloc] init];
    labelTop.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    labelTop.frame = CGRectMake(0, 0, ScreenWidth, 1);
    [searchView addSubview:labelTop];
    UILabel *labelBottom = [[UILabel alloc] init];
    labelBottom.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    labelBottom.frame = CGRectMake(0, 49, ScreenWidth, 1);
    [searchView addSubview:labelBottom];
    self.txtSearch = [[UITextField alloc] init];
    self.txtSearch.placeholder = @"请输入地址";
    self.txtSearch.frame = CGRectMake(30, 10, ScreenWidth - 60, 30);
    self.txtSearch.layer.masksToBounds = YES;
    self.txtSearch.layer.cornerRadius = 15.f;
    self.txtSearch.delegate = self;
    UIImageView *LeftViewNum = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_search_gray"]];
    LeftViewNum.contentMode= UIViewContentModeCenter;
    LeftViewNum.frame= CGRectMake(0,0,30,30);
    self.txtSearch.leftViewMode= UITextFieldViewModeAlways;
    self.txtSearch.leftView= LeftViewNum;
    self.txtSearch.font = [UIFont systemFontOfSize:15];
    self.txtSearch.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.txtSearch.clearButtonMode = UITextFieldViewModeAlways;
    self.txtSearch.returnKeyType = UIReturnKeySearch;
    [searchView addSubview:self.txtSearch];
    
    //显示地址区域
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(10, ScreenHeight - 65, ScreenWidth - 20, 55)];
    bottomView.layer.masksToBounds = YES;
    bottomView.layer.cornerRadius = 4.f;
    bottomView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"icon_gray_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    UIButton *comfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    comfirmBtn.frame = CGRectMake(ScreenWidth - 50, 20, 50, 44);
    [comfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    comfirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [comfirmBtn setTitleColor:[UIColor colorWithHexString:@"ef5f7d"] forState:UIControlStateNormal];
    [comfirmBtn addTarget:self action:@selector(navigationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:comfirmBtn];
    
    
    UILabel *topTitle = [[UILabel alloc] init];
    topTitle.frame = CGRectMake(0, 20, ScreenWidth, 44);
    topTitle.text = @"选择约见地址";
    topTitle.font = [UIFont systemFontOfSize:18];
    topTitle.textAlignment = NSTextAlignmentCenter;
    topTitle.textColor = [UIColor colorWithHexString:@"333333"];
    [topView addSubview:topTitle];
    
    self.mainTitle = [[UILabel alloc] init];
    self.mainTitle.frame = CGRectMake(15, 10, ScreenWidth - 50, 20);
    self.mainTitle.text = @"";
    self.mainTitle.font = [UIFont systemFontOfSize:15];
    self.mainTitle.textAlignment = NSTextAlignmentLeft;
    self.mainTitle.textColor = [UIColor colorWithHexString:@"333333"];
    [bottomView addSubview:self.mainTitle];
    
    self.subTitle = [[UILabel alloc] init];
    self.subTitle.frame = CGRectMake(15, 35, ScreenWidth, 15);
    self.subTitle.text = @"";
    self.subTitle.font = [UIFont systemFontOfSize:13];
    self.subTitle.textAlignment = NSTextAlignmentLeft;
    self.subTitle.textColor = [UIColor colorWithHexString:@"666666"];
    [bottomView addSubview:self.subTitle];
    
    
    [self.view addSubview:topView];
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    self.mapView.mapType = BMKMapTypeStandard;
    [self.view addSubview:self.mapView];
    [self.view addSubview:searchView];
    [self.view addSubview:bottomView];
    
    //搜索结果列表
    self.searchListTableView = [[UITableView alloc] init];
    self.searchListTableView.frame = CGRectMake(0, 114, ScreenWidth, ScreenHeight-114);
    self.searchListTableView.delegate = self;
    self.searchListTableView.dataSource = self;
    self.searchListTableView.hidden = YES;
    self.searchListTableView.showsVerticalScrollIndicator = NO;
    self.searchListTableView.backgroundColor = [UIColor whiteColor];
    [self.searchListTableView registerNib:[UINib nibWithNibName:@"MapListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MapListTableViewCell"];
    self.searchListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.searchListTableView];
    
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    self.mapView.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    //    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.showMapScaleBar = YES;//显示比例尺
    _mapView.zoomLevel = 17;//地图显示的级别

    // Do any additional setup after loading the view from its nib.
}
-(void)initMapView{
        self.mainTitle.text = self.mapModel.name;
        self.subTitle.text = self.mapModel.address;
    
    
    //LocationView定位在当前位置，换算为屏幕的坐标，创建的定位的图标
    
    self.locationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 28, 35)];
    self.locImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 28, 35)];
    self.locImageView.image = [UIImage imageNamed:@"icon_map_location1"];
    [self.locationView addSubview:self.locImageView];
    
    
    //把当前定位的经纬度换算为了View上的坐标
    
    CGPoint point = [self.mapView convertCoordinate:_mapView.centerCoordinate toPointToView:_mapView];
    
    //当解析出现错误的时候，会出现超出屏幕的情况，一种是大于了屏幕，一种是小于了屏幕
    if(point.x > ScreenWidth || point.x < ScreenWidth/5){
        
        point.x = _mapView.center.x;
        point.y = _mapView.center.y - 64;
        
    }
    NSLog(@"Point------%f-----%f",point.x,point.y);
    //重新定位了LocationView
    self.locationView.center = point;
    [self.locationView setFrame:CGRectMake(point.x-14, point.y-18, 28, 35)];
    //把地址信息传递到上个界面的button
    [self.mapView addSubview:self.locationView];

}

//当前页面不在导航控制器中，需重写preferredStatusBarStyle，如下：

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    //     return UIStatusBarStyleLightContent; //白色
    
    return UIStatusBarStyleDefault; //黑色
}
-(void)navigationBtnAction:(id)sender{
    
    self.returnMapModel(self.mapModel);
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)getInstalledMapAppWithEndLocation:(CLLocationCoordinate2D)endLocation
{
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=北京&mode=driving&coord_type=gcj02",endLocation.latitude,endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        baiduMapDic[@"url"] = urlString;
    }
    
}



#pragma mark - BMKGeneralDelegate
- (void)onGetPermissionState:(int)iError{
    if (iError == 0) {
        //启动LocationService
        [_locService startUserLocationService];
        
    }
}

//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
//        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
//        BMKPinAnnotationView*annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
//        if (annotationView == nil) {
//            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
//        }
//        annotationView.pinColor = BMKPinAnnotationColorPurple;
////        annotationView.canShowCallout= YES;      //设置气泡可以弹出，默认为NO
////        annotationView.animatesDrop=YES;         //设置标注动画显示，默认为NO
//        annotationView.draggable = YES;          //设置标注可以拖动，默认为NO
//        annotationView.image = [UIImage imageNamed:@"icon_map_location1"];
//        return annotationView;
//    }
//    return nil;
//}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{

    BMKCoordinateRegion region;

    region.center.latitude  = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    
    //获取城市名称
    CLGeocoder* geoCoder = [[CLGeocoder alloc]init];
    
    //根据经纬度反向地理编译出地址信息
    
    [geoCoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray*array,NSError*error){
        
        if(array.count>0){
            
            CLPlacemark*placemark = [array objectAtIndex:0];
            
            //将获得的所有信息显示到导航栏上
            
//            _titleLab.text= [NSString stringWithFormat:@"%@%@",placemark.locality,placemark.subLocality];
            
            //获取城市
            
            NSString*city = placemark.locality;
            
            if(!city) {
                
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                
                city = placemark.administrativeArea;
                
            }
            
            NSLog(@"city = %@", city);
            self.cityStr = city;
            
        }
        
        else if(error == nil && [array count] ==0)
            
        {
            
            NSLog(@"No results were returned.");
            
        }
        
        else if(error !=nil)
            
        {
            
            NSLog(@"An error occurred = %@", error);
            
        }
        
    }];
    
    region.span.latitudeDelta = 0;
    region.span.longitudeDelta = 0;
    [_mapView updateLocationData:userLocation];
    [_locService stopUserLocationService];//取消定位  这个一定要写，不然无法移动定位了
    _mapView.centerCoordinate = userLocation.location.coordinate;
    
    self.mapModel.longitude = @(userLocation.location.coordinate.longitude);
    self.mapModel.latitude = @(userLocation.location.coordinate.latitude);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[ReverseGeoCode sharedManager] reverseGeoCode:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude result:^(NSArray *cityArr) {
            self.mapModel.name = cityArr[0];
            self.mapModel.address = cityArr[1];
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = [self.mapModel.latitude floatValue];
            coor.longitude = [self.mapModel.longitude floatValue];
            annotation.coordinate = coor;
            annotation.title = self.mapModel.address;
//            [self.mapView addAnnotation:annotation];
            
            [self.mapView setCenterCoordinate:coor animated:YES];

            [self initMapView];
            
        }];
        
    });
}
- (void)didFailToLocateUserWithError:(NSError *)error{
    [self showJGProgressWithMsg:@"定位失败"];
    self.mapModel.longitude = @(self.mapView.centerCoordinate.longitude);
    self.mapModel.latitude = @(self.mapView.centerCoordinate.latitude);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[ReverseGeoCode sharedManager] reverseGeoCode:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude result:^(NSArray *cityArr) {
            self.mapModel.name = cityArr[0];
            self.mapModel.address = cityArr[1];
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = [self.mapModel.latitude floatValue];
            coor.longitude = [self.mapModel.longitude floatValue];
            annotation.coordinate = coor;
            annotation.title = self.mapModel.address;
//            [self.mapView addAnnotation:annotation];
            
            [self.mapView setCenterCoordinate:coor animated:YES];
            
            [self initMapView];
            
        }];
        
    });
}
//地图被拖动的时候，需要时时的渲染界面，当渲染结束的时候我们就去定位然后获取图片对应的经纬度

- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus*)status{
    
}

- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{



    CGPoint touchPoint = self.locationView.center;

    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
    NSLog(@"touching %f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
    self.mapModel.longitude = @(touchMapCoordinate.longitude);
    self.mapModel.latitude = @(touchMapCoordinate.latitude);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[ReverseGeoCode sharedManager] reverseGeoCode:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude result:^(NSArray *cityArr) {
//            [_locService stopUserLocationService];
            self.mapModel.name = cityArr[0];
            self.mapModel.address = cityArr[1];
            [self initMapView];
        }];
        });
    BMKReverseGeoCodeOption * option = [[BMKReverseGeoCodeOption alloc]init];
    option.reverseGeoPoint = touchMapCoordinate;
//    BOOL flag=[_searchAddress reverseGeoCode:option];

//    if (flag) {
//                _mapView.showsUserLocation=NO;//不显示自己的位置
//    }
}

#pragma mark - UITextfieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length > 0) {
        [textField resignFirstResponder];
        //初始化搜索对象 ，并设置代理
        _searcher =[[BMKPoiSearch alloc]init];
        _searcher.delegate = self;
        //请求参数类BMKCitySearchOption
        BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
        citySearchOption.pageIndex = 0;
        citySearchOption.pageCapacity = 10;
        citySearchOption.city= self.cityStr;
        citySearchOption.keyword = textField.text;
        //发起城市内POI检索
        BOOL flag = [_searcher poiSearchInCity:citySearchOption];
        if(flag) {
            NSLog(@"城市内检索发送成功");
        }
        else {
            NSLog(@"城市内检索发送失败");
        }
    }
    return YES;
}

//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        
//        NSString* _name;            ///<POI名称
//        NSString* _uid;
//        NSString* _address;        ///<POI地址
//        NSString* _city;            ///<POI所在城市
//        NSString* _phone;        ///<POI电话号码
//        NSString* _postcode;        ///<POI邮编
//        int          _epoitype;        ///<POI类型，0:普通点 1:公交站 2:公交线路 3:地铁站 4:地铁线路
//        CLLocationCoordinate2D _pt;    ///<POI坐标
        [self.searchArray removeAllObjects];
        [self.searchArray addObjectsFromArray:poiResultList.poiInfoList];
//        CGRect rect = self.searchListTableView.frame;
//        rect.size.height = self.searchArray.count * 50;
//        if (rect.size.height > ScreenHeight - 200) {
//            rect.size.height = ScreenHeight - 200;
//        }
//        self.searchListTableView.frame = rect;
        self.searchListTableView.hidden = NO;
        [self.searchListTableView reloadData];
        
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MapListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapListTableViewCell"];
    BMKPoiInfo *info = self.searchArray[indexPath.row];
//    CLLocationCoordinate2D loca = info.pt;
    NSLog(@"%@",info.name);
    NSLog(@"%@",info.address);
    NSLog(@"%@",info.city);
    NSLog(@"%d",info.epoitype);
    cell.titleLabel.text = info.name;
    cell.subTitleLabel.text = info.address;
    return cell;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.searchListTableView.hidden = YES;
    BMKPoiInfo *info = self.searchArray[indexPath.row];
    CLLocationCoordinate2D loca = info.pt;
    NSLog(@"%@",info.name);
    NSLog(@"%@",info.address);
    NSLog(@"%@",info.city);
    NSLog(@"%d",info.epoitype);
    self.mapModel.longitude = @(loca.longitude);
    self.mapModel.latitude = @(loca.latitude);
    self.mapModel.name = info.name;
    self.mapModel.address = info.address;
    self.returnMapModel(self.mapModel);
    [self.navigationController popViewControllerAnimated:YES];
    
//    //定位成功
//    BMKCoordinateRegion region;
//
//    region.center.latitude  = loca.latitude;
//    region.center.longitude = loca.longitude;
//    region.span.latitudeDelta = 0;
//    region.span.longitudeDelta = 0;
//    //        [_mapView updateLocationData:userLocation];
//    [_locService stopUserLocationService];//取消定位  这个一定要写，不然无法移动定位了
//    _mapView.centerCoordinate = loca;
//
//    self.mapModel.longitude = @(loca.longitude);
//    self.mapModel.latitude = @(loca.latitude);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[ReverseGeoCode sharedManager] reverseGeoCode:loca.latitude longitude:loca.longitude result:^(NSArray *cityArr) {
//            self.mapModel.name = cityArr[0];
//            self.mapModel.address = cityArr[1];
//            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
//            CLLocationCoordinate2D coor;
//            coor.latitude = [self.mapModel.latitude floatValue];
//            coor.longitude = [self.mapModel.longitude floatValue];
//            annotation.coordinate = coor;
//            annotation.title = self.mapModel.address;
//            //            [self.mapView addAnnotation:annotation];
//
//            [self.mapView setCenterCoordinate:coor animated:YES];
//
//            [self initMapView];
//
//        }];
//
//    });
}

@end
