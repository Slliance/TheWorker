//
//  BrandListViewController.m
//  TheWorker
//
//  Created by yanghao on 8/19/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "BrandListViewController.h"
#import "BrandTableViewCell.h"
#import "WorkerBusinessViewModel.h"
#import "BannerWebViewController.h"
#import "PartnerModel.h"
@interface BrandListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIImageView *noDataImageView;

@property (nonatomic, retain) NSMutableArray *parterArr;

@end

@implementation BrandListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.parterArr = [[NSMutableArray alloc]init];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"BrandTableViewCell" bundle:nil] forCellReuseIdentifier:@"BrandTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
    WorkerBusinessViewModel *viewModel = [[WorkerBusinessViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self.parterArr addObjectsFromArray:returnValue];
        if (self.parterArr.count != 0) {
            self.itemTableView.hidden = NO;
            self.noDataImageView.hidden = YES;
            [self.itemTableView reloadData];
        }else{
            self.itemTableView.hidden = YES;
            self.noDataImageView.hidden = NO;
        }
        
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchBusinessParterList];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.parterArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandTableViewCell"];
    [cell initCellWithData:self.parterArr[indexPath.row]];
    return cell;
    
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PartnerModel *model = self.parterArr[indexPath.row];
    if (model.web_url.length > 5) {
        BannerWebViewController *vc = [[BannerWebViewController alloc] init];
        vc.bannerUrl = model.web_url;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
