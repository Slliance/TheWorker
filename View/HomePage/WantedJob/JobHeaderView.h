//
//  JobHeaderView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/29.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPRingedPages.h"
#import "XLCycleScrollView.h"
@interface JobHeaderView : UIView<RPRingedPagesDelegate, RPRingedPagesDataSource,UITextFieldDelegate,XLCycleScrollViewDatasource,XLCycleScrollViewDelegate,UIScrollViewDelegate>{
    
    XLCycleScrollView           *csView;
}


@property (weak, nonatomic) IBOutlet UIButton *btnLongTime;
@property (weak, nonatomic) IBOutlet UIButton *btnUrgency;
@property (weak, nonatomic) IBOutlet UIButton *btnPartTime;
@property (weak, nonatomic) IBOutlet UIScrollView *jobScrollView;


@property (nonatomic, copy) void(^returnTagBlock)(NSInteger tag);

@property (nonatomic, assign) NSInteger num;
@property (copy) NSDate *fireDate;
@property (nonatomic,copy) void(^EndDeceleratingBlock)(void);
@property (nonatomic,copy) void(^BeginDraggingBlock)(void);
@property (nonatomic,copy) void(^skipToWelfareBlock)(NSInteger blockTag);
@property (nonatomic, copy) void (^itemBlack)(NSInteger);
-(void)initBannerView:(NSArray *)banner;
-(void)timerStart;
-(void)initButtonView;
@end
