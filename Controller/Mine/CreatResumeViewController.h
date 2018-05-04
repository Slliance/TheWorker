//
//  CreatResumeViewController.h
//  TheWorker
//
//  Created by apple on 2018/5/3.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "HYBaseViewController.h"
typedef NS_ENUM(NSInteger,ResumeType) {
    ResumeTypeCreate          = 0,
    ResumeTypePreview        = 1,
    ResumeTypeChange        = 2,
 
};
@interface CreatResumeViewController : HYBaseViewController
@property(nonatomic,assign)ResumeType resumeType;
@end
