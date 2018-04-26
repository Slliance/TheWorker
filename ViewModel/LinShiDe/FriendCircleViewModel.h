//
//  FriendCircleViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/14.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface FriendCircleViewModel : BaseViewModel
//发布朋友圈
-(void)releaseFriendCircleWith:(NSString *)Content imgs:(NSArray *)imgs token:(NSString *)token;
//朋友圈
-(void)fetchFriendCircleDataWithToken:(NSString *)token page:(NSNumber *)page size:(NSNumber *)size;
//个人朋友圈
-(void)fetchUserCircleDataWithToken:(NSString *)token page:(NSNumber *)page uid:(NSString *)uid size:(NSNumber *)size;
//点赞
-(void)agreeFriendWithToken:(NSString *)token Id:(NSString *)Id;
//评论
-(void)discussFriendWithToken:(NSString *)token Id:(NSString *)Id friendId:(NSString *)friendId content:(NSString *)content;
//删除朋友圈
-(void)delCircleWithCircleId:(NSString *)Id Token:(NSString *)token;
//删除评论
-(void)delDiscussWithDiscussId:(NSString *)Id Token:(NSString *)token;
//设置朋友圈封面
-(void)setShowImageWithToken:(NSString *)token showImg:(NSString *)showImg;
//获取朋友圈封面
-(void)fetchShowImageWithToken:(NSString *)token uid:(NSString *)uid;
@end
