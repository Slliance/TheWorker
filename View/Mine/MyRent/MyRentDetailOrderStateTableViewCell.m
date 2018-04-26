//
//  MyRentDetailOrderStateTableViewCell.m
//  TheWorker
//
//  Created by yanghao on 9/2/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "MyRentDetailOrderStateTableViewCell.h"

@implementation MyRentDetailOrderStateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initCellWith:(RentOrderModel *)model{
    NSInteger status = [model.status integerValue];
    switch (status ) {
        case 1:
            self.disagreeLabel.text = @"待同意";
            self.timeLabel.text = model.confirmed_time;
            [self creatSuccessView:model];
            
            break;
        case 2:
            self.stateLabel.text = @"已同意";
            self.disagreeLabel.text = @"待见面";
            self.timeLabel.text = model.confirmed_time;
            [self creatSuccessView:model];
            break;
        case 3:
            self.disagreeLabel.text = @"已拒绝";
            self.stateLabel.hidden = YES;
            self.timeLabel.hidden = YES;
            break;
        case 4:
            self.stateLabel.text = @"已同意";
            if ([model.status2 integerValue] == 2) {
                self.disagreeLabel.text = @"待见面";
            }else{
                self.disagreeLabel.text = @"待评价";
            }
            self.timeLabel.text = model.confirmed_time;
            [self creatSuccessView:model];
            break;
        case 5:
            self.stateTitleLabel.text = @"审核状态";
            self.stateLabel.text = @"已同意";
            if ([model.exception_status integerValue] == 1) {
                self.disagreeLabel.text = @"审核中";
            }else if ([model.exception_status integerValue] == 2){
                self.disagreeLabel.text = @"已通过";
            }else{
                self.disagreeLabel.text = @"未通过";
            }
            self.timeLabel.text = model.confirmed_time;
            [self creatSuccessView:model];
            break;
        case 6:
            self.stateLabel.text = @"已同意";
            self.disagreeLabel.text = @"已评价";
            self.timeLabel.text = model.confirmed_time;
            [self creatSuccessView:model];
            break;
        case 7:
            self.disagreeLabel.text = @"已取消";
            self.stateLabel.hidden = YES;
            self.timeLabel.hidden = YES;
            break;
        case 8:
            self.stateLabel.text = @"已同意";
            self.disagreeLabel.hidden = YES;
            self.timeLabel.text = model.confirmed_time;
            [self creatSuccessView:model];
            break;
        default:
            break;
    }
}
-(void)creatSuccessView:(RentOrderModel *)model{
    for (UIView *view in self.subviews) {
        if (view.tag > 800) {
            [view removeFromSuperview];
        }
    }
    NSInteger type = [model.type integerValue];
        //第二行
        UILabel *labelRent = [[UILabel alloc] init];
        labelRent.font = [UIFont systemFontOfSize:12];
        labelRent.textColor = [UIColor colorWithHexString:@"666666"];
        labelRent.frame = CGRectMake(25, 60, 130, 20);
        labelRent.tag = 801;
        [self addSubview:labelRent];
        UILabel *labelRentTime = [[UILabel alloc] init];
        labelRentTime.font = [UIFont systemFontOfSize:12];
        labelRentTime.textColor = [UIColor colorWithHexString:@"666666"];
        labelRentTime.frame = CGRectMake(155, 60, ScreenWidth-160, 20);
        labelRentTime.tag = 802;
        [self addSubview:labelRentTime];
        //第三行
        UILabel *labelUser = [[UILabel alloc] init];
        labelUser.font = [UIFont systemFontOfSize:12];
        labelUser.textColor = [UIColor colorWithHexString:@"666666"];
        labelUser.frame = CGRectMake(25, 85, 130, 20);
        labelUser.tag = 803;
        [self addSubview:labelUser];
        UILabel *labelUserTime = [[UILabel alloc] init];
        labelUserTime.font = [UIFont systemFontOfSize:12];
        labelUserTime.textColor = [UIColor colorWithHexString:@"666666"];
        labelUserTime.frame = CGRectMake(155, 85, ScreenWidth-160, 20);
        labelUserTime.tag = 804;
        [self addSubview:labelUserTime];
    
        //第四行
        UILabel *labelRemark = [[UILabel alloc] init];
        labelRemark.font = [UIFont systemFontOfSize:12];
        labelRemark.textColor = [UIColor colorWithHexString:@"666666"];
        labelRemark.frame = CGRectMake(25, 110, 130, 20);
        labelRemark.tag = 805;
        UILabel *labelRemarkTime = [[UILabel alloc] init];
        labelRemarkTime.font = [UIFont systemFontOfSize:12];
        labelRemarkTime.textColor = [UIColor colorWithHexString:@"666666"];
        labelRemarkTime.frame = CGRectMake(155, 110, ScreenWidth-160, 20);
        labelRemarkTime.tag = 806;
        [self addSubview:labelRemarkTime];
        [self addSubview:labelRemark];
    //我租的人
    if (type == 1) {
        //待见面
        if ([model.status integerValue] == 2 && [model.status2 integerValue] == 4) {
            labelRent.text = @"出租方确认已见面";
            labelRentTime.text = model.rent_meeting_time;
        }
        //待评价
        else if ([model.status integerValue] == 4){
            labelUser.text = @"我已确认见面";
            labelRent.text = @"出租方确认已见面";
            labelUserTime.text = model.user_meeting_time;
            labelRentTime.text = model.rent_meeting_time;
        }
        //有异议
        else if ([model.status integerValue] == 5){
            if ([model.exception_status integerValue] == 1) {
                if (model.user_exception_remark.length == 0) {
                    labelRent.text = @"出租方提交时间";
                }else{
                    labelRent.text = @"我方提交时间";
                }
                labelRentTime.text = model.exception_time;
            }else{
                if (model.user_exception_remark.length == 0) {
                    labelRent.text = @"出租方提交时间";
                }else{
                    labelRent.text = @"我方提交时间";
                }
                labelRentTime.text = model.exception_time;
                labelUser.text = @"审核时间";
                labelUserTime.text = model.comment_time;
            }
            
        }
        //已评价
        else if ([model.status integerValue] == 6){
            if ([model.exception_status integerValue] == 0) {
                labelUser.text = @"我已确认见面";
                labelRent.text = @"出租方确认已见面";
                labelUserTime.text = model.user_meeting_time;
                labelRentTime.text = model.rent_meeting_time;
                labelRemark.text = @"评价时间";
                labelRemarkTime.text = model.user_comment_time;
            }else{
                if (model.user_exception_remark.length == 0) {
                    labelRent.text = @"出租方提交时间";
                }else{
                    labelRent.text = @"我方提交时间";
                }
                labelRentTime.text = model.exception_time;
                labelUser.text = @"审核时间";
                labelUserTime.text = model.comment_time;
                labelRemark.text = @"评价时间";
                labelRemarkTime.text = model.user_comment_time;
            }
            
        }
    
    }
    //租我的人
    else{
        //待见面
        if ([model.status integerValue] == 4) {
            if ([model.status2 integerValue] == 2) {
                labelRent.text = @"我已确认见面";
                labelRentTime.text = model.rent_meeting_time;
            }else{
                labelUser.text = @"租赁方确认已见面";
                labelRent.text = @"我已确认见面";
                labelUserTime.text = model.user_meeting_time;
                labelRentTime.text = model.rent_meeting_time;
            }
            
        }
//        //待评价
//        else if ([model.status integerValue] == 4 && [model.status2 integerValue] == 4){
//
//        }
    
        //有异议
        else if ([model.status integerValue] == 5){
            if ([model.exception_status integerValue] == 1) {
                if (model.user_exception_remark.length == 0) {
                    labelRent.text = @"我方提交时间";
                }else{
                    labelRent.text = @"租赁方提交时间";
                }
                labelRentTime.text = model.exception_time;
            }else{
                labelRent.text = @"我方提交时间";
                labelRentTime.text = model.exception_time;
                labelUser.text = @"审核时间";
                labelUserTime.text = model.comment_time;
            }
            
        }
        //已评价
        else if ([model.status integerValue] == 6){
            if ([model.exception_status integerValue] == 0) {
                labelUser.text = @"租赁方确认已见面";
                labelRent.text = @"我已确认见面";
                labelUserTime.text = model.user_meeting_time;
                labelRentTime.text = model.rent_meeting_time;
                labelRemark.text = @"评价时间";
                labelRemarkTime.text = model.rent_comment_time;
            }else{
                if (model.user_exception_remark.length == 0) {
                    labelRent.text = @"我方提交时间";
                }else{
                    labelRent.text = @"租赁方提交时间";
                }
                labelRentTime.text = model.exception_time;
                labelUser.text = @"审核时间";
                labelUserTime.text = model.comment_time;
                labelRemark.text = @"评价时间";
                labelRemarkTime.text = model.rent_comment_time;
            }
        }
    }
    
//    }
}

+(CGFloat)getCellHeightWith:(RentOrderModel *)model{
    NSInteger status = [model.status integerValue];
    CGFloat height = 0;
    switch (status ) {
        case 1:
            height += 40;
            break;
        case 2:
            if ([model.status2 integerValue] == 2) {
                height += 60;
            }else if ([model.status2 integerValue] == 4){
                height += 85;
            }
            break;
        case 3:
            height += 40;
            break;
        case 4:
//            if ([model.status2 integerValue] == 4) {
                height += 110;
//            }
//            else if ([model.status2 integerValue] == 6){
//                height += 135;
//            }

            break;
        case 5:
            if ([model.exception_status integerValue] == 1) {
                height += 85;
            }else{
                height += 110;
            }
            break;
        case 6:
           height += 135;
            break;
        case 7:
            height += 40;
            break;
        case 8:
            height += 150;
            break;
        default:
            break;
    }
    return height;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
