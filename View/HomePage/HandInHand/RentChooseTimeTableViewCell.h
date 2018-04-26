//
//  RentChooseTimeTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RentChooseTimeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UIButton *btnMinus;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;
@property (weak, nonatomic) IBOutlet UILabel *labelAmount;
@property (nonatomic, copy) void(^returnBlock)(NSString *);
-(void)initCellWithData;
@end
