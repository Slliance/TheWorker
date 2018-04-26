//
//  FriendCircleViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/14.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "FriendCircleViewModel.h"
#import "FriendCircleModel.h"
#import "FollowsModel.h"
#import "AgreesModel.h"
@implementation FriendCircleViewModel
//发布朋友圈
-(void)releaseFriendCircleWith:(NSString *)Content imgs:(NSArray *)imgs token:(NSString *)token{
    NSDictionary *parameter = @{@"content":Content,
                                @"imgs":imgs,
                                @"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_firend_circle_release method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
//            [self loginSuccessWithDic:publicModel];
            self.returnBlock(publicModel.message);
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//朋友圈
-(void)fetchFriendCircleDataWithToken:(NSString *)token page:(NSNumber *)page size:(NSNumber *)size{
    NSDictionary *parameter = @{@"page":page,
                                @"size":@(10),
                                @"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_friend_circle method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleFriendCircleData:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handleFriendCircleData:(PublicModel *)publicModel{
    NSArray *friendArr = publicModel.data;
    NSMutableArray *muFriendArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < friendArr.count; i ++) {
        FriendCircleModel *model = [[FriendCircleModel alloc]initWithDict:friendArr[i]];
        NSArray *imgsArr = friendArr[i][@"imgs"];
        NSArray *agreeArr = friendArr[i][@"agrees"];
        NSArray *followsArr = friendArr[i][@"follows"];
        NSString *content = [NSString stringWithFormat:@"%@",friendArr[i][@"content"]];
        model.content = content;
        NSString *idStr = [NSString stringWithFormat:@"%@",friendArr[i][@"uid"]];
        model.uid = idStr;
        NSMutableArray *agreeMuArr = [[NSMutableArray alloc] init];
        for (int x = 0; x < agreeArr.count; x ++) {
            AgreesModel *agreesModel = [[AgreesModel alloc] initWithDict:agreeArr[x]];
            [agreeMuArr addObject:agreesModel];
        }
        model.agrees = agreeMuArr;
        
        
        NSMutableArray *followsMuArr = [[NSMutableArray alloc] init];
        for (int x = 0; x < followsArr.count; x ++) {
            FollowsModel *followsModel = [[FollowsModel alloc] initWithDict:followsArr[x]];
            NSString *subcontent = [NSString stringWithFormat:@"%@",followsArr[x][@"content"]];
            followsModel.content = subcontent;
            [followsMuArr addObject:followsModel];
        }
        model.follows = followsMuArr;
        
        model.imgs = imgsArr;

        [muFriendArr addObject:model];
    }
    self.returnBlock(muFriendArr);
}
//个人朋友圈
-(void)fetchUserCircleDataWithToken:(NSString *)token page:(NSNumber *)page uid:(NSString *)uid size:(NSNumber *)size{
    NSDictionary *parameter = @{@"page":page,
                                @"size":@(10),
                                @"token":token,
                                @"uid":uid};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_friend_circle method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleFriendCircleData:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

/**
 点赞

 @param token token
 @param Id 朋友圈的动态id
 */
-(void)agreeFriendWithToken:(NSString *)token Id:(NSString *)Id{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_friend_agree method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
//            [self handleFriendCircleData:publicModel];
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
 评论

 @param token token
 @param Id 朋友圈id
 @param friendId @的id
 @param content 内容
 */
-(void)discussFriendWithToken:(NSString *)token Id:(NSString *)Id friendId:(NSString *)friendId content:(NSString *)content{
    NSDictionary *parameter = @{@"content":content,
                                @"token":token,
                                @"id":Id};
    NSMutableDictionary *muParameter = [[NSMutableDictionary alloc]initWithDictionary:parameter];
    if (friendId) {
        [muParameter setObject:friendId forKey:@"friend_id"];
    }
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_friend_discuss method:@"post" parameter:muParameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel.message);
//            [self handleFriendCircleData:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//删除朋友圈
-(void)delCircleWithCircleId:(NSString *)Id Token:(NSString *)token{
    NSDictionary *parameter = @{@"id":Id,
                                @"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_friend_delcircle method:@"post" parameter:parameter success:^(NSDictionary *data) {
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

//删除评论
-(void)delDiscussWithDiscussId:(NSString *)Id Token:(NSString *)token{
    NSDictionary *parameter = @{@"id":Id,
                                @"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_friend_deldiscuss method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
-(void)setShowImageWithToken:(NSString *)token showImg:(NSString *)showImg{
    NSDictionary *parameter = @{@"img":showImg,
                                @"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_friend_showImg method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
-(void)fetchShowImageWithToken:(NSString *)token uid:(NSString *)uid{
    NSDictionary *parameter = @{@"token":token,
                                @"uid":uid
                                
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_friend_getShowImg method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
@end
