//
//  MyCardListViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"
#import "WalletModel.h"
@interface MyCardListViewController : HYBaseViewController
@property (nonatomic, assign) BOOL isChoose;
@property (nonatomic, retain) NSNumber *selectIndex;
@property (nonatomic, copy) void(^returnBlock)(WalletModel *,NSInteger index);
@end
