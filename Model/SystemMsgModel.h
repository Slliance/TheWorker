//
//  SystemMsgModel.h
//  jishikangUser
//
//  Created by yanghao on 7/14/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "BaseMsgModel.h"

@interface SystemMsgModel : BaseMsgModel
@property (nonatomic, copy)                 NSString *title;
@property (nonatomic, copy)                 NSString *content;
@property (nonatomic, copy)                 NSString *uid;
@property (nonatomic, copy)                 NSString *createtime;
@end
