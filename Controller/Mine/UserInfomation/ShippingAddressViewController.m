//
//  ShippingAddressViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/24.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ShippingAddressViewController.h"
#import "AddAddressViewController.h"

#import "ShippingAddressTableViewCell.h"

#import "AddressViewModel.h"

@interface ShippingAddressViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (nonatomic, assign) NSInteger defaultSection;
@property (weak, nonatomic) IBOutlet UIButton *btnAddAddress;
@property (weak, nonatomic) IBOutlet UIView *noDataView;

@property (nonatomic, retain) NSMutableArray *itemArr;
@end

@implementation ShippingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaultSection = 0;
    self.itemArr = [[NSMutableArray alloc]init];
    [self.btnAddAddress setImagePositionWithType:SSImagePositionTypeLeft spacing:5.f];
    
    [self.itemTableView registerNib:[UINib nibWithNibName:@"ShippingAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShippingAddressTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self reloadView];
    // Do any additional setup after loading the view from its nib.
}

-(void)reloadView{
    AddressViewModel *viewModel = [[AddressViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self.itemArr removeAllObjects];
        [self.itemArr addObjectsFromArray:returnValue];
        if (self.itemArr.count) {
            self.itemTableView.hidden = NO;
            self.noDataView.hidden = YES;
        }
        else{
            self.itemTableView.hidden = YES;
            self.noDataView.hidden = NO;
        }
        [self.itemTableView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchMyOrderAddressListWithToken:[self getToken]];
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)addAddress:(id)sender {
    AddAddressViewController *vc = [[AddAddressViewController alloc]init];
    [vc setReturnLoadBlock:^{
        [self reloadView];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.itemArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShippingAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShippingAddressTableViewCell"];
        [cell initCellWithData:self.itemArr[indexPath.section]];
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 38.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]init];
    footerView.frame = CGRectMake(0, 0, ScreenWidth, 38);
    footerView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    //选中
    UIButton *btnSelected = [[UIButton alloc]init];
    [btnSelected setImage:[UIImage imageNamed:@"icon_circle_not_selected"] forState:UIControlStateNormal];
    AddressModel *model = self.itemArr[section];
    if ([model.is_def integerValue] == 1) {
        [btnSelected setImage:[UIImage imageNamed:@"icon_circle_selected1"] forState:UIControlStateNormal];
    }
    btnSelected.frame = CGRectMake(10, 0, 60, 30);
    btnSelected.tag = 200+section;
    btnSelected.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnSelected addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //编辑
    UIButton *btnEditing = [[UIButton alloc]init];
    [btnEditing setImage:[UIImage imageNamed:@"compile"] forState:UIControlStateNormal];
    [btnEditing setTitle:@"编辑" forState:UIControlStateNormal];
    [btnEditing setImagePositionWithType:SSImagePositionTypeLeft spacing:10.f];
    [btnEditing.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btnEditing setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    btnEditing.tag = 300+section;
    btnEditing.frame = CGRectMake(ScreenWidth-10-60-20-60, 10, 60, 18);
    [btnEditing addTarget:self action:@selector(editingAction:) forControlEvents:UIControlEventTouchUpInside];
    //删除
    UIButton *btnCancel = [[UIButton alloc]init];
    [btnCancel setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [btnCancel setTitle:@"删除" forState:UIControlStateNormal];
    btnCancel.tag = 400+section;
    btnCancel.frame = CGRectMake(ScreenWidth-10-60, 10, 60, 18);
    [btnCancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel setImagePositionWithType:SSImagePositionTypeLeft spacing:10.f];
    [btnCancel.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btnCancel setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [footerView addSubview:btnSelected];
    [footerView addSubview:btnEditing];
    [footerView addSubview:btnCancel];
    return footerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, 10);
    headerView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    return headerView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isChooseOrChange == 0) {
        AddressModel *addModel = self.itemArr[indexPath.section];
        self.returnAddressBlcok(addModel);
        [self backAction:nil];
    }else{
        AddAddressViewController *vc = [[AddAddressViewController alloc]init];
        vc.addressModel = self.itemArr[indexPath.section];
        [vc setReturnLoadBlock:^{
            [self reloadView];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    

    //    WithdrawDetailViewController *vc = [[WithdrawDetailViewController alloc]init];
    //    [self.navigationController pushViewController:vc animated:YES];
}

-(void)selectedAction:(UIButton *)button{

    self.defaultSection = button.tag-200;
    
//    if (self.isChooseOrChange == 0) {
//        AddressModel *addModel = self.itemArr[self.defaultSection];
//        self.returnAddressBlcok(addModel);
//        [self backAction:nil];
//    }else{
        for (int i = 0; i < self.itemArr.count; i ++) {
            AddressModel *addModel = self.itemArr[i];
            addModel.is_def = @(0);
            if (i == self.defaultSection) {
                AddressModel *model = self.itemArr[self.defaultSection];
                
                AddressViewModel *viewModel = [[AddressViewModel alloc]init];
                [viewModel setBlockWithReturnBlock:^(id returnValue) {
                    model.is_def = @(1);
                    [self.itemTableView reloadData];
                    [self dissJGProgressLoadingWithTag:2000];
                } WithErrorBlock:^(id errorCode) {
                    [self showJGProgressWithMsg:errorCode];
                    [self dissJGProgressLoadingWithTag:2000];
                }];
                [viewModel setDetaultAddressWithToken:[self getToken] Id:model.Id];
                [self showJGProgressLoadingWithTag:2000];
            }
//        }
    }
}

-(void)editingAction:(UIButton *)btn{
    AddAddressViewController *vc = [[AddAddressViewController alloc]init];
    vc.addressModel = self.itemArr[btn.tag-300];
    [vc setReturnLoadBlock:^{
        [self reloadView];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)cancelAction:(UIButton *)btn{
    AddressModel *model = self.itemArr[btn.tag-400];
    AddressViewModel *viewModel = [[AddressViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self reloadView];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel deleteAddressWithToken:[self getToken] Id:model.Id];
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
