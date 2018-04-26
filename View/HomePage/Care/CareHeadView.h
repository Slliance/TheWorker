//
//  CareHeadView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/16.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPRingedPages.h"
@interface CareHeadView : UIView<RPRingedPagesDelegate, RPRingedPagesDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *careScrollView;

@property (nonatomic, strong) RPRingedPages *pages;
@property (nonatomic, copy) void(^returnTagBlock)(NSInteger tag);



-(void)initBannerViewWith:(NSArray *)banner;

@end
