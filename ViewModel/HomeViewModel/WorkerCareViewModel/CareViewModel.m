//
//  CareViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/22.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "CareViewModel.h"
#import "BannerModel.h"
#import "ArticleModel.h"

@implementation CareViewModel
//员工关怀首页
-(void)fetchWorkCareMainPageWithToken:(NSString *)token{
    NSDictionary *parameter = @{@"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_food_careIndex method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleCareDataWithPublicModel:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)handleCareDataWithPublicModel:(PublicModel *)publicModel{
    NSArray *articleArr = [publicModel.data objectForKey:@"list"];
    NSArray *bannerArr = [publicModel.data objectForKey:@"banner"];
    
    NSMutableArray *muarticleArr = [[NSMutableArray alloc] init];
    NSMutableArray *mubannerArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < articleArr.count; i ++) {
        ArticleModel *model = [[ArticleModel alloc] initWithDict:articleArr[i]];
        [muarticleArr addObject:model];
    }
    
    for (int i = 0; i < bannerArr.count; i ++) {
        BannerModel *model = [[BannerModel alloc] initWithDict:bannerArr[i]];
        [mubannerArr addObject:model];
    }
    
    self.returnBlock(@[mubannerArr,muarticleArr]);

}



//衣食住行列表
-(void)fetchCareListWithToken:(NSString *)token page:(NSNumber *)page size:(NSNumber *)size{
    
    NSDictionary *parameter = @{@"token":token,
                                @"page":page,
                                @"size":size};
    
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_food_carelist method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleArticleWithPublicModel:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];

}

-(void)handleArticleWithPublicModel: (PublicModel *) publicModel{
    NSArray *articleArr = publicModel.data;
    NSMutableArray *muarticleArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < articleArr.count; i ++) {
        ArticleModel *model = [[ArticleModel alloc] initWithDict:articleArr[i]];
        NSString *idStr = [NSString stringWithFormat:@"%@",articleArr[i][@"Id"]];
        model.Id = idStr;
        [muarticleArr addObject:model];
    }
    self.returnBlock(muarticleArr);
    
}





/**
 员工餐饮

 @param token token
 @param page 从1开始
 @param size 默认为10
 @param zone_code 地区code
 */
-(void)fetchWorkerFoodListWithToken:(NSString *)token page:(NSNumber *)page size:(NSNumber *)size zone_code:(NSNumber *)zone_code{
    NSDictionary *parameter = @{@"token":token,
                                @"page":page,
                                @"zone_code":zone_code,
                                @"size":size};
    
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_food_index method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleArticleWithPublicModel:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}


/**
 获取员工住宿信息

 @param token token
 @param page 从1开始
 @param size 默认为10
 @param zone_code 地区code
 @param room_id 房间信息id从basedata获取
 @param price_id 价格id从basedata获取
 */
-(void)fetchWorkerLiveListWithToken:(NSString *)token page:(NSNumber *)page size:(NSNumber *)size zone_code:(NSNumber *)zone_code room_id:(NSNumber *)room_id price_id:(NSNumber *)price_id{
    NSDictionary *parameter = @{@"token":token,
                                @"page":page,
                                @"zone_code":zone_code,
                                @"room_id":room_id,
                                @"price_id":price_id,
                                @"size":size};
    
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_room_index method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleArticleWithPublicModel:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
@end
