//
//  WorkerHandInViewModel.h
//  TheWorker
//
//  Created by yanghao on 9/9/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "BaseViewModel.h"
#import "AddFateReq.h"
@interface WorkerHandInViewModel : BaseViewModel


//获取员工牵手首页数据
-(void)fetchWorkerHandInListWith:(NSString *)token;

//获取员工相亲数据列表
-(void)fetchWorkerHandInPersonListWith:(NSString *)token page:(NSInteger)page min_age:(NSNumber *)min_age max_age:(NSNumber *)max_age zone_code:(NSNumber *)zone_code sex:(NSNumber *)sex;

//员工相亲详情
-(void)fetchWorkerHandInDetailWith:(NSString *)token Id:(NSString *)Id;

//发布个人信息
-(void)publishHandInHanInfoWithReq:(AddFateReq*)req;
//我的相亲详情
-(void)fetchMyFateDetailWithToken:(NSString *)token;

//获取当前经纬度
-(void)getAPositionWithToken:(NSString *)token Lon:(NSString*)lon Lat:(NSString*)lat;
@end
