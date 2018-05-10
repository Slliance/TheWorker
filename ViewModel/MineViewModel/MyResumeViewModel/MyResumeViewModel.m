//
//  MyResumeViewModel.m
//  TheWorker
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "MyResumeViewModel.h"
#import "MyResumeModel.h"
@implementation MyResumeViewModel
-(void)previewMyResumeToken:(NSString *)token{
    NSDictionary *parameter = @{
                                @"token":token
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_resume method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            NSDictionary *dic = publicModel.data;
            MyResumeModel *model = [[MyResumeModel alloc]initWithDict:dic];
            self.returnBlock(model);
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
        
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)sendMyResumeParam:(SendResumesReq *)req{
    NSDictionary *parameter = (NSDictionary*)[req mj_keyValues];
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_send_resume method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            NSDictionary *dic = publicModel.data;
            self.returnBlock(dic);
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
        
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)deleteResumeToken:(NSString *)token{
    NSDictionary *parameter = @{
                                @"token":token
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_delete_resume method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            
            self.returnBlock(publicModel);
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
        
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)editMyResumeParam:(EditMyResumeReq *)req{
    NSDictionary *parameter = (NSDictionary*)[req mj_keyValues];
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_change_resume method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            NSDictionary *dic = publicModel.data;
            self.returnBlock(dic);
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
        
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
@end
