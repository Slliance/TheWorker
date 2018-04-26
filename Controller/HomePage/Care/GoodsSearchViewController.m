//
//  GoodsSearchViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 13/12/2017.
//  Copyright © 2017 huying. All rights reserved.
//

#import "GoodsSearchViewController.h"
#import "GoodsViewModel.h"
#import "WaresCollectionViewCell.h"
#import "CareGoodsDetailsViewController.h"
@interface GoodsSearchViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UICollectionView *itemCollectionView;

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, retain) NSMutableArray *itemArr;
@property (nonatomic, retain) GoodsViewModel *viewModel;
@end

@implementation GoodsSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemArr = [[NSMutableArray alloc]init];
    self.txtSearchBar.layer.masksToBounds = YES;
    self.txtSearchBar.layer.cornerRadius = 15.f;
    self.txtSearchBar.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    self.txtSearchBar.layer.borderWidth = 1;
    UIImageView *LeftViewNum = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_search_gray"]];
    //图片的显示模式
    LeftViewNum.contentMode= UIViewContentModeCenter;
    //图片的位置和大小
    LeftViewNum.frame= CGRectMake(20,0,30,30);
    //左视图默认是不显示的 设置为始终显示
    self.txtSearchBar.leftViewMode= UITextFieldViewModeAlways;
    self.txtSearchBar.leftView= LeftViewNum;
    self.txtSearchBar.returnKeyType = UIReturnKeySearch;
    self.txtSearchBar.delegate = self;
    [self.itemCollectionView registerNib:[UINib nibWithNibName:@"WaresCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WaresCollectionViewCell"];
    [self setNeedsStatusBarAppearanceUpdate];
    
    __weak typeof(self)weakSelf = self;
    self.viewModel = [[GoodsViewModel alloc]init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        if (self.pageIndex == 1) {
            [weakSelf.itemCollectionView.mj_header endRefreshing];
        }else{
            [weakSelf.itemCollectionView.mj_footer endRefreshing];
        }
        if ([returnValue count]<10) {
            [weakSelf.itemCollectionView.mj_footer removeFromSuperview];
        }
        [weakSelf.itemArr addObjectsFromArray:returnValue];
        if (self.itemArr.count == 0) {
            weakSelf.noDataView.hidden = NO;
        }else{
            weakSelf.noDataView.hidden = YES;
        }
        [weakSelf.itemCollectionView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
        
        if (self.pageIndex == 1) {
            [weakSelf.itemCollectionView.mj_header endRefreshing];
        }else{
            [weakSelf.itemCollectionView.mj_footer endRefreshing];
        }
        if (self.itemArr.count == 0) {
            weakSelf.noDataView.hidden = NO;
        }else{
            weakSelf.noDataView.hidden = YES;
        }
    }];
    [self setupRefresh];
    
    // Do any additional setup after loading the view from its nib.
}

//2、当前页面不在导航控制器中，需重写preferredStatusBarStyle，如下：
-(UIStatusBarStyle)preferredStatusBarStyle {
    
    //     return UIStatusBarStyleLightContent; //白色
    
    return UIStatusBarStyleDefault; //黑色
}
/**
 *  设置刷新
 */
-(void)setupRefresh
{
    self.itemCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    self.itemCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    [self.itemCollectionView.mj_header beginRefreshing];
    
}
/**
 *  下拉刷新
 */
-(void)headerRefreshing
{
    self.pageIndex = 0;
    [self.itemArr removeAllObjects];
    [self.itemCollectionView reloadData];
    [self footerRefreshing];
}
/**
 *  上拉刷新
 */
-(void)footerRefreshing
{
    [self.viewModel searchGoodsWithName:self.txtSearchBar.text Id:self.storeId token:[self getToken] page:@(++ self.pageIndex)];
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:nil];
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self setupRefresh];
    return YES;
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
