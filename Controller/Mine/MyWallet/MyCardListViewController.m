//
//  MyCardListViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyCardListViewController.h"
#import "CardListTableViewCell.h"
#import "AddBankCardViewController.h"
#import "BankCardDetailViewController.h"
#import "WalletModel.h"
#import "WalletViewModel.h"
@interface MyCardListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnAddCard;

@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isChoosed;
@property (nonatomic, retain) NSMutableArray *selectedArray;
@end

@implementation MyCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isChoose) {
        self.selectedArray = [[NSMutableArray alloc]init];
        self.btnAddCard.hidden = YES;
        if (self.selectIndex) {
            [self.selectedArray addObject:self.selectIndex];
        }
        
    }
    self.dataArray = [[NSMutableArray alloc]init];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"CardListTableViewCell" bundle:nil] forCellReuseIdentifier:@"CardListTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
    [self reloadView];
    
}

-(void)reloadView{
    WalletViewModel *viewModel = [[WalletViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:returnValue];
        [self.itemTableView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchMyBankListWithToken:[self getToken]];

}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
    if (self.selectedArray.count == 0) {
    }else{
        NSInteger index = [self.selectedArray[0] integerValue];
        self.returnBlock(self.dataArray[index],index);
    }
    
}
- (IBAction)addNewCard:(id)sender {
    AddBankCardViewController *vc = [[AddBankCardViewController alloc]init];
    [vc setReturnBlock:^{
        [self reloadView];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardListTableViewCell"];
    if (self.isChoose) {
        cell.btnCircle.hidden = NO;
        if ([self.selectedArray containsObject:@(indexPath.section)]) {
//            cell.btnCircle.hidden = NO;
            [cell.btnCircle setImage:[UIImage imageNamed:@"icon_circle_selected"] forState:UIControlStateNormal];
        }
        else{
            [cell.btnCircle setImage:[UIImage imageNamed:@"icon_circle_not_selected"] forState:UIControlStateNormal];
//            cell.btnCircle.hidden = YES;
        }
    }else{
        cell.btnCircle.hidden = YES;
    }
    [cell initCellWithData:self.dataArray[indexPath.section]];
    return cell;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    view.frame = CGRectMake(0, 0, ScreenWidth, 10);
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isChoose) {
        [self.selectedArray removeAllObjects];
        [self.selectedArray addObject:@(indexPath.section)];
        NSInteger index = [self.selectedArray[0] integerValue];
        self.returnBlock(self.dataArray[index],index);
        [self backBtnAction:nil];
        [self.itemTableView reloadData];
    }else{
        BankCardDetailViewController *vc = [[BankCardDetailViewController alloc]init];
        vc.bankModel = self.dataArray[indexPath.section];
        [vc setDeleteReturnBlock:^{
            [self reloadView];
        }];
        [self.navigationController pushViewController:vc animated:YES];
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
