//
//  AuthModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/19.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface AuthModel : BaseModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *auth_img;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, copy) NSString *upload_time;
@property (nonatomic, copy) NSString *show_img;

@end
