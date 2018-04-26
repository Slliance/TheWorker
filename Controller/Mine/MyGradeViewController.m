//
//  MyGradeViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/5.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyGradeViewController.h"
#import "UserViewModel.h"
@interface MyGradeViewController (){
    NSInteger currentScore;
}

@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet UILabel *labelFriendAmount;
@property (weak, nonatomic) IBOutlet UILabel *labelGrade;
@property (weak, nonatomic) IBOutlet UILabel *labelGradeOne;
@property (weak, nonatomic) IBOutlet UILabel *labelGradeTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelGradeThree;
@property (weak, nonatomic) IBOutlet UIImageView *imgLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imgMiddle;
@property (weak, nonatomic) IBOutlet UIImageView *imgRight;
@property (weak, nonatomic) IBOutlet UILabel *labelScoreLeft;
@property (weak, nonatomic) IBOutlet UILabel *labelScoreMiddle;
@property (weak, nonatomic) IBOutlet UILabel *labelScoreRight;



@property (nonatomic, retain) NSMutableArray *dataArray;
@end

@implementation MyGradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = self.scoreView.frame;
    rect.size.width = 128;
    self.scoreView.frame = rect;
    self.dataArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
    UserViewModel *viewModel = [[UserViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        currentScore = [returnValue[@"friend_amount"] integerValue];
        NSArray *dataArr = returnValue[@"level"];
        for (int i = 0; i < dataArr.count; i ++) {
            NSDictionary *dic = dataArr[i];
            [self.dataArray addObject:dic];
        }
        [self reloadView];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel queryUserGradeWithToken:[self getToken]];
}

-(void)reloadView{
    self.labelFriendAmount.text = [NSString stringWithFormat:@"%ld",(long)currentScore];
    
    self.labelGradeOne.text = [NSString stringWithFormat:@"%@",self.dataArray[0][@"name"]];
    self.labelScoreLeft.text = [NSString stringWithFormat:@"%@",self.dataArray[0][@"friend_amount"]];
    self.labelGradeTwo.text = [NSString stringWithFormat:@"%@",self.dataArray[1][@"name"]];
    self.labelScoreMiddle.text = [NSString stringWithFormat:@"%@",self.dataArray[1][@"friend_amount"]];
    self.labelGradeThree.text = [NSString stringWithFormat:@"%@",self.dataArray[2][@"name"]];
    self.labelScoreRight.text = [NSString stringWithFormat:@"%@",self.dataArray[2][@"friend_amount"]];
    NSInteger score1st = [self.dataArray[0][@"friend_amount"] integerValue];
    NSInteger score2nd = [self.dataArray[1][@"friend_amount"] integerValue];
    NSInteger score3rd = [self.dataArray[2][@"friend_amount"] integerValue];
    CGRect rect = self.scoreView.frame;
    rect.size.width = (currentScore/score3rd) * (ScreenWidth - 20);
    self.scoreView.frame = rect;
    if (currentScore <= score1st) {
        CGRect rect = self.imgLeft.frame;
        rect.size.width = 24;
        rect.size.height = 24;
        rect.origin.x = rect.origin.x-3;
        rect.origin.y = rect.origin.y-3;
        self.imgLeft.frame = rect;
        self.labelGrade.text = self.labelGradeOne.text;
    }else if (score1st<currentScore<score2nd){
        CGRect rect = self.imgMiddle.frame;
        rect.size.width = 24;
        rect.size.height = 24;
        rect.origin.x = rect.origin.x-3;
        rect.origin.y = rect.origin.y-3;
        self.imgMiddle.frame = rect;
        self.labelGrade.text = self.labelGradeTwo.text;
    }else{
        CGRect rect = self.imgRight.frame;
        rect.size.width = 24;
        rect.size.height = 24;
        rect.origin.x = rect.origin.x-3;
        rect.origin.y = rect.origin.y-3;
        self.imgRight.frame = rect;
        self.labelGrade.text = self.labelGradeThree.text;
    }
    
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
