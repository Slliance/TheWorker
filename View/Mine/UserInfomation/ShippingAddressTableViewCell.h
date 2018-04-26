//
//  ShippingAddressTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/24.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddressModel.h"
@interface ShippingAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNO;
@property (weak, nonatomic) IBOutlet UILabel *labelDefault;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
-(void)initCellWithData:(AddressModel *)model;
@end
