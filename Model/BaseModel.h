//
//  BaseModel.h
//  zhongchuan
//
//  Created by yanghao on 9/8/16.
//  Copyright © 2016 huying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYZBaseModel.h"
#import "BaseModel.h"
#import "PublicModel.h"
@interface BaseModel : CYZBaseModel

@property (nonatomic, retain)PublicModel *publicModel;

@end
