//
//  ChooseTypeView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/11/17.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ChooseTypeView.h"

@implementation ChooseTypeView

-(void)initViewWithPrice:(double)price type:(NSInteger)type{
    self.amountLabel.text = [NSString stringWithFormat:@"余额支付(余额：%.2f)",price];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:self.amountLabel.text];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(4, self.amountLabel.text.length-4)];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(4, self.amountLabel.text.length-4)];
    [self.amountLabel setAttributedText:attStr];
    [self.amountLabel sizeToFit];
    if (type == 0) {
        [self chooseMoney:nil];
    }else{
        [self chooseAlipay:nil];
    }
}

- (IBAction)payAction:(id)sender {
    self.returnTypeBlock(self.type);
//    icon_circle_not_selected
}
- (IBAction)tapAction:(id)sender {
    
    [self removeFromSuperview];
    
}
- (IBAction)chooseMoney:(id)sender {
    
//    if (self.btnWechat.selected == NO) {
        [self.btnMoney setImage:[UIImage imageNamed:@"icon_circle_selected"] forState:UIControlStateNormal];
        [self.btnAlipay setImage:[UIImage imageNamed:@"icon_circle_not_selected"] forState:UIControlStateNormal];
        [self.btnWechat setImage:[UIImage imageNamed:@"icon_circle_not_selected"] forState:UIControlStateNormal];
//        self.btnWechat.selected = YES;
//        self.btnAlipay.selected = NO;
//    }else{
        //        self.weiChatButton.tag = 121;
        //
        //        [self.weiChatButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    }
    self.type = 1;
}
- (IBAction)chooseAlipay:(id)sender {
    [self.btnMoney setImage:[UIImage imageNamed:@"icon_circle_not_selected"] forState:UIControlStateNormal];
    [self.btnAlipay setImage:[UIImage imageNamed:@"icon_circle_selected"] forState:UIControlStateNormal];
    [self.btnWechat setImage:[UIImage imageNamed:@"icon_circle_not_selected"] forState:UIControlStateNormal];
//    if (self.btnWechat.selected == NO) {
//        [self.btnWechat setImage:[UIImage imageNamed:@"icon_authorized"] forState:UIControlStateNormal];
//        [self.btnAlipay setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        self.btnWechat.selected = YES;
//        self.btnAlipay.selected = NO;
//    }else{
//        //        self.weiChatButton.tag = 121;
//        //
//        //        [self.weiChatButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    }
    self.type = 2;
}
- (IBAction)chooseWechar:(id)sender {
    [self.btnMoney setImage:[UIImage imageNamed:@"icon_circle_not_selected"] forState:UIControlStateNormal];
    [self.btnAlipay setImage:[UIImage imageNamed:@"icon_circle_not_selected"] forState:UIControlStateNormal];
    [self.btnWechat setImage:[UIImage imageNamed:@"icon_circle_selected"] forState:UIControlStateNormal];
//    if (self.btnWechat.selected == NO) {
//        [self.btnWechat setImage:[UIImage imageNamed:@"icon_authorized"] forState:UIControlStateNormal];
//        [self.btnAlipay setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        self.btnWechat.selected = YES;
//        self.btnAlipay.selected = NO;
//    }else{
//        //        self.weiChatButton.tag = 121;
//        //
//        //        [self.weiChatButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    }
    self.type = 3;
}

@end
