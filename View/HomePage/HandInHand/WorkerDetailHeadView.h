//
//  WorkerDetailHeadView.h
//  TheWorker
//
//  Created by yanghao on 8/29/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLCycleScrollView.h"

@interface WorkerDetailHeadView : UIView<XLCycleScrollViewDatasource,XLCycleScrollViewDelegate>{
    
    XLCycleScrollView           *csView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic,copy) void(^EndDeceleratingBlock)(void);
@property (nonatomic,copy) void(^BeginDraggingBlock)(void);
-(void)initBannerView:(NSArray *)banner;
-(void)timerStart;
@end
