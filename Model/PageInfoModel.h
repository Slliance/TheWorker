//
//  ListInfoModel.h
//  zhongchuan
//
//  Created by yanghao on 9/10/16.
//  Copyright © 2016 huying. All rights reserved.
//

#import "BaseModel.h"

@interface PageInfoModel : BaseModel
@property (nonatomic, retain)NSNumber *isEnd;
@property (nonatomic, retain)NSNumber *currentCount;
@property (nonatomic, retain)NSNumber *page;
@property (nonatomic, retain)NSNumber *total;
@property (nonatomic, retain)NSNumber *pageSize;

@end
