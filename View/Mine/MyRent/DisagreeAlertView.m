//
//  DisagreeAlertView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/13.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "DisagreeAlertView.h"

@implementation DisagreeAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)initViewWith:(NSString *)str{
    self.btnCancel.layer.masksToBounds = YES;
    self.btnCancel.layer.cornerRadius = 4.f;
    self.btnComfirm.layer.masksToBounds = YES;
    self.btnComfirm.layer.cornerRadius = 4.f;
    self.labelMiddle.text = str;
    
}
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)confirmAction:(id)sender {
    self.returnBlock(self.txtReason.text);
    if (self.txtReason.text.length != 0) {
        [self removeFromSuperview ];
    }
    
}

- (IBAction)tabAction:(UITapGestureRecognizer *) tap {
    if ([self.txtReason isFirstResponder]) {
        [self.txtReason resignFirstResponder];
    }else{
        [self removeFromSuperview];
    }
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.labelOne.hidden = YES;
    self.labelTwo.hidden = YES;
    self.labelMiddle.hidden = YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.labelOne.hidden = YES;
        self.labelTwo.hidden = YES;
        self.labelMiddle.hidden = YES;
    }
}

@end
