//
//  WorkerHandInViewModel.m
//  TheWorker
//
//  Created by yanghao on 9/9/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "WorkerHandInViewModel.h"
#import "BannerModel.h"
#import "HandInModel.h"

@implementation WorkerHandInViewModel

//获取员工牵手首页数据
-(void)fetchWorkerHandInListWith:(NSString *)token{
    NSDictionary *parameter = @{@"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_hand_in_hand_home method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            
            [self handleWorkerHandInWithPublicModel:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

//对员工牵手首页数据处理
-(void)handleWorkerHandInWithPublicModel: (PublicModel *) publicModel
{
    NSArray *bannerListArr = [publicModel.data objectForKey:@"bannerList"];
    NSArray *fateListArr = [publicModel.data objectForKey:@"fateList"];
    
    NSMutableArray *mubannerListArr = [[NSMutableArray alloc] init];
    NSMutableArray *mufateListArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < bannerListArr.count; i ++) {
        BannerModel *model = [[BannerModel alloc] initWithDict:bannerListArr[i]];
        [mubannerListArr addObject:model];
    }
    
    for (int i = 0; i < fateListArr.count; i ++) {
        HandInModel *model = [[HandInModel alloc] initWithDict:fateListArr[i]];
        [mufateListArr addObject:model];
    }
    
    self.returnBlock(@[mubannerListArr,mufateListArr]);
}

//获取员工相亲数据列表
-(void)fetchWorkerHandInPersonListWith:(NSString *)token page:(NSInteger)page min_age:(NSNumber *)min_age max_age:(NSNumber *)max_age zone_code:(NSNumber *)zone_code sex:(NSNumber *)sex{
    NSDictionary *parameter = @{@"token":token,
                                @"page": @(page),
                                @"size":@(10)};
    NSMutableDictionary *muParemeter = [[NSMutableDictionary alloc] initWithDictionary:parameter];
    if (min_age && min_age > 0) {
        [muParemeter setObject:min_age forKey:@"min_age"];
    }
    if (max_age && max_age > 0) {
        [muParemeter setObject:max_age forKey:@"max_age"];
    }
    

    if (sex) {
        if ([sex integerValue] != 2) {
            [muParemeter setObject:sex forKey:@"sex"];
        }
    }
    
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_hand_in_list method:@"post" parameter:muParemeter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            
            [self handleWorkerHandInPersonWithPublicModel:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

//对员工相亲数据列表处理
-(void)handleWorkerHandInPersonWithPublicModel: (PublicModel *) publicModel
{
    NSMutableArray *mufateListArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < [publicModel.data count]; i ++) {
        HandInModel *model = [[HandInModel alloc] initWithDict:publicModel.data[i]];
        [mufateListArr addObject:model];
    }
    
    self.returnBlock(mufateListArr);
}
//获取相亲详情
-(void)fetchWorkerHandInDetailWith:(NSString *)token Id:(NSString *)Id{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_hand_in_detail method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            
            [self handleHandInDetail:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handleHandInDetail:(PublicModel *)publicModel{
    HandInModel *model = [[HandInModel alloc]initWithDict:publicModel.data];
    NSArray *imgArr = publicModel.data[@"imgs"];
    model.imgs = imgArr;
    self.returnBlock(model);
}


//发布相亲信息

-(void)publishHandInHanInfoWithReq:(AddFateReq *)req{
    NSDictionary *parameter = [req mj_keyValues];
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_hand_in_addfate method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        self.returnBlock(publicModel);
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//我的相亲详情
-(void)fetchMyFateDetailWithToken:(NSString *)token{
    NSDictionary *parameter = @{@"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_hand_in_myfateinfo method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            
            [self handleMyFateDataWith:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handleMyFateDataWith:(PublicModel *)publicModel{
    HandInModel *model = [[HandInModel alloc] initWithDict:publicModel.data];
    NSArray *array = publicModel.data[@"imgs"];
    model.imgs = array;
    self.returnBlock(model);
}
//获取经纬度


-(void)getAPositionWithToken:(NSString *)token Lon:(NSString *)lon Lat:(NSString *)lat{
    NSDictionary *parameter = @{@"token":token,@"lon":lon,@"lat":lat};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_get_position method:@"post" parameter:parameter success:^(NSDictionary *data) {
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

@end
