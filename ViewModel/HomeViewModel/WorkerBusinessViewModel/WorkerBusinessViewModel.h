//
//  WorkerBusinessViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/12.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface WorkerBusinessViewModel : BaseViewModel
-(void)getWorkerBusinessDataWithToken:(NSString *)token;
-(void)fetchBusinessInfoListWithToken:(NSString *)token page:(NSNumber *)page;
-(void)fetchBusinessParterList;
@end
