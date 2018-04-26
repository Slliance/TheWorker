//
//  MyStateHeadView.m
//  TheWorker
//
//  Created by yanghao on 2017/10/24.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyStateHeadView.h"

@implementation MyStateHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)initView:(NSString *)name headUrl:(NSString *)headUrl bgUrl:(NSString *)bgUrl{
    self.headImgUrl = headUrl;
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = 30.f;

    self.labelName.text = name;
    if (bgUrl.length > 5) {
        [self.bgView setImageWithString:bgUrl placeHoldImageName:placeholderImage_home_banner];
    }
    [self.headImgView setImageWithString:headUrl placeHoldImageName:placeholderImage_user_headimg];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    self.headImgView.userInteractionEnabled = YES;
    [self.headImgView addGestureRecognizer:tap];
//    [self.headImgView setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"icon_personal_center_default_avatar"]];
}
-(void)tapAction{
    self.friendDetailBlock();
}
//    [self.headImgView setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"icon_personal_center_default_avatar"]];
- (IBAction)setShowImg:(id)sender {
    self.showImgBlock();
}
- (IBAction)lookHeadImage:(id)sender {
    self.lookHeadImgBlock(self.headImgUrl);
}

@end
