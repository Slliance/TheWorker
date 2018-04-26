//
//  ArticleModel.h
//  TheWorker
//
//  Created by yanghao on 9/7/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "BaseModel.h"

@interface ArticleModel : BaseModel

@property (nonatomic, copy) NSString        *createtime;
@property (nonatomic, copy) NSString        *detail_url;
@property (nonatomic, copy) NSString        *Id;
@property (nonatomic, copy) NSString        *title;
@property (nonatomic, retain) NSNumber        *click_count;
@property (nonatomic, copy) NSString        *content;
@property (nonatomic, copy) NSString        *show_img;
@property (nonatomic, copy) NSString        *img;
@property (nonatomic, retain) NSNumber        *is_collect;
@property (nonatomic, retain) NSNumber        *type;
@property (nonatomic, copy) NSString *collect_id;

@end
