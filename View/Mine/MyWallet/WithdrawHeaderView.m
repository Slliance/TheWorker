//
//  WithdrawHeaderView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "WithdrawHeaderView.h"

@implementation WithdrawHeaderView

- (IBAction)chooseStateAll:(id)sender {
    if (self.btnAll.selected == NO) {
        self.btnAll.selected = YES;
        self.btnAudit.selected = NO;
        self.btnPassed.selected = NO;
        self.btnReturn.selected = NO;
        self.labelAll.hidden = NO;
        self.labelAudit.hidden = YES;
        self.labelPassed.hidden = YES;
        self.labelReturn.hidden = YES;
    }
    self.returnSelectedBlock(0);
}
- (IBAction)chooseStateAudit:(id)sender {
    if (self.btnAudit.selected == NO) {
        self.btnAudit.selected = YES;
        self.btnAll.selected = NO;
        self.btnPassed.selected = NO;
        self.btnReturn.selected = NO;
        self.labelAudit.hidden = NO;
        self.labelAll.hidden = YES;
        self.labelPassed.hidden = YES;
        self.labelReturn.hidden = YES;
    }

    self.returnSelectedBlock(1);
}
- (IBAction)chooseStatePassed:(id)sender {
    if (self.btnPassed.selected == NO) {
        self.btnPassed.selected = YES;
        self.btnAudit.selected = NO;
        self.btnAll.selected = NO;
        self.btnReturn.selected = NO;
        self.labelPassed.hidden = NO;
        self.labelAudit.hidden = YES;
        self.labelAll.hidden = YES;
        self.labelReturn.hidden = YES;
    }

    self.returnSelectedBlock(2);
}
- (IBAction)chooseStateReturn:(id)sender {
    if (self.btnReturn.selected == NO) {
        self.btnReturn.selected = YES;
        self.btnAudit.selected = NO;
        self.btnPassed.selected = NO;
        self.btnAll.selected = NO;
        self.labelReturn.hidden = NO;
        self.labelAudit.hidden = YES;
        self.labelPassed.hidden = YES;
        self.labelAll.hidden = YES;
    }

    self.returnSelectedBlock(3);
}



@end
