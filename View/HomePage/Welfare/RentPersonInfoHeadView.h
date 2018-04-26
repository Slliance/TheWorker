//
//  RentPersonInfoHeadView.h
//  TheWorker
//
//  Created by yanghao on 8/21/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RentPersonModel.h"
#import "HandInModel.h"

#import "XLCycleScrollView.h"

@interface RentPersonInfoHeadView : UIView<XLCycleScrollViewDatasource,XLCycleScrollViewDelegate>{
    
    XLCycleScrollView           *csView;
}
@property (unsafe_unretained, nonatomic) IBOutlet UIView *redView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelTrust;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *infoBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *fansBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelLine;
@property (nonatomic, copy) void(^tagBlock)(NSInteger);
@property (weak, nonatomic) IBOutlet UIScrollView *homeScrollView;

@property (nonatomic,copy) void(^EndDeceleratingBlock)(void);
@property (nonatomic,copy) void(^BeginDraggingBlock)(void);
@property (nonatomic,copy) void(^skipToWelfareBlock)(NSInteger blockTag);
@property (nonatomic, copy) void (^itemBlack)(NSInteger);
@property (nonatomic, assign) NSInteger num;
@property (copy) NSDate *fireDate;

-(void)initViewWithModel:(RentPersonModel *)model;


-(void)initBannerView:(NSArray *)banner;
@end
