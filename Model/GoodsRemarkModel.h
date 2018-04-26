//
//  GoodsRemarkModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/26.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface GoodsRemarkModel : BaseModel


@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, retain) NSNumber *score;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *headimg;


@end
