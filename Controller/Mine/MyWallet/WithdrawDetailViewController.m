//
//  WithdrawDetailViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "WithdrawDetailViewController.h"

@interface WithdrawDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *applyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *refundReasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation WithdrawDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.applyTimeLabel.text = self.recordModel.createtime;
    self.amountLabel.text = [NSString stringWithFormat:@"%@元(实际到账金额%@元)",self.recordModel.amount,self.recordModel.rel_amount];
    self.nameLabel.text = self.recordModel.name;
    self.accountLabel.text = [NSString stringWithFormat:@"%@",self.recordModel.account];
    self.remarkLabel.text = self.recordModel.remark;
    //计算备注的高度
    CGSize sizeremark = [self.recordModel.remark sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth - 95, 100)];
    CGRect rectRemark = self.remarkLabel.frame;
    rectRemark.size.width = sizeremark.width;
    rectRemark.size.height = sizeremark.height;
    self.remarkLabel.frame = rectRemark;
    CGFloat pointY = rectRemark.origin.y + rectRemark.size.height;
    CGRect reasonRect = self.reasonLabel.frame;
    reasonRect.origin.y = pointY+10;
    self.reasonLabel.frame = reasonRect;
    self.refundReasonLabel.text = self.recordModel.reason;
    //计算原因的高度
    CGSize sizeReason = [self.recordModel.reason sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth - 95, 100)];
    CGRect refundRect = self.refundReasonLabel.frame;
    refundRect.origin.y = pointY;
    refundRect.size.height = sizeReason.height;
    refundRect.size.width = sizeReason.width;
    self.refundReasonLabel.frame = refundRect;
    if (sizeReason.height < 1) {
        pointY += reasonRect.size.height;
        
    }
    if (self.recordModel.reason.length == 0) {
        self.reasonLabel.hidden = YES;
    }
    pointY += refundRect.size.height;
    //分割线的位置
    CGRect lineRect = self.lineLabel.frame;
    pointY += 30;
    lineRect.origin.y = pointY;
    self.lineLabel.frame = lineRect;
    //申请状态的位置
    CGRect statusRect = self.statusLabel.frame;
    pointY += 15;
    statusRect.origin.y = pointY;
    self.statusLabel.frame = statusRect;
    //状态的位置
    if ([self.recordModel.status integerValue] == 1) {
        self.stateLabel.text = @"已通过";
    }else if ([self.recordModel.status integerValue] == 2){
        self.stateLabel.text = @"已退回";
    }else{
        self.stateLabel.text = @"审核中";
    }
    CGRect stateRect = self.stateLabel.frame;
    pointY += 20;
    stateRect.origin.y = pointY;
    self.stateLabel.frame = stateRect;
    //审核时间的位置
    self.updateLabel.text = self.recordModel.updatetime;
    CGRect timeRect = self.updateLabel.frame;
    timeRect.origin.y = pointY;
    self.updateLabel.frame = timeRect;
    // Do any additional setup after loading the view from its nib.
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
