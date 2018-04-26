//
//  AddAddressViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/25.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"
#import "AddressModel.h"
@interface AddAddressViewController : HYBaseViewController
@property (nonatomic, retain) AddressModel *addressModel;
@property (nonatomic, copy) void(^returnLoadBlock)(void);
@end
