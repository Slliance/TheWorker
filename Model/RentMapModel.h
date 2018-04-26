//
//  RentMapModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/31.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface RentMapModel : BaseModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, copy) NSString *address;
@end
