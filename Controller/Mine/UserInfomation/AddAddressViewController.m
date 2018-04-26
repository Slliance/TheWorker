//
//  AddAddressViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/25.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "AddAddressViewController.h"

#import "H_PCZ_PickerView.h"

#import "AddressViewModel.h"

@interface AddAddressViewController ()<UITextViewDelegate,H_PCZ_PickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNum;
@property (weak, nonatomic) IBOutlet UIButton *btnChoose;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;//字数label
@property (weak, nonatomic) IBOutlet UISwitch *addressSwitch;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@property (nonatomic, copy) NSString *zoneCode;
@property (nonatomic, assign) NSInteger isDefault;
@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zoneCode = [[NSString alloc]init];
    [self.btnChoose setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    self.btnSave.layer.masksToBounds = YES;
    self.btnSave.layer.cornerRadius = 4.f;
    self.isDefault = 0;
    if (self.addressModel) {
        self.txtName.text = self.addressModel.name;
        self.txtPhoneNum.text = [NSString stringWithFormat:@"%@",self.addressModel.mobile];
        self.inputTextView.text = self.addressModel.address_detail;
        [self.btnChoose setTitle:self.addressModel.zone_city forState:UIControlStateNormal];
        [self.btnChoose setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [self.btnChoose setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        if ([self.addressModel.is_def integerValue] == 1) {
            self.addressSwitch.on = YES;
        }
        
        self.zoneCode = [NSString stringWithFormat:@"%@",self.addressModel.zone_code];
        self.isDefault = [self.addressModel.is_def integerValue];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextViewTextDidChangeNotification" object:self.inputTextView];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)setDetault:(id)sender {
    
//    if (self.addressModel) {
//        if (self.addressSwitch.isOn == YES) {
//            //        }else{
//            AddressViewModel *viewModel = [[AddressViewModel alloc]init];
//            [viewModel setBlockWithReturnBlock:^(id returnValue) {
//                self.isDefault = 0;
//            } WithErrorBlock:^(id errorCode) {
//                [self showJGProgressWithMsg:errorCode];
//            }];
//            [viewModel setDetaultAddressWithToken:[self getToken] Id:self.addressModel.Id];
//        }
//    }else{
        if (self.addressSwitch.isOn == YES) {
            self.isDefault = 1;
        }else{
            self.isDefault = 0;
        }

//    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveAndUse:(id)sender {
    if (self.txtName.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入姓名"];
        return;
    }
    if (![CustomTool isValidtePhone:self.txtPhoneNum.text]) {
        [self showJGProgressWithMsg:@"请输入手机号码"];
        return;
    }
    if ([self.zoneCode integerValue] < 1) {
        [self showJGProgressWithMsg:@"请选择省市区"];
        return;
    }
    if (self.inputTextView.text.length == 0) {
        [self showJGProgressWithMsg:@"请填写详细收货地址"];
        return;
    }
    AddressViewModel *viewModel = [[AddressViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self backAction:nil];
        self.returnLoadBlock();
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    if (self.addressModel) {//修改
        [viewModel updateOrderAddressWithToken:[self getToken] name:self.txtName.text mobile:self.txtPhoneNum.text zone_code:self.zoneCode address_detail:self.inputTextView.text is_def:self.isDefault Id:self.addressModel.Id];
        
    }else{//新增
        [viewModel addNewOrderAddressWithToken:[self getToken] name:self.txtName.text mobile:self.txtPhoneNum.text zone_code:self.zoneCode address_detail:self.inputTextView.text is_def:self.isDefault];
    }
    
    
}
- (IBAction)chooseArea:(id)sender {
    [self txtResignFirstResponder];
    H_PCZ_PickerView *pickerView = [[H_PCZ_PickerView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    pickerView.delegate = self;
    [self.view addSubview:pickerView];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    self.labelCount.text = [NSString stringWithFormat:@"%lu/30",(unsigned long)textView.text.length];

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
            if (toBeString.length >= 30) {
                inputTextView.text = [toBeString substringToIndex:30];
                self.labelCount.text = [NSString stringWithFormat:@"%lu/30",(unsigned long)inputTextView.text.length];
            }
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length >= 30) {
            inputTextView.text = [toBeString substringToIndex:30];
        }
    }
}

#pragma mark - H_PCZ_PickerViewDelegate
-(void)getChooseIndex:(H_PCZ_PickerView *)_myPickerView addressStr:(NSString *)addressStr areaCode:(NSString *)areaCode{
    [self.btnChoose setTitle:addressStr forState:UIControlStateNormal];
    [self.btnChoose setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    self.zoneCode = areaCode;

}
-(void)txtResignFirstResponder{
    
    [self.txtPhoneNum resignFirstResponder];
    [self.inputTextView resignFirstResponder];
    [self.txtName resignFirstResponder];
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
