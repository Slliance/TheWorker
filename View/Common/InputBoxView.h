//
//  InputBoxView.h
//  TheWorker
//
//  Created by yanghao on 2017/10/13.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputBoxView : UIView


@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextField *txtContent;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (nonatomic,copy) void(^doneBlock)(NSString *);
-(void)initView;
@end
