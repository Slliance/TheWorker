//
//  HomeHeaderView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/10.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HomeHeaderView.h"
#import <objc/runtime.h>
#import "UIButton+SSEdgeInsets.h"
#import "UIImageView+Extension.h"
#import "BannerModel.h"
#import "HomePageViewController.h"
#import "BannerWebViewController.h"

#define img_height 200
static char arrchar;
@implementation HomeHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setContentLayout];
    }
    return self;
}

-(void)setContentLayout{
    [self addSubview:self.homeScrollView];
    [self addSubview:self.buttonView];
    self.buttonView.userInteractionEnabled = YES;
    [self.buttonView addSubview:self.btnWelfare];
    [self.buttonView addSubview:self.btnJobWanted];
    [self.buttonView addSubview:self.btnBlindDate];
    [self.buttonView addSubview:self.btnCare];
    [self.buttonView addSubview:self.btnStartBusiness];
    [self.buttonView addSubview:self.btnOther];
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.homeScrollView).offset(184);
        make.left.equalTo(self.homeScrollView).offset(10);
        make.width.mas_equalTo(ScreenWidth-24);
        make.height.mas_equalTo(160);
    }];
    [self.btnWelfare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttonView);
        make.left.equalTo(self.buttonView);
        make.width.mas_equalTo(ScreenWidth/3-8);
        make.height.mas_equalTo(80);
    }];
    [self.btnJobWanted mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttonView);
        make.left.equalTo(self.btnWelfare.mas_right);
        make.width.mas_equalTo(ScreenWidth/3-8);
        make.height.mas_equalTo(80);
    }];
    [self.btnBlindDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttonView);
        make.left.equalTo(self.btnJobWanted.mas_right);
        make.width.mas_equalTo(ScreenWidth/3-8);
        make.height.mas_equalTo(80);
    }];
    [self.btnCare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnWelfare.mas_bottom);
        make.left.equalTo(self.buttonView);
        make.width.mas_equalTo(ScreenWidth/3-8);
        make.height.mas_equalTo(80);
    }];
    [self.btnStartBusiness mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnWelfare.mas_bottom);
        make.left.equalTo(self.btnCare.mas_right);
        make.width.mas_equalTo(ScreenWidth/3-8);
        make.height.mas_equalTo(80);
    }];
    [self.btnOther mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnWelfare.mas_bottom);
        make.left.equalTo(self.btnStartBusiness.mas_right);
        make.width.mas_equalTo(ScreenWidth/3-8);
        make.height.mas_equalTo(80);
    }];
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
    [self.homeScrollView addSubview:csView];
    [self.homeScrollView setContentSize:CGSizeMake(ScreenWidth, img_height)];
    objc_setAssociatedObject(self, &arrchar, banner, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [csView reloadData];
}

-(void)initButtonView{

    self.buttonView.layer.cornerRadius = 4.f;

    self.buttonView.layer.shadowColor = [UIColor colorWithHexString:@"a4c1f1"].CGColor;

    self.buttonView.layer.shadowOpacity = 0.5f;

    self.buttonView.layer.shadowRadius = 4.f;

    self.buttonView.layer.shadowOffset = CGSizeMake(0,4);

}
-(void)timerStart{
    NSArray *arr = objc_getAssociatedObject(self, &arrchar);
    if (arr.count) {
        [csView timerScrollView];
    }
}

-(UIScrollView *)homeScrollView{
    if (!_homeScrollView) {
        _homeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 350)];
        _homeScrollView.delegate = self;
        _homeScrollView.backgroundColor = DSColorFromHex(0xEEEEEE);
    }
    return _homeScrollView;
}

-(UIView *)buttonView{
    if (!_buttonView) {
        _buttonView =[[UIView alloc]init];
        _buttonView.backgroundColor = [UIColor whiteColor];
    }
    return _buttonView;
}
-(HomeHeadBtns *)btnWelfare{
    if (!_btnWelfare) {
        _btnWelfare= [[HomeHeadBtns alloc]init];
        _btnWelfare.headImage.image = [UIImage imageNamed:@"welfare"];
        [_btnWelfare.headBtn addTarget:self action:@selector(welfateAction:) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
        _btnWelfare.contentLabel.text = @"员工福利";
    }
    return _btnWelfare;
}
-(HomeHeadBtns *)btnJobWanted{
    if (!_btnJobWanted) {
        _btnJobWanted= [[HomeHeadBtns alloc]init];
        _btnJobWanted.headImage.image = [UIImage imageNamed:@"lobsearch"];
        [_btnJobWanted.headBtn addTarget:self action:@selector(jobWantedAction:) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
        _btnJobWanted.contentLabel.text = @"员工求职";
    }
    return _btnJobWanted;
}
-(HomeHeadBtns *)btnBlindDate{
    if (!_btnBlindDate) {
        _btnBlindDate= [[HomeHeadBtns alloc]init];
        _btnBlindDate.headImage.image = [UIImage imageNamed:@"holdinghands"];
        [_btnBlindDate.headBtn addTarget:self action:@selector(blindDateAction:) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
        _btnBlindDate.contentLabel.text = @"员工牵手";
    }
    return _btnBlindDate;
}

-(HomeHeadBtns *)btnCare{
    if (!_btnCare) {
        _btnCare= [[HomeHeadBtns alloc]init];
        _btnCare.headImage.image = [UIImage imageNamed:@"care"];
         [_btnCare.headBtn addTarget:self action:@selector(careAction:) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
        _btnCare.contentLabel.text = @"员工关怀";
    }
    return _btnCare;
}

-(HomeHeadBtns *)btnStartBusiness{
    if (!_btnStartBusiness) {
        _btnStartBusiness= [[HomeHeadBtns alloc]init];
        _btnStartBusiness.headImage.image = [UIImage imageNamed:@"entrepeneurship"];
         [_btnStartBusiness.headBtn addTarget:self action:@selector(startBusinessAction:) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
        _btnStartBusiness.contentLabel.text = @"员工创业";
    }
    return _btnStartBusiness;
}

-(HomeHeadBtns *)btnOther{
    if (!_btnOther) {
        _btnOther= [[HomeHeadBtns alloc]init];
        _btnOther.headImage.image = [UIImage imageNamed:@"more"];
         [_btnOther.headBtn addTarget:self action:@selector(otherAction:) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
        _btnOther.contentLabel.text = @"更多";
    }
    return _btnOther;
}
- (void)welfateAction:(UIButton*)sender {
    self.skipToWelfareBlock(0);
}

- (void)jobWantedAction:(UIButton*)sender {
    self.skipToWelfareBlock(1);
}

- (void)blindDateAction:(UIButton*)sender {
    self.skipToWelfareBlock(2);
}

- (void)careAction:(UIButton*)sender {
    self.skipToWelfareBlock(3);
}
- (void)startBusinessAction:(UIButton*)sender {
    self.skipToWelfareBlock(4);
}
- (void)otherAction:(UIButton*)sender {
    self.skipToWelfareBlock(5);
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
    
    if (model.url.length > 5) {
        BannerWebViewController *vc = [[BannerWebViewController alloc]init];
        vc.bannerUrl = model.url;
        vc.hidesBottomBarWhenPushed = YES;
        HomePageViewController *homevc = (HomePageViewController *)next;
        [homevc.navigationController pushViewController:vc animated:YES];
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
