//
//  RentContentTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RentContentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;


-(void)initCellWithData:(BOOL)confirmed;
@end
