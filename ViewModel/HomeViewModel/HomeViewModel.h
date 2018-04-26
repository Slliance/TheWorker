//
//  HomeViewModel.h
//  TheWorker
//
//  Created by yanghao on 9/7/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface HomeViewModel : BaseViewModel

-(void)fetchHomeDataWithToken:(NSString *)token;

//获取资讯列表
-(void)fetchInfoListWithPage:(NSInteger)page token:(NSString *)token;

@end
