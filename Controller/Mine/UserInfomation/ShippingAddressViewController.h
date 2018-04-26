//
//  ShippingAddressViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/24.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"
#import "AddressModel.h"
@interface ShippingAddressViewController : HYBaseViewController
@property (nonatomic, copy) void(^returnAddressBlcok)(AddressModel*);
@property (nonatomic, assign) NSInteger isChooseOrChange;
@end
