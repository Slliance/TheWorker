//
//  WelfareHeadView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/14.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "WelfareHeadView.h"
#import <objc/runtime.h>
#import "BannerModel.h"
#import "WelfareViewController.h"
#import "BannerWebViewController.h"
#import "GoodsDetailViewController.h"
#import "UIView+HYExtension.h"
static char arrchar;
#define img_height 156

@implementation WelfareHeadView

//- (RPRingedPages *)pages {
//    if (_pages == nil) {
//        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//        CGRect pagesFrame = CGRectMake(0, 10, screenWidth, 140);
//
//        RPRingedPages *pages = [[RPRingedPages alloc] initWithFrame:pagesFrame];
//        CGFloat height = pagesFrame.size.height - pages.pageControlHeight - pages.pageControlMarginTop - pages.pageControlMarginBottom;
//        pages.carousel.mainPageSize = CGSizeMake(screenWidth - 20 * 2, height);
//        pages.carousel.pageScale = 0.92;
//        pages.dataSource = self;
//        pages.delegate = self;
//        [pages.pageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"icon_dot_selected"]];
//        [pages.pageControl setPageIndicatorImage:[UIImage imageNamed:@"icon_dot_not_selected"]];
//
//        _pages = pages;
//    }
//    return _pages;
//}
//
//-(void)initBannerViewWith:(NSArray *)banner{
//    objc_setAssociatedObject(self, &arrchar, banner, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    if (banner.count == 1) {
//        BannerModel *model = banner[0];
//        UIImageView *headImgView = [[UIImageView alloc] init];
//        headImgView.frame = CGRectMake(0, 0, ScreenWidth, 145);
//        [headImgView setImageWithString:model.img placeHoldImageName:placeholderImage_home_banner];
//        [self addSubview:headImgView];
//
//    }else{
//        [self addSubview:self.pages];
//        [self.pages reloadData];
//    }
//    [self addSubview:self.pages];
//    [self.pages reloadData];
//
//
//}
//
//- (NSInteger)numberOfItemsInRingedPages:(RPRingedPages *)pages {
//    NSArray *arr = objc_getAssociatedObject(self, &arrchar);
//    return arr.count;
//}
//- (UIView *)ringedPages:(RPRingedPages *)pages viewForItemAtIndex:(NSInteger)index {
//
//    NSArray *array = objc_getAssociatedObject(self, &arrchar);
//    BannerModel *model = [array objectAtIndex:index];
//    UIImageView *bannerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
//    bannerImgView.frame = CGRectMake(2, 2, 2, 2);
//    bannerImgView.contentMode = UIViewContentModeScaleToFill;
////    [bannerImgView setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
//    [bannerImgView setImageWithString:model.img placeHoldImageName:@"bg_no_pictures"];
//    bannerImgView.layer.masksToBounds = YES;
//    bannerImgView.layer.cornerRadius = 4.f;
//    UIView *shadowView = [[UIView alloc]initWithFrame:bannerImgView.frame];
//
//    shadowView.layer.shadowColor = [UIColor colorWithHexString:@"a4c1f1"].CGColor;
//
//    shadowView.layer.shadowOffset = CGSizeMake(4, 4);
//
//    shadowView.layer.shadowOpacity = 0.5f;
//
//    shadowView.layer.shadowRadius = 4.0;
//
//    shadowView.layer.cornerRadius = 4.0;
//
//    //    shadowView.clipsToBounds = NO;
//
//    [shadowView addSubview:bannerImgView];
//
//    return bannerImgView;
//
//}
//- (void)didSelectedCurrentPageInPages:(RPRingedPages *)pages {
//    id next = self.nextResponder;
//    while (![next isKindOfClass:[UIViewController class]]) {
//        next = [next nextResponder];
//    }
//    NSArray *arr = objc_getAssociatedObject(self, &arrchar);
//    BannerModel *model = [arr objectAtIndex:pages.currentIndex];
//    WelfareViewController *vc = (WelfareViewController *)next;
//    [self bannerSkipActionWithModel:model skipVC:vc];
//    if ([model.type integerValue] == 1) {
//        if (model.relation_id.length > 0) {
//            GoodsDetailViewController *vc = [[GoodsDetailViewController alloc]init];
//            vc.goodsId = model.relation_id;
//            vc.hidesBottomBarWhenPushed = YES;
//            WelfareViewController *homevc = (WelfareViewController *)next;
//            [homevc.navigationController pushViewController:vc animated:YES];
//        }
//    }else{
//        if (model.url.length > 5) {
//            BannerWebViewController *vc = [[BannerWebViewController alloc]init];
//            vc.bannerUrl = model.url;
//            vc.hidesBottomBarWhenPushed = YES;
//            WelfareViewController *homevc = (WelfareViewController *)next;
//            [homevc.navigationController pushViewController:vc animated:YES];
//        }
//    }
    

//    NSLog(@"pages selected, the current index is %zd", pages.currentIndex);
//}
//- (void)pages:(RPRingedPages *)pages didScrollToIndex:(NSInteger)index {
////    NSLog(@"pages scrolled to index: %zd", index);
//}


- (IBAction)poorEmployee:(id)sender {
    NSInteger blockTag = 0;
    self.returnTagBlock(blockTag);
}
- (IBAction)activeEmployee:(id)sender {
    NSInteger blockTag = 1;
    self.returnTagBlock(blockTag);
}
- (IBAction)honorEmployee:(id)sender {
    NSInteger blockTag = 2;
    self.returnTagBlock(blockTag);
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
    [self.welfareScrollView addSubview:csView];
    [self.welfareScrollView setContentSize:CGSizeMake(ScreenWidth, img_height)];
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
        WelfareViewController *vc = (WelfareViewController *)next;
        [self bannerSkipActionWithModel:model skipVC:vc];
    
}

@end
