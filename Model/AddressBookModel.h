//
//  AddressBookModel.h
//  TheWorker
//
//  Created by yanghao on 2017/10/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface AddressBookModel : BaseModel

@property (nonatomic, copy) NSString *letter;
@property (nonatomic, retain) NSArray *friends;


@end
