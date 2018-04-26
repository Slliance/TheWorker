//
//  DisagreeAlertView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/13.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisagreeAlertView : UIView<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *txtReason;
@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelMiddle;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnComfirm;
@property (nonatomic, copy) void(^returnBlock) (NSString *);
-(void)initViewWith:(NSString *)str;
@end
