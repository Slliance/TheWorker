//
//  MyWalletViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyWalletViewController.h"
#import "SaleRecordViewController.h"
#import "RechargeViewController.h"
#import "MyCardListViewController.h"
#import "WithdrawViewController.h"
#import "WithdrawRecordViewController.h"
#import "WalletModel.h"
#import "WalletViewModel.h"
@interface MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *labelMoney;
@property (weak, nonatomic) IBOutlet UILabel *labelWorkMoney;
@property (weak, nonatomic) IBOutlet UIButton *btnRecharge; //充值余额
@property (weak, nonatomic) IBOutlet UIButton *btnWorkRecharge; //充值工币
@property (weak, nonatomic) IBOutlet UITableView *walletTableView;
@property (nonatomic, retain) NSArray *tableArr;
@property (nonatomic, retain) NSArray *imageArr;
@property (nonatomic, retain) WalletViewModel *viewModel;
@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnRecharge.layer setBorderColor:[UIColor colorWithHexString:@"ffffff"].CGColor];
    [self.btnRecharge.layer setBorderWidth:1];
    [self.btnRecharge.layer setMasksToBounds:YES];
    [self.btnRecharge.layer setCornerRadius:4.f];
    [self.btnWorkRecharge.layer setBorderColor:[UIColor colorWithHexString:@"ffffff"].CGColor];
    [self.btnWorkRecharge.layer setBorderWidth:1];
    [self.btnWorkRecharge.layer setMasksToBounds:YES];
    [self.btnWorkRecharge.layer setCornerRadius:4.f];

    self.tableArr = @[@"余额提现",@"提现申请记录",@"我的银行卡"];
    self.imageArr = @[@"icon_balance_withdrawal",@"icon_aplication_record",@"icon_my_bank_card"];
    // Do any additional setup after loading the view from its nib.
    
    self.viewModel = [[WalletViewModel alloc]init];
    __weak typeof(self)weakSelf = self;
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        WalletModel *model = returnValue;
        weakSelf.labelMoney.text = [NSString stringWithFormat:@"￥%@",model.amount];
        weakSelf.labelWorkMoney.text = [NSString stringWithFormat:@"%@",model.score];
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    [self.viewModel fetchWalletInfomationWithToken:[self getToken]];
}
-(void)viewDidAppear:(BOOL)animated{
//    [self.viewModel fetchWalletInfomationWithToken:[self getToken]];
}
- (IBAction)backAction:(id)sender {
//    [self backBtnAction:sender];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)skipToSaleRecord:(id)sender {
    SaleRecordViewController *vc = [[SaleRecordViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
//充值余额
- (IBAction)rechargeMoney:(id)sender {
    RechargeViewController *vc = [[RechargeViewController alloc]init];
    vc.isWork = NO;
    [vc setReturnReloadBlock:^{
        [self.viewModel fetchWalletInfomationWithToken:[self getToken]];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
//充值工币
- (IBAction)rechargeWorkMoney:(id)sender {
    RechargeViewController *vc = [[RechargeViewController alloc]init];
    vc.isWork = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"walletCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"walletCell"];
    }
    cell.textLabel.text = self.tableArr[indexPath.section];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:self.imageArr[indexPath.section]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    return cell;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    view.frame = CGRectMake(0, 0, ScreenWidth, 10);
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:{
            WithdrawViewController *vc = [[WithdrawViewController alloc]init];
            [vc setReturnReloadBlock:^{
                [self.viewModel fetchWalletInfomationWithToken:[self getToken]];
            }];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:{
            WithdrawRecordViewController *vc = [[WithdrawRecordViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }

        case 2:{
            MyCardListViewController *vc = [[MyCardListViewController alloc]init];
            vc.isChoose = NO;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }

        default:
            break;
    }
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
