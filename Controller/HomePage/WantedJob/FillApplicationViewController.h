//
//  FillApplicationViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/29.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"
typedef NS_ENUM(NSInteger,ResumeType) {
    ResumeTypeCreate          = 0,
    ResumeTypePreview        = 1,
    ResumeTypeChange        = 2,
    
};
@interface FillApplicationViewController : HYBaseViewController
@property (nonatomic, retain) NSNumber *workId;
@property(nonatomic,assign)ResumeType resumeType;
@end
