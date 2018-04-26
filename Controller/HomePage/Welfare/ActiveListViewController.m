//
//  ActiveListViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/15.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ActiveListViewController.h"
#import "ActiveListCollectionViewCell.h"
#import "GoodsDetailViewController.h"
#import "WelfareConvertViewModel.h"
@interface ActiveListViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *activeCollectionView;
@property (nonatomic, retain) NSMutableArray *goodsArr;
@property (nonatomic, retain) WelfareConvertViewModel *viewModel;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation ActiveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.goodsArr = [[NSMutableArray alloc]init];

    if (self.employeeType == 2) {
        self.labelNavTitle.text = @"铂金会员领取商品列表";
    }else{
        self.labelNavTitle.text = @"钻石会员领取商品列表";
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 1.设置列间距
    layout.minimumInteritemSpacing = 0;
    // 2.设置行间距
    layout.minimumLineSpacing = 0;
    // 3.设置每个item的大小
    layout.itemSize = CGSizeMake((ScreenWidth-75)/2, (ScreenWidth-75)/2+70);
    //     4.设置Item的估计大小,用于动态设置item的大小，结合自动布局（self-sizing-cell）
    //    layout.estimatedItemSize = CGSizeMake(60, 120);
    // 5.设置布局方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 6.设置头视图尺寸大小
    layout.headerReferenceSize = CGSizeMake(ScreenWidth, 0);
    // 7.设置尾视图尺寸大小
    layout.footerReferenceSize = CGSizeMake(ScreenWidth, 0);
    // 8.设置分区(组)的EdgeInset（四边距）
    layout.sectionInset = UIEdgeInsetsMake(0, 25, 0, 25);
    // 9.10.设置分区的头视图和尾视图是否始终固定在屏幕上边和下边
    layout.sectionFootersPinToVisibleBounds = YES;
    layout.sectionHeadersPinToVisibleBounds = YES;
    self.activeCollectionView.collectionViewLayout = layout;
    [self.activeCollectionView registerNib:[UINib nibWithNibName:@"ActiveListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ActiveListCollectionViewCell"];
    // Do any additional setup after loading the view from its nib.
//    WelfareConvertViewModel *viewModel = [[WelfareConvertViewModel alloc]init];
//    [viewModel setBlockWithReturnBlock:^(id returnValue) {
//        [self.goodsArr addObjectsFromArray:returnValue];
//        [self.activeCollectionView reloadData];
//    } WithErrorBlock:^(id errorCode) {
//        [self showJGProgressWithMsg:errorCode];
//    }];
//    [viewModel getGoodsListWithToken:[self getToken] level:[NSString stringWithFormat:@"%ld",(long)self.employeeType] page:@(1)];
    self.viewModel = [[WelfareConvertViewModel alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        if (self.pageIndex == 1) {
            [weakSelf.goodsArr removeAllObjects];
            [weakSelf.activeCollectionView.mj_header endRefreshing];
        }
        else{
            [weakSelf.activeCollectionView.mj_footer endRefreshing];
        }
        
        if ([(NSArray *)returnValue count] < 10) {
            [weakSelf.activeCollectionView.mj_footer removeFromSuperview];
        }
        else{
            weakSelf.activeCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(footerRefreshing)];
        }
        [weakSelf.goodsArr addObjectsFromArray:returnValue];
        [weakSelf.activeCollectionView reloadData];
    } WithErrorBlock:^(id errorCode) {
        if (self.pageIndex == 1) {
            [weakSelf.activeCollectionView.mj_header endRefreshing];
        }
        else{
            [weakSelf.activeCollectionView.mj_footer endRefreshing];
        }
        
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    [self setupRefresh];
}

/**
 *  设置刷新
 */
-(void)setupRefresh
{
    self.activeCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    [self.activeCollectionView.mj_header beginRefreshing];
}
/**
 *  下拉刷新
 */
-(void)headerRefreshing
{
    self.pageIndex = 0;
    [self footerRefreshing];
}
/**
 *  上拉刷新
 */
-(void)footerRefreshing
{
    [self.viewModel getGoodsListWithToken:[self getToken] level:[NSString stringWithFormat:@"%ld",(long)self.employeeType] page:@(++ self.pageIndex)];
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}

//设置分区数（必须实现）
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//设置每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.goodsArr.count;
    
}

//设置返回每个item的属性必须实现）
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ActiveListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActiveListCollectionViewCell" forIndexPath:indexPath];
    [cell initCellWith:self.goodsArr[indexPath.row]];
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc]init];
    GoodsModel *model = self.goodsArr[indexPath.row];
    vc.goodsId = model.Id;
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
