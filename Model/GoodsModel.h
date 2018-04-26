//
//  GoodsModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/9.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"
//积分商品model
@interface GoodsModel : BaseModel

@property (nonatomic, copy) NSString        *name;
@property (nonatomic, retain) NSArray        *imgs;
@property (nonatomic, copy) NSString        *show_img;
@property (nonatomic, copy) NSString        *exchange_time  ;
@property (nonatomic, copy) NSString        *title;
@property (nonatomic, copy) NSString        *address;
@property (nonatomic, copy) NSString        *content;
@property (nonatomic, copy) NSString        *Id;
@property (nonatomic, retain) NSNumber        *friend_amount;
@property (nonatomic, retain) NSNumber        *is_collect;
@property (nonatomic, retain) NSNumber        *sku;
@property (nonatomic, retain) NSNumber        *repeat_exchange  ;
@property (nonatomic, retain) NSNumber        *point  ;
@property (nonatomic, retain) NSNumber        *exchanged_count  ;
@property (nonatomic, copy) NSString        *goods_detail  ;


@property (nonatomic, copy) NSString        *share  ;

@end
