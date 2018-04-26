//
//  CollectScoreGoodsTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/30.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "CollectScoreGoodsTableViewCell.h"

@implementation CollectScoreGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initCellWithData:(CollectModel *)model{
//    CALayer *cicleLayer = [[CALayer alloc] init];
    
    [self.imgGoodsName.layer setBorderColor:[UIColor colorWithHexString:@"f0f0f0"].CGColor];
    [self.imgGoodsName.layer setBorderWidth:1.f];
    [self.imgGoodsName setImageWithString:model.show_img placeHoldImageName:placeholderImage_home_banner];
//    [self.imgGoodsName setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.show_img]] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
    self.labelGoodsName.text = model.title;
    self.labelTime.text = model.createtime;
}

-(void)layoutSubviews
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xffffff);
    self.selectedBackgroundView = view;

    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *view in control.subviews)
            {
                if ([view isKindOfClass: [UIImageView class]]) {
                    UIImageView *image=(UIImageView *)view;
                    if (self.selected) {
                        image.image=[UIImage imageNamed:@"icon_circle_selected"];
                    }
                    else
                    {
                        image.image=[UIImage imageNamed:@"icon_circle_not_selected"];
                    }
                }
            }
        }
    }
    
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
