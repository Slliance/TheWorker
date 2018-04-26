//
//  RentRemarkView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/13.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMLStarView.h"
@interface RentRemarkView : UIView<UITextViewDelegate,FMLStarViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *txtRemark;
@property (weak, nonatomic) IBOutlet UILabel *labelAlert;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnComfirm;
@property (weak, nonatomic) IBOutlet UIView *remarkView;
@property (nonatomic, assign) NSInteger point;
@property (nonatomic, copy) void(^returnBlock)(NSString *, NSInteger point);

-(void)initView;
@end
