//
//  RentRangeTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/6.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RentRangeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIView *skillBgView;
@property (nonatomic, retain) NSMutableArray *skillArray;
@property (nonatomic, copy) void(^returnDelTag)(NSInteger);
-(void)initCellWithData:(NSArray *)array index:(NSInteger )index;
-(void)initCellWithData:(NSArray *)array;
+(CGFloat)getCellHeightWithData:(NSArray*)model;

@end
