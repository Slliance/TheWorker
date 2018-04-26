//
//  MyTeamDetailTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 15/12/2017.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTeamModel.h"
@interface MyTeamDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *registerTimeLabel;
-(void)initCellWithData:(MyTeamModel *)model;
@end
