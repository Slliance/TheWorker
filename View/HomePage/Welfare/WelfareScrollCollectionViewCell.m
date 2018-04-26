//
//  WelfareScrollCollectionViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/15.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "WelfareScrollCollectionViewCell.h"
#import <objc/runtime.h>
#import "BannerModel.h"
#import "UIView+HYExtension.h"
#import "HomePageViewController.h"
#define img_height 100
static char arrchar;

@implementation WelfareScrollCollectionViewCell
@synthesize pageControl = _pageControl;
-(void)initBannerView:(NSArray *)banner{
    __weak typeof (self)weakSelf = self;
    csView = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, img_height)];
//    csView.scrollView.scrollEnabled = NO;
        [csView addPageControlWithCount:banner.count];
    if (banner.count == 0) {
        self.noRecommendImg.hidden = NO;
        csView.scrollView.scrollEnabled = NO;
    }else{
        self.noRecommendImg.hidden = YES;
        csView.scrollView.scrollEnabled = YES;
    }
    csView.delegate = self;
    csView.datasource = self;
    csView.scrollView.backgroundColor=[UIColor lightGrayColor];
    [csView setEndDeceleratingBlock:^{
        weakSelf.EndDeceleratingBlock();
    }];
    [csView setBeginDraggingBlock:^{
        weakSelf.BeginDraggingBlock();
    }];
    [self.welfareScrollView addSubview:csView];
    [self.welfareScrollView setContentSize:CGSizeMake(ScreenWidth, img_height)];
    objc_setAssociatedObject(self, &arrchar, banner, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [csView reloadData];
}
-(void)timerStart{
    
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
    bannerImgView.contentMode = UIViewContentModeScaleToFill;
//    bannerImgView.image = [UIImage imageNamed:[arr objectAtIndex:index]];
//    [bannerImgView setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:placeholderImage_home_banner]];
    [bannerImgView setImageWithString:model.img placeHoldImageName:@"bg_no_pictures"];
    return bannerImgView;
}

- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index{
    id next = self.nextResponder;
    while (![next isKindOfClass:[UIViewController class]]) {
        next = [next nextResponder];
    }
    NSArray *arr = objc_getAssociatedObject(self, &arrchar);
    if (arr.count > 0) {
        BannerModel *model = [arr objectAtIndex:index];
        HomePageViewController *vc = (HomePageViewController *)next;
        [self bannerSkipActionWithModel:model skipVC:vc];
    }
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
