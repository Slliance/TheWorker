//
//  JobDetailViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/28.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "JobDetailViewController.h"
#import "JobViewModel.h"
#import "MyApplicationModel.h"
@interface JobDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *jobScrollView;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *nationLabel;
@property (weak, nonatomic) IBOutlet UILabel *eduLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNOLabel;
@property (weak, nonatomic) IBOutlet UILabel *interesetLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *resumeLabel;
@property (weak, nonatomic) IBOutlet UIView *resumeBgView;
@property (weak, nonatomic) IBOutlet UIView *stateBgView;
@property (weak, nonatomic) IBOutlet UILabel *expectedLael;
@property (weak, nonatomic) IBOutlet UILabel *expectedDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *healthLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailHealthLabel;

@end

@implementation JobDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jobScrollView.contentSize = CGSizeMake(ScreenWidth, 615);
    
    JobViewModel *viewModel = [[JobViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self initViewWithModel:(returnValue)];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchMyApplicationInfoWithToken:[self getToken] Id:self.idStr];
    // Do any additional setup after loading the view from its nib.
}

-(void)initViewWithModel:(MyApplicationModel *)model{
    self.createTimeLabel.text = model.create_time;
    self.jobNameLabel.text = model.job_name;
    self.companyLabel.text = model.company;
    self.nameLabel.text = model.name;
    if (model.salary!=0) {
        self.expectedDetailLabel.text = [NSString stringWithFormat:@"%ld",(long)model.salary];
    }
    
    self.resumeLabel.text = model.introduction;
    self.detailHealthLabel.text = model.health_no;
    
    self.mobileLabel.text = [NSString stringWithFormat:@"%@",model.mobile];
    if ([model.sex integerValue] == 0) {
        self.sexLabel.text = @"女";
    }else if ([model.sex integerValue] == 1){
        self.sexLabel.text = @"男";
    }else{
        self.sexLabel.text = @"";
    }
    self.nationLabel.text = model.nation;
    self.eduLabel.text = model.edu;
    self.cardNOLabel.text = [NSString stringWithFormat:@"%@",model.cardno];
    self.interesetLabel.text = model.interest;
    self.resumeLabel.text = model.resume;
    switch ([model.status integerValue]) {
        case 1:
            self.stateLabel.text = @"审核中";
            break;
        case 2:
            self.stateLabel.text = @"面试中";
            break;
        case 3:
            self.stateLabel.text = @"未通过";
            break;
        case 4:
            self.stateLabel.text = @"体检中";
            break;
        case 5:
            self.stateLabel.text = @"已入职";
            break;
        default:
            break;
    }

    self.confirmTimeLabel.text = model.confirmed_time;
    CGRect rect = self.resumeLabel.frame;
    CGSize size = [model.resume sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(335, 3000)];
    rect.size.height = size.height;
    self.resumeLabel.frame = rect;
    CGRect rectResume = self.resumeBgView.frame;
    rectResume.size.height = rect.origin.y + rect.size.height + 60;
    self.resumeBgView.frame = rectResume;
    CGRect rectState = self.stateBgView.frame;
    rectState.origin.y = rectResume.origin.y + rectResume.size.height + 10;
    self.stateBgView.frame = rectState;
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
