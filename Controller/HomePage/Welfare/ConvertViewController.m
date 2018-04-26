//
//  ConvertViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/15.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ConvertViewController.h"
#import "ConvertSuccessViewController.h"
#import "WelfareConvertViewModel.h"
#import "UserModel.h"
@interface ConvertViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UITextView *textName;
@property (weak, nonatomic) IBOutlet UITextView *textMobile;
@property (weak, nonatomic) IBOutlet UITextView *textRemark;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelFriendAmount;
@property (weak, nonatomic) IBOutlet UIImageView *imgGoods;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *labelPriceAgain;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UIButton *btnConvert;
@property (weak, nonatomic) IBOutlet UILabel *labelConvertTime;

@end

@implementation ConvertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self reloadView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)reloadView{
    self.textName.layer.masksToBounds = YES;
    self.textName.layer.cornerRadius = 4.f;
    [self.textName.layer setBorderColor:[UIColor colorWithHexString:@"e6e6e6"].CGColor];
    [self.textName.layer setBorderWidth:1];
    self.textMobile.layer.masksToBounds = YES;
    self.textMobile.layer.cornerRadius = 4.f;
    [self.textMobile.layer setBorderColor:[UIColor colorWithHexString:@"e6e6e6"].CGColor];
    [self.textMobile.layer setBorderWidth:1];self.textName.layer.masksToBounds = YES;
    self.textRemark.layer.masksToBounds = YES;
    self.textRemark.layer.cornerRadius = 4.f;
    [self.textRemark.layer setBorderColor:[UIColor colorWithHexString:@"e6e6e6"].CGColor];
    [self.textRemark.layer setBorderWidth:1];
    
    if ([self.goodsmodel.point integerValue] == 0 && [self.goodsmodel.friend_amount integerValue] == 0) {
        self.labelPrice.text = @"免费领取";
        self.labelPriceAgain.text = @"免费领取";
    }else{
        self.labelPrice.text = [NSString stringWithFormat:@"%@",self.goodsmodel.point];
        self.labelPriceAgain.text = [NSString stringWithFormat:@"%@积分",self.goodsmodel.point];

    }
    self.labelFriendAmount.text = [NSString stringWithFormat:@"%@",self.goodsmodel.friend_amount];
    [self.imgGoods setImageWithString:self.goodsmodel.show_img placeHoldImageName:@"bg_no_pictures"];
//    [self.imgGoods setImageWithURL:[NSURL URLWithString:self.goodsmodel.show_img] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
    self.goodsName.text = self.goodsmodel.name;
    self.labelAddress.text = self.goodsmodel.address;
    self.labelTime.text = self.goodsmodel.exchange_time;
    CGSize sizeAddress = [self.labelAddress.text sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth-20, 300)];
    CGRect rectAddress = self.labelAddress.frame;
    rectAddress.size.height = sizeAddress.height;
    self.labelAddress.frame = rectAddress;
    CGRect rectConvertTime = self.labelConvertTime.frame;
    rectConvertTime.origin.y = rectAddress.size.height + rectAddress.origin.y + 10;
    self.labelConvertTime.frame = rectConvertTime;
    CGRect rectTime = self.labelTime.frame;
    rectTime.origin.y = rectConvertTime.size.height + rectConvertTime.origin.y + 10;
    self.labelTime.frame = rectTime;
    self.mainScrollView.contentSize = CGSizeMake(ScreenWidth, rectTime.origin.y + rectTime.size.height +10);

    
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)convertAction:(id)sender {
    
    if ([self getToken].length == 0) {
        [self showJGProgressWithMsg:@"请登录"];
        return;
    }
    
    if (self.textName.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入兑换人姓名"];
        return;
    }
    
    if (self.textMobile.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入联系电话"];
        return;
    }

    WelfareConvertViewModel *viewModel = [[WelfareConvertViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        ConvertSuccessViewController *vc = [[ConvertSuccessViewController alloc]init];
        NSDictionary *info = @{@"name":self.textName.text,
                               @"mobile":self.textMobile.text,
                               @"remark":self.textRemark.text,
                               @"address":self.goodsmodel.address,
                               @"time":self.goodsmodel.exchange_time};
        vc.convertInfo = info;
        [self.navigationController pushViewController:vc animated:YES];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel convertGoodsWithToken:[self getToken] name:self.textName.text mobile:self.textMobile.text Id:self.goodsmodel.Id remark:self.textRemark.text];
    
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
