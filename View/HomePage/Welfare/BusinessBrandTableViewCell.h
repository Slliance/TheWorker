//
//  BusinessBrandTableViewCell.h
//  TheWorker
//
//  Created by yanghao on 8/18/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessBrandTableViewCell : UITableViewCell
@property (nonatomic, copy) void(^returnSkipTagBlock)(NSInteger);
-(void)initCellWithData:(NSArray *)itemArr;

+(CGFloat)getCellHeightWithData:(NSArray *)itemArr;

@end
