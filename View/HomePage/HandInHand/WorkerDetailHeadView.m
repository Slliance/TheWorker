//
//  WorkerDetailHeadView.m
//  TheWorker
//
//  Created by yanghao on 8/29/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "WorkerDetailHeadView.h"
#import <objc/runtime.h>
#import "UIButton+SSEdgeInsets.h"
static char arrchar;

@implementation WorkerDetailHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)initBannerView:(NSArray *)banner{
    __weak typeof (self)weakSelf = self;
    csView = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 180)];
    csView.tag = 99;
    csView.isRedPoint = YES;
    [csView addPageControlWithCount:banner.count];
    csView.delegate = self;
    csView.datasource = self;
    
    [csView setEndDeceleratingBlock:^{
        weakSelf.EndDeceleratingBlock();
    }];
    [csView setBeginDraggingBlock:^{
        weakSelf.BeginDraggingBlock();
    }];
    csView.scrollView.backgroundColor=[UIColor lightGrayColor];
    [self.mainScrollView addSubview:csView];
    objc_setAssociatedObject(self, &arrchar, banner, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [csView reloadData];
}

-(void)timerStart{
    [csView timerScrollView];
}
- (NSInteger)numberOfPages
{
    NSArray *arr = objc_getAssociatedObject(self, &arrchar);
    return arr.count;
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    NSArray *arr = objc_getAssociatedObject(self, &arrchar);
    //    BannerModel *model = [arr objectAtIndex:index];
    UIImageView *bannerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 180)];
    bannerImgView.contentMode = UIViewContentModeScaleToFill;
//    bannerImgView.image = [UIImage imageNamed:[arr objectAtIndex:index]];
    [bannerImgView setImageWithString:[arr objectAtIndex:index] placeHoldImageName:@"bg_no_pictures"];
//    [bannerImgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,[arr objectAtIndex:index]]] placeholderImage:[UIImage imageNamed:placeholderImage_home_banner]];
    
    return bannerImgView;
}


@end
