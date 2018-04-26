//
//  WelfareConvertViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/11.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface WelfareConvertViewModel : BaseViewModel
//获取福利兑换列表
-(void)getGoodsListWithToken:(NSString *)token level:(NSString *)level page:(NSNumber *)page;
//获取福利兑换首页
-(void)getConvertMainPageWithToken:(NSString *)token level:(NSString *)level;
//兑换
-(void)convertGoodsWithToken:(NSString *)token name:(NSString *)name mobile:(NSString *)mobile Id:(NSString *)Id remark:(NSString *)remark;
//积分商品详情
-(void)fetchGoodsDetailWithToken:(NSString *)token Id:(NSString *)Id;
@end
