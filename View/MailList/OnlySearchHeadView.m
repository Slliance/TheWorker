//
//  OnlySearchHeadView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/20.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "OnlySearchHeadView.h"

@implementation OnlySearchHeadView

-(void)initSearchViewWithType:(NSInteger)skipOrSearch{
    
    UIImageView *LeftViewNum = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_search"]];
    //图片的显示模式
    LeftViewNum.contentMode= UIViewContentModeCenter;
    //图片的位置和大小
    LeftViewNum.frame= CGRectMake(0,0,30,30);
    //左视图默认是不显示的 设置为始终显示
    self.txtSearch.leftViewMode= UITextFieldViewModeAlways;
    self.txtSearch.leftView= LeftViewNum;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"6398f1"];
    //NSAttributedString:带有属性的文字（叫富文本，可以让你的文字丰富多彩）但是这个是不可变的带有属性的文字，创建完成之后就不可以改变了  所以需要可变的
    NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc]initWithString:@"输入ID或者昵称查找" attributes:attrs];
    self.txtSearch.attributedPlaceholder = placeHolder;
    self.txtSearch.returnKeyType=UIReturnKeySearch;
    self.txtSearch.delegate = self;
    self.txtSearch.layer.shadowColor = [UIColor colorWithHexString:@"4082f1"].CGColor;
    
    self.txtSearch.layer.shadowOffset = CGSizeMake(4, 4);
    
    self.txtSearch.layer.shadowOpacity = 0.3f;
    
    self.txtSearch.layer.shadowRadius = 4.0;
    
    self.txtSearch.layer.cornerRadius = 15.0;
    
    self.txtSearch.clipsToBounds = NO;
    if (skipOrSearch == 1) {
        self.btnSkipToSearch.hidden = YES;
    }
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    id next = self.nextResponder;
    while (![next isKindOfClass:[UIViewController class]]) {
        next = [next nextResponder];
    }
    if (textField.text.length > 0) {
        self.returnSearchBlock(textField.text);
        //        SearchJobViewController *vc = [[SearchJobViewController alloc]init];
        //        vc.searchKey = textField.text;
        //        vc.hidesBottomBarWhenPushed = YES;
        //        WantedJobViewController *homevc = (WantedJobViewController *)next;
        //        [homevc.navigationController pushViewController:vc animated:YES];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}
- (IBAction)skipToSearch:(id)sender {
    self.returnSearchBlock(self.txtSearch.text);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
