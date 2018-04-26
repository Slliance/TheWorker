//
//  MessageViewModel.m
//  jishikangUser
//
//  Created by yanghao on 7/14/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "MessageViewModel.h"
#import "SystemMsgModel.h"
@implementation MessageViewModel



//消息列表
-(void)fetchMsg:(NSInteger)page token:(NSString *)token{
    NSDictionary *parameter = @{
                                @"page":@(page),
                                @"size":@(10),
                                @"token":token
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_system_msg method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleMsgListWithUid:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
        
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];

}

-(void)handleMsgListWithUid:(PublicModel *)publicModel{
    
    NSArray *arr = publicModel.data;
    NSMutableArray *muarr = [[NSMutableArray alloc] init];
    for (int i = 0; i < arr.count; i ++) {
        SystemMsgModel *model = [[SystemMsgModel alloc] initWithDict:arr[i]];
        [muarr addObject:model];
    }
    self.returnBlock(muarr);
}


-(void)delMessageWithId:(NSString *)Id token:(NSString *)token{
    NSDictionary *parameter = @{@"id":Id,
                                @"token":token
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_system_msg_del method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel.message);
        }else{
            self.errorBlock(publicModel.message);
        }
    } fail:^(NSString *error) {
        //
    }];
}


@end
