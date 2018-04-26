//
//  RentOrderViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/11.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RentOrderViewController.h"
#import "ConfirmRentViewController.h"
#import "HandInHandMapViewController.h"
#import "SingleChooseListView.h"
#import "RentPersonViewModel.h"
#import "WSDatePickerView.h"
#import "ChooseItemView.h"
#import "RentMapModel.h"

@interface RentOrderViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UILabel *trustLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnChooseItem;
@property (weak, nonatomic) IBOutlet UIButton *btnChooseTIme;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;
@property (weak, nonatomic) IBOutlet UIButton *btnMinus;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
@property (weak, nonatomic) IBOutlet UITextView *txtMessage;
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, assign) NSNumber *price;
@property (nonatomic, copy) NSString *skillId;
@property (nonatomic, retain) RentMapModel *mapModel;
@end

@implementation RentOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainScrollView.contentSize = CGSizeMake(ScreenWidth, 654);
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textShouldResignFirstResponder)];
    [self.mainScrollView addGestureRecognizer:tapGR];
    self.mapModel = [[RentMapModel alloc] init];
    self.orderTimeLabel.text = @"约见时长（单位：小时）";
    NSString *str = self.orderTimeLabel.text;
    NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc]initWithString:str];
    //    NSRange redRangeTwo = ;
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"999999"] range:NSMakeRange(4, 7)];
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(4, 7)];
    [self.orderTimeLabel setAttributedText:noteStr];
    [self.orderTimeLabel sizeToFit];
    self.btnMinus.layer.masksToBounds = YES;
    self.btnMinus.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    self.btnMinus.layer.cornerRadius = 5.f;
    self.btnMinus.layer.borderWidth = 1.f;
    self.btnAdd.layer.masksToBounds = YES;
    self.btnAdd.layer.cornerRadius = 5.f;
    [self.btnChooseItem setImage:[UIImage imageNamed:@"icon_more-"] forState:UIControlStateNormal];
    [self.btnChooseTIme setImage:[UIImage imageNamed:@"icon_more-"] forState:UIControlStateNormal];
    [self.btnChooseTIme setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.btnChooseItem setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.headImage setImageWithString:self.personModel.headimg placeHoldImageName:@"bg_no_pictures"];
//    [self.headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,self.personModel.headimg]] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
    self.nameLabel.text = self.personModel.nickname;
    CGSize size = [self.nameLabel.text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(200, 100)];
    CGRect rectName = self.nameLabel.frame;
    rectName.size.width = size.width;
    self.nameLabel.frame = rectName;
    CGRect rectSex = self.sexImage.frame;
    rectSex.origin.x = rectName.origin.x + rectName.size.width + 10;
    self.sexImage.frame = rectSex;
    if ([self.personModel.sex integerValue] == 0) {
        [self.sexImage setImage:[UIImage imageNamed:@"icon_gules_female_sex"]];
    }else if([self.personModel.sex integerValue] == 1){
        [self.sexImage setImage:[UIImage imageNamed:@"icon_gules_male_sex"]];
    }else{
        [self.sexImage setImage:[UIImage imageNamed:@""]];
    }
    
    self.nameStr = self.selectModel.name;
    self.price = self.selectModel.price;
    self.skillId = [NSString stringWithFormat:@"%@",self.selectModel.skill_id];
    if (self.skillId) {
        [self.btnChooseItem setTitle:[NSString stringWithFormat:@"%@  %@元/小时",self.selectModel.name,self.selectModel.price] forState:UIControlStateNormal];
    }else{
        [self.btnChooseItem setTitle:@"请选择服务项目" forState:UIControlStateNormal];
    }
    
    [self.btnChooseTIme setTitle:@"请选择开始时间" forState:UIControlStateNormal];
    [self.btnChooseItem setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.btnChooseTIme setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    self.trustLabel.text = [NSString stringWithFormat:@"信任值：%@",self.personModel.trust];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 32.5f;
    self.trustLabel.layer.masksToBounds = YES;
    self.trustLabel.layer.cornerRadius = 9.5f;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)chooseItemAction:(id)sender {
    [self textShouldResignFirstResponder];
//    SingleChooseListView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"SingleChooseListView" owner:self options:nil] firstObject];
//    chooseView.tag = 999;
//    chooseView.frame = CGRectMake(0, 200, ScreenWidth, 300);
//
//    [chooseView initView:self.skillArray];
//    [chooseView setReturnBlock:^(NSInteger index,NSArray *itemArr){
//
//    }];
//    [chooseView setRemoveBlock:^{
//    }];
//    [self.view addSubview:chooseView];
    ChooseItemView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"ChooseItemView" owner:self options:nil] firstObject];
    chooseView.tag = 999;
//    chooseView.currentSelectIndex = self.selectSkillIndex;
    chooseView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [chooseView initView:self.skillArray];
//    [chooseView initViewWithArray:self.skillArray];
    [chooseView setReturnBlock:^(SkillModel *model){
        [self.btnChooseItem setTitle:[NSString stringWithFormat:@"%@  %@元/小时",model.name,model.price] forState:UIControlStateNormal];
        [self.btnChooseItem setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        self.nameStr = model.name;
        self.price = model.price;
        self.skillId = [NSString stringWithFormat:@"%@",model.skill_id];
    }];
    
    [chooseView setRemoveBlock:^{
        
    }];
    [self.view addSubview:chooseView];
    
}
- (IBAction)chooseTimeAction:(id)sender {
    [self textShouldResignFirstResponder];
    NSString *str = [NSString stringWithFormat:@"%@",[self getNowDateFromatAnDate:[NSDate date]]];
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute dateStr:str CompleteBlock:^(NSDate *startDate)  {
        NSString *date = [startDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
        [self.btnChooseTIme setTitle:date forState:UIControlStateNormal];
        [self.btnChooseTIme setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        
        self.timeStr = date;
//        [self.infoDic setObject:self.timeStr forKey:@"start_time"];
//        [self.itemTableView reloadData];
    }];
    //            datepicker.minLimitDate = [self getNowDateFromatAnDate:[NSDate date]];
    datepicker.doneButtonColor = [UIColor colorWithHexString:@"6398f1"];//确定按钮的颜色
    [datepicker setMinLimitDate:[NSDate date]];
    [datepicker show];
}
- (IBAction)addTimeAction:(id)sender {
    [self textShouldResignFirstResponder];
    NSInteger count = [self.labelTime.text integerValue];
    if (count == 99) {
        return;
    }
    count += 1;
    self.labelTime.text = [NSString stringWithFormat:@"%ld",(long)count];
    [self.txtName resignFirstResponder];
}
- (IBAction)minusTimeAction:(id)sender {
    [self textShouldResignFirstResponder];
    NSInteger count = [self.labelTime.text integerValue];
    if (count < 1) {
        return;
    }
    count -= 1;
    self.labelTime.text = [NSString stringWithFormat:@"%ld",(long)count];
}
- (IBAction)chooseMeetAddress:(id)sender {
    [self textShouldResignFirstResponder];
    HandInHandMapViewController *vc = [[HandInHandMapViewController alloc] init];
    [vc setReturnMapModel:^(RentMapModel *model) {
        self.mapModel = model;
        self.addressLabel.text = model.address;
    }];
    [self.navigationController pushViewController: vc
                                         animated:YES];
}


- (IBAction)submitAction:(id)sender {
    
    if (self.timeStr.length == 0) {
        [self showJGProgressWithMsg:@"请选择约见时间"];
        return;
    }
    if (self.self.mapModel.address.length == 0) {
        [self showJGProgressWithMsg:@"请选择约见地址"];
        return;
    }
    if (self.txtName.text.length == 0) {
        [self showJGProgressWithMsg:@"联系人姓名不能为空"];
        return;
    }
    if ( ![CustomTool isValidtePhone:self.txtMobile.text]) {
        [self showJGProgressWithMsg:@"请输入正确的电话号码"];
        return;
    }
    NSDictionary *rentDic = @{
                              @"rent_uid":self.personModel.uid,
                              @"start_time":self.timeStr,
                              @"rent_long":self.labelTime.text,
                              @"meet_address":self.mapModel.address,
                              @"item":self.nameStr,
                              @"price":self.price,
                              @"skill_id":self.skillId,
                              @"lnk_user":self.txtName.text,
                              @"msg":self.txtMessage.text,
                              @"lnk_mobile":self.txtMobile.text
                              };
    
    
    RentPersonViewModel *viewModel = [[RentPersonViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        ConfirmRentViewController *vc = [[ConfirmRentViewController alloc]init];
        vc.rentDic = rentDic;
        vc.rentId = returnValue[@"rent_id"];
        vc.personModel = self.personModel;
        [self.navigationController pushViewController:vc animated:YES];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    
    [viewModel rentPersonWithToken:[self getToken] rent_uid:self.personModel.uid start_time:self.timeStr rent_long:self.labelTime.text meet_address:self.mapModel.address item:self.skillId lnk_user:self.txtName.text lnk_mobile:self.txtMobile.text msg:self.txtMessage.text longitude:self.mapModel.longitude latitude:self.mapModel.latitude];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textShouldResignFirstResponder{
    [self.txtName resignFirstResponder];
    [self.txtMobile resignFirstResponder];
    [self.txtMessage resignFirstResponder];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self textShouldResignFirstResponder];
}


@end
