//
//  ChooseInfoTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/21.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *choosedImage;
-(void)initCellWithData:(NSString *)str;
@end
