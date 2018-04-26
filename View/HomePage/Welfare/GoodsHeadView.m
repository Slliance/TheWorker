 //
//  GoodsHeadView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/16.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "GoodsHeadView.h"
#import <objc/runtime.h>
#import "UIButton+SSEdgeInsets.h"
#import "BannerModel.h"
//#import "BannerDetailViewController.h"
#import "HomePageViewController.h"
#define img_height 280
static char arrchar;

@implementation GoodsHeadView

-(void)initBannerView:(NSArray *)banner{
    __weak typeof (self)weakSelf = self;
    csView = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, img_height)];
//    csView.tag = 99;
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
    [self.goodsScrollView addSubview:csView];
    [self.goodsScrollView setContentSize:CGSizeMake(ScreenWidth, img_height)];
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
//        BannerModel *model = [arr objectAtIndex:index];
    UIImageView *bannerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, img_height)];
    bannerImgView.contentMode = UIViewContentModeScaleToFill;
//    [bannerImgView setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:placeholderImage_home_banner]];
//    [bannerImgView setImageWithURL:[NSURL URLWithString:arr[index]] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
    [bannerImgView setImageWithString:arr[index] placeHoldImageName:@"bg_no_pictures"];
    return bannerImgView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
