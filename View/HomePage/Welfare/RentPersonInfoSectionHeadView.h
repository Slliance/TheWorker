//
//  RentPersonInfoSectionHeadView.h
//  TheWorker
//
//  Created by yanghao on 8/21/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RentPersonInfoSectionHeadView : UIView

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *showBtn;
-(void)initViewWithSection:(NSInteger)section;
@end
