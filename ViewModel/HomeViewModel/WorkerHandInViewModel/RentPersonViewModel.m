//
//  RentPersonViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/10.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RentPersonViewModel.h"
#import "RentPersonModel.h"
#import "SkillModel.h"
#import "FansModel.h"
@implementation RentPersonViewModel
//出租用户信息
-(void)fetchRentPersonInfomationWithToken:(NSString *)token Id:(NSString *)Id{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_rentinfo method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handlePersonInfo:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handlePersonInfo:(PublicModel *)publicModel{
    RentPersonModel *model = [[RentPersonModel alloc] initWithDict:publicModel.data];
    NSArray *tagArr = publicModel.data[@"tag"];
    model.tag = tagArr;
    NSArray *serverArr = publicModel.data[@"server"];
    NSMutableArray *muServerArr = [[NSMutableArray alloc]init];
    for (int i = 0;  i < serverArr.count;  i ++) {
        SkillModel *subModel = [[SkillModel alloc] initWithDict:serverArr[i]];
        [muServerArr addObject:subModel];
    }
    model.server = muServerArr;
    self.returnBlock(model);
}

//用户粉丝列表
-(void)fetchRentPersonFansListWithToken:(NSString *)token Id:(NSString *)Id page:(NSNumber *)page size:(NSNumber *)size{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id,
                                @"page":page,
                                @"size":size};
//    NSMutableDictionary *muParameter = 
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_fanslist method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleFansListData:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//处理粉丝列表数据
-(void)handleFansListData:(PublicModel *)publicModel{
    FansModel *model = [[FansModel alloc] initWithDict:publicModel.data];
    NSArray *array = publicModel.data[@"follow_list"];
    NSMutableArray *muArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i ++) {
        FansModel *subModel = [[FansModel alloc] initWithDict:array[i]];
        [muArray addObject:subModel];
    }
    model.follow_list = muArray;
    self.returnBlock(model);
}
//关注
-(void)followPersonWithToken:(NSString *)token Id:(NSString *)Id{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_follow method:@"post" parameter:parameter success:^(NSDictionary *data) {
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

//获取出租项目
-(void)fetchRentPersonSkillPriceWithId:(NSString *)Id token:(NSString *)token{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_rentskill method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handelSkillDataWith:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handelSkillDataWith:(PublicModel *)publicModel{
    NSArray *array = publicModel.data;
    NSMutableArray *muArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i ++) {
        SkillModel *model = [[SkillModel alloc] initWithDict:array[i]];
        [muArray addObject:model];
    }
    self.returnBlock(muArray);
}

-(void)rentPersonWithToken:(NSString *)token rent_uid:(NSString *)rent_uid start_time:(NSString *)start_time rent_long:(NSString *)rent_long meet_address:(NSString *)meet_address item:(NSString *)item lnk_user:(NSString *)lnk_user lnk_mobile:(NSString *)lnk_mobile msg:(NSString *)msg longitude:(NSNumber *)longitude latitude:(NSNumber *)latitude{
    NSDictionary *parameter = @{@"token":token,
                                @"rent_uid":rent_uid,
                                @"start_time":start_time,
                                @"rent_long":rent_long,
                                @"meet_address":meet_address,
                                @"item":item,
                                @"lnk_user":lnk_user,
                                @"msg":msg,
                                @"lnk_mobile":lnk_mobile,
                                @"longitude":longitude,
                                @"latitude":latitude
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_order method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
//            [self handleFansListData:publicModel];
            self.returnBlock(publicModel.data);
        }
        
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

//添加好友
-(void)addFriendWithToken:(NSString *)token Id:(NSString *)Id{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_addfriend method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
@end
