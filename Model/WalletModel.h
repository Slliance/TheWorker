//
//  WalletModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/18.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface WalletModel : BaseModel
@property (nonatomic, retain) NSNumber *amount;
@property (nonatomic, retain) NSNumber *score;
@property (nonatomic, retain) NSNumber *card;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *Id;

@end
