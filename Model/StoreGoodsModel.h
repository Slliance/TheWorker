//
//  StoreGoodsModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/26.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"
#import "StoreModel.h"
@interface StoreGoodsModel : BaseModel

@property (nonatomic, retain) NSNumber *category_id;
@property (nonatomic, retain) NSNumber *price;
@property (nonatomic, retain) NSNumber *preferential_price;
@property (nonatomic, retain) NSNumber *original_price;
@property (nonatomic, retain) NSNumber *sku;
@property (nonatomic, retain) NSNumber *sales_volume;
@property (nonatomic, retain) NSNumber *store_id;
@property (nonatomic, retain) NSNumber *allow_coupon;
@property (nonatomic, retain) NSNumber *is_collect;
@property (nonatomic, retain) NSNumber *goods_number;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, retain) NSNumber *trans_price;
@property (nonatomic, retain) NSNumber *checked;
@property (nonatomic, retain) NSNumber *status;
@property (nonatomic, retain) NSNumber *number;
@property (nonatomic, retain) NSNumber *refund_status;
@property (nonatomic, retain) NSNumber *score;
@property (nonatomic, retain) NSNumber *shop_num;
@property (nonatomic, retain) NSNumber *have;
@property (nonatomic, retain) NSNumber *pub;
@property (nonatomic, retain) NSArray *goods_img;
@property (nonatomic, retain) NSArray *property;
@property (nonatomic, retain) NSArray *property_tag;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *show_img;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, copy) NSString *goods_detail;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, retain) StoreModel    *store;


@property (nonatomic, copy) NSString *share;



@end
