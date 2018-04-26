//
//  WithdrawHeaderView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btnAll;
@property (weak, nonatomic) IBOutlet UILabel *labelAll;
@property (weak, nonatomic) IBOutlet UIButton *btnAudit;
@property (weak, nonatomic) IBOutlet UILabel *labelAudit;
@property (weak, nonatomic) IBOutlet UIButton *btnPassed;
@property (weak, nonatomic) IBOutlet UILabel *labelPassed;
@property (weak, nonatomic) IBOutlet UIButton *btnReturn;
@property (weak, nonatomic) IBOutlet UILabel *labelReturn;
@property (nonatomic, copy) void(^returnSelectedBlock)(NSInteger);
@end
