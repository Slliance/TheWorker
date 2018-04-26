//
//  WelfareConvertViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/11.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "WelfareConvertViewModel.h"
#import "GoodsModel.h"
#import "BannerModel.h"
@implementation WelfareConvertViewModel
//获取福利兑换列表
-(void)getGoodsListWithToken:(NSString *)token level:(NSString *)level page:(NSNumber *)page{
    NSDictionary *parameter = @{@"token":token,
                                @"level_id":level,
                                @"page":page,
                                @"size":@(10)
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_welfare_goods_list method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleGoodsDataWithPublicModel:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

//对商品列表数据处理
-(void)handleGoodsDataWithPublicModel:(PublicModel *) publicModel{
    NSArray *goodsArr = publicModel.data ;
    
    NSMutableArray *muGoodsArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < goodsArr.count; i ++) {
        GoodsModel *model = [[GoodsModel alloc] initWithDict:goodsArr[i]];
        [muGoodsArr addObject:model];
    }
    self.returnBlock(muGoodsArr);

}
//对兑换首页数据处理
-(void)handleConvertDataWithPublicModel: (PublicModel *) publicModel
{
    NSArray *goodsArr = [publicModel.data objectForKey:@"goodsList"];
    NSArray *bannerArr = [publicModel.data objectForKey:@"banner"];
    
    NSMutableArray *muarticleArr = [[NSMutableArray alloc] init];
    NSMutableArray *mubannerArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < goodsArr.count; i ++) {
        GoodsModel *model = [[GoodsModel alloc] initWithDict:goodsArr[i]];
        [muarticleArr addObject:model];
    }
    
    for (int i = 0; i < bannerArr.count; i ++) {
        BannerModel *model = [[BannerModel alloc] initWithDict:bannerArr[i]];
        NSString *idStr = [NSString stringWithFormat:@"%@",bannerArr[i][@"relation_id"]];
        model.relation_id = idStr;
        [mubannerArr addObject:model];
    }
    
    self.returnBlock(@[muarticleArr,mubannerArr]);
}

//福利兑换首页
-(void)getConvertMainPageWithToken:(NSString *)token level:(NSString *)level{
    NSDictionary *parameter = @{@"token":token,
                                @"level_id":level};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_welfare_convert_list method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleConvertDataWithPublicModel:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)convertGoodsWithToken:(NSString *)token name:(NSString *)name mobile:(NSString *)mobile Id:(NSString *)Id remark:(NSString *)remark{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id,
                                @"mobile":mobile,
                                @"name":name,
                                @"remark":remark};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_welfare_convert method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel);
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//积分商品详情
-(void)fetchGoodsDetailWithToken:(NSString *)token Id:(NSString *)Id{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_welfare_goods_detail method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleGoodsDetailWithPublicModel:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//处理商品详情数据
-(void)handleGoodsDetailWithPublicModel:(PublicModel *)publicModel{
    GoodsModel *model = [[GoodsModel alloc]initWithDict:publicModel.data];
    NSArray *array = publicModel.data[@"imgs"];
    model.imgs = array;
    self.returnBlock(model);
}
@end
