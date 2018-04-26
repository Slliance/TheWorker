//
//  MobileFriendTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"
@interface MobileFriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnAddFriend;
@property (nonatomic, copy) void(^returnAddBlcok)(NSString *);
@property (nonatomic, copy) NSString *uid;
-(void)initCellWithData:(FriendModel *) model;

@end
