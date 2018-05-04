//
//  ChooseMatchMakingController.h
//  TheWorker
//
//  Created by apple on 2018/4/27.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "HYBaseViewController.h"
#import <ZLSwipeableView.h>
typedef NS_ENUM(NSInteger, HandleDirectionType) {
    HandleDirectionOn          = 0,
    HandleDirectionDown        = 1,
    HandleDirectionLeft        = 2,
    HandleDirectionRight       = 3,
};
///选择相亲人员
@interface ChooseMatchMakingController : HYBaseViewController
@property (nonatomic, strong) ZLSwipeableView *swipeableView;
//- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView;
@end
