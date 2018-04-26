//
//  WorkerDetailTableViewCell.h
//  TheWorker
//
//  Created by yanghao on 8/29/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkerDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
+(CGFloat)getCellHeight:(NSString *)content;
-(void)initView:(NSString *)content;
@end
