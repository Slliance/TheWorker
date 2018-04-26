//
//  JobInfoHeaderView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/29.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobInfoHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btnBigFactory;
@property (weak, nonatomic) IBOutlet UIButton *btnOther;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (nonatomic, copy) void(^returnJobType)(NSInteger);
@end
