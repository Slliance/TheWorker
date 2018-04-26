//
//  JobViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/19.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "JobViewModel.h"
#import "BannerModel.h"
#import "JobModel.h"
#import "ResumeModel.h"
#import "MyApplicationModel.h"
@implementation JobViewModel

/**
 求职首页
 */
-(void)fetchJobMainPageInfomationWithToken:(NSString *)token{
    NSDictionary *parameter = @{@"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_job_home method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            
            [self handleHomeDataWithPublicModel:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//对首页数据处理
-(void)handleHomeDataWithPublicModel: (PublicModel *) publicModel
{
    NSArray *jobArr = [publicModel.data objectForKey:@"list"];
    NSArray *bannerArr = [publicModel.data objectForKey:@"banner"];
    
    NSMutableArray *muJobArr = [[NSMutableArray alloc] init];
    NSMutableArray *mubannerArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < jobArr.count; i ++) {
        JobModel *model = [[JobModel alloc] initWithDict:jobArr[i]];
        [muJobArr addObject:model];
    }
    
    for (int i = 0; i < bannerArr.count; i ++) {
        BannerModel *model = [[BannerModel alloc] initWithDict:bannerArr[i]];
        [mubannerArr addObject:model];
    }
    
        self.returnBlock(@[mubannerArr,muJobArr]);
}




/**
 工作详情

 @param Id 工作id
 */
-(void)fetchJobDetailWithJobId:(NSNumber *)Id token:(NSString *)token{
    NSDictionary *parameter = @{@"id":Id,
                                @"token":token
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_job_detail method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            
            [self handleJobDetailInfoWith:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)handleJobDetailInfoWith:(PublicModel *)publicModel{
    JobModel *model= [[JobModel alloc]initWithDict:publicModel.data];
    self.returnBlock(model);
}



/**
 求职搜索

 @param search 关键字
 @param page 起始页
 @param size 每页数量
 */
-(void)searchJobWithKey:(NSString *)search page:(NSNumber *)page size:(NSNumber *)size{
    NSDictionary *parameter = @{@"search":search,
                                @"page":page,
                                @"size":@(10)};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_job_jobSearch method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            
            [self handleSearchDataWith:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)handleSearchDataWith:(PublicModel *)publicModel{
    NSArray *searchArr = publicModel.data;
    NSMutableArray *muSearchArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < searchArr.count; i ++) {
        JobModel *model = [[JobModel alloc]initWithDict:searchArr[i]];
        [muSearchArr addObject:model];
    }
    self.returnBlock(muSearchArr);
}


/**
 编辑简历

 @param name 名字
 @param cardno 身份证号码
 @param edu 学历
 @param nation 民族
 @param interest 兴趣
 @param resume 简历
 @param mobile 电话
 @param sex 性别   0 / 1
 @param recommend_user 推荐人（非必填）
 */
-(void)updateResumeWithName:(NSString *)name cradNo:(NSString *)cardno edu:(NSString *)edu nation:(NSString *)nation interest:(NSString *)interest resume:(NSString *)resume mobile:(NSString *)mobile sex:(NSNumber *)sex recommendUser:(NSString *)recommend_user token:(NSString *)token{
    NSDictionary *parameter = @{@"name":name,
                                @"cardno":cardno,
                                @"edu":edu,
                                @"nation":nation,
                                @"interest":interest,
                                @"resume":resume,
                                @"mobile":mobile,
                                @"sex":sex,
                                @"recommendUser":recommend_user,
                                @"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_job_resume method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel.message);
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}


/**
 求职(职位分类)

 @param job_type 1-长期工 2-兼职工 3-紧急工
 @param page page 默认为1
 @param size size
 @param trade 行业id 1-大型工厂 2-其他行业
 @param zone_code 地区code
 */
-(void)fetchJobCategoryWithJobType:(NSNumber *)job_type page:(NSNumber *)page size:(NSNumber *)size trade:(NSNumber *)trade zoneCode:(NSNumber *)zone_code{
    NSDictionary *parameter = @{@"job_type":job_type,
                                @"page":page,
                                @"trade":trade,
                                @"size":@(10)};
    NSMutableDictionary *muParameter = [[NSMutableDictionary alloc]initWithDictionary:parameter];
    if (zone_code) {
        [muParameter setObject:zone_code forKey:@"zone_code"];
    }
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_job_jobList method:@"post" parameter:muParameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            
            [self handleCategoryData:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//对分类数据处理
-(void)handleCategoryData:(PublicModel *)publicModel{
    NSArray *jobArr = publicModel.data;
    NSMutableArray *muJobArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < jobArr.count; i ++) {
        JobModel *model = [[JobModel alloc] initWithDict:jobArr[i]];
        [muJobArr addObject:model];
    }
    self.returnBlock(muJobArr);
}





/**
 投递简历

 @param Id 工作id
 @param token token
 @param job 职位
 */
-(void)applyWorkWithId:(NSNumber *)Id token:(NSString *)token job:(NSString *)job cardImg:(NSArray *)cardImg healthNo:(NSString *)healthNo skillImg:(NSString *)skillImg name:(NSString *)name cardno:(NSString *)cardno edu:(NSString *)edu nation:(NSString *)nation interest:(NSString *)interest resume:(NSString *)resume mobile:(NSString *)mobile sex:(NSNumber *)sex recommendUser:(NSString *)recommendUser{
    NSDictionary *parameter = @{@"id":Id,
                                @"job":job,
                                @"token":token,
                                @"name":name,
                                @"cardno":cardno,
                                @"mobile":mobile,
                                @"recommendUser":recommendUser,
                                };
    NSMutableDictionary *muParameter = [[NSMutableDictionary alloc] initWithDictionary:parameter];
    if (cardImg.count > 0) {
        [muParameter setObject:cardImg forKey:@"card_img"];
    }
    if (skillImg) {
        [muParameter setObject:skillImg forKey:@"skill_img"];
    }
    if (healthNo) {
        [muParameter setObject:healthNo forKey:@"health_no"];
    }
    if (sex) {
        [muParameter setObject:sex forKey:@"sex"];
    }
    if (interest) {
        [muParameter setObject:interest forKey:@"interest"];
    }
    if (resume) {
        [muParameter setObject:resume forKey:@"resume"];
    }
    if (nation) {
        [muParameter setObject:nation forKey:@"nation"];
    }if (edu) {
        [muParameter setObject:edu forKey:@"edu"];
    }
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_job_applyFor method:@"post" parameter:muParameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel.message);
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

/**
 我的简历

 @param token token
 */
-(void)fetchMyResumeWithToken:(NSString *)token{
    NSDictionary *parameter = @{@"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_job_myresume method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleResumeDataWith:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)handleResumeDataWith:(PublicModel *)publicModel{
    ResumeModel *model = [[ResumeModel alloc]initWithDict:publicModel.data];
    self.returnBlock(model);
}





/**
 我的应聘

 @param token token
 */
-(void)fetchMyJobApplyWithToken:(NSString *)token size:(NSNumber *)size page:(NSNumber *)page status:(NSNumber *)status{
    NSDictionary *parameter = @{@"token":token,
                                @"page":page,
                                @"size":@(10),
                                @"status":status};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_job_myapplication method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleMyApplicationWith:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)handleMyApplicationWith:(PublicModel *)publicModel{
    NSArray *array = publicModel.data;
    NSMutableArray *muArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < array.count; i ++) {
        MyApplicationModel *model = [[MyApplicationModel alloc]initWithDict:array[i]];
        [muArray addObject:model];
    }
    self.returnBlock(muArray);
}



/**
 我的应聘详情

 @param token token
 @param Id 应聘id
 */
-(void)fetchMyApplicationInfoWithToken:(NSString *)token Id:(NSString *)Id{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_job_applicationInfo method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleApplicationDataWith:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)handleApplicationDataWith:(PublicModel *)publicModel{
    MyApplicationModel *model = [[MyApplicationModel alloc]initWithDict:publicModel.data];
    self.returnBlock(model);
}
@end
