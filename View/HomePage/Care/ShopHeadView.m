//
//  ShopHeadView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/16.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ShopHeadView.h"
#import <objc/runtime.h>
#import "UIButton+SSEdgeInsets.h"
#import "BannerModel.h"
#import "UIView+HYExtension.h"
#import "EmployeeSaleViewController.h"
#define img_height 150
static char arrchar;

@implementation ShopHeadView
-(void)initBannerView:(NSArray *)banner{
    __weak typeof (self)weakSelf = self;
    csView = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-20, img_height)];
    [csView addPageControlWithCount:banner.count];
    csView.delegate = self;
    csView.datasource = self;
    csView.scrollView.backgroundColor=[UIColor clearColor];
    [csView setEndDeceleratingBlock:^{
        weakSelf.EndDeceleratingBlock();
    }];
    [csView setBeginDraggingBlock:^{
        weakSelf.BeginDraggingBlock();
    }];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    view.backgroundColor = [UIColor whiteColor];
    
    [self.shopScrollView addSubview:csView];    
    [self.shopScrollView addSubview:view];
    
    [self.shopScrollView setContentSize:CGSizeMake(ScreenWidth-20, img_height)];
    objc_setAssociatedObject(self, &arrchar, banner, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [csView reloadData];
}

-(void)timerStart{
    NSArray *arr = objc_getAssociatedObject(self, &arrchar);
    if (arr.count != 0) {
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
    UIImageView *bannerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 120)];
//    bannerImgView.image = [UIImage imageNamed:[arr objectAtIndex:index]];
//    [bannerImgView setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:placeholderImage_home_banner]];
    [bannerImgView setImageWithString:model.img placeHoldImageName:@"bg_no_pictures"];
    bannerImgView.layer.masksToBounds = YES;
    bannerImgView.layer.cornerRadius = 4.f;
    UIView *shadowView = [[UIView alloc]initWithFrame:bannerImgView.frame];
    
    shadowView.layer.shadowColor = [UIColor colorWithHexString:@"a4c1f1"].CGColor;
    
    shadowView.layer.shadowOffset = CGSizeMake(4, 4);
    
    shadowView.layer.shadowOpacity = 0.5f;
    
    shadowView.layer.shadowRadius = 4.0;
    
    shadowView.layer.cornerRadius = 4.0;
    
//    shadowView.clipsToBounds = NO;
    
    [shadowView addSubview:bannerImgView];
    return shadowView;
}

-(void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index{
    id next = self.nextResponder;
    while (![next isKindOfClass:[UIViewController class]]) {
        next = [next nextResponder];
    }
    NSArray *arr = objc_getAssociatedObject(self, &arrchar);
    BannerModel *model = [arr objectAtIndex:index];
    EmployeeSaleViewController *homevc = (EmployeeSaleViewController *)next;
    [self bannerSkipActionWithModel:model skipVC:homevc];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
