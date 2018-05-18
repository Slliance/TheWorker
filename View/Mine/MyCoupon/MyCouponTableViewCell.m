//
//  MyCouponTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/28.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyCouponTableViewCell.h"

@implementation MyCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

-(void)initCellWithDataType:(CouponModel *)model{
   
    
   
    self.labelName.text = model.name;
     self.labelTitle.text = [NSString stringWithFormat:@"%@元",model.price];
    self.labelTime.text = [NSString stringWithFormat:@"%@ - %@",model.start_time,model.end_time];
    self.labelcontent.text = @"";
}
-(void)setType:(NSInteger)type{
    _type = type;
    [self.btnGet.layer setMasksToBounds:YES];
    [self.btnGet.layer setCornerRadius:10.f];
}
- (IBAction)getAction:(id)sender {
    
    self.getBlock();
    
}
- (IBAction)pressUsed:(id)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
