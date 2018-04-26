//
//  BaseViewModel.m
//  zhongchuan
//
//  Created by yanghao on 9/8/16.
//  Copyright © 2016 huying. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

#pragma 接收穿过来的block
-(void) setBlockWithReturnBlock: (ReturnValueBlock) returnBlock
                 WithErrorBlock: (ErrorCodeBlock) errorBlock
{
    _returnBlock = returnBlock;
    _errorBlock = errorBlock;
}
-(void) setBlockWithSuccessBlock: (SuccessCodeBlock) successBlock
                 WithErrorBlock: (ErrorCodeBlock) errorBlock
{
    _successBlock = successBlock;
    _errorBlock = errorBlock;
}
#pragma 对ErrorCode进行处理
-(void) errorCodeWithDescribe: (NSString *) errorDescribe
{
    self.errorBlock(errorDescribe);
}

//上传数据成功
-(void)successCodeWithDescribe: (NSString *) successDescribe{
    self.successBlock(successDescribe);
}

//对PublicModel ，赋值
-(PublicModel *)publicModelInitWithData:(NSDictionary *)data{
    PublicModel *publicModel = [[PublicModel alloc] init];
    publicModel.message = [data objectForKey:@"message"];
    publicModel.code = [data objectForKey:@"code"];
    publicModel.data = [data objectForKey:@"data"];
    return publicModel;
}
@end
