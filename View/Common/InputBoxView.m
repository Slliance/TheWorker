//
//  InputBoxView.m
//  TheWorker
//
//  Created by yanghao on 2017/10/13.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "InputBoxView.h"

@implementation InputBoxView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)initView{
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 4.f;
    self.cancelBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.cornerRadius = 4.f;
    self.doneBtn.layer.masksToBounds = YES;
    self.doneBtn.layer.cornerRadius = 4.f;
    
    [self.cancelBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    
}
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)doneAction:(id)sender {
    
    self.doneBlock(self.txtContent.text);
    if (self.txtContent.text.length != 0) {
        [self removeFromSuperview];        
    }

}
@end
