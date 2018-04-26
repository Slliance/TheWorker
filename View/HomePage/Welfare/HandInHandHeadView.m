//
//  WelfareHeadView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/14.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HandInHandHeadView.h"
#import "HandInHandViewController.h"
#import "UIView+HYExtension.h"
#import "WorkerDetailViewController.h"
@implementation HandInHandHeadView


- (RPRingedPages *)pages {
    if (_pages == nil) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGRect pagesFrame = CGRectMake(0, 10, screenWidth, 140);

        RPRingedPages *pages = [[RPRingedPages alloc] initWithFrame:pagesFrame];
        CGFloat height = pagesFrame.size.height - pages.pageControlHeight - pages.pageControlMarginTop - pages.pageControlMarginBottom;
        pages.carousel.mainPageSize = CGSizeMake(screenWidth - 35 * 2, height);
        pages.carousel.pageScale = 0.93;
        pages.dataSource = self;
        pages.delegate = self;

        [pages.pageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"icon_dot_pink_selected"]];
        [pages.pageControl setPageIndicatorImage:[UIImage imageNamed:@"icon_dot_pink_not_selected@2x"]];
        _pages = pages;
    }
    return _pages;
}

//- (RPRingedPages *)pages {
//    if (_pages == nil) {
//        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//        CGRect pagesFrame = CGRectMake(0, 10, screenWidth, 140);
//        
//        RPRingedPages *pages = [[RPRingedPages alloc] initWithFrame:pagesFrame];
//        CGFloat height = pagesFrame.size.height - pages.pageControlHeight - pages.pageControlMarginTop - pages.pageControlMarginBottom;
//        pages.carousel.mainPageSize = CGSizeMake(screenWidth - 20 * 2, height);
//        //        pages.carousel.mainPageSize = CGSizeMake(100, 100);
//        pages.carousel.pageScale = 0.93f;
//        pages.dataSource = self;
//        pages.delegate = self;
//        [pages.pageControl xsetCurrentPageIndicatorImage:[UIImage imageNamed:@"icon_dot_selected"]];
//        [pages.pageControl xsetPageIndicatorImage:[UIImage imageNamed:@"icon_dot_not_selected"]];
//        _pages = pages;
//    }
//    return _pages;
//}

-(void)initView:(NSArray *)arr{
    
    self.bannerArr = [[NSMutableArray alloc] initWithArray:arr];
    if (self.bannerArr.count == 1) {
        BannerModel *model = self.bannerArr[0];
        UIImageView *headImgView = [[UIImageView alloc] init];
        headImgView.frame = CGRectMake(0, 0, ScreenWidth, 145);
        [headImgView setImageWithString:model.img placeHoldImageName:placeholderImage_home_banner];
        [self addSubview:headImgView];

    }else{
        [self addSubview:self.pages];
        [self.pages reloadData];
    }
    

    [self.liveBtn setImagePositionWithType:SSImagePositionTypeTop spacing:10.f];
    [self.loveBtn setImagePositionWithType:SSImagePositionTypeTop spacing:10.f];
    
}

- (NSInteger)numberOfItemsInRingedPages:(RPRingedPages *)pages {
    return self.bannerArr.count;
}
- (UIView *)ringedPages:(RPRingedPages *)pages viewForItemAtIndex:(NSInteger)index {
    UIImageView *bannerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
    bannerImgView.contentMode = UIViewContentModeScaleAspectFill;
    bannerImgView.clipsToBounds = YES;
    BannerModel *model = self.bannerArr[index];
//    [bannerImgView setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]]
    [bannerImgView setImageWithString:model.img placeHoldImageName:@"bg_no_pictures"];
    return bannerImgView;

}
- (void)didSelectedCurrentPageInPages:(RPRingedPages *)pages {
    id next = self.nextResponder;
    while (![next isKindOfClass:[UIViewController class]]) {
        next = [next nextResponder];
    }
    BannerModel *model = [self.bannerArr objectAtIndex:pages.currentIndex];
    HandInHandViewController *homevc = (HandInHandViewController *)next;
    [self bannerSkipActionWithModel:model skipVC:homevc];
   
    NSLog(@"pages selected, the current index is %zd", pages.currentIndex);
}
- (void)pages:(RPRingedPages *)pages didScrollToIndex:(NSInteger)index {
    NSLog(@"pages scrolled to index: %zd", index);
}

- (IBAction)workerLiveAction:(id)sender {
    NSInteger blockTag = 0;
    self.returnTagBlock(blockTag);
}
- (IBAction)saleLoveAction:(id)sender {
    NSInteger blockTag = 1;
    self.returnTagBlock(blockTag);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
