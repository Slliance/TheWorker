//
//  HomeScrollTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/10.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLCycleScrollView.h"
@interface HomeScrollTableViewCell : UITableViewCell<XLCycleScrollViewDatasource,XLCycleScrollViewDelegate>{
    
    XLCycleScrollView           *csView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *homeScrollView;
@property (nonatomic,copy) void(^EndDeceleratingBlock)(void);
@property (nonatomic,copy) void(^BeginDraggingBlock)(void);
@property (nonatomic,retain) AFPageControl *pageControl;
@property (nonatomic, copy) void (^itemBlack)(NSInteger);
@property (nonatomic, assign) NSInteger num;
@property (copy) NSDate *fireDate;

-(void)initBannerView:(NSArray *)banner;
-(void)timerStart;

@end
