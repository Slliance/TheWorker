//
//  JobHeaderView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/29.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "JobHeaderView.h"
#import <objc/runtime.h>
#import "BannerModel.h"
#import "SearchJobViewController.h"
#import "WantedJobViewController.h"
#import "BannerWebViewController.h"
#import "WantedJobViewController.h"
#define img_height 156
static char arrchar;
@implementation JobHeaderView



- (IBAction)wantLongTime:(id)sender {
    self.returnTagBlock(1);
}
- (IBAction)wantUrgency:(id)sender {
    self.returnTagBlock(3);
}
- (IBAction)wantPartTime:(id)sender {
    self.returnTagBlock(2);
}


-(void)initBannerView:(NSArray *)banner{
    __weak typeof (self)weakSelf = self;
    
    csView = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, img_height)];
    csView.tag = 99;
    [csView addPageControlWithCount:banner.count];
    csView.delegate = self;
    csView.datasource = self;
    csView.scrollView.backgroundColor=[UIColor lightGrayColor];
    [csView setEndDeceleratingBlock:^{
        weakSelf.EndDeceleratingBlock();
    }];
    [csView setBeginDraggingBlock:^{
        weakSelf.BeginDraggingBlock();
    }];
    [self.jobScrollView addSubview:csView];
    [self.jobScrollView setContentSize:CGSizeMake(ScreenWidth, img_height)];
    objc_setAssociatedObject(self, &arrchar, banner, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [csView reloadData];
}


-(void)timerStart{
    NSArray *arr = objc_getAssociatedObject(self, &arrchar);
    if (arr.count) {
        [csView timerScrollView];
    }
}
- (NSInteger)numberOfPages
{
    NSArray *arr = objc_getAssociatedObject(self, &arrchar);
    return arr.count;
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    NSArray *arr = objc_getAssociatedObject(self, &arrchar);
    BannerModel *model = [arr objectAtIndex:index];
    UIImageView *bannerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, img_height)];
    bannerImgView.contentMode = UIViewContentModeScaleAspectFill;
    [bannerImgView setImageWithString:model.img placeHoldImageName:@"bg_no_pictures"];
    
    
    return bannerImgView;
}

- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index{
    id next = self.nextResponder;
    while (![next isKindOfClass:[UIViewController class]]) {
        next = [next nextResponder];
    }
    NSArray *arr = objc_getAssociatedObject(self, &arrchar);
    BannerModel *model = [arr objectAtIndex:index];
    
    if (model.url.length > 5) {
        BannerWebViewController *vc = [[BannerWebViewController alloc]init];
        vc.bannerUrl = model.url;
        vc.hidesBottomBarWhenPushed = YES;
        WantedJobViewController *homevc = (WantedJobViewController *)next;
        [homevc.navigationController pushViewController:vc animated:YES];
    }
    
}
@end
