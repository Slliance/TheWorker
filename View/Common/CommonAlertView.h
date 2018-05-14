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
    CommonTypeCouponFinished        = 2,//领取完成
    
};
@interface CommonAlertView : UIView
@property(nonatomic,assign)CommonAlertViewType commonType;
@property(nonatomic,strong)UIButton *tmpBtn;
@property(nonatomic,strong)UILabel *sexLabel;
@property(nonatomic,strong)UIButton *maleBtn;
@property(nonatomic,strong)UIButton *femalemaleBtn;
@property(nonatomic,strong)UILabel *yearLabel;
@property(nonatomic,strong)CommonChooseBtn *yearBtn;

@property(nonatomic,strong)UIButton *sureBtn;


@end
