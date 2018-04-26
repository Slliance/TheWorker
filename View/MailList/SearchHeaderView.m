//
//  SearchHeaderView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/19.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "SearchHeaderView.h"
#import "NewFriendViewController.h"
@implementation SearchHeaderView


-(void)initSearchViewWithState:(NSNumber *)isNew{
    if ([isNew integerValue] == 0) {
        self.redLabel.hidden = YES;
    }else{
        self.redLabel.hidden = NO;
        self.redLabel.layer.masksToBounds = YES;
        self.redLabel.layer.cornerRadius = 6.f;
        self.redLabel.text = [NSString stringWithFormat:@"%@",isNew];
    }
    
    self.btnSearch.hidden = YES;
    NSString *str = @"搜索好友";
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ScreenWidth, 200)];
    CGRect rect = self.imgSearch.frame;
    rect.origin.x = ScreenWidth/2 - size.width/2;
    self.imgSearch.frame = rect;
    UIImageView *LeftViewNum = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    //图片的显示模式
    LeftViewNum.contentMode= UIViewContentModeCenter;
    //图片的位置和大小
    LeftViewNum.frame= CGRectMake(0,0,30,30);
    //左视图默认是不显示的 设置为始终显示
    self.searchBar.leftViewMode= UITextFieldViewModeAlways;
    self.searchBar.leftView= LeftViewNum;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"6398f1"];
    //NSAttributedString:带有属性的文字（叫富文本，可以让你的文字丰富多彩）但是这个是不可变的带有属性的文字，创建完成之后就不可以改变了  所以需要可变的
    NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc]initWithString:@"搜索好友" attributes:attrs];
    self.searchBar.attributedPlaceholder = placeHolder;
    self.searchBar.returnKeyType=UIReturnKeySearch;
    self.searchBar.delegate = self;
    self.searchBar.layer.shadowColor = [UIColor colorWithHexString:@"4082f1"].CGColor;
    
    self.searchBar.layer.shadowOffset = CGSizeMake(4, 4);
    
    self.searchBar.layer.shadowOpacity = 0.3f;
    
    self.searchBar.layer.shadowRadius = 4.0;
    
    self.searchBar.layer.cornerRadius = 15.0;
    
    self.searchBar.clipsToBounds = NO;
}
- (IBAction)skipAction:(id)sender {
    id next = self.nextResponder;
    while (![next isKindOfClass:[UIViewController class]]) {
        next = [next nextResponder];
    }
    
    NewFriendViewController *vc = [[NewFriendViewController alloc]init];
//    vc.searchKey = textField.text;
    vc.hidesBottomBarWhenPushed = YES;
    NewFriendViewController *homevc = (NewFriendViewController *)next;
    [homevc.navigationController pushViewController:vc animated:YES];
   
}

- (IBAction)searchAction:(id)sender {
//    self.returnSearchBlock(@"");
}


#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    id next = self.nextResponder;
    while (![next isKindOfClass:[UIViewController class]]) {
        next = [next nextResponder];
    }
    if (textField.text.length > 0) {
        self.returnSearchBlock(textField.text);
        [textField resignFirstResponder];
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length > 0) {
        CGRect rect = self.imgSearch.frame;
        rect.origin.x = 20;
        self.imgSearch.frame = rect;
    }else if ([string isEqualToString:@""]){
        if (textField.text.length == 1) {
            NSString *str = @"搜索好友";
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ScreenWidth, 200)];
            CGRect rect = self.imgSearch.frame;
            rect.origin.x = ScreenWidth/2 - size.width/2;
            self.imgSearch.frame = rect;
        }
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length == 0){
        NSString *str = @"搜索好友";
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ScreenWidth, 200)];
        CGRect rect = self.imgSearch.frame;
        rect.origin.x = ScreenWidth/2 - size.width/2;
        self.imgSearch.frame = rect;
        self.returnSearchBlock(textField.text);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
