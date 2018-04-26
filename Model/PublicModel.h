//
//  PubulicModel.h
//  zhongchuan
//
//  Created by yanghao on 9/8/16.
//  Copyright © 2016 huying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicModel : NSObject

@property (nonatomic, retain) NSNumber *code;
@property (nonatomic, assign) BOOL *success;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) id data;

@end
