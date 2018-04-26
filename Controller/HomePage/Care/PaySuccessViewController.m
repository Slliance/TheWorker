//
//  PaySuccessViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/22.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "ShopListViewController.h"
#import "MyOrderFormViewController.h"
#import "MyShoppingCartViewController.h"
@interface PaySuccessViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnContinue.layer setBorderColor:[UIColor colorWithHexString:@"6398f1"].CGColor];
    [self.btnContinue.layer setBorderWidth:1];
    [self.btnContinue.layer setMasksToBounds:YES];
    [self.btnContinue.layer setCornerRadius:4.f];
    [self.btnCheck.layer setMasksToBounds:YES];
    [self.btnCheck.layer setCornerRadius:4.f];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)continueAction:(id)sender {
//    ShopListViewController *vc = [[ShopListViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    NSMutableArray*tempMarr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ShopListViewController class]]) {
            ShopListViewController *A =(ShopListViewController *)controller;
            [self.navigationController popToViewController:A animated:YES];
        }else{
            ShopListViewController *A =[[ShopListViewController alloc]init];
            NSLog(@"===%@===",tempMarr);
            [tempMarr insertObject:A atIndex:3];
            [self.navigationController setViewControllers:tempMarr animated:YES];
            for (UIViewController *controller in self.navigationController.viewControllers){
                if ([controller isKindOfClass:[ShopListViewController class]]) {
                    ShopListViewController *shoppingvc =(ShopListViewController *)controller;
                    [self.navigationController popToViewController:shoppingvc animated:YES];
                }
            }
            break;
        }
    }
}
- (IBAction)lookDetailAction:(id)sender {
    MyOrderFormViewController *vc = [[MyOrderFormViewController alloc] init];
    vc.skipForm = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
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
