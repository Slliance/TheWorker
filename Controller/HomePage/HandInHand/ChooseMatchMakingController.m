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
#import "ChooseMatchMakingListController.h"

@interface ChooseMatchMakingController ()<ZLSwipeableViewDelegate, ZLSwipeableViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic) NSUInteger colorIndex;
@property (nonatomic, strong) NSArray *titles;
@property(nonatomic,strong)UIImageView *bgImageView;
@property(nonatomic,strong)UIImageView *backgroundImage;
@property(nonatomic,strong)MatchMakingInformationView *matchView;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIButton *editBtn;
@property(nonatomic,strong)UIButton *listBtn;

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
    [self setZl];
}

-(void)setZl{
    self.colorIndex = 0;
    self.colors = @[
                    @"Turquoise",
                    @"Green Sea",
                    @"Emerald",
                    @"Nephritis",
                    @"Peter River",
                    @"Belize Hole",
                    @"Amethyst",
                    @"Wisteria",
                    @"Wet Asphalt",
                    @"Midnight Blue",
                    @"Sun Flower",
                    @"Orange",
                    @"Carrot",
                    @"Pumpkin",
                    @"Alizarin",
                    @"Pomegranate",
                    @"Clouds",
                    @"Silver",
                    @"Concrete",
                    @"Asbestos"
                    ];
    self.titles = @[
                    @"Turquoise",
                    @"Green Sea",
                    @"Emerald",
                    @"Nephritis",
                    @"Peter River",
                    @"Belize Hole",
                    @"Amethyst",
                    @"Wisteria",
                    @"Wet Asphalt",
                    @"Midnight Blue",
                    @"Sun Flower",
                    @"Orange",
                    @"Carrot",
                    @"Pumpkin",
                    @"Alizarin",
                    @"Pomegranate",
                    @"Clouds",
                    @"Silver",
                    @"Concrete",
                    @"Asbestos"
                    ];
    
    
    [self.backgroundImage addSubview:self.swipeableView];
    ZLSwipeableView *swipeableView = _swipeableView;
    // Required Data Source
    self.swipeableView.dataSource = self;
    
    // Optional Delegate
    self.swipeableView.delegate = self;
    
    self.swipeableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *metrics = @{};
    // Adding constraints
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"|-30-[swipeableView]-30-|"
                               options:0
                               metrics:metrics
                               views:NSDictionaryOfVariableBindings(
                                                                    swipeableView)]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-50-[swipeableView]-100-|"
                               options:0
                               metrics:metrics
                               views:NSDictionaryOfVariableBindings(
                                                                    swipeableView)]];
//    [self.view addConstraints:[NSLayoutConstraint
//                               constraintsWithVisualFormat:@"V:|-50-[swipeableView]-100-|"
//                               options:0
//                               metrics:metrics
//                               views:NSDictionaryOfVariableBindings(
//                                                                    swipeableView)]];
    
    
    // `1` `2` `3` `4`
//    NSArray *items = @[@"😢", @"😄", @"😢", @"😄"];
//    for (NSInteger i = 0; i < 4; i++) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.view addSubview:button];
//        button.frame = CGRectMake(50 + 60 * i, self.view.frame.size.height - 90, 50, 50);
//        [button setTitle:items[i] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(handle:) forControlEvents:UIControlEventTouchUpInside];
//
//    }
//
}
// up down left right
- (void)handle:(UIButton *)sender
{
    HandleDirectionType type = sender.tag;
    switch (type) {
        case HandleDirectionOn:
            [self.swipeableView swipeTopViewToUp];
            break;
        case HandleDirectionDown:
            [self.swipeableView swipeTopViewToDown];
            break;
        case HandleDirectionLeft:
            [self.swipeableView swipeTopViewToLeft];
            break;
            
        case HandleDirectionRight:
            [self.swipeableView swipeTopViewToRight];
            break;
        default:
            break;
    }
}
- (ZLSwipeableView *)swipeableView
{
    if (_swipeableView == nil) {
        _swipeableView = [[ZLSwipeableView alloc] initWithFrame:CGRectMake(37, 142, ScreenWidth-70, 538)];
        
    }
    return _swipeableView;
}
- (void)viewDidLayoutSubviews {
    [self.swipeableView loadViewsIfNeeded];
}

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    NSLog(@"did swipe in direction: %zd", direction);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didCancelSwipe:(UIView *)view {
    NSLog(@"did cancel swipe");
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did start swiping at location: x %f, y %f", location.x, location.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation {
    NSLog(@"swiping at location: x %f, y %f, translation: x %f, y %f", location.x, location.y,
          translation.x, translation.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did end swiping at location: x %f, y %f", location.x, location.y);
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
    ChooseMatchMakingListController * listVC = [[ChooseMatchMakingListController alloc]init];
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
