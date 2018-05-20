//
//  AddFateReq.h
//  TheWorker
//
//  Created by apple on 2018/5/19.
//  Copyright © 2018年 huying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddFateReq : NSObject
///
@property(nonatomic,copy)NSString *token;
///月收入
@property(nonatomic,copy)NSNumber *monthly_income;
///身高
@property(nonatomic,copy)NSNumber *height;
///年龄
@property(nonatomic,copy)NSString *birthday;

///昵称
@property(nonatomic,copy)NSString *nicheng;
///性别0-女1-男2-变态
@property(nonatomic,copy)NSString *sex;
///婚姻状况0-已婚,1-未婚,2-已育
@property(nonatomic,copy)NSString *marital_status;
///居住地
@property(nonatomic,copy)NSString *live_address;

///爱情宣言
@property(nonatomic,copy)NSString *declaration;
///简介
@property(nonatomic,copy)NSString *introduce;
///照片
@property(nonatomic,copy)NSArray *imgs;
@end
