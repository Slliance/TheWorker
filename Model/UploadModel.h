//
//  UploadModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/11/2.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface UploadModel : BaseModel
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) BOOL isUploaded;

@end
