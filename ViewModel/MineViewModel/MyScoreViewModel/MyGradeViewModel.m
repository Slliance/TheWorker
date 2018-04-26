//
//  MyGradeViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/11/6.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyGradeViewModel.h"
#import "IntegralModel.h"
#import "MyTeamModel.h"
@implementation MyGradeViewModel
//获取邀请记录
-(void)fetchMyFriendAmount:(NSString *)token page:(NSNumber *)page level:(NSNumber *)level{
    NSDictionary *parameter = @{@"token":token,
                                @"page":page,
                                @"lv":level,
                                @"size":@(10)};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_user_friendamount method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS){
            [self handleMyFriendAmountData:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handleMyFriendAmountData:(PublicModel *)publicModel{
    
    NSArray *integralArray = publicModel.data[@"list"];
    NSNumber *number1 = publicModel.data[@"num1"];
    NSNumber *number2 = publicModel.data[@"num2"];
    NSMutableArray *muIntegralArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < integralArray.count; i ++) {
        IntegralModel *model = [[IntegralModel alloc]initWithDict:integralArray[i]];
        [muIntegralArray addObject:model];
    }
    self.returnBlock(@[muIntegralArray,number1,number2]);
}
//获取我的团队
-(void)fetchMyTeamWithToken:(NSString *)token page:(NSNumber *)page type:(NSNumber *)type{
    NSDictionary *parameter = @{@"token":token,
                                @"page":page,
                                @"lv":type,
                                @"size":@(10)};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_user_myteam method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS){
            [self handleMyTeamData:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handleMyTeamData:(PublicModel *)publicModel{
    NSArray *integralArray = publicModel.data[@"list"];
    NSNumber *number1 = publicModel.data[@"num1"];
    NSNumber *number2 = publicModel.data[@"num2"];
    NSMutableArray *muIntegralArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < integralArray.count; i ++) {
        MyTeamModel *model = [[MyTeamModel alloc]initWithDict:integralArray[i]];
        [muIntegralArray addObject:model];
    }
    self.returnBlock(@[muIntegralArray,number1,number2]);
}
//根据手机号获取团队成员
-(void)fetchTeamDetailWithToken:(NSString *)token mobile:(NSString *)mobile page:(NSNumber *)page{
    NSDictionary *parameter = @{@"token":token,
                                @"page":page,
                                @"mobile":mobile,
                                @"size":@(10)};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_user_mobileteam method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS){
            [self handleMyTeamDetailData:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handleMyTeamDetailData:(PublicModel *)publicModel{
    NSArray *integralArray = publicModel.data;
    NSMutableArray *muIntegralArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < integralArray.count; i ++) {
        MyTeamModel *model = [[MyTeamModel alloc]initWithDict:integralArray[i]];
        [muIntegralArray addObject:model];
    }
    self.returnBlock(muIntegralArray);
}
@end
