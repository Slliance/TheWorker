//
//  WelfareHeadView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/14.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPRingedPages.h"
#import "BannerModel.h"
@interface HandInHandHeadView : UIView<RPRingedPagesDelegate, RPRingedPagesDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *welfareScrollView;
@property (weak, nonatomic) IBOutlet UIButton *liveBtn;
@property (weak, nonatomic) IBOutlet UIButton *loveBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@property (nonatomic, strong) RPRingedPages *pages;
@property (nonatomic, copy) void(^returnTagBlock)(NSInteger tag);

@property (nonatomic, retain) NSMutableArray        *bannerArr;

-(void)initView:(NSArray *)arr;

@end
