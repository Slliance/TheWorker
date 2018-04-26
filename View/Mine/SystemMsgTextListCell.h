//
//  SystemMsgTextListCell.h
//  jishikangUser
//
//  Created by yanghao on 6/30/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemMsgModel.h"
@interface SystemMsgTextListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;


-(void)initCell:(SystemMsgModel *)model;
@end
