//
//  OrderHeaderView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/22.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
@interface OrderHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btnChooseAddress;
@property (nonatomic, copy) void(^returnBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

-(void)initViewWith:(AddressModel *)model;
-(void)initOrderViewWith:(AddressModel *)model;
@end
