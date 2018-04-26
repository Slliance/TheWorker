//
//  CollectFoodTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/31.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "CollectFoodTableViewCell.h"

@implementation CollectFoodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initCellWithData:(id )model{
    if ([model isKindOfClass:[ArticleModel class]]) {
        ArticleModel *submodel = (ArticleModel *)model;
        [self.articleImg setImageWithString:submodel.show_img placeHoldImageName:placeholderImage_home_banner];
//        [self.articleImg setImageWithURL:[NSURL URLWithString:submodel.show_img] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
        self.articleTitle.text = submodel.title;
        self.collectTime.text = submodel.createtime;
    }
    if ([model isKindOfClass:[HandInModel class]]) {
        HandInModel *subModel = (HandInModel *)model;
//        NSArray *array = model.imgs;
        if (subModel.imgs.count > 0) {
            [self.articleImg setImageWithString:subModel.imgs[0] placeHoldImageName:placeholderImage_home_banner];
        }

        self.articleTitle.text = subModel.title;
        self.collectTime.text = subModel.createtime;
    }
    
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
