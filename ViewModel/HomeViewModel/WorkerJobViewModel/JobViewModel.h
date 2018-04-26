//
//  JobViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/19.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface JobViewModel : BaseViewModel
//求职
-(void)fetchJobMainPageInfomationWithToken:(NSString *)token;

//工作详情
-(void)fetchJobDetailWithJobId:(NSNumber *)Id token:(NSString *)token;

//搜索
-(void)searchJobWithKey:(NSString *)search page:(NSNumber *)page size:(NSNumber *)size;

//填写简历
-(void)updateResumeWithName:(NSString *)name cradNo:(NSString *)cardno edu:(NSString *)edu nation:(NSString *)nation interest:(NSString *)interest resume:(NSString *)resume mobile:(NSString *)mobile sex:(NSNumber *)sex recommendUser:(NSString *)recommend_user token:(NSString *)token;

//求职(职位分类)
-(void)fetchJobCategoryWithJobType:(NSNumber *)job_type page:(NSNumber *)page size:(NSNumber *)size trade:(NSNumber *)trade zoneCode:(NSNumber *)zone_code;

//投递简历
-(void)applyWorkWithId:(NSNumber *)Id token:(NSString *)token job:(NSString *)job cardImg:(NSArray *)cardImg healthNo:(NSString *)healthNo skillImg:(NSString *)skillImg name:(NSString *)name cardno:(NSString *)cardno edu:(NSString *)edu nation:(NSString *)nation interest:(NSString *)interest resume:(NSString *)resume mobile:(NSString *)mobile sex:(NSNumber *)sex recommendUser:(NSString *)recommendUser;

//我的简历
-(void)fetchMyResumeWithToken:(NSString *)token;

//我的应聘
-(void)fetchMyJobApplyWithToken:(NSString *)token size:(NSNumber *)size page:(NSNumber *)page status:(NSNumber *)status;

//我的应聘详情
-(void)fetchMyApplicationInfoWithToken:(NSString *)token Id:(NSString *)Id;

@end
