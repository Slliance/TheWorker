//
//  WalletViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/18.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "WalletViewModel.h"
#import "WalletModel.h"
#import "SaleRecordModel.h"
#import "IntegralModel.h"
#import "BankModel.h"
#import "RewardModel.h"
@implementation WalletViewModel

/**
 我的钱包

 @param token token
 */
-(void)fetchWalletInfomationWithToken:(NSString *)token{
    NSDictionary *parameter = @{@"token":token};
        [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_wallet method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleWalletInfoWith:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)handleWalletInfoWith:(PublicModel *)publicModel{
    WalletModel *walletModel = [[WalletModel alloc]initWithDict:publicModel.data];
    self.returnBlock(walletModel);
}






/**
 添加银行卡

 @param card 银行卡号
 @param bankid 银行卡id
 @param address 开户支行
 @param name 用户名字
 @param token token
 */
-(void)addBankCardWithCardNum:(NSString *)card bankId:(NSNumber *)bankid address:(NSString *)address name:(NSString *)name token:(NSString *)token{
    NSDictionary *parameter = @{@"token":token,
                                @"card":card,
                                @"bankid":bankid,
                                @"address":address,
                                @"name":name};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_add_bank method:@"post" parameter:parameter success:^(NSDictionary *data) {
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







/**
 获取银行卡列表

 @param token token
 */
-(void)fetchBankListWithToken:(NSString *)token{
    NSDictionary *parameter = @{@"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_bank_list method:@"post" parameter:parameter success:^(NSDictionary *data) {
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






/**
 我的银行卡列表

 @param token token
 */
-(void)fetchMyBankListWithToken:(NSString *)token{
    NSDictionary *parameter = @{@"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_bankcard method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleMyBankListDataWith:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//处理我的银行卡列表数据
-(void)handleMyBankListDataWith:(PublicModel *)publicModel{
    NSArray *bankArray = publicModel.data;
    NSMutableArray *muBankArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < bankArray.count; i ++) {
        BankModel *model = [[BankModel alloc]initWithDict:bankArray[i]];
        [muBankArray addObject:model];
    }
    self.returnBlock(muBankArray);
}







/**
 余额提现

 @param token token
 @param card_id 银行卡id
 @param money 提现金额
 @param remarks 备注
 */
-(void)withdrawWithToken:(NSString *)token cardId:(NSString *)card_id money:(NSString *)money remarks:(NSString *)remarks{
    NSDictionary *parameter = @{@"token":token,
                                @"card_id":card_id,
                                @"money":money,
                                @"remark":remarks};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_withdraw method:@"post" parameter:parameter success:^(NSDictionary *data) {
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







/**
 交易记录

 @param token token
 @param page page 默认为1
 @param size size 默认为10
 */
-(void)fetchSaleRecordWithToken:(NSString *)token page:(NSNumber *)page size:(NSNumber *)size{
    NSDictionary *parameter = @{@"token":token,
                                @"page":page,
                                @"size":size};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_sale_record method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleSaleDataWith:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handleSaleDataWith:(PublicModel *)publicModel{
    NSArray *recordArray = publicModel.data;
    NSMutableArray *muRecordArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < recordArray.count; i ++) {
        SaleRecordModel *model = [[SaleRecordModel alloc]initWithDict:recordArray[i]];
        [muRecordArray addObject:model];
    }
    self.returnBlock(muRecordArray);
}





/**
 提现申请记录

 @param token token
 @param page page 默认为1
 @param size size  默认为10
 @param type 提现进度  0-提现申请（审核中），1-完成（已打款），2-失败（不通过）
 */
-(void)fetchWithdrawRecordWithToken:(NSString *)token page:(NSNumber *)page size:(NSNumber *)size type:(NSNumber *)type{
    NSDictionary *parameter = @{@"token":token,
                                @"page":page,
                                @"size":size};
    NSMutableDictionary *muPatameter = [[NSMutableDictionary alloc]initWithDictionary:parameter];
    if (type) {
        [muPatameter setObject:type forKey:@"type"];
    }
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_withdraw_record method:@"post" parameter:muPatameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleSaleDataWith:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handleWithdrawDataWith:(PublicModel *)publicModel{
    NSArray *recordArray = publicModel.data;
    NSMutableArray *muRecordArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < recordArray.count; i ++) {
        SaleRecordModel *model = [[SaleRecordModel alloc]initWithDict:recordArray[i]];
        [muRecordArray addObject:model];
    }
    self.returnBlock(muRecordArray);
}




/**
 我的积分列表

 @param token token
 @param page page 默认为1
 @param size size 默认为10
 */
-(void)fetchIntegralWithToken:(NSString *)token page:(NSNumber *)page size:(NSNumber *)size{
    NSDictionary *parameter = @{@"token":token,
                                @"page":page,
                                @"size":size};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_integral_record method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleintegralInfoWith:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)handleintegralInfoWith:(PublicModel *)publicModel{
    NSArray *integralArray = publicModel.data;
    NSMutableArray *muIntegralArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < integralArray.count; i ++) {
        IntegralModel *model = [[IntegralModel alloc]initWithDict:integralArray[i]];
        [muIntegralArray addObject:model];
    }
    self.returnBlock(muIntegralArray);
}


/**
 获取银行卡详情

 @param Id 银行卡id
 @param token token
 */
-(void)fetchBankCardDetailWithId:(NSString *)Id token:(NSString *)token{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_bank_bankInfo method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleBankCardInfoWith:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handleBankCardInfoWith:(PublicModel *)publicModel{
    BankModel *bankModel = [[BankModel alloc]initWithDict:publicModel.data];
    self.returnBlock(bankModel);
}



/**
 删除银行卡

 @param Id 银行卡id
 @param token token
 */
-(void)deleteBankCradWithId:(NSString *)Id token:(NSString *)token{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_bank_delete method:@"post" parameter:parameter success:^(NSDictionary *data) {
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

/**
 我的奖励

 @param token token
 */
-(void)fetchMyRewardWithToken:(NSString *)token{
    NSDictionary *parameter = @{@"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_myreward method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleMyRewardDataWith:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handleMyRewardDataWith:(PublicModel *)publicModel{
    NSNumber *reward = publicModel.data[@"reward_point"];
    self.returnBlock(reward);
}


/**
 我的奖励记录

 @param token token
 @param page 起始页，默认为1
 */
-(void)fetchMyRewardRecordWithToken:(NSString *)token page:(NSNumber *)page{
    NSDictionary *parameter = @{@"token":token,
                                @"page":page,
                                @"size":@(10)
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_reward method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleMyRewardRecordDataWith:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handleMyRewardRecordDataWith:(PublicModel *)publicModel{
    NSArray *array = publicModel.data;
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i ++) {
        RewardModel *model = [[RewardModel alloc] initWithDict:array[i]];
        [muArr addObject:model];
    }
    self.returnBlock(muArr);
}
@end
