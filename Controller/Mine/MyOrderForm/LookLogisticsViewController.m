//
//  LookLogisticsViewController.m
//  TheWorker
//
//  Created by yanghao on 25/11/2017.
//  Copyright © 2017 huying. All rights reserved.
//

#import "LookLogisticsViewController.h"

@interface LookLogisticsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelName;

@end

@implementation LookLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.logisticsOrderNo) {
        self.labelNumber.text = self.logisticsOrderNo;
    }
    if (self.logisticsCompanyName) {
        self.labelName.text = self.logisticsCompanyName;
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
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
