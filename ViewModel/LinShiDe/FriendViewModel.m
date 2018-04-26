//
//  FriendViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/20.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "FriendViewModel.h"
#import "FriendModel.h"
#import "AddressBookFriendModel.h"
#import "AddressBookModel.h"
@implementation FriendViewModel
//处理好友申请
-(void)handleFriendApplyWithToken:(NSString *)token Id:(NSString *)Id type:(NSNumber *)type{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id,
                                @"type":type
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_friend_apply method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel.message);
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

//获取好友申请列表
-(void)fetchFriendApplyListWithToken:(NSString *)token page:(NSNumber *)page{
    NSDictionary *parameter = @{@"token":token,
                                @"page":page,
                                @"size":@(10)
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_friend_applylist method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleFriendApplyListData:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handleFriendApplyListData:(PublicModel *)publicModel{
    NSArray *array = publicModel.data;
    NSMutableArray *muArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < array.count; i ++) {
        AddressBookFriendModel *model = [[AddressBookFriendModel alloc] initWithDict:array[i]];
        [muArray addObject:model];
    }
    self.returnBlock(muArray);
}
//通讯录
-(void)fetchMyFriendListWithToken:(NSString *)token name:(NSString *)name{
    NSDictionary *parameter = @{@"token":token};
    NSMutableDictionary *muparameter = [[NSMutableDictionary alloc] initWithDictionary:parameter];
    if (name) {
        [muparameter setObject:name forKey:@"name"];
    }
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_friend_friendlist method:@"post" parameter:muparameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleMyFriendList:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)handleMyFriendList:(PublicModel *)publicModel{
    NSArray *array = [publicModel.data objectForKey:@"friend"];
    NSMutableArray *listMuarr = [[NSMutableArray alloc] init];
    for (int i = 0; i < [array count]; i ++) {
        AddressBookModel *addressBookModel = [[AddressBookModel alloc] initWithDict:array[i]];
        NSArray *friendArr = [array[i] objectForKey:@"friend"];
        NSMutableArray *friendMuArr = [[NSMutableArray alloc] init];
        for (int j = 0; j < friendArr.count; j ++) {
            AddressBookFriendModel *friendModel = [[AddressBookFriendModel alloc] initWithDict:friendArr[j]];
            [friendMuArr addObject:friendModel];
        }
        addressBookModel.friends = friendMuArr;
        [listMuarr addObject:addressBookModel];
    }
    NSNumber *new = [publicModel.data objectForKey:@"apply"];
    self.returnBlock(@[listMuarr,new]);
    
}

//查找用户
-(void)searchUserWithName:(NSString *)name token:(NSString *)token page:(NSNumber *)page{
    NSDictionary *parameter = @{@"token":token,
                                @"page":page,
                                @"name":name,
                                @"size":@(10)
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_search_user method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleFriendApplyListData:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

//删除好友
-(void)deleteFriendWithToken:(NSString *)token Id:(NSString *)Id{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_friend_delfriend method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel.message);
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//设置备注
-(void)setRemarkWithToken:(NSString *)token Id:(NSString *)Id remark:(NSString *)remark{

    NSDictionary *parameter = @{@"token":token,
                                @"id":Id,
                                @"remark":remark
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_friend_setremark method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel.message);
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//删除好友申请
-(void)deleteFriendApplyWithToken:(NSString *)token Id:(NSString *)Id{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_friend_delapply method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel.message);
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//通过手机号添加好友
-(void)addFriendWithToken:(NSString *)token mobile:(NSString *)mobile{
    NSDictionary *parameter = @{@"token":token,
                                @"mobile":mobile
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_friend_addbymobile method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel.message);
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//获取用户信息
-(void)fetchFriendInfomationWithToken:(NSString *)token mobile:(NSString *)mobile{
    NSDictionary *parameter = @{@"token":token,
                                @"mobile":mobile
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_friend_infobymobile method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleMyFriendData:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//获取用户信息
-(void)fetchFriendInfomationWithToken:(NSString *)token Id:(NSString *)Id{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_friend_infobyid method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleMyFriendData:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handleMyFriendData:(PublicModel *)publicModel{
    AddressBookFriendModel *model = [[AddressBookFriendModel alloc] initWithDict:publicModel.data];
    NSString *idStr = publicModel.data[@"Id"];
    model.Id = idStr;
    self.returnBlock(model);
}
@end
