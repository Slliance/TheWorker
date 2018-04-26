//
//  WorkerLiveViewController.m
//  TheWorker
//
//  Created by yanghao on 8/19/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "WorkerLiveViewController.h"
#import "WorkerLiveCollectionViewCell.h"

@interface WorkerLiveViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *itemCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *hotLiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (nonatomic,retain)NSMutableArray *itemArr;

@end

@implementation WorkerLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemArr = [[NSMutableArray alloc] init];
    [self.itemArr addObject:@""];
    [self.itemArr addObject:@""];
    [self.itemArr addObject:@""];
    [self.itemArr addObject:@""];

    [self.itemCollectionView registerNib:[UINib nibWithNibName:@"WorkerLiveCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WorkerLiveCollectionViewCell"];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}

- (IBAction)attentionAction:(id)sender {
    self.attentionBtn.selected = YES;
    self.hotLiveBtn.selected = NO;
}
- (IBAction)hotLiveAction:(id)sender {
    self.attentionBtn.selected = NO;
    self.hotLiveBtn.selected = YES;
}

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemArr.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WorkerLiveCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WorkerLiveCollectionViewCell" forIndexPath:indexPath];
    [cell initCell];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScreenWidth / 2 - 15 , 280);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 10, 1, 10);
}

#pragma mark --UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor whiteColor];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor grayColor];
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
