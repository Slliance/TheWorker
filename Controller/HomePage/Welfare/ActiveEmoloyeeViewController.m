//
//  ActiveEmoloyeeViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/15.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ActiveEmoloyeeViewController.h"
#import "WelfareActiveCollectionViewCell.h"
#import "HomeScrollTableViewCell.h"
#import "WelfareScrollCollectionViewCell.h"
#import "ActiveListViewController.h"
#import "GoodsDetailViewController.h"
#import "WelfareConvertViewModel.h"

@interface ActiveEmoloyeeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *activeCollectionView;
@property (nonatomic, retain) NSMutableArray *goodsArr;
@property (nonatomic, retain) NSMutableArray *bannerArr;
@end

@implementation ActiveEmoloyeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.goodsArr = [[NSMutableArray alloc]init];
    self.bannerArr = [[NSMutableArray alloc]init];
    if (self.employeetype == 2) {
        self.labelNavTitle.text = @"铂金会员积分商城";
    }else{
        self.labelNavTitle.text = @"钻石会员积分商城";
    }
    [self.activeCollectionView registerNib:[UINib nibWithNibName:@"WelfareActiveCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WelfareActiveCollectionViewCell"];
    [self.activeCollectionView registerNib:[UINib nibWithNibName:@"WelfareScrollCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WelfareScrollCollectionViewCell"];
    [self.activeCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
    [self.activeCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeaderTwo"];

    // Do any additional setup after loading the view from its nib.
    WelfareConvertViewModel *viewModel = [[WelfareConvertViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self.goodsArr addObjectsFromArray:returnValue[0]];
        [self.bannerArr addObjectsFromArray:returnValue[1]];
        [self.activeCollectionView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel getConvertMainPageWithToken:[self getToken] level:[NSString stringWithFormat:@"%ld",(long)self.employeetype]];
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}

//设置分区数（必须实现）
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

//设置每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.goodsArr.count;
    }
    return 1;
}

//设置返回每个item的属性必须实现）
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        WelfareActiveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WelfareActiveCollectionViewCell" forIndexPath:indexPath];
        [cell initCellWith:self.goodsArr[indexPath.row]];
        return cell;
    }
    WelfareScrollCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WelfareScrollCollectionViewCell" forIndexPath:indexPath];
    [cell initBannerView:self.bannerArr];
    [cell setEndDeceleratingBlock:^{
        NSLog(@"");
    }];
    [cell setBeginDraggingBlock:^{
        NSLog(@"");
    }];
    
    return cell;
}

//对头视图或者尾视图进行设置
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader" forIndexPath:indexPath];
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(ScreenWidth-60, 0, 50, 34);
        [btn setTitle:@"更多" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_more-"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        [btn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -65)];
        [btn addTarget:self action:@selector(skipToEmplloyeeInfo) forControlEvents:UIControlEventTouchUpInside];
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(15, 0, 150, 40);
        label.text = @"本期可兑换的商品";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithHexString:@"333333"];
        UILabel *lineLabel = [[UILabel alloc]init];
        lineLabel.frame = CGRectMake(0, 10, 4, 15);
        lineLabel.backgroundColor = [UIColor colorWithHexString:@"6398f1"];
        [view addSubview:lineLabel];
        [view addSubview:btn];
        [view addSubview:label];
        return view;
    }
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeaderTwo" forIndexPath:indexPath];
        UILabel *lineLabel = [[UILabel alloc]init];
        lineLabel.frame = CGRectMake(0, 10, 4, 15);
        lineLabel.backgroundColor = [UIColor colorWithHexString:@"6398f1"];
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(15, 0, 150, 40);
        label.text = @"新品推荐";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithHexString:@"333333"];
        [view addSubview:label];
        [view addSubview:lineLabel];
        return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return  CGSizeMake(ScreenWidth/3, ScreenWidth/320*120);
    }
    return CGSizeMake(ScreenWidth, 100);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(ScreenWidth, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        GoodsDetailViewController *vc = [[GoodsDetailViewController alloc]init];
        GoodsModel *model = self.goodsArr[indexPath.row];
        vc.goodsId = model.Id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(void)skipToEmplloyeeInfo{
    ActiveListViewController *vc = [[ActiveListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.employeeType = self.employeetype;
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
