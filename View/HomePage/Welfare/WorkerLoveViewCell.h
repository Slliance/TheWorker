//
//  BrandTableViewCell.h
//  TheWorker
//
//  Created by yanghao on 8/19/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkerLoveViewCell : UITableViewCell
@property (nonatomic, retain) NSArray *dataArr;

-(void)initCellWithData:(NSArray *)itemArr;
+(CGFloat)getCellHeightWithData:(NSArray *)itemArr;


@end
