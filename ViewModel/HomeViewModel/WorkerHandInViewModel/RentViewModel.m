//
//  RentViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/9.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RentViewModel.h"
#import "RentModel.h"
#import "SkillModel.h"
@implementation RentViewModel
//租缘吧首页
-(void)fetchRentListWithToken:(NSString *)token page:(NSNumber *)page type:(NSNumber *)type{
    NSDictionary *parameter = @{@"token":token,
                                @"page":page,
                                @"type":type,
                                @"size":@(10)};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_list method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleRentListData:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)handleRentListData:(PublicModel *)publicModel{
    NSArray *dataArr = publicModel.data;
    NSMutableArray *muDataArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < dataArr.count; i++) {
        RentModel *model = [[RentModel alloc]initWithDict:dataArr[i]];
        NSArray *imgArr = dataArr[i][@"img"];
        NSArray *tagArr = dataArr[i][@"tag"];
        model.img = imgArr;
        model.tag = tagArr;
        [muDataArr addObject:model];
    }
    self.returnBlock(muDataArr);
}

//获取我的形象照片
-(void)fetchMyImageWithToken:(NSString *)token{
    NSDictionary *parameter = @{@"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_myownimg method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
//            [self handleMyImageWith:publicModel];
            self.returnBlock(publicModel.data);
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)handleMyImageWith:(PublicModel *)publicModel{
    NSArray *array = publicModel.data[@"img"];
    self.returnBlock(array);
}

//设置为封面图片
-(void)setShowImgWithToken:(NSString *)token show_img:(NSString *)show_img{
    NSDictionary *parameter = @{@"token":token,
                                @"show_img":show_img};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_showimg method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
//设置个人形象照片
-(void)setOwnerImageWithToken:(NSString *)token img:(NSArray *)img{
    NSDictionary *parameter = @{@"token":token,
                                @"img":img};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_ownimg method:@"post" parameter:parameter success:^(NSDictionary *data) {
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

//添加个人技能
-(void)addOwnSkillWithToken:(NSString *)token skill:(NSArray *)skill{
    NSDictionary *parameter = @{@"token":token,
                                @"skill":skill};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_add_skill method:@"post" parameter:parameter success:^(NSDictionary *data) {
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

//提交出租范围
-(void)submitRentRangeWithToken:(NSString *)token skill:(NSArray *)skill jobSkill:(NSArray *)jobskill friendSkill:(NSArray *)friendskill{
    NSDictionary *parameter = @{@"token":token,
                                @"jobskill":jobskill,
                                @"friendskill":friendskill,
                                @"myskill":skill};
    
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_range method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel.data);
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

//获取用户出租范围
-(void)fetchOwnRentRangeWithToken:(NSString *)token{
    NSDictionary *parameter = @{@"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_ownrange method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleOwnRentSkillRange:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handleOwnRentRange:(PublicModel *)publicModel{
    NSArray *skillArr = publicModel.data[@"skill"];
    NSArray *friendArr = publicModel.data[@"friendskill"];
    NSArray *jobArr = publicModel.data[@"jobskill"];
    NSMutableArray *muSkillArr = [[NSMutableArray alloc] init];
    NSMutableArray *muFriendArr = [[NSMutableArray alloc] init];
    NSMutableArray *muJobArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < skillArr.count; i ++) {
        SkillModel *model = [[SkillModel alloc] initWithDict:skillArr[i]];
        model.name = model.skill;
        [muSkillArr addObject:model];
    }
    for (int i = 0; i < friendArr.count; i ++) {
        SkillModel *model = [[SkillModel alloc] initWithDict:friendArr[i]];
        [muFriendArr addObject:model];
    }
    for (int i = 0; i < jobArr.count; i ++) {
        SkillModel *model = [[SkillModel alloc] initWithDict:jobArr[i]];
        [muJobArr addObject:model];
    }
    self.returnBlock(@[muSkillArr,muFriendArr,muJobArr]);
}
//获取用户未设置价格技能
-(void)fetchUserRentSkillWithToken:(NSString *)token{
    NSDictionary *parameter = @{@"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_range_skill method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleOwnRentSkillRange:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)handleOwnRentSkillRange:(PublicModel *)publicModel{
    NSArray *skillArr = publicModel.data[@"myskill"];
    NSArray *friendArr = publicModel.data[@"friendskill"];
    NSArray *jobArr = publicModel.data[@"jobskill"];
    NSMutableArray *muSkillArr = [[NSMutableArray alloc] init];
    NSMutableArray *muFriendArr = [[NSMutableArray alloc] init];
    NSMutableArray *muJobArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < skillArr.count; i ++) {
        SkillModel *model = [[SkillModel alloc] initWithDict:skillArr[i]];
        model.name = model.skill;
        [muSkillArr addObject:model];
    }
    for (int i = 0; i < friendArr.count; i ++) {
        SkillModel *model = [[SkillModel alloc] initWithDict:friendArr[i]];
        [muFriendArr addObject:model];
    }
    for (int i = 0; i < jobArr.count; i ++) {
        SkillModel *model = [[SkillModel alloc] initWithDict:jobArr[i]];
        [muJobArr addObject:model];
    }
    self.returnBlock(@[muSkillArr,muFriendArr,muJobArr]);
}

@end
