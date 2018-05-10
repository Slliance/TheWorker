//
//  MyResumeViewModel.h
//  TheWorker
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "BaseViewModel.h"
#import "SendResumesReq.h"
#import "EditMyResumeReq.h"
@interface MyResumeViewModel : BaseViewModel
///我的简历
-(void)previewMyResumeToken:(NSString *)token;
///投递简历
-(void)sendMyResumeParam:(SendResumesReq *)req;
///删除简历
-(void)deleteResumeToken:(NSString *)token;
///编辑、修改简历
-(void)editMyResumeParam:(EditMyResumeReq *)req;
@end
