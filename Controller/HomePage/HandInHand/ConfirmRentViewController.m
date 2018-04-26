//
//  ConfirmRentViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ConfirmRentViewController.h"
#import "RentContentTableViewCell.h"
#import "RentInputViewTableViewCell.h"
#import "RentHeaderView.h"
#import "RentPayViewController.h"
#import "RentPersonViewModel.h"
@interface ConfirmRentViewController ()
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (nonatomic, retain) RentHeaderView *headView;
@property (nonatomic, retain) NSNumber *price;
@end

@implementation ConfirmRentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headView = [[[NSBundle mainBundle]loadNibNamed:@"RentHeaderView" owner:self options:nil]firstObject];
    [self.headView initViewWith:self.personModel];
    self.itemTableView.tableHeaderView = self.headView;
    NSInteger time = [self.rentDic[@"rent_long"] integerValue];
    self.price = self.rentDic[@"price"];
    NSInteger allPrice = time * [self.price integerValue];
    self.labelPrice.text = [NSString stringWithFormat:@"(%ld元,%ld小时)",(long)allPrice,(long)time];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"RentContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"RentContentTableViewCell"];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"RentInputViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"RentInputViewTableViewCell"];
    if ([self.itemTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.itemTableView setSeparatorInset:UIEdgeInsetsMake(44, 15, 0, 15)];
        
    }
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)confirmOrder:(id)sender {
    RentPayViewController *vc = [[RentPayViewController alloc]init];
    vc.rentId = self.rentId;
    NSInteger time = [self.rentDic[@"rent_long"] integerValue];
    self.price = self.rentDic[@"price"];
    NSInteger allPrice = time * [self.price integerValue];
    vc.price = [NSString stringWithFormat:@"%ld",(long)allPrice];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        RentInputViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RentInputViewTableViewCell"];
        [cell initCellWithData:self.rentDic[@"msg"]];
        cell.messageTextView.editable = NO;
        return cell;
    }
    RentContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RentContentTableViewCell"];
    [cell initCellWithData:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.labelTitle.text = @"预约内容";
            cell.labelContent.text = [NSString stringWithFormat:@"%@",self.rentDic[@"item"]];
        }
        if (indexPath.row == 1) {
            cell.labelTitle.text = @"约见时间";
            cell.labelContent.text = [NSString stringWithFormat:@"%@",self.rentDic[@"start_time"]];
        }
        if (indexPath.row == 2) {
            cell.labelTitle.text = @"约见时长";
            cell.labelContent.text = [NSString stringWithFormat:@"%@",self.rentDic[@"rent_long"]];
        }
    }
    if (indexPath.section == 1) {
        cell.labelTitle.text = @"约见地址";
        cell.labelContent.text =[NSString stringWithFormat:@"%@",self.rentDic[@"meet_address"]];
    }
    if (indexPath.section == 2) {
        cell.labelTitle.text = @"联系人";
        cell.labelContent.text = [NSString stringWithFormat:@"%@",self.rentDic[@"lnk_user"]];
    }
    if (indexPath.section == 3) {
        cell.labelTitle.text = @"联系电话";
        cell.labelContent.text = [NSString stringWithFormat:@"%@",self.rentDic[@"lnk_mobile"]];
    }
    return cell;

}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4){
        return 104;
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
