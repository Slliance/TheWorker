//
//  BankModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/20.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface BankModel : BaseModel
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *real_name;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, retain) NSNumber *card;

@end
