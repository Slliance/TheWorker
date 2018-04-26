//
//  MyRentViewController.m
//  TheWorker
//
//  Created by yanghao on 9/2/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "MyRentViewController.h"
#import "MyPhotoViewController.h"
#import "MyFansViewController.h"
#import "MyRentPersonViewController.h"
#import "MyTagsViewController.h"
#import "RentRangeViewController.h"
#import "MyTagsViewController.h"
#import "RentPersonViewModel.h"
#import "MyRentViewModel.h"
#import "RentMyPersonViewController.h"
#import "NotVertificationViewController.h"
#import "VertificateDefeatViewController.h"
#import "VertificateResultViewController.h"
#import "UserModel.h"
@interface MyRentViewController ()

@property (weak, nonatomic) IBOutlet UIButton *imgBtn;
@property (weak, nonatomic) IBOutlet UIButton *rentServiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *myMarkBtn;
@property (weak, nonatomic) IBOutlet UIButton *myFansBtn;
@property (weak, nonatomic) IBOutlet UIButton *myRentBtn;
@property (weak, nonatomic) IBOutlet UIButton *rentMyBtn;
@property (weak, nonatomic) IBOutlet UILabel *rentTrustLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *beRentTrustLabel;
@property (weak, nonatomic) IBOutlet UILabel *beRentScoreLabel;
@property (nonatomic, retain) UserModel *userModel;
@property (nonatomic, retain) MyRentViewModel *viewModel;
@property (nonatomic, assign) BOOL isSetImg;

@end

@implementation MyRentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat distance = 2.f;
    CGFloat btn_w = (ScreenWidth - 5 * 2) / 4;
    
    CGRect img_rect = self.imgBtn.frame;
    img_rect.origin.x = distance;
    img_rect.size.width = btn_w;
    self.imgBtn.frame = img_rect;
    
    CGRect rentService_rect = self.rentServiceBtn.frame;
    rentService_rect.origin.x = distance * 2 + btn_w;
    rentService_rect.size.width = btn_w;
    self.rentServiceBtn.frame = rentService_rect;
    
    CGRect myMark_rect = self.myMarkBtn.frame;
    myMark_rect.origin.x = distance * 3 + btn_w * 2;
    myMark_rect.size.width = btn_w;
    self.myMarkBtn.frame = myMark_rect;
    
    CGRect myFans_rect = self.myFansBtn.frame;
    myFans_rect.origin.x = distance * 4 + btn_w * 3;
    myFans_rect.size.width = btn_w;
    self.myFansBtn.frame = myFans_rect;
    

    [self.imgBtn setImagePositionWithType:SSImagePositionTypeTop spacing:15.0f];
    [self.rentServiceBtn setImagePositionWithType:SSImagePositionTypeTop spacing:15.0f];
    [self.myMarkBtn setImagePositionWithType:SSImagePositionTypeTop spacing:15.0f];
    [self.myFansBtn setImagePositionWithType:SSImagePositionTypeTop spacing:15.0f];
    
    [self.myRentBtn setImagePositionWithType:SSImagePositionTypeTop spacing:10.0f];
    [self.rentMyBtn setImagePositionWithType:SSImagePositionTypeTop spacing:10.0f];

    __weak typeof(self)weakSelf = self;
    self.viewModel = [[MyRentViewModel alloc] init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        NSDictionary *dic = returnValue;
        NSDictionary *rentDic = dic[@"rent"];
        NSDictionary *beRentDic = dic[@"be_rent"];
        NSNumber *isShow = dic[@"is_show"];
        if ([isShow integerValue] == 0) {
            weakSelf.isSetImg = NO;
        }else{
            weakSelf.isSetImg = YES;
        }
        weakSelf.rentTrustLabel.text = [NSString stringWithFormat:@"信任值：%@",rentDic[@"trust"]];
        weakSelf.rentScoreLabel.text = [NSString stringWithFormat:@"评    分：%@",rentDic[@"point"]];
        weakSelf.beRentScoreLabel.text = [NSString stringWithFormat:@"评    分：%@",beRentDic[@"point"]];
        weakSelf.beRentTrustLabel.text = [NSString stringWithFormat:@"信任值：%@",beRentDic[@"trust"]];
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
        
    }];
    
    self.userModel = [[UserModel alloc] initWithDict:[UserDefaults readUserDefaultObjectValueForKey:user_info]];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.viewModel fetchMyRentInfoWithToken:[self getToken]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}

- (IBAction)imgAction:(id)sender {
  
    if ([self.userModel.auth integerValue] == 0) {
        NotVertificationViewController *vc = [[NotVertificationViewController alloc] init];
//        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.userModel.auth integerValue] == 1){
        VertificateResultViewController *vc = [[VertificateResultViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.userModel.auth integerValue] == 2){
        MyPhotoViewController *vc = [[MyPhotoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        VertificateDefeatViewController *vc = [[VertificateDefeatViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (IBAction)rentServiceAction:(id)sender {
    
        if ([self.userModel.auth integerValue] == 0) {//未提交
            NotVertificationViewController *vc = [[NotVertificationViewController alloc] init];
            //        vc.type = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }else if([self.userModel.auth integerValue] == 1){//审核中
            VertificateResultViewController *vc = [[VertificateResultViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([self.userModel.auth integerValue] == 2){//已通过
            if (self.isSetImg == YES) {
                RentRangeViewController *vc = [[RentRangeViewController alloc] init];
                vc.backType = 0;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self showJGProgressWithMsg:@"请先设置形象照片"];
            }
        }else{
            VertificateDefeatViewController *vc = [[VertificateDefeatViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    
    
    
}
- (IBAction)myMarkAction:(id)sender {
    if ([self.userModel.auth integerValue] == 0) {//未提交
        NotVertificationViewController *vc = [[NotVertificationViewController alloc] init];
//        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([self.userModel.auth integerValue] == 1){//审核中
        VertificateResultViewController *vc = [[VertificateResultViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.userModel.auth integerValue] == 2){//已通过
        MyTagsViewController *vc = [[MyTagsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        VertificateDefeatViewController *vc = [[VertificateDefeatViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (IBAction)myFansAction:(id)sender {
    if ([self.userModel.auth integerValue] == 0) {//未提交
        NotVertificationViewController *vc = [[NotVertificationViewController alloc] init];
//        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([self.userModel.auth integerValue] == 1){//审核中
        VertificateResultViewController *vc = [[VertificateResultViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.userModel.auth integerValue] == 2){//已通过
        MyFansViewController *vc = [[MyFansViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        VertificateDefeatViewController *vc = [[VertificateDefeatViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (IBAction)myRentAction:(id)sender {
    MyRentPersonViewController *vc = [[MyRentPersonViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)rentMyAction:(id)sender {
    if ([self.userModel.auth integerValue] == 0) {//未提交
        NotVertificationViewController *vc = [[NotVertificationViewController alloc] init];
//        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([self.userModel.auth integerValue] == 1){//审核中
        VertificateResultViewController *vc = [[VertificateResultViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.userModel.auth integerValue] == 2){//已通过
        RentMyPersonViewController *vc = [[RentMyPersonViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        VertificateDefeatViewController *vc = [[VertificateDefeatViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
