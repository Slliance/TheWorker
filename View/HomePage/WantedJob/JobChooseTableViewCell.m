
//
//  JobChooseTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/29.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "JobChooseTableViewCell.h"

@implementation JobChooseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//-(void)initCellWithData:(NSString *)str{
//    [self.btnSelected setTitle:str forState:UIControlStateNormal];
//    [self.btnSelected setImagePositionWithType:SSImagePositionTypeRight spacing:ScreenWidth-100];
//    
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    self.btnSelected.selected = self.selected;
    // Configure the view for the selected state
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
//    self.labelTitle.textColor = [UIColor colorWithHexString:@"333333"];
//            self.imageSelected.hidden = YES;

}

@end
