//
//  RentPersonInfoHeadView.m
//  TheWorker
//
//  Created by yanghao on 8/21/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "RentPersonInfoHeadView.h"
#import "RentPersonInfoViewController.h"
#define img_height 160
static char arrchar;

@implementation RentPersonInfoHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)initBannerView:(NSArray *)banner{
    __weak typeof (self)weakSelf = self;
    csView = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, img_height)];
    csView.tag = 99;
    csView.isRedPoint = YES;
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

-(void)initViewWithModel:(RentPersonModel *)model{
    
    self.redView.layer.masksToBounds = YES;
    self.redView.layer.cornerRadius = 9.f;
    self.labelTrust.text = [NSString stringWithFormat:@"信任值：%@",model.trust];
//    [self.imgView setImageWithString:model.showimg placeHoldImageName:@"bg_no_pictures"];
//    [self.imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,model.showimg]] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
    [self infoAction:nil];
    
}
- (IBAction)infoAction:(id)sender {
    CGRect heightRect = self.infoBtn.frame;
    
    CGRect rect = self.labelLine.frame;
    rect.origin.x = heightRect.origin.x + 50;
    rect.size.width = heightRect.size.width - 100;
    self.labelLine.frame = rect;
    self.infoBtn.selected = YES;
    self.fansBtn.selected = NO;
    if (sender) {
        self.tagBlock(0);
    }
}
- (IBAction)fansAction:(id)sender {
    CGRect heightRect = self.fansBtn.frame;
    
    CGRect rect = self.labelLine.frame;
    rect.origin.x = heightRect.origin.x + 50;
    rect.size.width = heightRect.size.width - 100;
    self.labelLine.frame = rect;
    self.infoBtn.selected = NO;
    self.fansBtn.selected = YES;
    self.tagBlock(1);
}




- (NSInteger)numberOfPages
{
    NSArray *arr = objc_getAssociatedObject(self, &arrchar);
    return arr.count;
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    NSArray *arr = objc_getAssociatedObject(self, &arrchar);
    NSString *urlstr = [arr objectAtIndex:index];
    UIImageView *bannerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, img_height)];
    bannerImgView.contentMode = UIViewContentModeScaleAspectFill;
    [bannerImgView setImageWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,urlstr] placeHoldImageName:@"bg_no_pictures"];
    
    
    return bannerImgView;
}

- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index{
    id next = self.nextResponder;
    while (![next isKindOfClass:[UIViewController class]]) {
        next = [next nextResponder];
    }
    NSArray *arr = objc_getAssociatedObject(self, &arrchar);
    NSString *model = [arr objectAtIndex:index];
    
//
//    RentPersonInfoViewController *vc = [[RentPersonInfoViewController alloc]init];
//
//    vc.hidesBottomBarWhenPushed = YES;
//    RentPersonInfoViewController *homevc = (RentPersonInfoViewController *)next;
//    [homevc.navigationController pushViewController:vc animated:YES];
//
//    
}

@end
