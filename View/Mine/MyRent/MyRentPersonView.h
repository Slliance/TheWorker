//
//  MyRentPersonView.h
//  TheWorker
//
//  Created by yanghao on 9/2/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RentOrderModel.h"
@interface MyRentPersonView : UIView
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelShow;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *firstBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *secondBtn;

@property (nonatomic, copy) void(^firstReturnBlock)(NSInteger);
@property (nonatomic, copy) void(^secondReturnBlock)(NSInteger);
@property (nonatomic, assign) NSInteger state;
-(void)initView:(RentOrderModel *)model type:(NSInteger)type;


@end
