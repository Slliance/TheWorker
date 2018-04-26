//
//  FeedbackViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/11/7.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface FeedbackViewModel : BaseViewModel
-(void)feedbackWithToken:(NSString *)token text:(NSString *)text;
@end
