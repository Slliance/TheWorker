//
//  WorkerWelfareViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/8.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface WorkerWelfareViewModel : BaseViewModel
//获取福利首页数据
-(void)getWorkerWelfareInfomationWith:(NSString *)token;
//获取福利信息列表数据
-(void)getArticleListWithToken:(NSString *)token page:(NSNumber *)page;


@end
