//
//  AddressBookTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/20.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"
#import "AddressBookFriendModel.h"
@interface AddressBookTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnAccept;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) void(^returnAgreeApplyBlock)(NSString *);
-(void)initCellWithData:(AddressBookFriendModel *) model isHidden:(NSInteger)isHidden;
@end
