//
//  JobHeaderView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/29.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPRingedPages.h"
@interface JobHeaderView : UIView<RPRingedPagesDelegate, RPRingedPagesDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtSearchBar;

@property (weak, nonatomic) IBOutlet UIButton *btnLongTime;
@property (weak, nonatomic) IBOutlet UIButton *btnUrgency;
@property (weak, nonatomic) IBOutlet UIButton *btnPartTime;
@property (weak, nonatomic) IBOutlet UIScrollView *jobScrollView;

@property (nonatomic, strong) RPRingedPages *pages;
-(void)initViewWithData:(NSArray *)dataArray;
@property (nonatomic, copy) void(^returnTagBlock)(NSInteger tag);
@end
