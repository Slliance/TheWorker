//
//  MyTagsViewController.m
//  TheWorker
//
//  Created by yanghao on 9/2/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "MyTagsViewController.h"
#import "CreateMyOwnTagsViewController.h"
#import "SkillModel.h"
#import "MyRentViewModel.h"
@interface MyTagsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnCreateSkill;
@property (weak, nonatomic) IBOutlet UIView *ownSkillView;
@property (weak, nonatomic) IBOutlet UIView *commonSkillView;
@property (nonatomic, retain) NSMutableArray *selectOwnerArray;
@property (nonatomic, retain) NSMutableArray *commonDataArray;
@property (nonatomic, retain) NSMutableArray *selectCommonArray;
@property (nonatomic, retain) NSMutableArray *allTagsArray;
@end

@implementation MyTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectOwnerArray = [[NSMutableArray alloc] init];
    self.commonDataArray = [[NSMutableArray alloc] init];
    self.selectCommonArray = [[NSMutableArray alloc] init];
    self.allTagsArray = [[NSMutableArray alloc] init];
    self.btnCreateSkill.layer.masksToBounds = YES;
    self.btnCreateSkill.layer.cornerRadius = 4.f;
    MyRentViewModel *viewModel = [[MyRentViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self.selectOwnerArray addObjectsFromArray:returnValue[0]];
        [self.commonDataArray addObjectsFromArray:returnValue[1]];
        [self.selectCommonArray addObjectsFromArray:returnValue[2]];
//        NSMutableArray *array = [[NSMutableArray alloc] init];
//        for (SkillModel *model in self.allTagsArray) {
//            if (![self.selectCommonArray containsObject:model]) {
//                [array addObject:model];
//            }
//        }
        
        [self createOwnerView];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchUserCommonSkillWithToken:[self getToken]];
    
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveAction:(id)sender {
    NSMutableArray *ownArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.selectOwnerArray.count; i ++) {
        SkillModel *model = self.selectOwnerArray[i];
        [ownArr addObject:model.name];
    }
    for (int i = 0; i < self.selectCommonArray.count; i ++) {
        SkillModel *model = self.selectCommonArray[i];
        [ownArr addObject:model.name];
    }
    MyRentViewModel *viewModel = [[MyRentViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self backBtnAction:nil];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel setMyTagWithToken:[self getToken] tag:ownArr];
}

- (IBAction)createOwnSkill:(id)sender {
    CreateMyOwnTagsViewController *vc = [[CreateMyOwnTagsViewController alloc]init];
    [vc setReturnSkillBlock:^(NSMutableArray *skillArr) {
        NSMutableArray *ownArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < skillArr.count; i ++) {
            SkillModel *model = [[SkillModel alloc] init];
            model.name = skillArr[i];
            [ownArr addObject:model];
        }
        [self.selectOwnerArray addObjectsFromArray:ownArr];
        [self createOwnerView];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

//创建个性技能view
-(void)createOwnerView{
    for (UIView *subview in self.ownSkillView.subviews) {
        if (subview.tag > 900) {
            [subview removeFromSuperview];
        }
    }
    CGRect rectView = self.ownSkillView.frame;
    rectView.size.height = (self.selectOwnerArray.count+2)/3*40+130;
    self.ownSkillView.frame = rectView;
    
    CGFloat w = (ScreenWidth-60)/3;
    for (int i = 0; i < self.selectOwnerArray.count; i ++) {
        SkillModel *model = self.selectOwnerArray[i];
        UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(10+i%3*(w+20), 120+i/3*40, w, 30)];
        backview.tag = 901 + i;
        backview.backgroundColor = [UIColor whiteColor];
        backview.layer.borderColor = [UIColor colorWithHexString:@"ef5f7d"].CGColor;
        backview.layer.borderWidth = 1;
        UILabel *skillLabel = [[UILabel alloc] init];
        skillLabel.text = model.name;
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
        [self.ownSkillView addSubview:backview];
        [self.ownSkillView addSubview:delBtn];
    }
    [self crateSystemView];
    
    
}


-(void)deleteAction:(UIButton *)btn{
    [self.selectOwnerArray removeObjectAtIndex:btn.tag - 901];
    [self createOwnerView];
    
}

//创建常用标签view
-(void)crateSystemView{
    for (UIView *subview in self.commonSkillView.subviews) {
        if (subview.tag > 699) {
            [subview removeFromSuperview];
        }
    }
    CGRect rectOwn = self.ownSkillView.frame;
    CGRect rect = self.commonSkillView.frame;
    rect.origin.y = rectOwn.origin.y+rectOwn.size.height + 10;
    rect.size.height = 40*((self.commonDataArray.count+2)/3+1);
    self.commonSkillView.frame = rect;
    for (int i = 0; i < self.commonDataArray.count; i ++) {
        
        SkillModel *model = self.commonDataArray[i];
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
        [button.layer setBorderColor:[UIColor colorWithHexString:@"e6e6e6"].CGColor];
        for (int j = 0; j < self.selectCommonArray.count; j ++) {
            SkillModel *model1 = self.selectCommonArray[j];
            if ([model.name isEqualToString:model1.name]) {
                button.selected = YES;
                [button.layer setBorderColor:[UIColor colorWithHexString:@"ef5f7d"].CGColor];
            }
        }
        [self.commonSkillView addSubview:button];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        CGRect rect = button.frame;
        imageView.frame = CGRectMake(rect.origin.x+rect.size.width-13, rect.origin.y+rect.size.height-10, 13, 10);
        imageView.image = [UIImage imageNamed:@"icon_selected_labels"];
        imageView.tag = 700+i;
        imageView.hidden = !button.selected;
        [self.commonSkillView addSubview:imageView];
    }
}

-(void)btnChooseAction:(UIButton *)btn{
    
    for (UIImageView *imageView in self.commonSkillView.subviews) {
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
        SkillModel *model = self.commonDataArray[btn.tag-700];
        [self.selectCommonArray addObject:model];
    }else{
        [btn.layer setBorderColor:[UIColor colorWithHexString:@"e6e6e6"].CGColor];
        [btn.layer setBorderWidth:1];
        btn.selected = NO;
        SkillModel *model = self.commonDataArray[btn.tag-700];
        for (int i = 0; i < self.selectCommonArray.count; i ++) {
            SkillModel *subModel = self.selectCommonArray[i];
            if ([model.name isEqualToString:subModel.name]) {
                [self.selectCommonArray removeObjectAtIndex:i];
                break;
            }
        }
        [self.selectCommonArray removeObject:model];
    }
    NSLog(@"%@",self.selectCommonArray);
    
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}

@end
