//
//  GoodsPropertyModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/26.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface GoodsPropertyModel : BaseModel
@property (nonatomic, copy) NSString *property_id;
@property (nonatomic, retain) NSArray *property;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSNumber *checked;
@end
