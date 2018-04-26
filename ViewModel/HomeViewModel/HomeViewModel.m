//
//  HomeViewModel.m
//  TheWorker
//
//  Created by yanghao on 9/7/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "HomeViewModel.h"
#import "ArticleModel.h"
#import "BannerModel.h"
@implementation HomeViewModel


//获取首页数据
-(void)fetchHomeDataWithToken:(NSString *)token{
    NSDictionary *parameter = @{@"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_home_data method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
    NSArray *banneroneArr = [publicModel.data objectForKey:@"bannerOne"];
    
    NSMutableArray *muarticleArr = [[NSMutableArray alloc] init];
    NSMutableArray *mubannerArr = [[NSMutableArray alloc] init];
    NSMutableArray *mubanneroneArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < articleArr.count; i ++) {
        ArticleModel *model = [[ArticleModel alloc] initWithDict:articleArr[i]];
        [muarticleArr addObject:model];
    }
    
    for (int i = 0; i < bannerArr.count; i ++) {
        BannerModel *model = [[BannerModel alloc] initWithDict:bannerArr[i]];
        [mubannerArr addObject:model];
    }
    
    for (int i = 0; i < banneroneArr.count; i ++) {
        BannerModel *model = [[BannerModel alloc] initWithDict:banneroneArr[i]];
        [mubanneroneArr addObject:model];
    }
    self.returnBlock(@[mubannerArr,mubanneroneArr,muarticleArr]);
}

//获取资讯列表
-(void)fetchInfoListWithPage:(NSInteger)page token:(NSString *)token{
    NSDictionary *parameter = @{@"token": token,
                                @"page": @(page),
                                @"size":@(10)};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_home_info_list method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            
            [self handleInfoListWithPublicModel:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

//资讯列表数据的处理
-(void)handleInfoListWithPublicModel:(PublicModel *)publicModel{
    NSMutableArray *muarticleArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < [publicModel.data count]; i ++) {
        ArticleModel *model = [[ArticleModel alloc] initWithDict:publicModel.data[i]];
        [muarticleArr addObject:model];
    }
    self.returnBlock(muarticleArr);
}

@end
