//
//  CareViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/22.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface CareViewModel : BaseViewModel
//员工关怀首页
-(void)fetchWorkCareMainPageWithToken:(NSString *)token;

//衣食住行列表
-(void)fetchCareListWithToken:(NSString *)token page:(NSNumber *)page size:(NSNumber *)size;

//员工餐饮
-(void)fetchWorkerFoodListWithToken:(NSString *)token page:(NSNumber *)page size:(NSNumber *)size zone_code:(NSNumber *)zone_code;

//员工住宿
-(void)fetchWorkerLiveListWithToken:(NSString *)token page:(NSNumber *)page size:(NSNumber *)size zone_code:(NSNumber *)zone_code room_id:(NSNumber *) room_id price_id:(NSNumber *)price_id;
@end
