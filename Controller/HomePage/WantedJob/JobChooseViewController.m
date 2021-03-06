//
//  JobChooseViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/29.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "JobChooseViewController.h"
#import "JobChooseTableViewCell.h"
@interface JobChooseViewController ()
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, retain) NSArray *eduArr;
@property (nonatomic, retain) NSArray *nationArr;
@property (nonatomic, retain) NSArray *sexArr;
@property (nonatomic, retain) NSMutableArray *selectArr;

@end

@implementation JobChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"JobChooseTableViewCell" bundle:nil] forCellReuseIdentifier:@"JobChooseTableViewCell"];
//    [self.itemTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.eduArr = @[@"中专以下",@"高中",@"大专",@"本科",@"硕士"];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    self.nationArr =
  @[@{@"name":@"汉族",@"id":@"1"},@{@"name":@"蒙古族",@"id":@"2"},@{@"name":@"回族",@"id":@"3"},@{@"name":@"藏族",@"id":@"4"},@{@"name":@"维吾尔族",@"id":@"5"},@{@"name":@"苗族",@"id":@"6"},@{@"name":@"彝族",@"id":@"7"},@{@"name":@"壮族",@"id":@"8"},@{@"name":@"布依族",@"id":@"9"},@{@"name":@"朝鲜族",@"id":@"10"},@{@"name":@"满族",@"id":@"11"},@{@"name":@"侗族",@"id":@"12"},@{@"name":@"瑶族",@"id":@"13"},@{@"name":@"白族",@"id":@"14"},@{@"name":@"土家族",@"id":@"15"},@{@"name":@"哈尼族",@"id":@"16"},@{@"name":@"哈萨克族",@"id":@"17"},@{@"name":@"傣族",@"id":@"18"},@{@"name":@"黎族",@"id":@"19"},@{@"name":@"僳僳族",@"id":@"20"},@{@"name":@"佤族",@"id":@"21"},@{@"name":@"畲族",@"id":@"22"},@{@"name":@"高山族",@"id":@"23"},@{@"name":@"拉祜族",@"id":@"24"},@{@"name":@"水族",@"id":@"25"},@{@"name":@"东乡族",@"id":@"26"},@{@"name":@"纳西族",@"id":@"27"},@{@"name":@"景颇族",@"id":@"28"},@{@"name":@"柯尔克孜族",@"id":@"29"},@{@"name":@"土族",@"id":@"30"},@{@"name":@"达斡尔族",@"id":@"31"},@{@"name":@"仫佬族",@"id":@"32"},@{@"name":@"羌族",@"id":@"33"},@{@"name":@"布朗族",@"id":@"34"},@{@"name":@"撒拉族",@"id":@"35"},@{@"name":@"毛南族",@"id":@"36"},@{@"name":@"仡佬族",@"id":@"37"},@{@"name":@"锡伯族",@"id":@"38"},@{@"name":@"阿昌族",@"id":@"39"},@{@"name":@"普米族",@"id":@"40"},@{@"name":@"塔吉克族",@"id":@"41"},@{@"name":@"怒族",@"id":@"42"},@{@"name":@"乌孜别克族",@"id":@"43"},@{@"name":@"俄罗斯族",@"id":@"44"},@{@"name":@"鄂温克族",@"id":@"45"},@{@"name":@"德昂族",@"id":@"46"},@{@"name":@"保安族",@"id":@"47"},@{@"name":@"裕固族",@"id":@"48"},@{@"name":@"京族",@"id":@"49"},@{@"name":@"塔塔尔族",@"id":@"50"},@{@"name":@"独龙族",@"id":@"51"},@{@"name":@"鄂伦春族",@"id":@"52"},@{@"name":@"赫哲族",@"id":@"53"},@{@"name":@"门巴族",@"id":@"54"},@{@"name":@"珞巴族",@"id":@"55"},@{@"name":@"基诺族",@"id":@"56"}];
    for (int i = 0; i < 56;  i ++) {
        NSString *str = self.nationArr[i][@"name"];
        [array addObject:str];
    }
    self.sexArr = @[@"男",@"女"];
    if (self.currentSelectType == 0) {
        self.selectArr = [[NSMutableArray alloc]initWithArray:self.eduArr];
        self.titleLabel.text = @"学历选择";
    }else if (self.currentSelectType == 1){
        self.selectArr = [[NSMutableArray alloc]initWithArray:self.sexArr];
        self.titleLabel.text = @"性别选择";
    }else{
        self.selectArr = [[NSMutableArray alloc]initWithArray:array];
        self.titleLabel.text = @"民族选择";
    }
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.selectArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    JobChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobChooseTableViewCell"];
    for (UIView *subview in cell.subviews) {
        if (subview.tag >= 999 ) {
            [subview removeFromSuperview];
        }
    }
    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    itemBtn.enabled = NO;
    itemBtn.frame = CGRectMake(15, 0, 200, 44);
    itemBtn.tag = 999 + indexPath.row;
    itemBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [itemBtn setTitle:self.selectArr[indexPath.row] forState:UIControlStateNormal];
    itemBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [itemBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [cell addSubview:itemBtn];
    
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectedBtn.enabled = NO;
    selectedBtn.tag = 999 + indexPath.row;
    selectedBtn.frame = CGRectMake(ScreenWidth - 15 - 44, 0, 44, 44);
    selectedBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [selectedBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    if (indexPath.row == self.currentSelectIndex) {
        [itemBtn setTitleColor:[UIColor colorWithHexString:@"6398f1"] forState:UIControlStateNormal];
        [cell addSubview:selectedBtn];
        [selectedBtn setImage:[UIImage imageNamed:@"icon_tick"] forState:UIControlStateNormal];
        
    }
    else{
        [itemBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [selectedBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
    }
    
    
    return cell;

}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.currentSelectIndex = indexPath.row;
    [self.itemTableView reloadData];
    self.returnText(self.selectArr[indexPath.row],indexPath.row);
    [self backBtnAction:nil];

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
