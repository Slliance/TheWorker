//
//  ShopHeadView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/16.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLCycleScrollView.h"

@interface ShopHeadView : UICollectionReusableView<XLCycleScrollViewDatasource,XLCycleScrollViewDelegate>{
    
    XLCycleScrollView           *csView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *shopScrollView;
@property (nonatomic,copy) void(^EndDeceleratingBlock)(void);
@property (nonatomic,copy) void(^BeginDraggingBlock)(void);
@property (nonatomic,copy) void(^skipToWelfareBlock)(NSInteger blockTag);
@property (nonatomic, copy) void (^itemBlack)(NSInteger);
@property (nonatomic, assign) NSInteger num;
@property (copy) NSDate *fireDate;

-(void)initBannerView:(NSArray *)banner;
-(void)timerStart;

@end
