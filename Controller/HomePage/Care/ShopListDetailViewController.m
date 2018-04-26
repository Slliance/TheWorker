//
//  ShopListDetailViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/17.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ShopListDetailViewController.h"
#import "WaresCollectionViewCell.h"
#import "ServiceViewController.h"
#import "CareGoodsDetailsViewController.h"
#import "ChooseClassifyView.h"
#import "ClassifyDetailViewController.h"
#import "GoodsViewModel.h"
#import "StoreModel.h"
#import "StoreGoodsModel.h"
#import "GoodsSearchViewController.h"
@interface ShopListDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelShopName;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *labelStar;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UIButton *btnHomePage;
@property (weak, nonatomic) IBOutlet UILabel *labelHomePage;
@property (weak, nonatomic) IBOutlet UIButton *btnCategory;
@property (weak, nonatomic) IBOutlet UILabel *labelCategory;
@property (weak, nonatomic) IBOutlet UIScrollView *listScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *listCollectionView;
@property (weak, nonatomic) IBOutlet UIView *classifyView;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchBar;

@property (nonatomic, retain) ChooseClassifyView *classView;

@property (nonatomic, retain) NSMutableArray *goodsListArr;
@property (nonatomic, retain) NSMutableArray *categoryArr;
@property (nonatomic, retain) StoreModel *storeModel;
@property (nonatomic, retain) GoodsViewModel *searchViewModel;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation ShopListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.goodsListArr = [[NSMutableArray alloc]init];
    self.categoryArr = [[NSMutableArray alloc]init];
    self.storeModel = [[StoreModel alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;

    //searchBar
    UIImageView *LeftViewNum = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_search_gray"]];
    //图片的显示模式
    LeftViewNum.contentMode= UIViewContentModeCenter;
    //图片的位置和大小
    LeftViewNum.frame= CGRectMake(0,0,30,30);
    //左视图默认是不显示的 设置为始终显示
    self.txtSearchBar.leftViewMode= UITextFieldViewModeAlways;
    self.txtSearchBar.leftView= LeftViewNum;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"666666"];
    //NSAttributedString:带有属性的文字（叫富文本，可以让你的文字丰富多彩）但是这个是不可变的带有属性的文字，创建完成之后就不可以改变了  所以需要可变的
    NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc]initWithString:@"搜索商品" attributes:attrs];
    self.txtSearchBar.attributedPlaceholder = placeHolder;
    self.txtSearchBar.returnKeyType=UIReturnKeySearch;
    self.txtSearchBar.delegate = self;
    self.txtSearchBar.layer.shadowColor = [UIColor colorWithHexString:@"4082f1"].CGColor;
    
    self.txtSearchBar.layer.shadowOffset = CGSizeMake(4, 4);
    
    self.txtSearchBar.layer.shadowOpacity = 0.3f;
    
    self.txtSearchBar.layer.shadowRadius = 4.0;
    
    self.txtSearchBar.layer.cornerRadius = 15.0;
    
    self.txtSearchBar.clipsToBounds = NO;
    
    //tableView
    [self.listCollectionView registerNib:[UINib nibWithNibName:@"WaresCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WaresCollectionViewCell"];
//            self.classView = [[[NSBundle mainBundle]loadNibNamed:@"ChooseClassifyView" owner:self options:nil]firstObject];
    
    
    GoodsViewModel *viewModel = [[GoodsViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        self.storeModel = returnValue[0];
        [self.goodsListArr addObjectsFromArray:returnValue[1]];
        [self.categoryArr addObjectsFromArray:returnValue[2]];
        [self initStoreView];
        [self.listCollectionView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchStoreInfoWithToken:[self getToken] storeId:self.storeId];
    
    __weak typeof(self)weakSelf = self;
    self.searchViewModel = [[GoodsViewModel alloc]init];
    [self.searchViewModel setBlockWithReturnBlock:^(id returnValue) {
        if (self.pageIndex == 1) {
            [weakSelf.listCollectionView.mj_header endRefreshing];
        }else{
            [weakSelf.listCollectionView.mj_footer endRefreshing];
        }
        if ([returnValue count]<10) {
            [weakSelf.listCollectionView.mj_footer removeFromSuperview];
        }
        [weakSelf.goodsListArr addObjectsFromArray:returnValue];
//        if (self.goodsListArr.count == 0) {
//            weakSelf.noDataView.hidden = NO;
//        }else{
//            weakSelf.noDataView.hidden = YES;
//        }
        [weakSelf.listCollectionView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
        
        if (self.pageIndex == 1) {
            [weakSelf.listCollectionView.mj_header endRefreshing];
        }else{
            [weakSelf.listCollectionView.mj_footer endRefreshing];
        }
//        if (self.itemArr.count == 0) {
//            weakSelf.noDataView.hidden = NO;
//        }else{
//            weakSelf.noDataView.hidden = YES;
//        }
    }];
    // Do any additional setup after loading the view from its nib.
}

/**
 *  设置刷新
 */
-(void)setupRefresh
{
    self.listCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    self.listCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    [self.listCollectionView.mj_header beginRefreshing];
    
}
/**
 *  下拉刷新
 */
-(void)headerRefreshing
{
    self.pageIndex = 0;
    [self.goodsListArr removeAllObjects];
    [self.listCollectionView reloadData];
    [self footerRefreshing];
}
/**
 *  上拉刷新
 */
-(void)footerRefreshing
{
    [self.searchViewModel searchGoodsWithName:self.txtSearchBar.text Id:self.storeId token:[self getToken] page:@(++ self.pageIndex)];
}
-(void)initStoreView{
    CGFloat count = [self.storeModel.score floatValue];
    CGRect rect = self.starView.frame;
    for (int i = 0; i < count; i++) {
        UIImage *image = [UIImage imageNamed:@"icon_shop_list_stars"];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        CGFloat width = 12;
        CGFloat margin = 3;
        CGFloat height = rect.size.height;
        CGFloat starX = i*width+i*margin;
        imageView.frame = CGRectMake(starX, 0, width, height);
        [self.starView addSubview:imageView];
    }
    rect.size.width = count * 15;
    self.starView.frame = rect;
    [self.shopImageView setImageWithString:self.storeModel.logo placeHoldImageName:@"bg_no_pictures"];
//    [self.shopImageView setImageWithURL:[NSURL URLWithString:self.storeModel.logo] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
    self.labelShopName.text = self.storeModel.name;
    self.labelStar.text = [NSString stringWithFormat:@"%@分",self.storeModel.score];
    CGRect rectStar = self.labelStar.frame;
    rectStar.origin.x = rect.origin.x + rect.size.width + 5;
    self.labelStar.frame = rectStar;
    self.labelContent.text = [NSString stringWithFormat:@"店铺简介：%@",self.storeModel.describ];
    
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)lookForService:(id)sender {
    ServiceViewController *vc = [[ServiceViewController alloc]init];
    vc.storeModel = self.storeModel;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)homeAction:(id)sender {
    if (self.btnHomePage.selected == NO) {
        self.btnHomePage.selected = YES;
        self.labelHomePage.hidden = NO;
        self.btnCategory.selected = NO;
        self.labelCategory.hidden = YES;
        self.classifyView.hidden = YES;
        self.listCollectionView.hidden = NO;
//        self.itemTableView.contentOffset = CGPointMake(0, 0);
    }
}
- (IBAction)cateGoryAction:(id)sender {
    if (self.btnCategory.selected == NO) {
        self.btnCategory.selected = YES;
        self.labelCategory.hidden = NO;
        self.btnHomePage.selected = NO;
        self.labelHomePage.hidden = YES;
//        self.itemTableView.contentOffset = CGPointMake(0, 0);
        
        self.classifyView.hidden = NO;
        self.listCollectionView.hidden = YES;
        if (!self.classView) {
            self.classView = [[ChooseClassifyView alloc]init];
            self.classView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-196);
            [self.classifyView addSubview:self.classView];
            self.classView.hidden = NO;
            [self.classView initViewWithData:self.categoryArr];
            __weak typeof(self)weakSelf = self;
            [self.classView setReturnItemblock:^(NSInteger item) {
                
                NSLog(@"大类第%ld列被点击了",(long)item);
            }];
            [self.classView setReturnMenublock:^(NSString *item,NSString *str) {
                ClassifyDetailViewController *vc = [[ClassifyDetailViewController alloc]init];
                vc.goodsId = item;
                vc.shopId = weakSelf.storeId;
                vc.titleStr = str;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
        }
    }
}

//设置分区数（必须实现）
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//设置每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodsListArr.count;
}
//设置返回每个item的属性必须实现）
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WaresCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WaresCollectionViewCell" forIndexPath:indexPath];
    [cell initCellWithData:self.goodsListArr[indexPath.row]];
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
    StoreGoodsModel *model = self.goodsListArr[indexPath.row];
    vc.goodsId = model.Id;
        [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    GoodsSearchViewController *vc = [[GoodsSearchViewController alloc] init];
    vc.storeId = self.storeId;
    [self.txtSearchBar resignFirstResponder];
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    id next = self.nextResponder;
    while (![next isKindOfClass:[UIViewController class]]) {
        next = [next nextResponder];
    }
    if (textField.text.length > 0) {
        [self setupRefresh];
//        SearchJobViewController *vc = [[SearchJobViewController alloc]init];
//        vc.searchKey = textField.text;
//
//        vc.hidesBottomBarWhenPushed = YES;
//        WantedJobViewController *homevc = (WantedJobViewController *)next;
//        [homevc.navigationController pushViewController:vc animated:YES];
//    }else{
//        [textField resignFirstResponder];
    }
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
