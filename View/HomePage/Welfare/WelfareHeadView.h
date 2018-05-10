//
//  WelfareHeadView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/14.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPRingedPages.h"
#import "XLCycleScrollView.h"
@interface WelfareHeadView : UIView<RPRingedPagesDelegate, RPRingedPagesDataSource,XLCycleScrollViewDatasource,XLCycleScrollViewDelegate,UIScrollViewDelegate>{
    
    XLCycleScrollView           *csView;
}
@property (weak, nonatomic) IBOutlet UIScrollView *welfareScrollView;

@property (nonatomic, copy) void(^returnTagBlock)(NSInteger tag);
@property (nonatomic, assign) NSInteger num;
@property (copy) NSDate *fireDate;
@property (nonatomic,copy) void(^EndDeceleratingBlock)(void);
@property (nonatomic,copy) void(^BeginDraggingBlock)(void);
@property (nonatomic,copy) void(^skipToWelfareBlock)(NSInteger blockTag);
@property (nonatomic, copy) void (^itemBlack)(NSInteger);
-(void)initBannerView:(NSArray *)banner;
-(void)timerStart;
@end
