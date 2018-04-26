//
//  AddressModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/28.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface AddressModel : BaseModel
@property (nonatomic, retain) NSNumber *zone_code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSNumber *mobile;
@property (nonatomic, retain) NSNumber *post_code;
@property (nonatomic, copy) NSString *address_detail;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, retain) NSNumber *is_def;
@property (nonatomic, copy) NSString *zone;
@property (nonatomic, copy) NSString *zone_city;
@end

