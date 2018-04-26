//
//  WorkerBusinessViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/12.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "WorkerBusinessViewModel.h"
#import "ArticleModel.h"
#import "BannerModel.h"
#import "PartnerModel.h"

@implementation WorkerBusinessViewModel
//员工创业首页
-(void)getWorkerBusinessDataWithToken:(NSString *)token{
    NSDictionary *parameter = @{@"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_business_home method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
    NSArray *bannerArr = [publicModel.data objectForKey:@"bannerList"];
    NSArray *articleArr = [publicModel.data objectForKey:@"information"];
    NSArray *parterArr = [publicModel.data objectForKey:@"cooperative"];
    
    NSMutableArray *muarticleArr = [[NSMutableArray alloc] init];
    NSMutableArray *mubannerArr = [[NSMutableArray alloc] init];
    NSMutableArray *muparterArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < bannerArr.count; i ++) {
        BannerModel *model = [[BannerModel alloc] initWithDict:bannerArr[i]];
        [mubannerArr addObject:model];
    }

    for (int i = 0; i < articleArr.count; i ++) {
        ArticleModel *model = [[ArticleModel alloc] initWithDict:articleArr[i]];
        [muarticleArr addObject:model];
    }
    
    for (int i = 0; i < parterArr.count; i ++) {
        PartnerModel *model = [[PartnerModel alloc] initWithDict:parterArr[i]];
        [muparterArr addObject:model];
    }
    self.returnBlock(@[mubannerArr,muarticleArr,muparterArr]);
}
//创业资讯
-(void)fetchBusinessInfoListWithToken:(NSString *)token page:(NSNumber *)page{
    NSDictionary *parameter = @{@"token":token,
                                @"page":page,
                                @"size":@(10)
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_business_list method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            
            [self handleInfomationListWithPublicModel:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handleInfomationListWithPublicModel:(PublicModel *)publicModel{
    NSArray *articleArr = publicModel.data;
    NSMutableArray *muarticleArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < articleArr.count; i ++) {
        ArticleModel *model = [[ArticleModel alloc] initWithDict:articleArr[i]];
        [muarticleArr addObject:model];
    }
    self.returnBlock(muarticleArr);
}

//创业伙伴
-(void)fetchBusinessParterList{
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_business_parter method:@"post" parameter:nil success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            
            [self handleParterListWithPublicModel:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handleParterListWithPublicModel:(PublicModel *)publicModel{
    NSArray *parterArr = publicModel.data ;
    NSMutableArray *muparterArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < parterArr.count; i ++) {
        PartnerModel *model = [[PartnerModel alloc] initWithDict:parterArr[i]];
        [muparterArr addObject:model];
    }
    self.returnBlock(muparterArr);
}

@end
