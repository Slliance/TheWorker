//
//  ConvertSuccessViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/15.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ConvertSuccessViewController.h"
#import "WelfareViewController.h"
#import "GoodsDetailViewController.h"
#import "MyOrderFormViewController.h"
@interface ConvertSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnConvert;
@property (weak, nonatomic) IBOutlet UIButton *btnLookDetail;
@property (weak, nonatomic) IBOutlet UILabel *convertPeople;
@property (weak, nonatomic) IBOutlet UILabel *labelMobile;
@property (weak, nonatomic) IBOutlet UILabel *labelRemark;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelConvertTime;
@property (weak, nonatomic) IBOutlet UILabel *labelConvertAddress;
@property (weak, nonatomic) IBOutlet UIView *btnBgView;
@property (weak, nonatomic) IBOutlet UIView *bgview;

@end

@implementation ConvertSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnConvert.layer.masksToBounds = YES;
    self.btnConvert.layer.cornerRadius = 4.f;
    [self.btnConvert.layer setBorderWidth:1];
    [self.btnConvert.layer setBorderColor:[UIColor colorWithHexString:@"6398f1"].CGColor];
    self.btnLookDetail.layer.masksToBounds = YES;
    self.btnLookDetail.layer.cornerRadius = 4.f;

    self.convertPeople.text = self.convertInfo[@"name"];
    self.labelMobile.text = self.convertInfo[@"mobile"];
    NSString *remarkStr = self.convertInfo[@"remark"];
    self.labelRemark.text = remarkStr;
    self.labelAddress.text = self.convertInfo[@"address"];
    self.labelTime.text = self.convertInfo[@"time"];
    
    CGSize sizeRamark = [remarkStr sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(ScreenWidth-140, 300)];
    CGRect rectRamark = self.labelRemark.frame;
    rectRamark.size.width = sizeRamark.width;
    rectRamark.size.height = sizeRamark.height;
    self.labelRemark.frame = rectRamark;
    
    CGRect rectConvertAddress = self.labelConvertAddress.frame;
    rectConvertAddress.origin.y = 160 + sizeRamark.height + 10;
    self.labelConvertAddress.frame = rectConvertAddress;
    
    CGSize sizeAddress = [self.labelAddress.text sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth-90, 300)];
    CGRect rectAddress = self.labelAddress.frame;
    rectAddress.size.height = sizeAddress.height;
    rectAddress.origin.y = rectConvertAddress.origin.y + rectConvertAddress.size.height + 10;
    self.labelAddress.frame = rectAddress;
    
    
    CGRect rectConvertTime = self.labelConvertTime.frame;
    rectConvertTime.origin.y = rectAddress.size.height + rectAddress.origin.y + 10;
    self.labelConvertTime.frame = rectConvertTime;
    CGRect rectTime = self.labelTime.frame;
    CGSize sizeTime = [self.labelTime.text sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth-90, 300)];
    rectTime.origin.y = rectConvertTime.size.height + rectConvertTime.origin.y + 10;
    rectTime.size.height = sizeTime.height;
    self.labelTime.frame = rectTime;
    
    CGRect rectLeftBtn = self.btnBgView.frame;
    rectLeftBtn.origin.y = rectTime.origin.y + rectTime.size.height + 15;
    self.btnBgView.frame = rectLeftBtn;
    CGRect bgRect = self.bgview.frame;
    bgRect.size.height = rectLeftBtn.origin.y + rectLeftBtn.size.height + 30;
    self.bgview.frame = bgRect;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)continueConvert:(id)sender {
//
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[GoodsDetailViewController class]]) {
            GoodsDetailViewController *aVc = (GoodsDetailViewController *)vc;
            [self.navigationController popToViewController:aVc animated:YES];
        }
    }
}
- (IBAction)checkOrderAction:(id)sender {
    MyOrderFormViewController *vc = [[MyOrderFormViewController alloc] init];
    vc.skipForm = 0;
    [self.navigationController pushViewController:vc animated:YES];
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
