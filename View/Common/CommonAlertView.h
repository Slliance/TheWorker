//
//  CommonAlertView.h
//  TheWorker
//
//  Created by apple on 2018/5/14.
//  Copyright © 2018年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonChooseBtn.h"
typedef NS_ENUM(NSInteger,CommonAlertViewType) {
    CommonTypeLogin          = 0,//登录后
    CommonTypeCoupon        = 1,//领取优惠券
    CommonTypeCouponfinished  =2,//领取成功
    CommonTypeApplyForJob  = 3,//求职
};
@protocol CommonAlertViewDelegate <NSObject>

- (void)selectedYearBtn;
-(void)selecteddismissBtn;
-(void)commitCommonTypeLogin:(NSString *)year Sex:(NSString*)sex;
-(void)commitCommonTypeCoupon;
-(void)commitCheckPackage;
-(void)commitApplyForJob;


@end
@interface CommonAlertView : UIView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)id<CommonAlertViewDelegate>delegate;

@property(nonatomic,assign)CommonAlertViewType commonType;
@property(nonatomic,strong)UIButton *tmpBtn;
@property(nonatomic,strong)UILabel *sexLabel;
@property(nonatomic,strong)UIButton *maleBtn;
@property(nonatomic,strong)UIButton *femalemaleBtn;
@property(nonatomic,strong)UILabel *yearLabel;
@property(nonatomic,strong)CommonChooseBtn *yearBtn;
///领取优惠券、领取成功
@property(nonatomic,strong)UIImageView *checkUpImge;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UIButton *dismissBtn;

@property(nonatomic,strong)UIButton *sureBtn;

@property(nonatomic,strong)NSArray *dataArr;

@end
