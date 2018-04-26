//
//  CollectViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/15.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "CollectViewModel.h"
#import "CollectModel.h"
#import "JobModel.h"
#import "ArticleModel.h"
#import "HandInModel.h"
//1-积分商品，2-商城商品，3-求职信息，4-餐饮信息，5-房源信息，6-员工资讯 , 7-创业资讯 , 8-福利信息 , 9-衣食住行 , 10-相亲的员工收藏
@implementation CollectViewModel
-(void)userCollectWithToken:(NSString *)token articleId:(NSString *)articleId collectType:(NSNumber *)collectType{
    NSDictionary *parameter = @{@"token":token,
                                @"articleid":articleId,
                                @"collect_type":collectType};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_collect method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel.message);
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//获取我的收藏列表
-(void)fetchMyCollectionWithToken:(NSString *)token type:(NSNumber *)type page:(NSNumber *)page{
    NSDictionary *parameter = @{@"token":token,
                                @"type":type,
                                @"page":page,
                                @"size":@(10)
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_collect_list method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleMyCollectionData:publicModel type:type];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handleMyCollectionData:(PublicModel *)publicModel type:(NSNumber *)type{
    NSArray *array = publicModel.data;
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i ++) {
        if ([type integerValue] < 3) {
            CollectModel *model = [[CollectModel alloc] initWithDict:array[i]];
            NSNumber *Id = array[i][@"Id"];
            model.Id = [NSString stringWithFormat:@"%@",Id];
            [muArr addObject:model];
        }else if ([type integerValue] == 3){
            JobModel *model = [[JobModel alloc] initWithDict:array[i]];
            [muArr addObject:model];
        }else if([type integerValue] == 9){
            HandInModel *model = [[HandInModel alloc] initWithDict:array[i]];
            NSMutableArray *img = [[NSMutableArray alloc] init];
            img = array[i][@"imgs"];
            model.imgs = img;
            [muArr addObject:model];
        }else{
            ArticleModel *model = [[ArticleModel alloc] initWithDict:array[i]];
            [muArr addObject:model];
        }
    }
    self.returnBlock(muArr);
}

//批量删除收藏
-(void)deleteMyCollectionWithToken:(NSString *)token Ids:(NSArray *)Ids{
    NSDictionary *parameter = @{@"token":token,
                                @"ids":Ids
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_collect_delete method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel.message);
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

//是否收藏
-(void)isCollectWithToken:(NSString *)token articleId:(NSString *)articleId collectType:(NSNumber *)collectType{
    NSDictionary *parameter = @{@"token":token,
                                @"article_id":articleId,
                                @"type":collectType};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_article_iscollect method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel.data);
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

@end
