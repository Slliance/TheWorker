//
//  WelfareScrollCollectionViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/15.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLCycleScrollView.h"
@interface WelfareScrollCollectionViewCell : UICollectionViewCell<XLCycleScrollViewDatasource,XLCycleScrollViewDelegate>{
    
    XLCycleScrollView           *csView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *welfareScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *noRecommendImg;
@property (nonatomic,copy) void(^EndDeceleratingBlock)(void);
@property (nonatomic,copy) void(^BeginDraggingBlock)(void);
@property (nonatomic,retain) AFPageControl *pageControl;
@property (nonatomic, copy) void (^itemBlack)(NSInteger);
@property (nonatomic, assign) NSInteger num;
@property (copy) NSDate *fireDate;

-(void)initBannerView:(NSArray *)banner;
-(void)timerStart;

@end
