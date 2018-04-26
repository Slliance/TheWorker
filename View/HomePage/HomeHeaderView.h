//
//  HomeHeaderView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/10.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLCycleScrollView.h"
#import <Masonry.h>
#import "HomeHeadBtns.h"

@interface HomeHeaderView : UIView<XLCycleScrollViewDatasource,XLCycleScrollViewDelegate,UIScrollViewDelegate>{
    
    XLCycleScrollView           *csView;
}
@property (strong, nonatomic)  UIView *buttonView;
@property (nonatomic,copy) void(^EndDeceleratingBlock)(void);
@property (nonatomic,copy) void(^BeginDraggingBlock)(void);
@property (nonatomic,copy) void(^skipToWelfareBlock)(NSInteger blockTag);
@property (nonatomic, copy) void (^itemBlack)(NSInteger);
@property (strong, nonatomic) UIScrollView *homeScrollView;
///员工福利
@property (strong, nonatomic)  HomeHeadBtns *btnWelfare;
///员工关怀
@property (strong, nonatomic)  HomeHeadBtns *btnCare;
///更多
@property (strong, nonatomic)  HomeHeadBtns *btnOther;
///员工创业
@property (strong, nonatomic)  HomeHeadBtns *btnStartBusiness;
///员工牵手
@property (strong, nonatomic)  HomeHeadBtns *btnBlindDate;
///员工求职
@property (strong, nonatomic)  HomeHeadBtns *btnJobWanted;


@property (nonatomic, assign) NSInteger num;
@property (copy) NSDate *fireDate;

-(void)initBannerView:(NSArray *)banner;
-(void)timerStart;
-(void)initButtonView;
@end
