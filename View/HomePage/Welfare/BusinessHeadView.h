//
//  WelfareHeadView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/14.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPRingedPages.h"

@interface BusinessHeadView : UIView<RPRingedPagesDelegate, RPRingedPagesDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *welfareScrollView;

@property (nonatomic, strong) RPRingedPages *pages;
-(void)initBannerViewWith:(NSArray *)banner;
@property (nonatomic, copy) void(^returnTagBlock)(NSInteger tag);

@end
