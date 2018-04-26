//
//  WalletViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/18.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface WalletViewModel : BaseViewModel
//我的钱包
-(void)fetchWalletInfomationWithToken:(NSString *)token;

//添加银行卡
-(void)addBankCardWithCardNum:(NSString *)card bankId:(NSNumber *)bankid address:(NSString *)address name:(NSString *)name token:(NSString *)token;

//获取银行卡列表
-(void)fetchBankListWithToken:(NSString *)token;

//我的银行卡列表
-(void)fetchMyBankListWithToken:(NSString *)token;

//余额提现
-(void)withdrawWithToken:(NSString *)token cardId:(NSString *)card_id money:(NSString *)money remarks:(NSString *)remarks;

//交易记录
-(void)fetchSaleRecordWithToken:(NSString *)token page:(NSNumber *)page size:(NSNumber *)size;

//提现申请记录
-(void)fetchWithdrawRecordWithToken:(NSString *)token page:(NSNumber *)page size:(NSNumber *)size type:(NSNumber *)type;

//我的积分
-(void)fetchIntegralWithToken:(NSString *)token page:(NSNumber *)page size:(NSNumber *)size;

//银行卡详情
-(void)fetchBankCardDetailWithId:(NSString *)Id token:(NSString *)token;

//删除银行卡
-(void)deleteBankCradWithId:(NSString *)Id token:(NSString *)token;

//我的奖励
-(void)fetchMyRewardWithToken:(NSString *)token;

//我的奖励记录
-(void)fetchMyRewardRecordWithToken:(NSString *)token page:(NSNumber *)page;
@end
