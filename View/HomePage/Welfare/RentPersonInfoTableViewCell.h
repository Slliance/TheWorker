//
//  RentPersonInfoTableViewCell.h
//  TheWorker
//
//  Created by yanghao on 8/21/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RentPersonModel.h"
@interface RentPersonInfoTableViewCell : UITableViewCell

-(void)initCell:(RentPersonModel *)model section:(NSInteger)section;
+(CGFloat)getHeightCell:(RentPersonModel *)model section:(NSInteger)section;
@end
