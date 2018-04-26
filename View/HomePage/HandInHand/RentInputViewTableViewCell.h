//
//  RentInputViewTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RentInputViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
-(void)initCellWithData:(NSString *)confirmed;
@end
