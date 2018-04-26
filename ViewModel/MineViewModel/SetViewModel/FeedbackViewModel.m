//
//  FeedbackViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/11/7.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "FeedbackViewModel.h"

@implementation FeedbackViewModel
-(void)feedbackWithToken:(NSString *)token text:(NSString *)text{
    NSDictionary *parameter = @{@"token":token,
                                @"content":text
                                    };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_feed_back method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel.message);
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
@end
