//
//  ChooseItemView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/12.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkillModel.h"
@interface ChooseItemView : UIView
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *itemTablView;
@property (nonatomic, copy) void(^returnBlock)(SkillModel *);
@property (nonatomic, copy) void(^removeBlock)(void);
@property (nonatomic, retain) NSArray *itemArr;
-(void)initView:(NSArray *)itemArr;


@end
