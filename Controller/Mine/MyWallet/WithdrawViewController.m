//
//  WithdrawViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "WithdrawViewController.h"
#import "WithdrawSuccessViewController.h"
#import "MyCardListViewController.h"
#import "WalletViewModel.h"
@interface WithdrawViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *inputMoneyTxt;
@property (weak, nonatomic) IBOutlet UITextView *inputTextTxt;
@property (weak, nonatomic) IBOutlet UILabel *labelBankName;
@property (weak, nonatomic) IBOutlet UILabel *labelBankNO;
@property (weak, nonatomic) IBOutlet UIButton *btnWithdraw;
@property (weak, nonatomic) IBOutlet UIView *defaultView;
@property (weak, nonatomic) IBOutlet UIView *bankView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, retain) NSNumber *selectIndex;
@end

@implementation WithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cardId = [[NSString alloc]init];
    
    self.inputMoneyTxt.layer.masksToBounds = YES;
    self.inputMoneyTxt.layer.cornerRadius = 4.f;
    [self.inputMoneyTxt.layer setBorderColor:[UIColor colorWithHexString:@"f0f0f0"].CGColor];
    [self.inputMoneyTxt.layer setBorderWidth:1];
    self.inputTextTxt.layer.masksToBounds = YES;
    self.inputTextTxt.layer.cornerRadius = 4.f;
    [self.inputTextTxt.layer setBorderColor:[UIColor colorWithHexString:@"f0f0f0"].CGColor];
    [self.inputTextTxt.layer setBorderWidth:1];

    self.btnWithdraw.layer.masksToBounds = YES;
    self.btnWithdraw.layer.cornerRadius = 4.f;
    NSDictionary *baseDic = [UserDefaults readUserDefaultObjectValueForKey:base_data];
    NSString *rateStr = baseDic[@"rate"];
    double rate = [rateStr doubleValue];
    self.serviceLabel.text = [NSString stringWithFormat:@"提现费率为:%.1f%%",rate];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.inputMoneyTxt resignFirstResponder];
    [self.inputTextTxt resignFirstResponder];
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)withdrawAction:(id)sender {
    if (self.inputMoneyTxt.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入提现金额"];
        return;
    }
    if (self.cardId.length == 0) {
        [self showJGProgressWithMsg:@"请选择银行卡"];
        return;
    }
    WalletViewModel *viewModel = [[WalletViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        self.returnReloadBlock();
        WithdrawSuccessViewController *vc = [[WithdrawSuccessViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel withdrawWithToken:[self getToken] cardId:self.cardId money:self.inputMoneyTxt.text remarks:self.inputTextTxt.text];
    }
- (IBAction)chooseBankAction:(id)sender {
    [self.inputMoneyTxt resignFirstResponder];
    [self.inputTextTxt resignFirstResponder];
    MyCardListViewController *vc = [[MyCardListViewController alloc]init];
    [vc setReturnBlock:^(WalletModel *model,NSInteger selectIndex) {
        
        if (model) {
            self.selectIndex = @(selectIndex);
            self.defaultView.hidden = YES;
            self.bankView.hidden = NO;
            self.labelBankNO.text = [NSString stringWithFormat:@"%@",model.card];
            self.labelBankName.text = model.name;
            self.cardId = model.Id;
            CGRect rect = self.bgView.frame;
            rect.size.height = 190;
            self.bgView.frame = rect;
        }
    }];
    if (self.selectIndex) {
        vc.selectIndex = self.selectIndex;
    }
    vc.isChoose = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSDictionary *baseDic = [UserDefaults readUserDefaultObjectValueForKey:base_data];
    NSString *rateStr = baseDic[@"rate"];
    double rate = [rateStr doubleValue] / 100;
    if (text.length > 0) {
        NSString *str = [NSString stringWithFormat:@"%@%@",textView.text,text];
        double money = [str doubleValue];
        double serviceMoney = money * rate;
        double realMoney = money - serviceMoney;
        self.moneyLabel.text = [NSString stringWithFormat:@"实际到账金额：%.2f    手续费：%.2f",realMoney,serviceMoney];
    }else{
        CGFloat length = textView.text.length;
        NSString *str = [textView.text stringByReplacingCharactersInRange:NSMakeRange(length-1, 1) withString:@""];
        double money = [str doubleValue];
        double serviceMoney = money * rate;
        double realMoney = money - serviceMoney;
        self.moneyLabel.text = [NSString stringWithFormat:@"实际到账金额：%.2f    手续费：%.2f",realMoney,serviceMoney];
    }
    
    return YES;
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
