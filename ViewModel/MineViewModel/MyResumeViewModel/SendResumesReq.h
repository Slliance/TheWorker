//
//  SendResumesReq.h
//  TheWorker
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 huying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendResumesReq : NSObject
///
@property(nonatomic,copy)NSString* token;
///工作id
@property(nonatomic,copy)NSString* id;
///应聘职位
@property(nonatomic,copy)NSString*job;
///姓名
@property(nonatomic,copy)NSString*name;
@end
