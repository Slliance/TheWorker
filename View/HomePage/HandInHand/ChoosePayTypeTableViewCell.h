//
//  ChoosePayTypeTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePayTypeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;
@property (weak, nonatomic) IBOutlet UILabel *labelPayType;
-(void)initCellWithData:(NSInteger)row :(BOOL)isSelect money:(NSNumber *)money;
@end
