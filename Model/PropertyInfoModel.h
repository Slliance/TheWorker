//
//  PropertyInfoModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/30.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface PropertyInfoModel : BaseModel
@property (nonatomic, retain) NSNumber        *original_price;
@property (nonatomic, retain) NSNumber        *price;
@property (nonatomic, retain) NSNumber        *sku;
@property (nonatomic, copy) NSString          *img;
@property (nonatomic, retain) NSArray *property;
@end
