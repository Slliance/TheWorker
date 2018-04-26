//
//  MyRentDetailInfoTableViewCell.m
//  TheWorker
//
//  Created by yanghao on 9/2/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "MyRentDetailInfoTableViewCell.h"

@implementation MyRentDetailInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initCellWith:(RentOrderModel *)model{
    self.timeLabel.text = model.appointment;
    self.itemLabel.text = model.item;
    self.rentLongLabel.text = [NSString stringWithFormat:@"%@小时",model.rent_long];
    self.msgLabel.text = model.msg;
    self.labelAddress.text = model.meet_address;
//    [self.btnAddress setTitle:model.meet_address forState:UIControlStateNormal];
    CGSize size = [model.meet_address sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ScreenWidth - 120, 400)];
    //地址
    CGRect rect = self.labelAddress.frame;
//    rect.size.width = size.width;
    rect.size.height = size.height;
    self.labelAddress.frame = rect;
    //时长
    CGRect rectLong = self.rentLongLabel.frame;
    rectLong.origin.y = rect.size.height + rect.origin.y + 10.f;
    self.rentLongLabel.frame = rectLong;
    CGRect rectlong = self.rentLonglabel.frame;
    rectlong.origin.y = rect.size.height + rect.origin.y + 10.f;
    self.rentLonglabel.frame = rectlong;
    //留言
    CGRect rectmsg = self.msgTitleLabel.frame;
    rectmsg.origin.y = rectlong.size.height + rectlong.origin.y + 10.f;
    self.msgTitleLabel.frame = rectmsg;
    
    CGSize msgSize = [model.msg sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ScreenWidth - 100, 400)];
    CGRect rectMsg = self.msgLabel.frame;
    rectMsg.origin.y = rectlong.size.height + rectlong.origin.y + 10.f;
//    rectMsg.size.width = msgSize.width;
    rectMsg.size.height = msgSize.height;
    self.msgLabel.frame = rectMsg;
    
    
    
    
}
- (IBAction)skipToMap:(id)sender {
    self.skipToMapBlock();
}
+(CGFloat)getHeightWithModel:(RentOrderModel *)model{
    CGFloat height = 130;
    CGSize size = [model.meet_address sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ScreenWidth - 120, 400)];
    CGSize msgSize = [model.msg sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ScreenWidth - 100, 400)];
    return height + size.height + msgSize.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
