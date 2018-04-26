//
//  AddBankCardViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "WalletViewModel.h"
#import "H_Single_PickerView.h"
@interface AddBankCardViewController ()<H_Single_PickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnChooseBank;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtCardNO;
@property (weak, nonatomic) IBOutlet UITextField *txtBankName;//开户支行名称
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (nonatomic, retain) NSNumber *chooseId;
@end

@implementation AddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chooseId = [[NSNumber alloc]init];
    [self.btnChooseBank setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    self.btnAdd.layer.masksToBounds = YES;
    self.btnAdd.layer.cornerRadius = 4.f;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)chooseBank:(id)sender {
    
    WalletViewModel *viewModel = [[WalletViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        H_Single_PickerView *pickerView = [[H_Single_PickerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) arr:returnValue];
        pickerView.delegate = self;
        [self.view addSubview:pickerView];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchBankListWithToken:[self getToken]];

}
- (IBAction)addBankCard:(id)sender {
    if (!self.chooseId) {
        [self showJGProgressWithMsg:@"请选择银行"];
        return;
    }
    if (self.txtUserName.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入姓名"];
        return;
    }
    if (self.txtCardNO.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入银行卡号"];
        return;
    }
    if (self.txtBankName.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入开户行"];
        return;
    }
    
    WalletViewModel *viewModel = [[WalletViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self backBtnAction:nil];
        self.returnBlock();
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel addBankCardWithCardNum:self.txtCardNO.text bankId:self.chooseId address:self.txtBankName.text name:self.txtUserName.text token:[self getToken]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - H_Single_PickerViewDelegate
-(void)SinglePickergetObjectWithArr:(H_Single_PickerView *)_h_Single_PickerView arr:(NSArray *)_arr index:(NSInteger)_index chooseStr:(NSString *)chooseStr chooseId:(NSNumber *)chooseId{
    [self.btnChooseBank setTitle:chooseStr forState:UIControlStateNormal];
    [self.btnChooseBank setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    self.chooseId = chooseId;
}

@end
