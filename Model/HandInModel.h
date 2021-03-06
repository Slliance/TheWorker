//
//  HandInModel.h
//  TheWorker
//
//  Created by yanghao on 9/9/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "BaseModel.h"

@interface HandInModel : BaseModel

@property (nonatomic, copy) NSString        *name;
@property (nonatomic, copy) NSString        *nickname;
@property (nonatomic, copy) NSString        *headimg;
@property (nonatomic, copy) NSString        *uid;
@property (nonatomic, assign) NSInteger       sex  ;
@property (nonatomic, copy) NSString        *Id  ;
///爱情宣言
@property (nonatomic, copy) NSString        *declaration;
@property (nonatomic, copy) NSString        *introduce;
@property (nonatomic, retain) NSArray *imgs;
@property (nonatomic, retain) NSNumber        *is_friend  ;
@property (nonatomic, retain) NSNumber        *is_collect  ;
@property (nonatomic, retain) NSNumber        *fate_status  ;
@property (nonatomic, copy) NSString        *confirm_time;
@property (nonatomic, copy) NSString        *audite_time;
@property (nonatomic, copy) NSString *collect_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *createtime;
///距离
@property (nonatomic, copy) NSNumber *ditance;
///月收入
@property (nonatomic, copy) NSNumber *monthly_income;
///身高
@property (nonatomic, copy) NSNumber *height;
///年龄
@property (nonatomic, copy) NSString *brithday;
@end
