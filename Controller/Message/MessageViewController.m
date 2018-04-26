//
//  MessageViewController.m
//  TheWorker
//
//  Created by yanghao on 9/4/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "MessageViewController.h"
#import "NTESSessionListViewController.h"
#import <NIMSDK/NIMSDK.h>

@interface MessageViewController ()
@property (weak, nonatomic) IBOutlet UIView *nologinView;

@property (nonatomic, retain) NTESSessionListViewController *vc;
@end

@implementation MessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vc = [[NTESSessionListViewController alloc] init];
    [self addChildViewController:self.vc];
    [self.vc didMoveToParentViewController:self];
    [self.vc.view setFrame:CGRectMake(0, 64, ScreenWidth, self.view.bounds.size.height - 64)];
    [self.view addSubview:self.vc.view];

    // Do any additional setup after loading the view.
}


-(void)viewDidAppear:(BOOL)animated{
    if ([self isLogin]) {
        self.vc.view.hidden = NO;
        self.nologinView.hidden = YES;
       
    }else{
        self.vc.view.hidden = YES;
        self.nologinView.hidden = NO;
    }
}
- (IBAction)loginAction:(id)sender {
    [self skiptoLogin];
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
