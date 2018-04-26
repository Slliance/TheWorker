//
//  CreateOwnSkillViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "CreateOwnSkillViewController.h"
#import "RentViewModel.h"
#import "SkillModel.h"
@interface CreateOwnSkillViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnAddLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *skillScrollView;
@property (nonatomic, retain) NSNumber *itemNums;
@property (nonatomic, retain) NSMutableArray *skillArray;
@property (nonatomic, retain) NSMutableArray *skillContentArray;

@end

@implementation CreateOwnSkillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemNums = 0;
    
    self.skillArray = [[NSMutableArray alloc]init];
    self.skillContentArray = [[NSMutableArray alloc]init];
    [self.skillArray addObject:@"添加标签"];
    [self createSkillArray];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.txtMyRemark];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)saveAction:(id)sender {
    NSMutableArray *muarr = [[NSMutableArray alloc] init];
    for (UITextField *txtField in self.skillContentArray) {
        if (txtField.text.length) {
            [muarr addObject:txtField.text];
        }
    }
    NSMutableArray *muModel = [[NSMutableArray alloc]init];
    for (int i = 0; i < muarr.count; i ++) {
        SkillModel *model = [[SkillModel alloc]init];
        model.skill = muarr[i];
        [muModel addObject:model];
    }
    RentViewModel *viewModel = [[RentViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        self.returnSkillBlock(muModel);
        [self backBtnAction:nil];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel addOwnSkillWithToken:[self getToken] skill:muarr];
    
    
}
- (IBAction)btnAdd:(id)sender {
    for (int i = 0; i < self.skillContentArray.count; i ++) {
        
        UITextField *txtField = (UITextField *)self.skillContentArray[i];
        [self.skillArray replaceObjectAtIndex:i withObject:txtField.text];
        
    }
    [self.skillArray insertObject:@"" atIndex:self.skillArray.count-1];
    NSLog(@"%@",self.skillArray);
    [self createSkillArray];
}
-(void)deleteAction:(UIButton *)btn{
    for (int i = 0; i < self.skillContentArray.count; i ++) {
        
        UITextField *txtField = (UITextField *)self.skillContentArray[i];
        [self.skillArray replaceObjectAtIndex:i withObject:txtField.text];
        
    }
    [self.skillArray removeObjectAtIndex:btn.tag - 801];
    [self createSkillArray];
}

-(void)createSkillArray{
    for (UIView *subview in self.skillScrollView.subviews) {
        if (subview.tag > 800) {
            [subview removeFromSuperview];
        }
    }
    [self.skillContentArray removeAllObjects];
    CGFloat w = ScreenWidth - 50;
//    CGFloat sw = ScreenWidth / 3;
    self.skillScrollView.contentSize = CGSizeMake(ScreenWidth, self.skillArray.count*50);
    
    for (int i = 0; i < self.skillArray.count; i ++) {
        
        if (i == self.skillArray.count - 1) {
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(25,60+i*50,w,40)];
            backview.tag = 801 + i;
            
            
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addBtn.frame = CGRectMake(0, 0, w, 40);
            [addBtn setTitle:self.skillArray[self.skillArray.count-1] forState:UIControlStateNormal];
            [addBtn setImage:[UIImage imageNamed:@"icon_plus_black"] forState:UIControlStateNormal];
            [addBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
            [addBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [addBtn setBackgroundColor:[UIColor whiteColor]];
            [addBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:10.f];
            [addBtn addTarget:self action:@selector(btnAdd:) forControlEvents:UIControlEventTouchUpInside];
            [backview addSubview:addBtn];
            [self.skillScrollView addSubview:backview];
            
        }
        else{
            
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(25, 60+i*50, w, 40)];
            backview.tag = 801 + i;
            UITextField *textView = [[UITextField alloc]init];
            textView.frame = CGRectMake(0, 0, w, 40);
            textView.placeholder = @"请输入技能";
            textView.text = self.skillArray[i];
            textView.tag = 801 + i;
            [textView addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
//            textView.delegate = self;
            textView.textAlignment = NSTextAlignmentCenter;
            textView.backgroundColor = [UIColor whiteColor];
            textView.textColor = [UIColor colorWithHexString:@"333333"];
            textView.font = [UIFont systemFontOfSize:15];
            [backview addSubview:textView];
            
            [self.skillContentArray addObject:textView];
            
            UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [delBtn setImageEdgeInsets:UIEdgeInsetsMake(16, 16, 16, 16)];
            delBtn.tag = 801 + i;
            CGRect rect = backview.frame;
            CGFloat delX = rect.origin.x+rect.size.width -22;
            CGFloat delY = rect.origin.y-22;
            delBtn.frame = CGRectMake(delX, delY, 44, 44);
            [delBtn setImage:[UIImage imageNamed:@"icon_cancel1"] forState:UIControlStateNormal];
            [delBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.skillScrollView addSubview:backview];
            [self.skillScrollView addSubview:delBtn];

        }
    }
}

- (void)textFiledEditChanged:(UITextField *)textField
{
//    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];       //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length >= 6) {
                textField.text = [toBeString substringToIndex:6];
            }
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length >= 6) {
            textField.text = [toBeString substringToIndex:6];
        }
    }
}

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    if (textField.text.length > 6) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"超出最大可输入长度" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];//如果输入的文字大于140 则提示 <span style="font-family: Arial, Helvetica, sans-serif;">"超出最大可输入长度" 并不能继续输入文字</span>
//        
//        [alert show];
//        return NO;
//    }
//    else {
//        return YES;
//    }
//}

@end
