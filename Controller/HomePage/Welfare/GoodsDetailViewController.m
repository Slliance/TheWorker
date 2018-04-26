//
//  GoodsDetailViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/16.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "GoodsHeadView.h"
#import "GoodsInfoTableViewCell.h"
#import "ConvertViewController.h"
#import "WorkerWelfareViewModel.h"
#import "WelfareConvertViewModel.h"
#import "GoodsModel.h"
#import "CollectViewModel.h"
#import "UserModel.h"
#define content_height (ScreenHeight - 64 - 49)

@interface GoodsDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *btnGoods;
@property (weak, nonatomic) IBOutlet UIButton *btnDetail;
@property (weak, nonatomic) IBOutlet UILabel *labelGoods;
@property (weak, nonatomic) IBOutlet UILabel *labelDetial;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnCollect;

@property (nonatomic, retain) GoodsHeadView *headView;
@property (nonatomic, retain) UILabel *labelScroll;
@property (nonatomic, retain) UIWebView *htmlWebView;
@property (nonatomic, retain) GoodsModel *goodsModel;
@end

@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.goodsModel = [[GoodsModel alloc] init];
     self.automaticallyAdjustsScrollViewInsets = NO;
    [self.mainScrollView setContentSize:CGSizeMake(ScreenWidth, content_height + content_height)];
    
    self.htmlWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, content_height, ScreenWidth, content_height)];
    
    [self.mainScrollView addSubview:self.htmlWebView];
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"GoodsHeadView" owner:self options:nil] firstObject];
//    __weak typeof (self)weakSelf = self;
    [self.headView setEndDeceleratingBlock:^{
        NSLog(@"");
        //        weakSelf.bannerTimer = [MSWeakTimer scheduledTimerWithTimeInterval:5 target:weakSelf.headview selector:@selector(timerStart) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
    }];
    [self.headView setBeginDraggingBlock:^{
        NSLog(@"");
        //        [weakSelf.bannerTimer invalidate];
    }];
    self.itemTableView.tableHeaderView = self.headView;
    [self.itemTableView registerNib:[UINib nibWithNibName:@"GoodsInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoodsInfoTableViewCell"];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"GoodsWebTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoodsWebTableViewCell"];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view from its nib.
    
    WelfareConvertViewModel *viewModel = [[WelfareConvertViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        self.goodsModel = returnValue;
        [self.htmlWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.goodsModel.goods_detail]]];
        [self.headView initBannerView:self.goodsModel.imgs];
        if ([self.goodsModel.is_collect integerValue] == 0) {
            self.btnCollect.selected = NO;
        }else{
            self.btnCollect.selected = YES;
        }
        [self.itemTableView reloadData];
    } WithErrorBlock:^(id errorCode) {
        
        [self showJGProgressWithMsg:errorCode];
        if ([self getToken].length == 0) {
            [self showJGProgressWithMsg:@"请登录"];
            return;
        }
    }];
    [viewModel fetchGoodsDetailWithToken:[self getToken] Id:self.goodsId];
}


//2、当前页面不在导航控制器中，需重写preferredStatusBarStyle，如下：

-(UIStatusBarStyle)preferredStatusBarStyle {
    
//     return UIStatusBarStyleLightContent; //白色
    
    return UIStatusBarStyleDefault; //黑色
}

- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)shareAction:(id)sender {
    [self shareWithPageUrl:self.goodsModel.share shareTitle:self.goodsModel.name shareDes:@"" thumImage:self.goodsModel.show_img];
}
- (IBAction)chooseGoods:(id)sender {
    
    if (self.btnGoods.selected == NO) {
        self.btnGoods.selected = YES;
        self.labelGoods.hidden = NO;
        self.btnDetail.selected = NO;
        self.labelDetial.hidden = YES;
        
        [UIView animateWithDuration:0.3
                         animations:^{
//                             CGRect rect = self.labelGoods.frame;
//                             rect.origin.x = self.btnGoods.frame.origin.x + 5;
//                             self.labelGoods.frame = rect;
                             self.mainScrollView.contentOffset = CGPointMake(0, 0);
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}
- (IBAction)chooseDetail:(id)sender {
//    if (self.btnDetail.selected == NO) {
//        self.btnDetail.selected = YES;
//        self.labelDetial.hidden = NO;
//        self.btnGoods.selected = NO;
//        self.labelGoods.hidden = YES;
//        self.itemTableView.contentOffset = CGPointMake(0, 445);
//    }
    if (self.btnDetail.selected == NO) {
        self.btnDetail.selected = YES;
                self.labelDetial.hidden = NO;
                self.labelGoods.hidden = YES;
        self.btnGoods.selected = NO;
        [UIView animateWithDuration:0.3
                         animations:^{
//                             CGRect rect = self.labelGoods.frame;
//                             rect.origin.x = self.btnDetail.frame.origin.x + 5;
//                             self.labelGoods.frame = rect;
                             self.mainScrollView.contentOffset = CGPointMake(0, content_height);
                         } completion:^(BOOL finished) {
                             
                         }];
        
    }
    
}
- (IBAction)collectAction:(id)sender {
    if (![self isLogin]) {
        [self skiptoLogin];
        return;
    }
    if (self.btnCollect.selected == YES) {
        CollectViewModel *viewModel = [[CollectViewModel alloc]init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [self showJGProgressWithMsg:@"取消收藏成功"];
            self.btnCollect.selected = NO;
            [self.btnCollect setTitle:@"我要收藏" forState:UIControlStateNormal];
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel userCollectWithToken:[self getToken] articleId:[NSString stringWithFormat:@"%@",self.goodsModel.Id] collectType:@(1)];
        
    }else{
        CollectViewModel *viewModel = [[CollectViewModel alloc]init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [self showJGProgressWithMsg:@"添加收藏成功"];
            self.btnCollect.selected = YES;
            [self.btnCollect setTitle:@"取消收藏" forState:UIControlStateSelected];
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel userCollectWithToken:[self getToken] articleId:[NSString stringWithFormat:@"%@",self.goodsModel.Id] collectType:@(1)];
        
    }
    
}
- (IBAction)exchangeAction:(id)sender {
    if (![self isLogin]) {
        [self skiptoLogin];
        return;
    }
//    UserModel *model = [[UserModel alloc] initWithDict:[UserDefaults readUserDefaultObjectValueForKey:user_info]];
//    if ([model.level_id]) {
//        <#statements#>
//    }
    ConvertViewController *vc = [[ConvertViewController alloc]init];
    vc.goodsmodel = self.goodsModel;
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.goodsModel) {
        return 1;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        GoodsInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsInfoTableViewCell"];
        [cell initCellWithData:self.goodsModel];
        return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 32.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    
        headView.frame = CGRectMake(0, 0, ScreenWidth, 32);
        headView.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
        self.labelScroll = [[UILabel alloc]init];
        self.labelScroll.text = @"继续滑动，查看商品详情";
        self.labelScroll.font = [UIFont systemFontOfSize:12];
        self.labelScroll.textColor = [UIColor colorWithHexString:@"999999"];
        CGSize size = [self.labelScroll.text sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(200, 100)];
        self.labelScroll.frame = CGRectMake(ScreenWidth/2-size.width/2, 10, size.width, 12);
        [headView addSubview:self.labelScroll];
        return headView;
    
    return headView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.mainScrollView.contentOffset.y < 400) {
        self.btnGoods.selected = YES;
        self.labelGoods.hidden = NO;
        self.btnDetail.selected = NO;
        self.labelDetial.hidden = YES;
        self.labelScroll.text = @"继续滑动，查看商品详情";
    }else if(self.mainScrollView.contentOffset.y > 400){
        self.btnDetail.selected = YES;
        self.labelDetial.hidden = NO;
        self.btnGoods.selected = NO;
        self.labelGoods.hidden = YES;
        self.labelScroll.text = @"向上滑动，查看商品信息";
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.mainScrollView]) {
        
        NSInteger index = fabs(scrollView.contentOffset.y) / 410;
        if (index == 0) {
            self.btnGoods.selected = YES;
            self.btnDetail.selected = NO;
            
//            [UIView animateWithDuration:0.3
//                             animations:^{
//                                 CGRect rect = self.labelGoods.frame;
//                                 rect.origin.x = self.btnGoods.frame.origin.x + 5;
//                                 self.labelGoods.frame = rect;
//                             } completion:^(BOOL finished) {
//                                 
//                             }];
        }
        else if (index >= 1){
            self.btnGoods.selected = NO;
            self.btnDetail.selected = YES;
            
//            [UIView animateWithDuration:0.3
//                             animations:^{
//                                 CGRect rect = self.labelGoods.frame;
//                                 rect.origin.x = self.btnDetail.frame.origin.x + 5;
//                                 self.labelGoods.frame = rect;
//                             } completion:^(BOOL finished) {
//
//                             }];
            
        }
    }
}

@end
