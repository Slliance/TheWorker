//
//  EmployeeSaleViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/16.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "EmployeeSaleViewController.h"
#import "ShopHeadView.h"
#import "ShopCollectionViewCell.h"
#import "ShopListViewController.h"
#import "CareGoodsDetailsViewController.h"
#import "ShopListDetailViewController.h"
#import "GoodsSearchViewController.h"
#import "StoreModel.h"
#import "GoodsViewModel.h"
#import "MSWeakTimer.h"
@interface EmployeeSaleViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *shopListCollectionView;
@property (nonatomic, retain) ShopHeadView  *headView;
@property (nonatomic, retain) NSMutableArray *bannerArray;
@property (nonatomic, retain) NSMutableArray *storeArray;
@property (nonatomic, retain) MSWeakTimer *bannerTimer;
@end

@implementation EmployeeSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bannerArray = [[NSMutableArray alloc]init];
    self.storeArray = [[NSMutableArray alloc]init];

    [self.shopListCollectionView registerNib:[UINib nibWithNibName:@"ShopHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ShopHeadView"];
    [self.shopListCollectionView registerNib:[UINib nibWithNibName:@"ShopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ShopCollectionViewCell"];
    // Do any additional setup after loading the view from its nib.
    
    GoodsViewModel *viewModel = [[GoodsViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self.bannerArray addObjectsFromArray:returnValue[0]];
        [self.storeArray addObjectsFromArray:returnValue[1]];
        CGRect rect = self.shopListCollectionView.frame;
        if (self.bannerArray.count == 0) {
            rect.origin.y = 74;
            rect.size.height = rect.size.height - 10;
        }
        self.shopListCollectionView.frame = rect;
        [self.shopListCollectionView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchWorkerShoppingMainpageWithToken:[self getToken]];
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)skipToMoreShop:(id)sender {
    ShopListViewController *vc = [[ShopListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)skipToSearch:(id)sender {
    GoodsSearchViewController *vc = [[GoodsSearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



//设置分区数（必须实现）
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//设置每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.storeArray.count;
}
//设置返回每个item的属性必须实现）
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShopCollectionViewCell" forIndexPath:indexPath];
    [cell initCellWithData:self.storeArray[indexPath.row]];
        return cell;
}

//对头视图或者尾视图进行设置
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    self.headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ShopHeadView" forIndexPath:indexPath];
    [self.headView initBannerView:self.bannerArray];
    self.bannerTimer = [MSWeakTimer scheduledTimerWithTimeInterval:5 target:self.headView selector:@selector(timerStart) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
    __weak typeof(self) weakSelf = self;
    [self.headView setBeginDraggingBlock:^{
        weakSelf.bannerTimer = [MSWeakTimer scheduledTimerWithTimeInterval:5 target:weakSelf.headView selector:@selector(timerStart) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
        NSLog(@"'");
    }];
    [self.headView setEndDeceleratingBlock:^{
        [weakSelf.bannerTimer invalidate];
        NSLog(@"");
    }];

       return self.headView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

        return  CGSizeMake((ScreenWidth-100)/3, 120*(ScreenWidth/320));
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 25, 0, 25);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.bannerArray.count == 0) {
            return CGSizeMake(ScreenWidth, 0);
        }
        return CGSizeMake(ScreenWidth, 150);
    }
    return CGSizeMake(ScreenWidth, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ShopListDetailViewController *vc = [[ShopListDetailViewController alloc]init];
    StoreModel *model = self.storeArray[indexPath.row];
    vc.storeId = model.Id;
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
