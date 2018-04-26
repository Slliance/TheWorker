//
//  UIView+HYExtension.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/11/18.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerModel.h"
#import "HYBaseViewController.h"
@interface UIView (HYExtension)
-(void)bannerSkipActionWithModel:(BannerModel *)model skipVC:(HYBaseViewController *)skipVC;
@end
