//
//  OrderHeaderView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/22.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "OrderHeaderView.h"

@implementation OrderHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initViewWith:(AddressModel *)model{
    if (model.Id.length > 0) {
        self.nameLabel.text = model.name;
        self.mobileLabel.text = [NSString stringWithFormat:@"%@",model.mobile];
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@",model.zone_city,model.address_detail];
    }else{
        self.nameLabel.text = @"";
        self.mobileLabel.text = @"";
        self.addressLabel.text = @"请选择收货地址";
        self.addressLabel.center = self.btnChooseAddress.center;
        CGRect rect = self.addressLabel.frame;
        rect.origin.x = 10;
        self.addressLabel.frame = rect;
        
    }
}

-(void)initOrderViewWith:(AddressModel *)model{
    self.nameLabel.text = model.name;
    self.mobileLabel.text = [NSString stringWithFormat:@"%@",model.mobile];
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@",model.zone_city,model.address_detail];
    self.btnChooseAddress.hidden = YES;

}

- (IBAction)chooseAddress:(id)sender {
    self.returnBlock();
}

@end
