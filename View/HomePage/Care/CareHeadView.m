//
//  CareHeadView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/16.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "CareHeadView.h"
#import <objc/runtime.h>
#import "BannerModel.h"
#import "CareViewController.h"
#import "UIView+HYExtension.h"
static char arrchar;
@implementation CareHeadView
- (RPRingedPages *)pages {
    if (_pages == nil) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGRect pagesFrame = CGRectMake(0, 10, screenWidth, 140);
        
        RPRingedPages *pages = [[RPRingedPages alloc] initWithFrame:pagesFrame];
        CGFloat height = pagesFrame.size.height - pages.pageControlHeight - pages.pageControlMarginTop - pages.pageControlMarginBottom;
        pages.carousel.mainPageSize = CGSizeMake(screenWidth - 20 * 2, height);
//        pages.carousel.mainPageSize = CGSizeMake(100, 100);
        pages.carousel.pageScale = 0.93f;
        pages.dataSource = self;
        pages.delegate = self;
        [pages.pageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"icon_dot_selected"]];
        [pages.pageControl setPageIndicatorImage:[UIImage imageNamed:@"icon_dot_not_selected"]];
        _pages = pages;
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
    NSArray *array = objc_getAssociatedObject(self, &arrchar);
    return array.count;
}
- (UIView *)ringedPages:(RPRingedPages *)pages viewForItemAtIndex:(NSInteger)index {

    NSArray *array = objc_getAssociatedObject(self, &arrchar);
    BannerModel *model = [array objectAtIndex:index];
    UIImageView *bannerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
    bannerImgView.frame = CGRectMake(2, 2, 2, 2);
    bannerImgView.contentMode = UIViewContentModeScaleToFill;
//    [bannerImgView setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
    [bannerImgView setImageWithString:model.img placeHoldImageName:@"bg_no_pictures"];
    bannerImgView.layer.masksToBounds = YES;
    bannerImgView.layer.cornerRadius = 4.f;
    UIView *shadowView = [[UIView alloc]initWithFrame:bannerImgView.frame];
    
    shadowView.layer.shadowColor = [UIColor colorWithHexString:@"a4c1f1"].CGColor;
    
    shadowView.layer.shadowOffset = CGSizeMake(4, 4);
    
    shadowView.layer.shadowOpacity = 0.5f;
    
    shadowView.layer.shadowRadius = 4.0;
    
    shadowView.layer.cornerRadius = 4.0;
    
        shadowView.clipsToBounds = NO;
    
    [shadowView addSubview:bannerImgView];

    return bannerImgView;
    
}
- (void)didSelectedCurrentPageInPages:(RPRingedPages *)pages {
    id next = self.nextResponder;
    while (![next isKindOfClass:[UIViewController class]]) {
        next = [next nextResponder];
    }
    NSArray *arr = objc_getAssociatedObject(self, &arrchar);
    BannerModel *model = [arr objectAtIndex:pages.currentIndex];
    CareViewController *vc = (CareViewController *)next;
    [self bannerSkipActionWithModel:model skipVC:vc];
    
    
    NSLog(@"pages selected, the current index is %zd", pages.currentIndex);
}
- (void)pages:(RPRingedPages *)pages didScrollToIndex:(NSInteger)index {
    NSLog(@"pages scrolled to index: %zd", index);
}
- (IBAction)btnShopping:(id)sender {
    self.returnTagBlock(0);
}
- (IBAction)btnFood:(id)sender {
    self.returnTagBlock(1);
}

- (IBAction)btnLive:(id)sender {
    self.returnTagBlock(2);
}
- (IBAction)btnGoOut:(id)sender {
    self.returnTagBlock(3);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
