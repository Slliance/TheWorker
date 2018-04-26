//
//  ChooseAreaTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/18.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseAreaTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;

-(void)initCellWithData:(NSString *)str;
@end
