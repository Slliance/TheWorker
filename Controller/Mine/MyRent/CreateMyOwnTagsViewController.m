//
//  CreateMyOwnTagsViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/13.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "CreateMyOwnTagsViewController.h"
@interface CreateMyOwnTagsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *tagsScrollView;
@property (nonatomic, retain) NSNumber *itemNums;
@property (nonatomic, retain) NSMutableArray *skillArray;
@property (nonatomic, retain) NSMutableArray *skillContentArray;
@end

@implementation CreateMyOwnTagsViewController

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
//    NSMutableArray *muModel = [[NSMutableArray alloc]init];
//    for (int i = 0; i < muarr.count; i ++) {
//        SkillModel *model = [[SkillModel alloc]init];
//        model.skill = muarr[i];
//        [muModel addObject:model];
//    }
    
        self.returnSkillBlock(muarr);
        [self backBtnAction:nil];
}

-(void)btnAdd:(UIButton *)btn{
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
    for (UIView *subview in self.tagsScrollView.subviews) {
        if (subview.tag > 800) {
            [subview removeFromSuperview];
        }
    }
    [self.skillContentArray removeAllObjects];
    CGFloat w = ScreenWidth - 50;
    //    CGFloat sw = ScreenWidth / 3;
    self.tagsScrollView.contentSize = CGSizeMake(ScreenWidth, self.skillArray.count*50);
    
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
            [self.tagsScrollView addSubview:backview];
            
        }
        else{
            
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(25, 60+i*50, w, 40)];
            backview.tag = 801 + i;
            UITextField *textView = [[UITextField alloc]init];
            textView.frame = CGRectMake(0, 0, w, 40);
            textView.placeholder = @"请输入标签";
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
            [self.tagsScrollView addSubview:backview];
            [self.tagsScrollView addSubview:delBtn];
            
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
