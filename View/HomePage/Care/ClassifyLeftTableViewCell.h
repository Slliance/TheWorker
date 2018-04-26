//
//  ClassifyLeftTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/22.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassifyLeftTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *cellBgView;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *labelLine;

-(void)initCellWithData:(NSDictionary *)dic;
@end
