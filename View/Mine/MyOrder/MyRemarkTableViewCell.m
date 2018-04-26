//
//  MyRemarkTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/5.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyRemarkTableViewCell.h"
#import "UITextView+Placeholder.h"

@implementation MyRemarkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.star = 0;
    
    // Initialization code
}
-(void)initCellWithData:(StoreGoodsModel *)model{

    [[self viewWithTag:899]removeFromSuperview];
    FMLStarView *starView = [[FMLStarView alloc] initWithFrame:CGRectMake(0, 0, 30 * 5, 20)
                                                 numberOfStars:5
                                                   isTouchable:YES
                                                         index:1
                                                starImgDefault:@"icon_gray_star"
                                                 starImgSelect:@"icon_yellow_star"];
    starView.currentScore = 1;
    starView.totalScore = 5;
    starView.isFullStarLimited = YES;
    
    
    
    starView.delegate = self;
    starView.tag = 899;
    [self.starView addSubview:starView];
    self.txtView.placeholder = @"请输入评价内容";
    
    NSString *perpertystr = @"";
    for (int i = 0; i < model.property_tag.count; i ++) {
        perpertystr = [perpertystr stringByAppendingString:model.property_tag[i]];
        perpertystr = [perpertystr stringByAppendingString:@"    "];
    }
    self.propertyOneLabel.text = perpertystr;
    
    
    
    self.labelName.text = model.name;
    [self.headImg setImageWithString:model.show_img placeHoldImageName:placeholderImage_home_banner];
//    [self.headImg setImageWithURL:[NSURL URLWithString:model.show_img]];
    self.labelPrice.text = [NSString stringWithFormat:@"￥%.2f",[model.price floatValue]];
    self.parameterDic = [[NSMutableDictionary alloc] init];
    [HYNotification addOrderCommentCloseKeyboardNotification:self action:@selector(closeKeyBoard)];
    [self.parameterDic setValue:model.order_id forKey:@"id"];
    [self.parameterDic setValue:@(1) forKey:@"score"];
    
    
}

-(void)fml_didClickStarViewByScore:(CGFloat)score atIndex:(NSInteger)index{
    NSLog(@"%f===%ld",score,(long)index);
    
    [self.parameterDic setValue:@((int)score) forKey:@"score"];
    self.returnBlock(self.parameterDic);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)closeKeyBoard{
    [self.txtView resignFirstResponder];
    if (self.txtView.text.length) {
        [self.parameterDic setValue:self.txtView.text forKey:@"remark"];
    }
    self.returnBlock(self.parameterDic);
}
@end
