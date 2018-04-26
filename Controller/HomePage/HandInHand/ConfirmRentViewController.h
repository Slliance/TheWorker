//
//  ConfirmRentViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"
#import "RentPersonModel.h"
@interface ConfirmRentViewController : HYBaseViewController
@property (nonatomic, retain) NSDictionary *rentDic;
@property (nonatomic, retain) NSString *rentId;
@property (nonatomic, retain) RentPersonModel *personModel;
@end
