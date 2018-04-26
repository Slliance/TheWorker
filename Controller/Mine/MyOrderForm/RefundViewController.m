//
//  RefundViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/4.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RefundViewController.h"
#import "OrderViewModel.h"
@interface RefundViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *orderScrollView;
@property (weak, nonatomic) IBOutlet UIView *reasonView;
@property (weak, nonatomic) IBOutlet UIView *auditView;
@property (weak, nonatomic) IBOutlet UILabel *orderStr;
@property (weak, nonatomic) IBOutlet UILabel *labelStatu;
@property (weak, nonatomic) IBOutlet UILabel *labelReason;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelRemake;
@property (weak, nonatomic) IBOutlet UILabel *labelReply;
@property (weak, nonatomic) IBOutlet UILabel *proveLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UIView *attentionView;

@end

@implementation RefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderStr.text = [NSString stringWithFormat:@"%@",self.model.refund_no];
    
    switch ([self.model.status integerValue]) {
        case 0:
        {
            self.labelStatu.text = @"申请中";
        }
            break;
        case 1:
        {
            self.labelStatu.text = @"申请中";
        }
            break;
        case 2:
        {
            self.labelStatu.text = @"驳回";
        }
            break;
            
        case 3:
        {
            self.labelStatu.text = @"已通过";
        }
            break;
            
        case 4:
        {
            self.labelStatu.text = @"驳回";
        }
            break;
            
        default:
            break;
    }
    self.labelReason.text = self.model.user_reason;
    double price = [self.model.refund_price doubleValue];
    self.labelPrice.text = [NSString stringWithFormat:@"%.2f元",price];
    self.labelRemake.text = self.model.remark;
    self.labelReply.text = self.model.reason;
    //计算退款说明frame
    CGSize remarkSize = [self.model.remark sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth - 85, 300)];
    //退款说明
    CGRect rectRemark = self.labelRemake.frame;
    rectRemark.size.width = remarkSize.width;
    rectRemark.size.height = remarkSize.height;
    self.labelRemake.frame = rectRemark;
    
    //分割线&凭证
    CGRect rectLine = self.lineLabel.frame;
    rectLine.origin.y = rectRemark.origin.y + rectRemark.size.height + 10;
    self.lineLabel.frame = rectLine;
    CGRect rectLabel = self.proveLabel.frame;
    rectLabel.origin.y = rectLine.origin.y + rectLabel.size.height;
    self.proveLabel.frame = rectLabel;
    CGFloat pointY;
    if (self.model.imgs.count > 0) {
        CGFloat w = (ScreenWidth - 50) / 3;
        pointY = rectLabel.origin.y + rectLabel.size.height + 5;
        for (int i = 0; i < self.model.imgs.count; i ++) {
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView setFrame:CGRectMake(15 + (w + 10) * i, pointY, w, w)];
            NSString *imgurl =  [NSString stringWithFormat:@"%@%@",BaseUrl,self.model.imgs[i]];
            [imgView setImageWithURL:[NSURL URLWithString:imgurl]];
            [self.reasonView addSubview:imgView];
        }
        pointY = pointY + w;
    }else{
        self.proveLabel.hidden = YES;
        self.lineLabel.hidden = YES;
        pointY = rectRemark.size.height + rectRemark.origin.y + 5;
    }
    CGRect rectView = self.reasonView.frame;
    rectView.size.height = pointY + 10;
    self.reasonView.frame = rectView;
    
    CGRect rectAtten = self.attentionView.frame;
    rectAtten.origin.y = rectView.size.height + rectView.origin.y + 10;
    self.attentionView.frame = rectAtten;
    //审核备注
    CGSize sizeReason = [self.model.reason sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth - 90, 300)];
    CGRect rectReason = self.labelReply.frame;
    rectReason.size.width = sizeReason.width;
    rectReason.size.height = sizeReason.height;
    self.labelReply.frame = rectReason;
    
    CGRect rectAudit = self.auditView.frame;
    rectAudit.origin.y = rectAtten.origin.y + rectAtten.size.height + 35;
    rectAudit.size.height = rectReason.origin.y + rectReason.size.height + 10;
    self.auditView.frame = rectAudit;
    
    __weak typeof (self)weakSelf = self;
    
    OrderViewModel *viewModel = [[OrderViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    
    //    [viewModel fetchRefundOrderPrice:self.model.order_id token:[self getToken] type:self.type];
    
    
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
