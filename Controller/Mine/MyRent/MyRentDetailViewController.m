//
//  MyRentDetailViewController.m
//  TheWorker
//
//  Created by yanghao on 9/2/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "MyRentDetailViewController.h"
#import "MyRentDetailInfoTableViewCell.h"
#import "MyRentDetailBaseInfoTableViewCell.h"
#import "MyRentDetailOrderStateTableViewCell.h"
#import "MyRentDetailOrderInfoTableViewCell.h"
#import "MyRentViewModel.h"
#import "RentOrderModel.h"
#import <MapKit/MapKit.h>
#import "IDMPhotoBrowser.h"
@interface MyRentDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) RentOrderModel *rentModel;
@end

@implementation MyRentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.type integerValue] == 1) {
        self.titleLabel.text = @"我租的人-预约详情";
    }else{
        self.titleLabel.text = @"租我的人-预约详情";
    }
    [self.itemTableView registerNib:[UINib nibWithNibName:@"MyRentDetailInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyRentDetailInfoTableViewCell"];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"MyRentDetailBaseInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyRentDetailBaseInfoTableViewCell"];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"MyRentDetailOrderStateTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyRentDetailOrderStateTableViewCell"];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"MyRentDetailOrderInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyRentDetailOrderInfoTableViewCell"];
    self.rentModel = [[RentOrderModel alloc] init];
    MyRentViewModel *viewModel = [[MyRentViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        self.rentModel = returnValue;
        [self.itemTableView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchMyRentOrderDetailWithToken:[self getToken] Id:self.rentId type:self.type];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MyRentDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyRentDetailInfoTableViewCell"];
        [cell initCellWith:self.rentModel];
        [cell setSkipToMapBlock:^{
            [self skipToMap];
        }];
        return cell;
    }
    if (indexPath.section == 1) {
        MyRentDetailBaseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyRentDetailBaseInfoTableViewCell"];
        [cell initCellWith:self.rentModel];
        return cell;
    }
    if (indexPath.section == 2) {
        MyRentDetailOrderInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyRentDetailOrderInfoTableViewCell"];
        [cell initCellWith:self.rentModel];
        [cell setPhotoBlock:^(RentOrderModel *model, NSInteger index) {
            [self lookPhoto:model index:index];
        }];
        return cell;
    }
    MyRentDetailOrderStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyRentDetailOrderStateTableViewCell"];
    [cell initCellWith:self.rentModel];
    return cell;


    
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [MyRentDetailInfoTableViewCell getHeightWithModel:self.rentModel];
    }
    if (indexPath.section == 1) {
        return 140.f;
    }
    if (indexPath.section == 2) {
        return [MyRentDetailOrderInfoTableViewCell getCellHeightWithData:self.rentModel];
    }
    return [MyRentDetailOrderStateTableViewCell getCellHeightWith:self.rentModel];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, ScreenWidth, 10);
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, ScreenWidth, 10);
    view.backgroundColor = [UIColor clearColor];
    return view;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        if ([MyRentDetailOrderInfoTableViewCell getCellHeightWithData:self.rentModel] > 1) {
            return 10.f;
        }
        return 0.001f;
    }
    return 10.f;
}

//查看图片
-(void)lookPhoto:(RentOrderModel *)model index:(NSInteger)index{
    NSMutableArray *photosURL = [[NSMutableArray alloc] init];
    
    for ( int i = 0; i < model.img.count; i ++) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,model.img[i]]];
        [photosURL addObject:url];
    }
    
    // Create an array to store IDMPhoto objects
    NSMutableArray *photos = [NSMutableArray new];
    
    for (NSURL *url in photosURL) {
        IDMPhoto *photo = [IDMPhoto photoWithURL:url];
        [photos addObject:photo];
    }
    
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    [browser setInitialPageIndex:index];
    [self presentViewController:browser animated:YES completion:nil];
}


-(void)skipToMap{
    
    CLLocationCoordinate2D coor;
    coor.latitude = [self.rentModel.latitude floatValue];
    coor.longitude = [self.rentModel.longitude floatValue];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //自带地图
    [alertController addAction:[UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //使用自带地图导航
        MKMapItem *currentLocation =[MKMapItem mapItemForCurrentLocation];
        
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coor addressDictionary:nil]];
        
        [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                                   MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
        
        
    }]];
    
    //判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 高德地图");
            NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2",[self.rentModel.latitude floatValue],[self.rentModel.longitude floatValue]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:urlsting]];
            
        }]];
    }
    
    //判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 百度地图");
            NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",[self.rentModel.latitude floatValue],[self.rentModel.longitude floatValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
            
        }]];
    }
    
    //添加取消选项
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    //显示alertController
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
