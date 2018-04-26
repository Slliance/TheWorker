//
//  MyCollectionViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/30.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "CollectScoreGoodsTableViewCell.h"
#import "WantedJobTableViewCell.h"
#import "CollectFoodTableViewCell.h"
#import "GoodsDetailViewController.h"
#import "CareGoodsDetailsViewController.h"
#import "WantedJobDetailViewController.h"
#import "InfoDetailViewController.h"
#import "WorkerDetailViewController.h"
#import "CollectViewModel.h"
#import "CollectModel.h"
#import "JobModel.h"
#import "ArticleModel.h"
#import "HandInModel.h"
@interface MyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger currentIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnEditing;
@property (nonatomic, retain) UILabel *lineLabel;
@property (nonatomic, assign) NSInteger selectedTag;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *deleteView;
@property (weak, nonatomic) IBOutlet UIButton *btnAllSelect;
@property (weak, nonatomic) IBOutlet UIImageView *imageAllSelect;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (nonatomic, retain) NSMutableArray *deleteArr;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) CollectViewModel *viewModel;
@property (nonatomic, retain) NSMutableArray *itemArr;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentIndex = 1;
    [self crateHeaderView];
    self.dataArray = [[NSMutableArray alloc]init];
    self.deleteArr = [[NSMutableArray alloc]init];
//    [self.dataArray addObjectsFromArray:array];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"CollectScoreGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CollectScoreGoodsTableViewCell"];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"WantedJobTableViewCell" bundle:nil] forCellReuseIdentifier:@"WantedJobTableViewCell"];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"CollectFoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"CollectFoodTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.viewModel = [[CollectViewModel alloc] init];
    
    __weak typeof(self)weakSelf = self;
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        
        if (self.pageIndex == 1) {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.itemTableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
        [weakSelf.dataArray addObjectsFromArray:returnValue];
        [weakSelf.itemTableView reloadData];
        if ([self.dataArray count]<10) {
            [weakSelf.itemTableView.mj_footer removeFromSuperview];
        }
        
        if (self.dataArray.count == 0) {
            weakSelf.noDataView.hidden = NO;
            weakSelf.itemTableView.hidden = YES;
        }else{
            weakSelf.noDataView.hidden = YES;
            weakSelf.itemTableView.hidden = NO;
        }
        
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
        [weakSelf.itemTableView.mj_header endRefreshing];
        if (self.dataArray.count == 0) {
            weakSelf.noDataView.hidden = NO;
            weakSelf.itemTableView.hidden = YES;
        }
        else{
            weakSelf.noDataView.hidden = YES;
            weakSelf.itemTableView.hidden = NO;
        }
        
    }];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self headerRefreshing];
}

/**
 *  设置刷新
 */
-(void)setupRefresh
{
    self.itemTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    self.itemTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    [self.itemTableView.mj_header beginRefreshing];
    
}
/**
 *  下拉刷新
 */
-(void)headerRefreshing
{
    self.pageIndex = 0;
    [self.dataArray removeAllObjects];
//    [self.itemTableView reloadData];
    [self footerRefreshing];
}
/**
 *  上拉刷新
 */
-(void)footerRefreshing
{
    [self.viewModel fetchMyCollectionWithToken:[self getToken] type:@(currentIndex) page:@(++ self.pageIndex)];
}

- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)editingAction:(id)sender {
    self.itemTableView.allowsMultipleSelectionDuringEditing = YES;
    self.itemTableView.editing = !self.itemTableView.editing;
    if (self.itemTableView.editing == YES) {
        self.scrollView.userInteractionEnabled = NO;
        [self.btnEditing setTitle:@"完成" forState:UIControlStateNormal];
        self.deleteView.hidden = NO;
    }else{
        self.scrollView.userInteractionEnabled = YES;
        [self.btnEditing setTitle:@"编辑" forState:UIControlStateNormal];
        self.deleteView.hidden = YES;
    }
    
}
- (IBAction)deleteAction:(id)sender {
    if (self.itemTableView.editing) {
        NSMutableArray *idArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.deleteArr.count; i ++) {
            NSInteger index = [self.deleteArr[i] integerValue];
            if (currentIndex == 1) {
                CollectModel *model = self.dataArray[index];
                NSString *idStr = [NSString stringWithFormat:@"%@",model.collect_id];
                [idArr addObject:idStr];
            }else if (currentIndex == 2){
                CollectModel *model = self.dataArray[index];
                NSString *idStr = [NSString stringWithFormat:@"%@",model.collect_id];
                [idArr addObject:idStr];
            }else if (currentIndex == 3){
                JobModel *model = self.dataArray[index];
                NSString *idStr = [NSString stringWithFormat:@"%@",model.collect_id];
                [idArr addObject:idStr];
            }else if (currentIndex == 9){
                HandInModel *model = self.dataArray[index];
                NSString *idStr = [NSString stringWithFormat:@"%@",model.collect_id];
                [idArr addObject:idStr];
            }else{
                ArticleModel *model = self.dataArray[index];
                NSString *idStr = [NSString stringWithFormat:@"%@",model.collect_id];
                [idArr addObject:idStr];
            }
        }
        //删除
        CollectViewModel *viewModel = [[CollectViewModel alloc] init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [self headerRefreshing];
            [self showJGProgressWithMsg:@"删除成功"];
            [self.btnEditing setTitle:@"编辑" forState:UIControlStateNormal];
            self.deleteView.hidden = YES;
            [self.deleteArr removeAllObjects];
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel deleteMyCollectionWithToken:[self getToken] Ids:idArr];
        
        
    }
    
    else return;

    
}
- (IBAction)allSelectAction:(id)sender {
    if (self.btnAllSelect.selected == NO) {
        self.btnAllSelect.selected = YES;
        self.imageAllSelect.image = [UIImage imageNamed:@"icon_circle_selected"];
        [self.deleteArr removeAllObjects];
        for (int i = 0; i < self.dataArray.count; i ++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.itemTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self.deleteArr addObject:@(i)];

        }
        
        NSLog(@"self.deleteArr:%@", self.deleteArr);
        
    }else{
        self.btnAllSelect.selected = NO;
        self.imageAllSelect.image = [UIImage imageNamed:@"icon_circle_not_selected"];
        for (int i = 0; i < self.dataArray.count; i ++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.itemTableView deselectRowAtIndexPath:indexPath animated:YES];
            
        }
        [self.deleteArr removeAllObjects];
        NSLog(@"self.deleteArr:%@", self.deleteArr);

    }
    
    
}



#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (currentIndex == 1) {
        CollectScoreGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectScoreGoodsTableViewCell"];
        [cell initCellWithData:self.dataArray[indexPath.row]];
        return cell;
    }
    
    if (currentIndex == 2) {
        CollectScoreGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectScoreGoodsTableViewCell"];
        [cell initCellWithData:self.dataArray[indexPath.row]];
        NSLog(@"%@",self.dataArray[indexPath.row]);
        return cell;
    }
    if (currentIndex == 3) {
        WantedJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WantedJobTableViewCell"];
        NSLog(@"%@",self.dataArray[indexPath.row]);
        [cell initCellWithData:self.dataArray[indexPath.row]];
    return cell;
    }
    CollectFoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectFoodTableViewCell"];
    [cell initCellWithData:self.dataArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (currentIndex == 1 || currentIndex == 2) {
        return 140.f;
    }
    if (currentIndex == 3) {
        return 75.f;
    }
        return 88.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark - UITableViewDelegate

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}

//选中时将选中行的在self.dataArray 中的数据添加到删除数组self.deleteArr中

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.itemTableView.editing == YES) {
        [self.deleteArr addObject:@(indexPath.row)];
//        if (currentIndex == 1) {
//            CollectModel *model = self.dataArray[indexPath.row];
//            NSString *idStr = [NSString stringWithFormat:@"%@",model.Id];
//            [self.deleteArr addObject:idStr];
//        }else if (currentIndex == 2){
//            CollectModel *model = self.dataArray[indexPath.row];
//            NSString *idStr = [NSString stringWithFormat:@"%@",model.Id];
//            [self.deleteArr addObject:idStr];
//        }else if (currentIndex == 3){
//            JobModel *model = self.dataArray[indexPath.row];
//            NSString *idStr = [NSString stringWithFormat:@"%@",model.Id];
//            [self.deleteArr addObject:idStr];
//        }else if (currentIndex == 9){
//            HandInModel *model = self.dataArray[indexPath.row];
//            NSString *idStr = [NSString stringWithFormat:@"%@",model.Id];
//            [self.deleteArr addObject:idStr];
//        }else{
//            ArticleModel *model = self.dataArray[indexPath.row];
//            NSString *idStr = [NSString stringWithFormat:@"%@",model.Id];
//            [self.deleteArr addObject:idStr];
//        }
    
    }else{
        if (currentIndex == 1) {
            GoodsDetailViewController *vc = [[GoodsDetailViewController alloc]init];
            CollectModel *model = self.dataArray[indexPath.row];
            vc.goodsId = model.Id;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (currentIndex == 2){
            CareGoodsDetailsViewController *vc = [[CareGoodsDetailsViewController alloc]init];
            CollectModel *model = self.dataArray[indexPath.row];
            vc.goodsId = model.Id;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (currentIndex == 3){
            WantedJobDetailViewController *vc = [[WantedJobDetailViewController alloc]init];
            JobModel *model = self.dataArray[indexPath.row];
            vc.jobModel = model;
            [vc setReturnReloadBlock:^(JobModel *model) {
                self.itemArr[indexPath.row] = model;
                [self.itemTableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (currentIndex == 9){
            WorkerDetailViewController *vc = [[WorkerDetailViewController alloc] init];
            HandInModel *model = self.dataArray[indexPath.row];
            vc.handInId = model.Id;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            InfoDetailViewController *vc = [[InfoDetailViewController alloc]init];
            ArticleModel *model = self.dataArray[indexPath.row];
            vc.articleModel = model;
            vc.bannerUrl = model.detail_url;
            vc.articleId = model.Id;
            vc.isCollect = 1;
            vc.type = @(currentIndex);
            [vc setReturnReloadBlock:^{
                [self headerRefreshing];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//取消选中时 将存放在self.deleteArr中的数据移除

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
//    if (currentIndex == 1) {
//        CollectModel *model = self.dataArray[indexPath.row];
//        NSString *idStr = [NSString stringWithFormat:@"%@",model.Id];
//        [self.deleteArr removeObject:idStr];
//    }else if (currentIndex == 2){
//        CollectModel *model = self.dataArray[indexPath.row];
//        NSString *idStr = [NSString stringWithFormat:@"%@",model.Id];
//        [self.deleteArr removeObject:idStr];
//    }else if (currentIndex == 3){
//        JobModel *model = self.dataArray[indexPath.row];
//        NSString *idStr = [NSString stringWithFormat:@"%@",model.Id];
//        [self.deleteArr removeObject:idStr];
//    }else if (currentIndex == 9){
//        HandInModel *model = self.dataArray[indexPath.row];
//        NSString *idStr = [NSString stringWithFormat:@"%@",model.Id];
//        [self.deleteArr removeObject:idStr];
//    }else{
//        ArticleModel *model = self.dataArray[indexPath.row];
//        NSString *idStr = [NSString stringWithFormat:@"%@",model.Id];
//        [self.deleteArr removeObject:idStr];
//    }
    [self.deleteArr removeObject:@(indexPath.row)];
}

-(void)crateHeaderView{
    NSArray *titleArr = @[@"积分商品",@"商城商品",@"求职信息",@"餐饮信息",@"房源信息",@"员工资讯",@"创业资讯",@"福利信息",@"员工相亲"];
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.frame = CGRectMake(0, 0, ScreenWidth, 45);
    for (int i = 0; i < titleArr.count; i ++) {
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.tag = 200+i;
        [btn setTitleColor:[UIColor colorWithHexString:@"6398f1"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        CGSize size = [titleArr[i] sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(100, 100)];
        if (i == 0) {
            btn.frame = CGRectMake(15, 0, size.width, 45);
            btn.selected = YES;
        }else{
            btn.frame = CGRectMake(15 + size.width*i+20*i, 0, size.width, 45);
            btn.selected = NO;
        }
        
        [btn addTarget:self action:@selector(headerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
    }
    self.lineLabel = [[UILabel alloc]init];
    self.lineLabel.backgroundColor = [UIColor colorWithHexString:@"6398f1"];
    self.lineLabel.frame = CGRectMake(15, 43, 61.2, 2);
    [self.scrollView addSubview:self.lineLabel];
    self.scrollView.contentSize = CGSizeMake(81.2*9, 45);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:self.scrollView];
    [self.view addSubview:self.headerView];

}
-(void)headerBtnAction:(UIButton *)btn{
    for (UIButton *btn in self.scrollView.subviews) {
        if (btn.tag > 99) {
            //            [btn removeFromSuperview];
            //将所有按钮设置为未选中的状态
            btn.selected = NO;
        }
    }
    if (self.itemTableView.editing == YES) {
        return;
    }
    //将选中按钮设置为选中状态
    btn.selected = YES;
    currentIndex = btn.tag-200 + 1;
    [self.dataArray removeAllObjects];
    [self headerRefreshing];
    
    self.lineLabel.center = btn.center;
    CGRect rect = self.lineLabel.frame;
    rect.origin.y = 43;
    self.lineLabel.frame = rect;
    //    }
    NSLog(@"%ld",(long)currentIndex);
//    if (self.btnAllSelect.selected == YES) {
//        self.btnAllSelect.selected = NO;
//        self.imageAllSelect.image = [UIImage imageNamed:@"icon_circle_not_selected"];
//        for (int i = 0; i < self.dataArray.count; i ++) {
//
//            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//            [self.itemTableView deselectRowAtIndexPath:indexPath animated:YES];
//            [self.deleteArr removeAllObjects];
//
//        }
//
//        NSLog(@"self.deleteArr:%@", self.deleteArr);
//
//    }
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
