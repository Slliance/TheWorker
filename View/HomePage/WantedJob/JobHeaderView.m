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
static char arrchar;
@implementation JobHeaderView

- (RPRingedPages *)pages {
    if (_pages == nil) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGRect pagesFrame = CGRectMake(0, 173, screenWidth, 140);
        
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

-(void)initViewWithData:(NSArray *)dataArray{
    objc_setAssociatedObject(self, &arrchar, dataArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (dataArray.count == 1) {
        BannerModel *model = dataArray[0];
        UIImageView *headImgView = [[UIImageView alloc] init];
        headImgView.frame = CGRectMake(0, 173, ScreenWidth, 145);
        [headImgView setImageWithString:model.img placeHoldImageName:placeholderImage_home_banner];
        [self addSubview:headImgView];
        
    }else{
        [self addSubview:self.pages];
        [self.pages reloadData];
    }
    
    
    UIImageView *LeftViewNum = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_search"]];
    //图片的显示模式
    LeftViewNum.contentMode= UIViewContentModeCenter;
    //图片的位置和大小
    LeftViewNum.frame= CGRectMake(0,0,30,30);
    //左视图默认是不显示的 设置为始终显示
    self.txtSearchBar.leftViewMode= UITextFieldViewModeAlways;
    self.txtSearchBar.leftView= LeftViewNum;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"6398f1"];
    //NSAttributedString:带有属性的文字（叫富文本，可以让你的文字丰富多彩）但是这个是不可变的带有属性的文字，创建完成之后就不可以改变了  所以需要可变的
    NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc]initWithString:@"请输入地区、职位关键字" attributes:attrs];
    self.txtSearchBar.attributedPlaceholder = placeHolder;
    self.txtSearchBar.returnKeyType=UIReturnKeySearch;
    self.txtSearchBar.delegate = self;
    self.txtSearchBar.layer.shadowColor = [UIColor colorWithHexString:@"4082f1"].CGColor;
    
    self.txtSearchBar.layer.shadowOffset = CGSizeMake(4, 4);
    
    self.txtSearchBar.layer.shadowOpacity = 0.3f;
    
    self.txtSearchBar.layer.shadowRadius = 4.0;
    
    self.txtSearchBar.layer.cornerRadius = 15.0;
    
    self.txtSearchBar.clipsToBounds = NO;

    
}

- (NSInteger)numberOfItemsInRingedPages:(RPRingedPages *)pages {
    NSArray *arr = objc_getAssociatedObject(self, &arrchar);
    return arr.count;
}
- (UIView *)ringedPages:(RPRingedPages *)pages viewForItemAtIndex:(NSInteger)index {
    NSArray *arr = objc_getAssociatedObject(self, &arrchar);
    BannerModel *model = [arr objectAtIndex:index];
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
    
    if (model.url.length > 5) {
        BannerWebViewController *vc = [[BannerWebViewController alloc]init];
        vc.bannerUrl = model.url;
        vc.hidesBottomBarWhenPushed = YES;
        WantedJobViewController *homevc = (WantedJobViewController *)next;
        [homevc.navigationController pushViewController:vc animated:YES];
    }
    NSLog(@"pages selected, the current index is %zd", pages.currentIndex);
}
- (void)pages:(RPRingedPages *)pages didScrollToIndex:(NSInteger)index {
    NSLog(@"pages scrolled to index: %zd", index);
}

- (IBAction)wantLongTime:(id)sender {
    self.returnTagBlock(1);
}
- (IBAction)wantUrgency:(id)sender {
    self.returnTagBlock(3);
}
- (IBAction)wantPartTime:(id)sender {
    self.returnTagBlock(2);
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    id next = self.nextResponder;
    while (![next isKindOfClass:[UIViewController class]]) {
        next = [next nextResponder];
    }
    if (textField.text.length > 0) {
        SearchJobViewController *vc = [[SearchJobViewController alloc]init];
        vc.searchKey = textField.text;
        
        vc.hidesBottomBarWhenPushed = YES;
        WantedJobViewController *homevc = (WantedJobViewController *)next;
        [homevc.navigationController pushViewController:vc animated:YES];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}



@end
