//
//  RentModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/9.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface RentModel : BaseModel

@property (nonatomic, copy) NSString        *name;
@property (nonatomic, copy) NSString        *nickname;
@property (nonatomic, copy) NSString        *headimg;
@property (nonatomic, copy) NSString        *uid;
@property (nonatomic, retain) NSNumber      *trust  ;
@property (nonatomic, retain) NSNumber      *score  ;
@property (nonatomic, retain) NSNumber        *price;
@property (nonatomic, copy) NSString        *showimg;
@property (nonatomic, retain) NSArray       *img;
@property (nonatomic, retain) NSArray        *tag  ;

@end
