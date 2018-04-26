//
//  BannerModel.h
//  TheWorker
//
//  Created by yanghao on 9/7/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "BaseModel.h"

@interface BannerModel : BaseModel

@property (nonatomic, copy) NSString        *Id;
@property (nonatomic, copy) NSString        *content;
@property (nonatomic, copy) NSString        *createtime;
@property (nonatomic, copy) NSString        *img;
@property (nonatomic, copy) NSString        *relation_id;
@property (nonatomic, copy) NSString        *title;
@property (nonatomic, copy) NSString        *url;
@property (nonatomic, retain) NSNumber      *position;
@property (nonatomic, retain) NSNumber      *sort;
@property (nonatomic, retain) NSNumber      *type;



@end
