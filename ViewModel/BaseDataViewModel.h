//
//  BaseDataViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/20.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface BaseDataViewModel : BaseViewModel
//获取基础数据
-(void)fetchBaseData;
//我的客服
-(void)fetchMyServiceWithToken:(NSString *)token;

@end
