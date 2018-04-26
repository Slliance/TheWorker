//
//  FriendDetailViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/20.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"
#import "AddressBookFriendModel.h"
@interface FriendDetailViewController : HYBaseViewController
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *applyId;
@property (nonatomic, assign) NSInteger status;
@end
