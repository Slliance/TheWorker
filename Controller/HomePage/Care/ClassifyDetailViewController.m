//
//  ClassifyDetailViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/22.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ClassifyDetailViewController.h"
#import "WaresCollectionViewCell.h"
#import "CareGoodsDetailsViewController.h"
#import "GoodsViewModel.h"
#import "StoreGoodsModel.h"
@interface ClassifyDetailViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *classifyCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) GoodsViewModel   *viewModel;
@property (nonatomic, retain) NSMutableArray *itemArr;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation ClassifyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.titleStr;
    self.itemArr = [[NSMutableArray alloc] init];
    [self.classifyCollectionView registerNib:[UINib nibWithNibName:@"WaresCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WaresCollectionViewCell"];
    
    __weak typeof(self)weakSelf = self;
    self.viewModel = [[GoodsViewModel alloc]init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        if (self.pageIndex == 1) {
            [weakSelf.classifyCollectionView.mj_header endRefreshing];
        }else{
            [weakSelf.classifyCollectionView.mj_footer endRefreshing];
        }
        if ([returnValue count]<10) {
            [weakSelf.classifyCollectionView.mj_footer removeFromSuperview];
        }
        [weakSelf.itemArr addObjectsFromArray:returnValue];
        [weakSelf.classifyCollectionView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
        if (self.pageIndex == 1) {
            [weakSelf.classifyCollectionView.mj_header endRefreshing];
        }else{
            [weakSelf.classifyCollectionView.mj_footer endRefreshing];
        }
    }];
    [self setupRefresh];
    
    // Do any additional setup after loading the view from its nib.
}

/**
 *  设置刷新
 */
-(void)setupRefresh
{
    self.classifyCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    self.classifyCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    [self.classifyCollectionView.mj_header beginRefreshing];
    
}
/**
 *  下拉刷新
 */
-(void)headerRefreshing
{
    self.pageIndex = 0;
    [self.itemArr removeAllObjects];
    [self.classifyCollectionView reloadData];
    [self footerRefreshing];
}
/**
 *  上拉刷新
 */
-(void)footerRefreshing
{
    [self.viewModel fetchStoreCategoryListWithToken:[self getToken] storeId:self.shopId page:@(++ self.pageIndex) size:@(10) categoryId:self.goodsId];

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
    return self.itemArr.count;
}
//设置返回每个item的属性必须实现）
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WaresCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WaresCollectionViewCell" forIndexPath:indexPath];
        [cell initCellWithData:self.itemArr[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return  CGSizeMake((ScreenWidth-6)/2, 238*(ScreenWidth/320));
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 6.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 6.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(ScreenWidth, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CareGoodsDetailsViewController *vc = [[CareGoodsDetailsViewController alloc]init];
    StoreGoodsModel *model = self.itemArr[indexPath.row];
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
