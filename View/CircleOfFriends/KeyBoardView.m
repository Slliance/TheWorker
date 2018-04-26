//
//  KeyBoardView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/29.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "KeyBoardView.h"

@implementation KeyBoardView

-(void)initViewWithName:(NSString *)name{
    self.btnSend.layer.masksToBounds = YES;
    self.btnSend.layer.cornerRadius = 4.f;
    self.txtComment.layer.masksToBounds = YES;
    self.txtComment.layer.cornerRadius = 4.f;
    
    if (!self.placestr) {
        [self.txtComment setPlaceholder:@"请输入评论内容"];
    }
    else{
        [self.txtComment setPlaceholder:[NSString stringWithFormat:@"回复%@:",name]];

    }

}
- (IBAction)sendComment:(id)sender {
    self.sendBlcok(self.txtComment.text);
}

@end
