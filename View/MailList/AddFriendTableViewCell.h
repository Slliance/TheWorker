//
//  AddFriendTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/20.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBookFriendModel.h"
@interface AddFriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (nonatomic, copy) void(^returnAddBlcok)(NSString *);
@property (nonatomic, copy) NSString *uid;
-(void)initCellWithData:(AddressBookFriendModel *) model;
@end
