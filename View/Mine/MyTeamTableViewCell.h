//
//  MyTeamTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 14/12/2017.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTeamModel.h"
@interface MyTeamTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *registerTimelabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgMore;

-(void)initCellWithData:(MyTeamModel *)model type:(NSInteger)type; 
@end
