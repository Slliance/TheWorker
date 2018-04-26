//
//  JobInfoHeaderView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/29.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "JobInfoHeaderView.h"

@implementation JobInfoHeaderView

- (IBAction)chooseBigFactory:(id)sender {
    self.returnJobType(0);
    self.lineLabel.center = self.btnBigFactory.center;
    CGRect rect = self.lineLabel.frame;
    rect.origin.y = 43;
    self.lineLabel.frame = rect;
    self.btnOther.selected = NO;
    self.btnBigFactory.selected = YES;
}
- (IBAction)chooseOther:(id)sender {
    self.returnJobType(1);
    self.lineLabel.center = self.btnOther.center;
    CGRect rect = self.lineLabel.frame;
    rect.origin.y = 43;
    self.lineLabel.frame = rect;
    self.btnOther.selected = YES;
    self.btnBigFactory.selected = NO;

}


@end
