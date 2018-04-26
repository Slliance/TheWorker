//
//  RentRemarkView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/13.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RentRemarkView.h"


@implementation RentRemarkView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)initView{
    self.btnCancel.layer.masksToBounds = YES;
    self.btnCancel.layer.cornerRadius = 4.f;
    self.btnComfirm.layer.masksToBounds = YES;
    self.btnComfirm.layer.cornerRadius = 4.f;
    
    [[self viewWithTag:899]removeFromSuperview];
    FMLStarView *starView = [[FMLStarView alloc] initWithFrame:CGRectMake((280-110)/2, 15, 22 * 5, 20)
                                                 numberOfStars:5
                                                   isTouchable:YES
                                                         index:0
                                                starImgDefault:@"icon_gray_star"
                                                 starImgSelect:@"icon_yellow_star"];
    starView.currentScore = 0;
    starView.totalScore = 5;
    starView.isFullStarLimited = YES;
    
    
    
    starView.delegate = self;
    starView.tag = 899;
    [self.remarkView addSubview:starView];
    self.txtRemark.returnKeyType = UIReturnKeyDone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextViewTextDidChangeNotification" object:self.txtRemark];
}

-(void)fml_didClickStarViewByScore:(CGFloat)score atIndex:(NSInteger)index{
    self.point = score;
    NSLog(@"%f===%ld",score,(long)index);
}
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)comfirmAction:(id)sender {
    self.returnBlock(self.txtRemark.text,self.point);
    if (self.txtRemark.text.length > 0) {
        [self removeFromSuperview];
    }
    
}
- (IBAction)tapAction:(UITapGestureRecognizer *)tap {
    if ([self.txtRemark isFirstResponder]) {
        [self.txtRemark resignFirstResponder];
    }else{
        [self removeFromSuperview];
    }
    
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.labelAlert.hidden = YES;
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.labelAlert.hidden = YES;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textFiledEditChanged:(NSNotification *)obj
{
    UITextView *inputTextView = (UITextView *)obj.object;
    NSString *toBeString = inputTextView.text;
    
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [inputTextView markedTextRange];       //获取高亮部分
        UITextPosition *position = [inputTextView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length >= 20) {
                inputTextView.text = [toBeString substringToIndex:20];
                //                self.labelCount.text = [NSString stringWithFormat:@"%lu/30",(unsigned long)inputTextView.text.length];
            }
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length >= 20) {
            inputTextView.text = [toBeString substringToIndex:20];
        }
    }
}


@end
