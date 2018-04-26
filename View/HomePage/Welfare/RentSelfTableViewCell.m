//
//  RentSelfTableViewCell.m
//  TheWorker
//
//  Created by yanghao on 8/21/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "RentSelfTableViewCell.h"
#import "FMLStarView.h"
#define max_tag  999
@implementation RentSelfTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)initCellWithModel:(RentModel *)model{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.f;
    
    self.headImgView.layer.cornerRadius = 15.f;
    self.headImgView.layer.masksToBounds = YES;
    [self.headImgView setImageWithString:model.headimg placeHoldImageName:placeholderImage_user_headimg];
    [self.imgView setImageWithString:model.showimg placeHoldImageName:@"bg_no_pictures"];
    self.labelName.text = model.nickname;
    self.labelPrice.text = [NSString stringWithFormat:@"%@元/小时",model.price];
    
    self.labelPrice.textColor = [UIColor colorWithHexString:@"ee5f7d"];
    for (UIView *subview in self.markScrollView.subviews) {
        if (subview.tag >= max_tag) {
            [subview removeFromSuperview];
        }
    }
    
    NSArray *markarr = model.tag;
    
    CGFloat pointx = 0.f;
    for (int i = 0; i < markarr.count; i++) {
        NSString *str = markarr[i][@"name"];
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:11] maxSize:CGSizeMake(200, 16)];
        
        if (self.imgView.frame.size.width - pointx < 50 || self.imgView.frame.size.width - pointx < size.width) {
            UILabel *moreLabel = [[UILabel alloc] init];
            moreLabel.frame = CGRectMake(pointx, 0, 50, 20);
            moreLabel.text = @"...";
            moreLabel.font = [UIFont systemFontOfSize:12];
            moreLabel.textColor = [UIColor colorWithHexString:@"666666"];
            [self.markScrollView addSubview:moreLabel];

            break;
        }

        
        UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(pointx, 0, size.width + 20, 20)];
        backview.tag = max_tag + i;
        backview.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
        backview.layer.masksToBounds = YES;
        backview.layer.cornerRadius = 3.f;
        UIButton *markBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        markBtn.frame = CGRectMake(10, 2, size.width, 16);
        markBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [markBtn setTitle:str forState:UIControlStateNormal];
        [markBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [backview addSubview:markBtn];
        [self.markScrollView addSubview:backview];
        pointx += size.width + 30;
    }
    [self.markScrollView setContentSize:CGSizeMake(pointx, 20)];
    
    
    [[self viewWithTag:899]removeFromSuperview];
    for (UIView *subview in self.subviews) {
        if (subview.tag == 500) {
            [subview removeFromSuperview];
        }
    }
    UIView *starView = [[UIView alloc] init];
    starView.frame = CGRectMake(ScreenWidth-105, 200, 75, 18);
    starView.tag = 500;
    
    for (int i = 0; i < [model.score integerValue]; i ++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_rent_it_star_rating"];
        imgView.frame = CGRectMake(i * 15, 0, 13, 13);
        [starView addSubview:imgView];
    }
    [self addSubview:starView];
//    FMLStarView *starView = [[FMLStarView alloc] initWithFrame:CGRectMake(ScreenWidth - 20 - 15 * 5 - 8, 200, 15 * 5, 18)
//                                     numberOfStars:5
//                                       isTouchable:NO
//                                             index:1
//                                    starImgDefault:@"icon_gray_small_empty_star"
//                                    starImgSelect:@"icon_rent_it_star_rating"];
//    starView.currentScore = [model.score integerValue];
//    starView.totalScore = 5;
//    starView.isFullStarLimited = NO;

    
    
//    starView.delegate = controller;
//    starView.tag = 899;
//    [self addSubview:starView];
    

    
}
@end
