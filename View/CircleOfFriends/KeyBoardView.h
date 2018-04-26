//
//  KeyBoardView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/29.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyBoardView : UIView
@property (weak, nonatomic) IBOutlet UITextField *txtComment;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (nonatomic, copy) NSString *placestr;
@property (nonatomic, copy) void(^sendBlcok)(NSString *);
-(void)initViewWithName:(NSString *)name;
@end
