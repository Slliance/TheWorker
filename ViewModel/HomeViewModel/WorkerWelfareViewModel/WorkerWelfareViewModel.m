//
//  WorkerWelfareViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/8.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "WorkerWelfareViewModel.h"
#import "BannerModel.h"
#import "ArticleModel.h"



@implementation WorkerWelfareViewModel

//获取福利首页数据
-(void)getWorkerWelfareInfomationWith:(NSString *)token{
    NSDictionary *parameter = @{@"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_welfare_data method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
    NSArray *articleArr = [publicModel.data objectForKey:@"article"];
    NSArray *bannerArr = [publicModel.data objectForKey:@"banner"];
    
    NSMutableArray *muarticleArr = [[NSMutableArray alloc] init];
    NSMutableArray *mubannerArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < articleArr.count; i ++) {
        ArticleModel *model = [[ArticleModel alloc] initWithDict:articleArr[i]];
        [muarticleArr addObject:model];
    }
    
    for (int i = 0; i < bannerArr.count; i ++) {
        BannerModel *model = [[BannerModel alloc] initWithDict:bannerArr[i]];
        NSString *idStr = [NSString stringWithFormat:@"%@",bannerArr[i][@"relation_id"]];
        model.relation_id = idStr;
        [mubannerArr addObject:model];
    }
    
    self.returnBlock(@[mubannerArr,muarticleArr]);
}

//获取福利信息列表数据
-(void)getArticleListWithToken:(NSString *)token page:(NSNumber *)page{
    NSDictionary *parameter = @{@"token":token,
                                @"page":page,
                                @"size":@(10)
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_welfare_article method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            
            [self handleArticleWithPublicModel:publicModel];
        }
        else{
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
        [muarticleArr addObject:model];
    }
    self.returnBlock(muarticleArr);

}


@end
