//
//  RemarkViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/5.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RemarkViewController.h"
#import "MyRemarkTableViewCell.h"
#import "OrderViewModel.h"
@interface RemarkViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (nonatomic, retain) OrderViewModel *viewModel;
@property (nonatomic, retain) NSMutableArray *goodsArr;
@end

@implementation RemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"MyRemarkTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyRemarkTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.goodsArr = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)submitAction:(id)sender {
    if (!self.isSmallOrder) {
        if (self.goodsArr.count != self.model.goods.count) {
            [self showJGProgressWithMsg:@"请评分"];
            return;
        }
    }
    else if (self.storeModel){
        if (!self.goodsArr.count) {
            [self showJGProgressWithMsg:@"请评分"];
            return;
        }
    }
    [HYNotification postOrderCommentCloseKeyboardNotification:nil];
    __weak typeof (self)weakSelf = self;
    self.viewModel = [[OrderViewModel alloc] init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        weakSelf.finishBlock();
        [weakSelf showJGProgressWithMsg:@"评论成功"];
        [weakSelf backAction:nil];
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    NSLog(@"==%@",self.goodsArr);
    [self.viewModel commitComment:self.model.Id token:[self getToken] goods:self.goodsArr];
}


#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.isSmallOrder) {
        return self.model.goods.count;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof (self)weakSelf = self;
    MyRemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyRemarkTableViewCell"];
    if (!self.isSmallOrder) {
        [cell initCellWithData:self.model.goods[indexPath.section]];
    }
    else{
        [cell initCellWithData:self.storeModel];
    }
    [cell setReturnBlock:^(NSDictionary *dic){
        for ( int i = 0; i < self.goodsArr.count; i ++) {
            NSDictionary *xdic = self.goodsArr[i];
            if ([xdic[@"id"] isEqual:[dic objectForKey:@"id"]]) {
                [weakSelf.goodsArr removeObjectAtIndex:i];
                break;
            }
        }
        [weakSelf.goodsArr addObject:dic];
    }];
    return cell;
    
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

@end

