//
//  WelfareHeadView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/14.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BusinessHeadView.h"
#import <objc/runtime.h>
#import "BannerModel.h"
#import "BannerWebViewController.h"
#import "BusinessViewController.h"
static char arrchar;

@implementation BusinessHeadView

- (RPRingedPages *)pages {
    if (_pages == nil) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGRect pagesFrame = CGRectMake(0, 10, screenWidth, 140);
        
        RPRingedPages *pages = [[RPRingedPages alloc] initWithFrame:pagesFrame];
        CGFloat height = pagesFrame.size.height - pages.pageControlHeight - pages.pageControlMarginTop - pages.pageControlMarginBottom;
        pages.carousel.mainPageSize = CGSizeMake(screenWidth - 35 * 2, height);
        pages.carousel.pageScale = 0.9;
        pages.dataSource = self;
        pages.delegate = self;
        _pages = pages;
        [pages.pageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"icon_dot_selected"]];
        [pages.pageControl setPageIndicatorImage:[UIImage imageNamed:@"icon_dot_not_selected"]];
    }
    return _pages;
}

-(void)initBannerViewWith:(NSArray *)banner{
    objc_setAssociatedObject(self, &arrchar, banner, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (banner.count == 1) {
        BannerModel *model = banner[0];
        UIImageView *headImgView = [[UIImageView alloc] init];
        headImgView.frame = CGRectMake(0, 0, ScreenWidth, 145);
        [headImgView setImageWithString:model.img placeHoldImageName:placeholderImage_home_banner];
        [self addSubview:headImgView];
    }else{
        [self addSubview:self.pages];
        [self.pages reloadData];
    };

    
}

- (NSInteger)numberOfItemsInRingedPages:(RPRingedPages *)pages {
    NSArray *arr = objc_getAssociatedObject(self, &arrchar);
    return arr.count;
}
- (UIView *)ringedPages:(RPRingedPages *)pages viewForItemAtIndex:(NSInteger)index {
    NSArray *array = objc_getAssociatedObject(self, &arrchar);
    BannerModel *model = [array objectAtIndex:index];
    UIImageView *bannerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
    bannerImgView.contentMode = UIViewContentModeScaleToFill;
//    [bannerImgView setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
    [bannerImgView setImageWithString:model.img placeHoldImageName:@"bg_no_pictures"];
    return bannerImgView;

}

- (void)didSelectedCurrentPageInPages:(RPRingedPages *)pages {id next = self.nextResponder;
    while (![next isKindOfClass:[UIViewController class]]) {
        next = [next nextResponder];
    }
    NSArray *arr = objc_getAssociatedObject(self, &arrchar);
    BannerModel *model = [arr objectAtIndex:pages.currentIndex];
    
    if (model.url.length > 5) {
        BannerWebViewController *vc = [[BannerWebViewController alloc]init];
        vc.bannerUrl = model.url;
        vc.hidesBottomBarWhenPushed = YES;
        BusinessViewController *homevc = (BusinessViewController *)next;
        [homevc.navigationController pushViewController:vc animated:YES];
    }
    NSLog(@"pages selected, the current index is %zd", pages.currentIndex);
}

- (void)pages:(RPRingedPages *)pages didScrollToIndex:(NSInteger)index {
    NSLog(@"pages scrolled to index: %zd", index);
}


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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
