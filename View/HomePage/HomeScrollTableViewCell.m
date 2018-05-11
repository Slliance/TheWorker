//
//  HomeScrollTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/10.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HomeScrollTableViewCell.h"
#import <objc/runtime.h>
#import "UIButton+SSEdgeInsets.h"
#import "BannerModel.h"
#import "UIView+HYExtension.h"
#import "BannerWebViewController.h"
#import "HomePageViewController.h"
#define img_height 80
static char arrchar;

@implementation HomeScrollTableViewCell
@synthesize pageControl = _pageControl;
-(void)initBannerView:(NSArray *)banner{
    __weak typeof (self)weakSelf = self;
    csView = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, img_height)];
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
    [self.homeScrollView addSubview:csView];
    [self.homeScrollView setContentSize:CGSizeMake(ScreenWidth, img_height)];
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
    bannerImgView.contentMode = UIViewContentModeScaleAspectFill;
//    [bannerImgView setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
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
    HomePageViewController *homevc = (HomePageViewController *)next;
    [self bannerSkipActionWithModel:model skipVC:homevc];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
