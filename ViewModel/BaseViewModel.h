//
//  BaseViewModel.h
//  zhongchuan
//
//  Created by yanghao on 9/8/16.
//  Copyright © 2016 huying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublicModel.h"
#import "PageInfoModel.h"
#import "HYNetwork.h"
#import "HYNetWorkHead.h"
@interface BaseViewModel : NSObject
@property (strong, nonatomic) ReturnValueBlock returnBlock;
@property (strong, nonatomic) ErrorCodeBlock errorBlock;
@property (strong, nonatomic) SuccessCodeBlock successBlock;

// 传入交互的Block块
-(void) setBlockWithReturnBlock: (ReturnValueBlock) returnBlock
                 WithErrorBlock: (ErrorCodeBlock) errorBlock;

-(void) setBlockWithSuccessBlock: (SuccessCodeBlock) successBlock
                  WithErrorBlock: (ErrorCodeBlock) errorBlock;

-(void)errorCodeWithDescribe:(NSString *)errorDescribe;

-(void)successCodeWithDescribe:(NSString *)successDescribe;

//对PublicModel ，赋值

-(PublicModel *)publicModelInitWithData:(NSDictionary *)data;
@end
