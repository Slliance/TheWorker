//
//  MyShoppingCartViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/4.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"

@interface MyShoppingCartViewController : HYBaseViewController
@property (nonatomic, copy) void(^returnReloadGoodsBlock)(void);
-(void)headerRefreshing;
@end
