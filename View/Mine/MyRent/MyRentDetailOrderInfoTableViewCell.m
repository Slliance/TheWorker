//
//  MyRentDetailOrderInfoTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/13.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyRentDetailOrderInfoTableViewCell.h"

@implementation MyRentDetailOrderInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initCellWith:(RentOrderModel *)model{

    self.rentOrderModel = model;
    
    if ([model.status integerValue] == 1 || [model.status integerValue] == 2 || [model.status integerValue] == 4 || [model.status integerValue] == 6) {
        return ;
    }
    NSString *remarkStr = [[NSString alloc] init];
        if ([model.type integerValue] == 1) {
            remarkStr = model.user_remark;
        }else{
            remarkStr = model.rent_remark;
        }
        self.labelReason.text = remarkStr;
        CGFloat pointY = 15;
        if ([model.status integerValue] == 3) {
            self.labelState.text = @"拒绝原因";
            remarkStr = model.refund_reason;
            self.labelReason.text = remarkStr;
        }
        if ([model.status integerValue] == 5) {
            //图片
            
            CGFloat w = (ScreenWidth-95-30) / 3;
            CGFloat margin = 10;
            if (model.img.count > 0) {
                UILabel *label = [[UILabel alloc] init];
                label.text = @"证据照片";
                label.frame = CGRectMake(10, pointY, 60, 20);
                label.font = [UIFont systemFontOfSize:13];
                label.textColor = [UIColor colorWithHexString:@"333333"];
                [self addSubview:label];
            }
            
            for (int i = 0; i < model.img.count; i ++) {
                
                UIImageView *image = [[UIImageView alloc]init];
                [image setContentMode:UIViewContentModeScaleAspectFill];
                image.clipsToBounds = YES;
                [image setUserInteractionEnabled:YES];
                image.tag = 800 + i;
                image.frame = CGRectMake(95 + (i%3)*(w+margin), pointY + (i/3)*(w+margin), w, w);
                [image setImageWithString:model.img[i] placeHoldImageName:placeholderImage_home_banner];
                [self addSubview:image];
                
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                [image addGestureRecognizer:tap];
            }
            if (model.img.count) {
                pointY += model.img.count % 3 ? (model.img.count / 3 + 1) * (w + margin) + 10 : model.img.count / 3 * (w + margin) + 10;
            }
            self.labelState.text = @"补充原因";

            if (model.user_exception_remark.length == 0) {
                remarkStr = model.rent_exception_remark;
            }else{
                remarkStr = model.user_exception_remark;
            }
            CGSize size = [remarkStr sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth-95, 3000)];
            if (model.user_remark.length == 0) {
                size.height = 30;
            }

        }
        if ([model.status integerValue] == 7) {
            self.labelState.text = @"取消原因";
            remarkStr = model.refund_reason;
            self.labelReason.text = remarkStr;
        }
        CGSize size = [remarkStr sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth-95, 3000)];
        self.labelState.hidden = NO;
        if (remarkStr.length == 0) {
            //        self.labelState.hidden = YES;
        }
        self.labelReason.text = remarkStr;
        CGRect rect = self.labelReason.frame;
        rect.size.height = size.height;
        rect.origin.y = pointY;
        self.labelReason.frame = rect;
        CGRect rectState = self.labelState.frame;
        rectState.origin.y = pointY;
        rectState.size.height = 15;
        self.labelState.frame = rectState;
}

+(CGFloat)getCellHeightWithData:(RentOrderModel *)model{
    CGFloat height = 0;
    if ([model.status integerValue] == 1 || [model.status integerValue] == 2 || [model.status integerValue] == 4 || [model.status integerValue] == 6) {
        return 0;
    }
    
    if ([model.status integerValue] == 5) {
        NSArray *imgArr = model.img;
        CGFloat w = (ScreenWidth-95) / 3;
        height += (imgArr.count+2)/3 * w + 30;
        if ([model.type integerValue] == 1) {
            CGSize size = [model.user_exception_remark sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth-95, 3000)];
            if (model.user_remark.length == 0) {
                size.height = 30;
            }
            height += size.height + 30;
        }else{
            CGSize size = [model.rent_exception_remark sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth-95, 3000)];
            if (model.rent_remark.length == 0) {
                size.height = 30;
            }
            height += size.height + 30;
        }
        
        
        return height;
    }
    
    if ([model.type integerValue] == 1) {
        
//        if (model.user_remark.length > 0) {
            CGSize size = [model.refund_reason sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth-95, 3000)];
            height += size.height + 30;
//        }else{
//            height += 20;
//        }
    }else{

//        if (model.rent_remark.length > 0) {
            CGSize size = [model.refund_reason sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth-95, 3000)];
            height += size.height + 30;
//        }else{
//            height += 20;
//        }
    }
    
    
    NSLog(@"%f",height);
    return height;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)tapAction:(UITapGestureRecognizer *)ges{
    
    self.photoBlock(self.rentOrderModel, ges.view.tag - 800);
    
}
@end
