//
//  BusinessBrandTableViewCell.m
//  TheWorker
//
//  Created by yanghao on 8/18/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "BusinessBrandTableViewCell.h"
#import "PartnerModel.h"
#define a_tag_max 999
@implementation BusinessBrandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)initCellWithData:(NSArray *)itemArr{
    for (UIView *subview in self.subviews) {
        if (subview.tag >= a_tag_max) {
            [subview removeFromSuperview];
        }
    }
    CGFloat w = (ScreenWidth - 40.f) / 3;
    for (int i = 0; i < itemArr.count; i ++) {
        PartnerModel *model = itemArr[i];
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(10 + (w + 10) * (i % 3), i / 3 * (w + 40.f), w, w + 40.f)];
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, w, w)];
        imgview.backgroundColor = [UIColor lightGrayColor];
//        [imgview setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
        [imgview setImageWithString:model.logo placeHoldImageName:@"bg_no_pictures"];
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0 , w + 10, w, 30.f);
        label.text = model.name;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithHexString:@"333333"];
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(10 + (w + 10) * (i % 3), i / 3 * (w + 40.f), w, w + 40.f);
        [button addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = a_tag_max + i;
        [itemView addSubview:label];
        [itemView addSubview:imgview];
        itemView.tag = a_tag_max + i;
        [self addSubview:itemView];
        [self addSubview:button];
    }
}
-(void)tapAction:(UIButton *)button{
    self.returnSkipTagBlock(button.tag-999);
}
+(CGFloat)getCellHeightWithData:(NSArray *)itemArr{
    CGFloat w = (ScreenWidth - 40.f) / 3;
    CGFloat h = itemArr.count % 3 == 0 ? itemArr.count / 3 * (w + 40.f) : (itemArr.count / 3 + 1) * (w + 40.f);
    
    
    return h;
}


@end
