//
//  ScoreOrderDetailViewController.m
//  TheWorker
//
//  Created by yanghao on 2017/10/14.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ScoreOrderDetailViewController.h"
#import "OrderViewModel.h"
#import "ScoreOrderModel.h"
@interface ScoreOrderDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *tradeNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkMobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnConvert;
@property (weak, nonatomic) IBOutlet UIView *btnBgView;

@property(nonatomic, retain) OrderViewModel *viewModel;
@property (nonatomic, retain) ScoreOrderModel *orderModel;
@end

@implementation ScoreOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isConverted == 1) {
        self.btnBgView.hidden = YES;
    }else{
        self.btnBgView.hidden = NO;
    }
    __weak typeof (self)weakSelf = self;
    self.viewModel = [[OrderViewModel alloc] init];
    self.orderModel = [[ScoreOrderModel alloc] init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        weakSelf.orderModel = returnValue;
        [weakSelf initView];
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    
    [self.viewModel fetchScoreOrderDetail:self.scoreOrderModel.Id token:[self getToken]];

    // Do any additional setup after loading the view from its nib.
}

-(void)initView{
//    [self.goodsImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.orderModel.show_img]] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
    [self.goodsImg setImageWithString:self.orderModel.show_img placeHoldImageName:@"bg_no_pictures"];
    self.goodsNameLabel.text = self.orderModel.goods_name;
    self.tradeNoLabel.text = [NSString stringWithFormat:@"%@",self.orderModel.order_no];
    self.scoreLabel.text = [NSString stringWithFormat:@"%@",self.orderModel.point];
    self.friendAmountLabel.text = [NSString stringWithFormat:@"%@",self.orderModel.friend_amount];
    self.nameLabel.text = self.orderModel.name;
    self.linkMobileLabel.text = [NSString stringWithFormat:@"%@",self.orderModel.mobile];
    self.remarkLabel.text = self.orderModel.remark;
    self.labelAddress.text = self.orderModel.address;
    if ([self.orderModel.status integerValue] == 0) {
        self.timeLabel.text = @"未领取";
    }else{
        self.timeLabel.text = self.orderModel.receive_time;
    }
    CGSize size = [self.labelAddress.text sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth - 40, 3000)];
    CGRect rectAddress = self.labelAddress.frame;
    rectAddress.size.height = size.height;
    self.labelAddress.frame = rectAddress;
    CGRect rect = self.receiveTimeLabel.frame;
    CGRect rect1 = self.timeLabel.frame;
    rect.origin.y = rectAddress.origin.y + rectAddress.size.height + 13;
    rect1.origin.y = rectAddress.origin.y + rectAddress.size.height + 13;
    self.receiveTimeLabel.frame = rect;
    self.timeLabel.frame = rect1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)convertAction:(id)sender {
    OrderViewModel *viewModel = [[OrderViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self showJGProgressWithMsg:@"领取成功"];
        [self backBtnAction:nil];
        self.returnBlock();
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel getPointGoodsWithToken:[self getToken] Id:self.scoreOrderModel.Id];
}



@end
