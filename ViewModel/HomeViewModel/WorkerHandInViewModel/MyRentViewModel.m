//
//  MyRentViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/11.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyRentViewModel.h"
#import "RentOrderModel.h"
#import "SkillModel.h"
@implementation MyRentViewModel
-(void)fetchMyRentInfoWithToken:(NSString *)token{
    NSDictionary *parameter = @{@"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_myrent method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
//我的租赁订单
-(void)fetchMyRentOrderWithToken:(NSString *)token status:(NSNumber *)status tag:(NSNumber *)tag page:(NSNumber *)page{
    NSDictionary *parameter = @{@"token":token,
                                @"status":status,
                                @"tag":tag,
                                @"page":page,
                                @"size":@(10)
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_myrentorder method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleMyRentOrderData:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handleMyRentOrderData:(PublicModel *)publicModel{
    NSArray *array = publicModel.data;
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i ++) {
        RentOrderModel *model = [[RentOrderModel alloc] initWithDict:array[i]];
        [muArr addObject:model];
    }
    self.returnBlock(muArr);
}
//获取订单详情
-(void)fetchMyRentOrderDetailWithToken:(NSString *)token Id:(NSString *)Id type:(NSNumber *)type{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id,
                                @"type":type
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_orderdetail method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleOrderDataWith:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)handleOrderDataWith:(PublicModel *)publicModel{
    RentOrderModel *model = [[RentOrderModel alloc] initWithDict:publicModel.data];
    NSArray *imgArr = publicModel.data[@"img"];
    model.img = imgArr;
    self.returnBlock(model);
}
//处理我的订单
-(void)handleMyRentOrderWithToken:(NSString *)token Id:(NSString *)Id arrange:(NSNumber *)arrange refundReason:(NSString *)refundReason{
    NSDictionary *parameter = @{@"token":token,
                                @"arrange":arrange,
                                @"id":Id,
                                @"refund_reason":refundReason
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_arrangerent method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
//取消订单
-(void)cancelMyRentOrderWithToken:(NSString *)token Id:(NSString *)Id reason:(NSString *)reason{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id,
                                @"refund_reason":reason
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_cancel_order method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
//用户评价
-(void)remarkMyRentWithToken:(NSString *)token Id:(NSString *)Id point:(NSNumber *)point remark:(NSString *)remark type:(NSInteger)type{
    NSDictionary *parameter = @{@"token":token,
                                @"point":point,
                                @"remark":remark,
                                @"id":Id
                                };
    NSString *str = [[NSString alloc] init];
    if (type == 1) {
        str = url_worker_rent_userremark;
    }else{
        str = url_worker_rent_remarkuser;
    }
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:str method:@"post" parameter:parameter success:^(NSDictionary *data) {
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

//获取我的常用标签
-(void)fetchUserCommonSkillWithToken:(NSString *)token{
    
    NSDictionary *parameter = @{@"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_usertag method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleSkillDataWith:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)handleSkillDataWith:(PublicModel *)publicModel{
    NSArray *array = publicModel.data[@"tag"];
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    NSArray *myArray = publicModel.data[@"myTag"];
    NSMutableArray *muMyArr = [[NSMutableArray alloc] init];
    NSMutableArray *myTagArr = [[NSMutableArray alloc] init];
    NSMutableArray *myTagArr1 = [[NSMutableArray alloc] init];
    NSMutableArray *myTagArr2 = [[NSMutableArray alloc] init];
    NSMutableArray *myTagArr3 = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i ++) {
        SkillModel *model = [[SkillModel alloc] initWithDict:array[i]];
        [muArr addObject:model];
        [myTagArr1 addObject:model.name];
    }
    for (int i = 0; i < myArray.count; i ++) {
        SkillModel *model = [[SkillModel alloc] initWithDict:myArray[i]];
        [muMyArr addObject:model];
        [myTagArr2 addObject:model.name];
    }
    for (NSString *str in myTagArr2) {
        if (![myTagArr1 containsObject:str]) {
            [myTagArr3 addObject:str];
        }
    }
    [myTagArr1 removeAllObjects];
    for (int i = 0; i < myTagArr3.count; i ++) {
        SkillModel *model = [[SkillModel alloc] init];
        model.name = myTagArr3[i];
        [myTagArr1 addObject:model];
    }
    for (int i = 0; i < muMyArr.count; i ++) {
        for (int j = 0; j < muArr.count; j ++) {
          
            SkillModel *model = muMyArr[i];
            SkillModel *model1 = muArr[j];
            if ([model.name isEqualToString:model1.name]) {
                [myTagArr addObject:model];
            }
        }  
    }
    self.returnBlock(@[myTagArr1,muArr,myTagArr]);
}
//设置常用标签

-(void)setMyTagWithToken:(NSString *)token tag:(NSArray *)tag{
    NSDictionary *parameter = @{@"token":token,
                                @"tag":tag
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_mytag method:@"post" parameter:parameter success:^(NSDictionary *data) {
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

//确认见面
-(void)comfirmMeetWithToken:(NSString *)token Id:(NSString *)Id type:(NSNumber *)type{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id,
                                @"type":type
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_meet method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
//提出未见面
-(void)submitNoMeetWithToken:(NSString *)token remark:(NSString *)remark img:(NSArray *)img Id:(NSString *)Id{
    NSDictionary *parameter = @{@"token":token,
                                @"remark":remark,
                                @"img":img,
                                @"id":Id
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_rentdissent method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
//提出异议
-(void)submitDissentWithToken:(NSString *)token remark:(NSString *)remark img:(NSArray *)img Id:(NSString *)Id{
    NSDictionary *parameter = @{@"token":token,
                                @"remark":remark,
                                @"img":img,
                                @"id":Id
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_rent_userdissent method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
