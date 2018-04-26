//
//  AddSkillsViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "AddSkillsViewController.h"
#import "CreateOwnSkillViewController.h"
#import "RentViewModel.h"
#import "SkillModel.h"
@interface AddSkillsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *skillScrollView;
@property (weak, nonatomic) IBOutlet UIView *moneyView;
@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIView *systemView;
@property (weak, nonatomic) IBOutlet UITextView *moneyTextView;
@property (weak, nonatomic) IBOutlet UIButton *btnAddOwnSkills;
@property (weak, nonatomic) IBOutlet UIView *systemSkillView;

@property (nonatomic, retain) NSMutableArray *selectOwnerArray;//个性技能数组

@property (nonatomic, retain) NSMutableArray *selectFriendArray;//单身交友选中数组
@property (nonatomic, retain) NSMutableArray *selectSkillArray;//职业技能选中数组
@property (nonatomic, retain) NSMutableArray *dataFriendArray;//单身交友数据源数组
@property (nonatomic, retain) NSMutableArray *dataSkillArray;//职业技能数据源数组
@end

@implementation AddSkillsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectOwnerArray = [[NSMutableArray alloc]init];
    self.selectFriendArray = [[NSMutableArray alloc]init];
    self.selectSkillArray = [[NSMutableArray alloc]init];
    self.moneyTextView.layer.borderColor = [UIColor colorWithHexString:@"f0f0f0"].CGColor;
    self.moneyTextView.layer.borderWidth = 1;
    self.moneyTextView.layer.cornerRadius = 4.f;
    self.moneyTextView.layer.masksToBounds = YES;

    self.dataFriendArray = [[NSMutableArray alloc]init];
    self.dataSkillArray = [[NSMutableArray alloc]init];
    [self.btnAddOwnSkills setImagePositionWithType:SSImagePositionTypeLeft spacing:10.f];
    self.btnAddOwnSkills.layer.masksToBounds = YES;
    self.btnAddOwnSkills.layer.cornerRadius = 4.f;
    RentViewModel *viewModel = [[RentViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self.selectOwnerArray addObjectsFromArray:returnValue[0]];
        [self.dataSkillArray addObjectsFromArray:returnValue[2]];
        [self.dataFriendArray addObjectsFromArray:returnValue[1]];
        [self createOwnerView];
        
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchUserRentSkillWithToken:[self getToken]];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)crateSkill:(id)sender {
    [self.moneyTextView resignFirstResponder];
    CreateOwnSkillViewController *vc = [[CreateOwnSkillViewController alloc]init];
    [vc setReturnSkillBlock:^(NSMutableArray *skillArr) {
        [self.selectOwnerArray addObjectsFromArray:skillArr];
        [self createOwnerView];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)saveAction:(id)sender {
    if (self.moneyTextView.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入价格"];
        return;
    }
    if ([self.moneyTextView.text integerValue] <= 0) {
        [self showJGProgressWithMsg:@"请输入正确的价格"];
        return;
    }
    if (self.selectOwnerArray.count == 0 && self.selectFriendArray.count == 0 && self.selectSkillArray.count == 0) {
        [self showJGProgressWithMsg:@"请选择技能"];
        return;
    }
    NSMutableArray *returnArray = [[NSMutableArray alloc]init];
    NSMutableArray *muOwnArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.selectOwnerArray.count; i ++) {
        SkillModel *model = self.selectOwnerArray[i];
        model.name = model.skill;
        NSInteger price = [self.moneyTextView.text doubleValue];
        model.price = @(price);
        [muOwnArr addObject:model];
    }
    NSMutableArray *muFriendArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.selectFriendArray.count; i ++) {
        SkillModel *model = self.selectFriendArray[i];
        NSInteger price = [self.moneyTextView.text doubleValue];
        model.price = @(price);
        [muFriendArr addObject:model];
    }
    NSMutableArray *muJobArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.selectSkillArray.count; i ++) {
        SkillModel *model = self.selectSkillArray[i];
        NSInteger price = [self.moneyTextView.text doubleValue];
        model.price = @(price);
        [muJobArr addObject:model];
    }
    
    [returnArray addObject:muOwnArr];
    [returnArray addObject:muFriendArr];
    [returnArray addObject:muJobArr];
    self.returnBlock(returnArray);
    [self backBtnAction:nil];
    
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}

//创建个性技能view
-(void)createOwnerView{
    if (self.skillArray.count > 0) {
        NSArray *friendArray = self.skillArray[0];
        for (int i = 0; i < self.selectOwnerArray.count; i ++) {
            for (int j = 0; j < friendArray.count; j ++) {
                SkillModel *iModel = self.selectOwnerArray[i];
                SkillModel *jModel = friendArray[j];
                if ([iModel.skill isEqualToString: jModel.skill]) {
                    [self.selectOwnerArray removeObjectAtIndex:i];
                }
            }
        }
    }
    for (UIView *subview in self.customView.subviews) {
        if (subview.tag > 900) {
            [subview removeFromSuperview];
        }
    }
    CGRect rectView = self.customView.frame;
    rectView.size.height = (self.selectOwnerArray.count+2)/3*40+130;
    self.customView.frame = rectView;
    
    CGFloat w = (ScreenWidth-60)/3;
    for (int i = 0; i < self.selectOwnerArray.count; i ++) {
        SkillModel *model = self.selectOwnerArray[i];
        UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(10+i%3*(w+20), 120+i/3*40, w, 30)];
        backview.tag = 901 + i;
        backview.backgroundColor = [UIColor whiteColor];
        backview.layer.borderColor = [UIColor colorWithHexString:@"ef5f7d"].CGColor;
        backview.layer.borderWidth = 1;
        UILabel *skillLabel = [[UILabel alloc] init];
        skillLabel.text = model.skill;
        CGSize size = [skillLabel.text sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(300, 300)];
        skillLabel.frame = CGRectMake((w-size.width)/2 , 5, size.width, size.height );
        skillLabel.textColor = [UIColor colorWithHexString:@"333333"];
        skillLabel.font = [UIFont systemFontOfSize:13];
        [backview addSubview:skillLabel];
        
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setImageEdgeInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
        CGRect rect = backview.frame;
        delBtn.frame = CGRectMake(rect.origin.x+rect.size.width - 18, rect.origin.y - 18, 36, 36);
        delBtn.tag = 901 + i;
        [delBtn setImage:[UIImage imageNamed:@"icon_cancel1"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.customView addSubview:backview];
        [self.customView addSubview:delBtn];
    }
    [self crateSystemView];
   

}


-(void)deleteAction:(UIButton *)btn{
    [self.selectOwnerArray removeObjectAtIndex:btn.tag - 901];
        [self createOwnerView];

}

//创建单身交友view
-(void)crateSystemView{
    if (self.skillArray.count > 0 ) {
        NSArray *friendArray = self.skillArray[1];
        for (int i = 0; i < self.dataFriendArray.count; i ++) {
            for (int j = 0; j < friendArray.count; j ++) {
                SkillModel *iModel = self.dataFriendArray[i];
                SkillModel *jModel = friendArray[j];
                if ([iModel.Id integerValue] == [jModel.Id integerValue]) {
                    [self.dataFriendArray removeObjectAtIndex:i];
                }
            }
        }
    }
    
    CGRect rectOwn = self.customView.frame;
    CGRect rect = self.systemView.frame;
    rect.origin.y = rectOwn.origin.y+rectOwn.size.height + 10;
    rect.size.height = 40*((self.dataFriendArray.count+2)/3+1);
    self.systemView.frame = rect;
    for (int i = 0; i < self.dataFriendArray.count; i ++) {
        SkillModel *model = self.dataFriendArray[i];
        UIButton *button = [[UIButton alloc]init];
        CGFloat w = (ScreenWidth-60)/3;
        button.frame = CGRectMake(10+i%3*(w+20), 45+i/3*40, w, 30);
        [button.layer setBorderColor:[UIColor colorWithHexString:@"e6e6e6"].CGColor];
        [button.layer setBorderWidth:1];
        [button addTarget:self action:@selector(btnChooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:model.name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
        button.tag = 700+i;
        button.selected = NO;
        [self.systemView addSubview:button];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        CGRect rect = button.frame;
        imageView.frame = CGRectMake(rect.origin.x+rect.size.width-13, rect.origin.y+rect.size.height-10, 13, 10);
        imageView.image = [UIImage imageNamed:@"icon_selected_labels"];
        imageView.tag = 700+i;
        imageView.hidden = YES;
        [self.systemView addSubview:imageView];
    }
     [self creatSkillView];
}


-(void)btnChooseAction:(UIButton *)btn{
    
    for (UIImageView *imageView in self.systemView.subviews) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            if (imageView.tag == btn.tag) {
                imageView.hidden = btn.selected;
            }
        }
    }
    if (btn.selected == NO) {
        [btn.layer setBorderColor:[UIColor colorWithHexString:@"ef5f7d"].CGColor];
        [btn.layer setBorderWidth:1];
        btn.selected = YES;
        [self.selectFriendArray addObject:self.dataFriendArray[btn.tag-700]];
    }else{
        [btn.layer setBorderColor:[UIColor colorWithHexString:@"e6e6e6"].CGColor];
        [btn.layer setBorderWidth:1];
        btn.selected = NO;
        [self.selectFriendArray removeObject:self.dataFriendArray[btn.tag-700]];
    }
    NSLog(@"%@",self.selectFriendArray);
    
}
//创建职业技能view
-(void)creatSkillView{
    if (self.skillArray.count > 0) {
        NSArray *friendArray = self.skillArray[2];
        for (int i = 0; i < self.dataSkillArray.count; i ++) {
            for (int j = 0; j < friendArray.count; j ++) {
                SkillModel *iModel = self.dataSkillArray[i];
                SkillModel *jModel = friendArray[j];
                if ([iModel.Id integerValue] == [jModel.Id integerValue]) {
                    [self.dataSkillArray removeObjectAtIndex:i];
                }
            }
        }
    }
    
    for (int i = 0; i < self.dataSkillArray.count; i ++) {
        SkillModel *model = self.dataSkillArray[i];
        UIButton *button = [[UIButton alloc]init];
        CGFloat w = (ScreenWidth-60)/3;
        button.frame = CGRectMake(10+i%3*(w+20), 45+i/3*40, w, 30);
        [button.layer setBorderColor:[UIColor colorWithHexString:@"e6e6e6"].CGColor];
        [button.layer setBorderWidth:1];
        [button addTarget:self action:@selector(btnChooseSkillAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:model.name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
        button.tag = 800+i;
        button.selected = NO;
        [self.systemSkillView addSubview:button];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        CGRect rect = button.frame;
        imageView.frame = CGRectMake(rect.origin.x+rect.size.width-13, rect.origin.y+rect.size.height-10, 13, 10);
        imageView.image = [UIImage imageNamed:@"icon_selected_labels"];
        imageView.tag = 800+i;
        imageView.hidden = YES;
        [self.systemSkillView addSubview:imageView];
    }
    CGRect rectUp = self.systemView.frame;
    CGRect rectDown = self.systemSkillView.frame;
    rectDown.origin.y = rectUp.origin.y + rectUp.size.height + 10;
    rectDown.size.height = 40*((self.dataSkillArray.count+2)/3+1);
    self.systemSkillView.frame = rectDown;
    self.skillScrollView.contentSize = CGSizeMake(ScreenWidth, rectDown.origin.y + rectDown.size.height + 10);
}

-(void)btnChooseSkillAction:(UIButton *)btn{
    for (UIImageView *imageView in self.systemSkillView.subviews) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
                if (imageView.tag == btn.tag) {
                    imageView.hidden = btn.selected;
                }
        }
    }
    if (btn.selected == NO) {
        [btn.layer setBorderColor:[UIColor colorWithHexString:@"ef5f7d"].CGColor];
        [btn.layer setBorderWidth:1];
        btn.selected = YES;
        NSLog(@"%@",btn.titleLabel.text);
        [self.selectSkillArray addObject:self.dataSkillArray[btn.tag-800]];
    }else{
        [btn.layer setBorderColor:[UIColor colorWithHexString:@"e6e6e6"].CGColor];
        [btn.layer setBorderWidth:1];
        btn.selected = NO;
        [self.selectSkillArray removeObject:self.dataSkillArray[btn.tag-800]];
    }
    NSLog(@"%@",self.selectSkillArray);

}


@end
