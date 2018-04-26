//
//  CollectViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/15.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface CollectViewModel : BaseViewModel
//收藏
-(void)userCollectWithToken:(NSString *)token articleId:(NSString *)articleId collectType:(NSNumber *)collectType;
//我的收藏
-(void)fetchMyCollectionWithToken:(NSString *)token type:(NSNumber *)type page:(NSNumber *)page;
//批量删除收藏
-(void)deleteMyCollectionWithToken:(NSString *)token Ids:(NSArray *)Ids;
//判断是否收藏
-(void)isCollectWithToken:(NSString *)token articleId:(NSString *)articleId collectType:(NSNumber *)collectType;
@end
