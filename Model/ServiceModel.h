//
//  ServiceModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/12.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface ServiceModel : BaseModel
@property (nonatomic, copy) NSString *weibo;
@property (nonatomic, copy) NSString *wechat;
@property (nonatomic, retain) NSNumber *qq;
@end
