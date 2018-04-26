//
//  RentRangeViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RentRangeViewController.h"
#import "AddSkillsViewController.h"
#import "RentSelfSuccessViewController.h"

#import "RentRangeTableViewCell.h"

#import "RentViewModel.h"
#import "SkillModel.h"
@interface RentRangeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (nonatomic, retain) NSMutableArray *muArray1st;//个性技能
@property (nonatomic, retain) NSMutableArray *muArray2rd;//单身交友
@property (nonatomic, retain) NSMutableArray *muArray3th;//职业技能
@property (nonatomic, retain) NSMutableArray *skillNewArray1st;
@property (nonatomic, retain) NSMutableArray *skillNewArray2rd;
@property (nonatomic, retain) NSMutableArray *skillNewArray3th;
@property (nonatomic, retain) NSMutableArray *skillNewArray;
@property (nonatomic, assign) BOOL isNetData;
@end

@implementation RentRangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNetData = YES;
    self.skillNewArray1st = [[NSMutableArray alloc] init];
    self.skillNewArray2rd = [[NSMutableArray alloc] init];
    self.skillNewArray3th = [[NSMutableArray alloc] init];
    self.skillNewArray = [[NSMutableArray alloc] init];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"RentRangeTableViewCell" bundle:nil] forCellReuseIdentifier:@"RentRangeTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    RentViewModel  *viewModel = [[RentViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        self.muArray1st = [[NSMutableArray alloc]initWithArray:returnValue[0]];
        self.muArray2rd = [[NSMutableArray alloc]initWithArray:returnValue[1]];
        self.muArray3th = [[NSMutableArray alloc]initWithArray:returnValue[2]];
        [self.itemTableView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchOwnRentRangeWithToken:[self getToken]];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)skipToNext:(id)sender {
    NSNumber *price = [[NSNumber alloc] init];
    NSMutableArray *muOwnName = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.muArray1st.count; i ++) {
        SkillModel *model = self.muArray1st[i];
        model.name = model.skill;
        price = model.price;
        NSDictionary *skillDic = @{@"skill":model.name,
                                   @"price":model.price};
        [muOwnName addObject:skillDic];
        
    }
    
    NSMutableArray *muFriendId = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.muArray2rd.count; i ++) {
        SkillModel *model = self.muArray2rd[i];
        price = model.price;
        NSDictionary *skillDic = @{@"skill_id":model.Id ? model.Id : model.skill_id,
                                   @"price":model.price};
        [muFriendId addObject:skillDic];
    }
    
    NSMutableArray *muSkillId = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.muArray3th.count; i ++) {
        SkillModel *model = self.muArray3th[i];
        price = model.price;
        NSDictionary *skillDic = @{@"skill_id":model.Id ? model.Id : model.skill_id,
                                   @"price":model.price};
        [muSkillId addObject:skillDic];
    }
    if (muOwnName.count == 0 && muSkillId.count == 0 && muFriendId.count == 0) {
        [self showJGProgressWithMsg:@"请选择出租技能"];
        return;
    }
    RentViewModel *viewModel = [[RentViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        if (self.backType == 0) {
            NSString *str = returnValue[@"msg"];
            [self showJGProgressWithMsg:str];
            [self backAction:nil];
        }else{
            RentSelfSuccessViewController *vc = [[RentSelfSuccessViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel submitRentRangeWithToken:[self getToken] skill:muOwnName jobSkill:muSkillId friendSkill:muFriendId];
    
    
}
- (IBAction)addRentRange:(id)sender {
    AddSkillsViewController *vc = [[AddSkillsViewController alloc]init];
    [vc setReturnBlock:^(NSMutableArray *array) {
        self.isNetData = NO;
        [self.skillNewArray1st addObjectsFromArray:array[0]];
        [self.skillNewArray2rd addObjectsFromArray:array[1]];
        [self.skillNewArray3th addObjectsFromArray:array[2]];
        [self.skillNewArray addObject:self.skillNewArray1st];
        [self.skillNewArray addObject:self.skillNewArray2rd];
        [self.skillNewArray addObject:self.skillNewArray3th];
//        [self.muArray1st removeAllObjects];
//        [self.muArray2rd removeAllObjects];
//        [self.muArray3th removeAllObjects];
        NSLog(@"%@",self.skillNewArray);
        [self.muArray1st addObjectsFromArray:array[0]];
        [self.muArray2rd addObjectsFromArray:array[1]];
        [self.muArray3th addObjectsFromArray:array[2]];
        [self.itemTableView reloadData];
    }];
    vc.skillArray = self.skillNewArray;
    [self.navigationController pushViewController:vc animated:YES];

    
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        RentRangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RentRangeTableViewCell"];
        [cell setReturnDelTag:^(NSInteger tag) {
            [self.muArray1st removeObjectAtIndex:tag];
            [tableView reloadData];
        }];
        cell.labelTitle.text = @"个性技能";
        if (self.isNetData == YES) {
            [cell initCellWithData:self.muArray1st index:indexPath.section];
        }else{
            [cell initCellWithData:self.muArray1st];
        }
        
        return cell;

    }else if (indexPath.section == 1){
        RentRangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RentRangeTableViewCell"];
        [cell setReturnDelTag:^(NSInteger tag) {
            [self.muArray2rd removeObjectAtIndex:tag];
            [tableView reloadData];

        }];
        cell.labelTitle.text = @"单身交友";
        if (self.isNetData == YES) {
            [cell initCellWithData:self.muArray2rd index:indexPath.section];
        }else{
            [cell initCellWithData:self.muArray2rd];
        }
        return cell;

    }
    RentRangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RentRangeTableViewCell"];
        [cell setReturnDelTag:^(NSInteger tag) {
        [self.muArray3th removeObjectAtIndex:tag];
            [tableView reloadData];

    }];
    cell.labelTitle.text = @"职业技能";
    if (self.isNetData == YES) {
        [cell initCellWithData:self.muArray3th index:indexPath.section];
    }else{
        [cell initCellWithData:self.muArray3th];
    }
    return cell;
}
#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [RentRangeTableViewCell getCellHeightWithData:self.muArray1st];

    }else if (indexPath.section == 1){
        return [RentRangeTableViewCell getCellHeightWithData:self.muArray2rd];

    }
    return [RentRangeTableViewCell getCellHeightWithData:self.muArray3th];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
}

@end
