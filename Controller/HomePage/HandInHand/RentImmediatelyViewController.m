//
//  RentImmediatelyViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/31.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RentImmediatelyViewController.h"
#import "RentHeaderView.h"
#import "RentPersonItemTableViewCell.h"
#import "RentPersonInfoSectionHeadView.h"
#import "RentOrderViewController.h"
#import "RentPersonViewModel.h"
@interface RentImmediatelyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnNextStep;
@property (nonatomic, retain) RentHeaderView *headView;
@property (nonatomic, retain) NSMutableArray *selectedArray;
@property (nonatomic, retain) NSMutableArray *dataArray;
@end

@implementation RentImmediatelyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc] init];
    self.selectedArray = [[NSMutableArray alloc]init];
    self.headView = [[[NSBundle mainBundle]loadNibNamed:@"RentHeaderView" owner:self options:nil]firstObject];
    [self.headView initViewWith:self.personModel];
    self.itemTableView.tableHeaderView = self.headView;
    [self.itemTableView registerNib:[UINib nibWithNibName:@"RentPersonItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"RentPersonItemTableViewCell"];
    if ([self.itemTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.itemTableView setSeparatorInset:UIEdgeInsetsMake(44, 10, 0, 10)];
    }
    
    RentPersonViewModel *viewModel = [[RentPersonViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self.dataArray addObjectsFromArray:returnValue];
        [self.itemTableView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchRentPersonSkillPriceWithId:self.personModel.uid token:[self getToken]];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)skipToNextStep:(id)sender {
    if (self.selectedArray.count == 0) {
        [self showJGProgressWithMsg:@"请选择服务项目"];
        return;
    }
    RentOrderViewController *vc = [[RentOrderViewController alloc]init];
    vc.personModel = self.personModel;
    vc.skillArray = self.dataArray;
    
    if (self.selectedArray.count != 0) {
        NSInteger index = [self.selectedArray[0] integerValue];
        vc.selectModel = self.dataArray[index];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RentPersonItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RentPersonItemTableViewCell"];
    BOOL isSelect = NO;
    if ([self.selectedArray containsObject:@(indexPath.row)]) {
        isSelect = YES;
    }
    [cell initCellWithData:isSelect model:self.dataArray[indexPath.row]];
    return cell;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 54;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, ScreenWidth, 54);
    view.backgroundColor = [UIColor whiteColor];
    UIView *grayView = [[UIView alloc]init];
    grayView.frame = CGRectMake(0, 0, ScreenWidth, 20);
    grayView.backgroundColor = [UIColor colorWithHexString:@"e9e9e9"];
    UIImageView *headImageView = [[UIImageView alloc]init];
    headImageView.image = [UIImage imageNamed:@"icon_service_items"];
    headImageView.frame = CGRectMake(10, 29,15, 15);
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(35, 20, 60, 34);
    label.text = @"服务项目";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"333333"];
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.frame = CGRectMake(0, 53, ScreenWidth, 1);
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"e9e9e9"];
    [view addSubview:lineLabel];
    [view addSubview:grayView];
    [view addSubview:headImageView];
    [view addSubview:label];

    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSNumber *selectId = @(indexPath.row);
    if ([self.selectedArray containsObject:selectId]) {
        [self.selectedArray removeObject:selectId];
    }else{
        [self.selectedArray removeAllObjects];
        [self.selectedArray addObject:selectId];
    }
    NSLog(@"%@",self.selectedArray);
    [self.itemTableView reloadData];
}


@end
