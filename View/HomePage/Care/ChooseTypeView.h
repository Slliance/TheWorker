//
//  ChooseTypeView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/11/17.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoosePayTypeTableViewCell.h"


@interface ChooseTypeView : UIView
@property (weak, nonatomic) IBOutlet UIView *blackBgView;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@property (weak, nonatomic) IBOutlet UIButton *btnMoney;
@property (weak, nonatomic) IBOutlet UIButton *btnAlipay;
@property (weak, nonatomic) IBOutlet UIButton *btnWechat;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) void(^returnTypeBlock)(NSInteger);
-(void)initViewWithPrice:(double )price type:(NSInteger)type;
@end
