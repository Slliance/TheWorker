//
//  ChooseMatchMakingController.m
//  TheWorker
//
//  Created by apple on 2018/4/27.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "ChooseMatchMakingController.h"
#import "HandInHandInformationController.h"
#import "MatchMakingInformationView.h"
#import "MatchMakingInformationController.h"
#import <ZLSwipeableView.h>
#import "ChooseMatchMakingCell.h"
#import "HandWorkerListViewController.h"
#import "V_SlideCard.h"
#import "M_TanTan.h"
#import "V_TanTan.h"
@interface ChooseMatchMakingController ()<ZLSwipeableViewDelegate, ZLSwipeableViewDataSource,UITableViewDelegate,UITableViewDataSource,V_SlideCardDataSource, V_SlideCardDelegate, UICollectionViewDelegate>
{
    NSInteger _pageNo;//数据页码
    CGFloat _buttonWidth;
    CGFloat _buttonBorderWidth;
}
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic) NSUInteger colorIndex;
@property (nonatomic, strong) NSArray *titles;
@property(nonatomic,strong)UIImageView *bgImageView;
@property(nonatomic,strong)UIImageView *backgroundImage;
@property(nonatomic,strong)MatchMakingInformationView *matchView;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIButton *editBtn;
@property(nonatomic,strong)UIButton *listBtn;
@property (nonatomic, strong) V_SlideCard *slideCard;
@property (nonatomic, strong) NSMutableArray *listData;
@end

@implementation ChooseMatchMakingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.backBtn];
    [self.bgImageView addSubview:self.editBtn];
    [self.bgImageView addSubview:self.backgroundImage];
    [self.bgImageView addSubview:self.listBtn];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView);
        make.bottom.equalTo(self.bgImageView.mas_top).offset(64);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImageView);
        make.bottom.equalTo(self.bgImageView.mas_top).offset(64);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    [self.listBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.editBtn.mas_left);
        make.bottom.equalTo(self.bgImageView.mas_top).offset(64);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(80);
    }];
    [self.backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView).offset(7);
        make.top.equalTo(self.bgImageView).offset(64);
        make.right.equalTo(self.bgImageView).offset(-7);
        make.bottom.equalTo(self.bgImageView).offset(-7);
    }];
     [self.view addSubview:self.slideCard];//加入滑动组件
    
}


#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    if (self.colorIndex >= self.colors.count || self.colorIndex >= self.titles.count) {
        self.colorIndex = 0;
    }
    
    MatchMakingInformationView *view = [[MatchMakingInformationView alloc] init];
    view.frame = CGRectMake(37, 142, ScreenWidth-70,538);
    view.backgroundColor = [UIColor redColor];
    view.bgImageView.image = [UIImage imageNamed:@"photo"];
    self.colorIndex++;
    return view;
}

#pragma mark - event response

- (void)likeOrHateAction:(UIButton *)sender {
    // 按钮点击缩放效果
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.08;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.9];
    pulse.toValue= [NSNumber numberWithFloat:1.1];
    [sender.layer addAnimation:pulse forKey:nil];
    
    if (sender.tag == 520) {
        [self.slideCard animateTopCardToDirection:PanDirectionRight];
    } else {
        [self.slideCard animateTopCardToDirection:PanDirectionLeft];
    }
}

#pragma mark - V_SlideCardDataSource
- (void)loadNewDataInSlideCard:(V_SlideCard *)slideCard {
    _pageNo ++;
    self.listData = [self getDataSourceWithPageNo:_pageNo];
    [self.slideCard reloadData];
}

- (void)slideCard:(V_SlideCard *)slideCard loadNewDataInCell:(V_SlideCardCell *)cell atIndex:(NSInteger)index {
 
        V_TanTan *tantanCell = (V_TanTan *)cell;
        M_TanTan *item = [self.listData objectAtIndex:index];
        tantanCell.dataItem = item;
   
}

- (NSInteger)numberOfItemsInSlideCard:(V_SlideCard *)slideCard {
    return self.listData.count;
}

#pragma mark - V_SlideCardDelegate

- (void)slideCard:(V_SlideCard *)slideCard topCell:(V_SlideCardCell *)cell didPanPercent:(CGFloat)percent withDirection:(PanDirection)direction atIndex:(NSInteger)index {
        V_TanTan *tantanCell = (V_TanTan *)cell;
        if (direction == PanDirectionRight) {
            tantanCell.iv_like.alpha = percent;
//            self.btn_like.layer.borderWidth = _buttonBorderWidth * (1 - percent);
        } else {
            tantanCell.iv_hate.alpha = percent;
//            self.btn_hate.layer.borderWidth = _buttonBorderWidth * (1 - percent);
        }
    
}

- (void)slideCard:(V_SlideCard *)slideCard topCell:(V_SlideCardCell *)cell willScrollToDirection:(PanDirection)direction atIndex:(NSInteger)index {
   
        V_TanTan *tantanCell = (V_TanTan *)cell;
        if (direction == PanDirectionRight) {
            tantanCell.iv_like.alpha = 1;
        } else {
            tantanCell.iv_hate.alpha = 1;
        }
}

- (void)slideCard:(V_SlideCard *)slideCard topCell:(V_SlideCardCell *)cell didChangedStateWithDirection:(PanDirection)direction atIndex:(NSInteger)index {
   
        V_TanTan *tantanCell = (V_TanTan *)cell;
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//            self.btn_like.layer.borderWidth = _buttonBorderWidth;
//            self.btn_hate.layer.borderWidth = _buttonBorderWidth;
            tantanCell.iv_like.alpha = 0;
            tantanCell.iv_hate.alpha = 0;
        } completion:nil];
   
}

- (void)slideCard:(V_SlideCard *)slideCard didResetFrameInCell:(V_SlideCardCell *)cell atIndex:(NSInteger)index {
   
        V_TanTan *tantanCell = (V_TanTan *)cell;
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//            self.btn_like.layer.borderWidth = _buttonBorderWidth;
//            self.btn_hate.layer.borderWidth = _buttonBorderWidth;
            tantanCell.iv_like.alpha = 0;
            tantanCell.iv_hate.alpha = 0;
        } completion:nil];
}

- (void)slideCard:(V_SlideCard *)slideCard didSelectCell:(V_SlideCardCell *)cell atIndex:(NSInteger)index {
   
        V_TanTan *tantanCell = (V_TanTan *)cell;
        NSLog(@"tantan userName = %@", tantanCell.dataItem.userName);
    
}

#pragma mark - private methods

- (void)leftBarButtonClick {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightBarButtonClick { }

#pragma mark - getter

- (V_SlideCard *)slideCard {
    if (_slideCard == nil) {
        _slideCard = [[V_SlideCard alloc] initWithFrame:CGRectMake(0, 95, ScreenWidth, ScreenHeight-64-60)];
        _slideCard.cellScaleSpace = 0.06;
        _slideCard.cellCenterYOffset = - 100;
        
        _slideCard.cellSize = CGSizeMake(ScreenWidth-67, ScreenHeight-64-60);
        NSString *cellClassName = @"";
        cellClassName = @"V_TanTan";
        _slideCard.panDistance = 150;
        [_slideCard registerCellClassName:cellClassName];
        _slideCard.dataSource = self;
        _slideCard.delegate = self;
    }
    return _slideCard;
}

- (NSMutableArray *)listData {
    if (_listData == nil) {
        _listData = [[NSMutableArray alloc] init];
        _listData = [[self getDataSourceWithPageNo:0] copy];
    }
    return _listData;
}

- (NSMutableArray *)getDataSourceWithPageNo:(NSInteger)pageNo {
    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 10; i++) {
        NSString *imageName = [NSString stringWithFormat:@"tantan%d%lu", 0,i];
        NSString *nickName = [NSString stringWithFormat:@"姓名%lu%lu", pageNo,i];
        
        [itemArray addObject:[[M_TanTan alloc] initWithImage:imageName andName:nickName andConstellation:@"某星座" andJob:@"职位" andDistance:[NSString stringWithFormat:@"%lu%lukm", pageNo,i] andAge:@"23岁"]];
    }
    return itemArray;
}








-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = [UIImage imageNamed:@"bg_gradient"];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}
-(UIImageView *)backgroundImage{
    if (!_backgroundImage) {
        _backgroundImage = [[UIImageView alloc]init];
        _backgroundImage.image = [UIImage imageNamed:@"pic_frame"];
        _backgroundImage.userInteractionEnabled = YES;
    }
    return _backgroundImage;
}
-(MatchMakingInformationView *)matchView{
    if (!_matchView) {
        _matchView = [[MatchMakingInformationView alloc]init];
//        _matchView.alpha = 0.6;
        _matchView.userInteractionEnabled = YES;
        _matchView.backgroundColor = [UIColor whiteColor];
        [_matchView.inputBtn addTarget:self action:@selector(pressInputBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _matchView;
}
-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
-(UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setImage:[UIImage imageNamed:@"holdinghands_icon_edit"] forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}
-(UIButton *)listBtn{
    if (!_listBtn) {
        _listBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_listBtn setTitle:@"列表查看" forState:UIControlStateNormal];
        [_listBtn addTarget:self action:@selector(presslistBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _listBtn;
}
-(void)pressInputBtn:(UIButton*)sender{
    MatchMakingInformationController *informationVC = [[MatchMakingInformationController alloc]init];
    [self.navigationController pushViewController:informationVC animated:YES];
}
-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)pressEditBtn{
    HandInHandInformationController *changeVc = [[HandInHandInformationController alloc]init];
    [self.navigationController pushViewController:changeVc animated:YES];
}
-(void)presslistBtn{
    HandWorkerListViewController * listVC = [[HandWorkerListViewController alloc]init];
    [self.navigationController pushViewController:listVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
