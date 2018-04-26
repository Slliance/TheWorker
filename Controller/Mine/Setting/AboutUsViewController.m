//
//  AboutUsViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/2.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AboutUsWebViewController.h"
@interface AboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.itemTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"aboutUsCell"];
     // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutUsCell"];
    NSArray *cellArr = @[@"服务条款",@"免责声明"];
    cell.textLabel.text = cellArr[indexPath.section];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, ScreenWidth, 10);
    view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AboutUsWebViewController *vc = [[AboutUsWebViewController alloc] init];
    if (indexPath.section == 0) {
        vc.urlStr = @"service";
        vc.titleStr = @"服务条款";
    }else{
        vc.urlStr = @"disclaimer";
        vc.titleStr = @"免责声明";
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
