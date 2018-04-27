//
//  CircleOfFriendsViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/11.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "CircleOfFriendsViewController.h"
#import "CircleTableViewCell.h"
#import "ReleaseInfoViewController.h"
#import "MyStateViewController.h"
#import "KeyBoardView.h"
#import "IQKeyboardManager.h"
#import "FriendCircleViewModel.h"
#import "FriendCircleModel.h"
#import "AgreesModel.h"
#import "FollowsModel.h"
#import "IDMPhoto.h"
#import "IDMPhotoBrowser.h"
@interface CircleOfFriendsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIView *noLoginView;
@property (nonatomic, retain) KeyBoardView *commentView;
@property (nonatomic, retain) NSMutableArray *muFriendArray;

@property (nonatomic, assign) NSInteger     pageIndex;
@property (nonatomic, retain) FriendCircleViewModel *viewModel;
@end

@implementation CircleOfFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.itemTableView.estimatedRowHeight = 80.0f;
    self.itemTableView.rowHeight = UITableViewAutomaticDimension;
    self.muFriendArray = [[NSMutableArray alloc]init];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"CircleTableViewCell" bundle:nil] forCellReuseIdentifier:@"CircleTableViewCell"];
    [self.itemTableView setBackgroundColor:[UIColor colorWithHexString:@"f5f5f5"]];
    
    [HYNotification addLoginNotification:self action:@selector(setupRefresh)];
    __weak typeof (self)weakSelf = self;
    
    self.viewModel = [[FriendCircleViewModel alloc] init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        if (self.pageIndex == 1) {
            [weakSelf.muFriendArray removeAllObjects];
            [weakSelf.itemTableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
     
        if ([(NSArray *)returnValue count] < 10) {
            [weakSelf.itemTableView.mj_footer removeFromSuperview];
        }
        else{
            weakSelf.itemTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(footerRefreshing)];
        }
        [weakSelf.muFriendArray addObjectsFromArray:returnValue];
        [weakSelf.itemTableView reloadData];
        if (weakSelf.muFriendArray.count == 0) {
            weakSelf.noDataView.hidden = NO;
            weakSelf.itemTableView.hidden = YES;
            weakSelf.noLoginView.hidden = YES;
        }else{
            weakSelf.noDataView.hidden = YES;
            weakSelf.itemTableView.hidden = NO;
            weakSelf.noLoginView.hidden = YES;
        }
    } WithErrorBlock:^(id errorCode) {
        if (self.pageIndex == 1) {
            [weakSelf.itemTableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
        if (weakSelf.muFriendArray.count == 0) {
            weakSelf.noDataView.hidden = NO;
            weakSelf.itemTableView.hidden = YES;
            weakSelf.noLoginView.hidden = YES;
        }else{
            weakSelf.noDataView.hidden = YES;
            weakSelf.itemTableView.hidden = NO;
            weakSelf.noLoginView.hidden = YES;
        }
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    

    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillChangeFrameNotification
     
                                               object:nil];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self isLogin]) {
        [self setupRefresh];
    }else{
        self.noDataView.hidden = YES;
        self.itemTableView.hidden = YES;
        self.noLoginView.hidden = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.itemTableView.mj_header endRefreshing];
}
/**
 *  设置刷新
 */
-(void)setupRefresh
{
    self.itemTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    [self.itemTableView.mj_header beginRefreshing];
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
    [self.viewModel fetchFriendCircleDataWithToken:[self getToken] page:@(++ self.pageIndex) size:nil];
}

- (IBAction)skipToRelease:(id)sender {
    if (![self isLogin]) {
        [self skiptoLogin];
        return;
    }
    ReleaseInfoViewController *vc = [[ReleaseInfoViewController alloc]init];
    [vc setReloadViewBlock:^{
        self.pageIndex = 0;
        [self footerRefreshing];
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)loginAction:(id)sender {
    [self skiptoLogin];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.muFriendArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CircleTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initCellWithData:self.muFriendArray[indexPath.section] section:indexPath.section];
    //跳转用户
    [cell setSkipBlock:^(NSString *str,NSString *nameStr,NSString *imgStr){
        [self skipToUserWithUid:str name:nameStr headImage:imgStr];
    }];
    //弹出键盘
    [cell setShowKeyBoardBlock:^(FriendCircleModel *model,NSInteger section){
        [self popKeyBoardWithModel:model  section:indexPath.section];
    }];
    //点赞
    [cell setThumpBlock:^(FriendCircleModel *friendCircleModel,NSInteger index) {
        [self agreeFriendWithId:friendCircleModel section:index];
    }];
    //删除朋友圈
    [cell setDeleteCircleBlock:^(FriendCircleModel *friendCircleModel,NSInteger index) {
        [self delCircleWithId:friendCircleModel section:index];
    }];
    
    //查看图片
    [cell setPhotoBlock:^(FriendCircleModel *friendCircleModel,NSInteger index){
        [self lookPhoto:friendCircleModel index:index];
    }];
    //回复评论
    [cell setReplyCommentBlock:^(FriendCircleModel *friendCircleModel,FollowsModel * followsModel,NSInteger index){
        [self replyComment:friendCircleModel followsModel:followsModel section:index];
    }];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CircleTableViewCell"];
    return [cell getCellHeightWithData:self.muFriendArray[indexPath.section]];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, ScreenWidth, 10);
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[self.view viewWithTag:1998] removeFromSuperview];
    FriendCircleModel *model = self.muFriendArray[indexPath.section];
    MyStateViewController *vc = [[MyStateViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.uid = model.uid;
    vc.name = model.nickname;
    vc.image = model.headimg;
    vc.isMyState = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self.view viewWithTag:1998] removeFromSuperview];
}


- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
     [aTextfield resignFirstResponder];//关闭键盘
    self.commentView.frame = CGRectMake(0, ScreenHeight-50, ScreenWidth, 50);
    return YES;
}

//跳转
-(void)skipToUserWithUid:(NSString *)uid name:(NSString *)name headImage:(NSString *)headImage{
    MyStateViewController *vc = [[MyStateViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.uid = uid;
    vc.name = name;
    vc.image = headImage;
    vc.isMyState = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

//弹出键盘
-(void)popKeyBoardWithModel:(FriendCircleModel *)model  section:(NSInteger)section{
    [[self.view viewWithTag:1998] removeFromSuperview];
    UserModel *userModel = [[UserModel alloc]initWithDict:[UserDefaults readUserDefaultObjectValueForKey:user_info]];
    self.commentView = [[[NSBundle mainBundle]loadNibNamed:@"KeyBoardView" owner:self options:nil]firstObject];
    self.commentView.frame = CGRectMake(0, self.view.bounds.size.height, ScreenWidth, 50);
    __weak typeof(self)weakSelf = self;
    [self.commentView initViewWithName:model.nickname];
    [self.commentView setSendBlcok:^(NSString *str) {
        NSLog(@"%@",str);
        FriendCircleViewModel *viewModel = [[FriendCircleViewModel alloc]init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {

            //评论成功
            
            
            FriendCircleModel *newmodel = [[FriendCircleModel alloc] initWithDict:[model dictionaryRepresentation]];
            newmodel.agrees = model.agrees;
            newmodel.imgs = model.imgs;
                    
            NSMutableArray *followarr = [[NSMutableArray alloc] initWithArray:model.follows];
            
            
            FollowsModel *newFollowsModel = [[FollowsModel alloc] init];
            newFollowsModel.uid = userModel.Id;
            newFollowsModel.atnickname = @"";
            newFollowsModel.content = weakSelf.commentView.txtComment.text;
            newFollowsModel.friend_id = @"";
            newFollowsModel.nickname = userModel.nickname;
            
            [followarr addObject:newFollowsModel];
            
            newmodel.follows = followarr;

            [weakSelf.muFriendArray replaceObjectAtIndex:section withObject:newmodel];
            [weakSelf.itemTableView reloadData];
            
            
        } WithErrorBlock:^(id errorCode) {
            [weakSelf showJGProgressWithMsg:errorCode];
        }];
        [viewModel discussFriendWithToken:[weakSelf getToken] Id:model.Id friendId:nil content:str];
        [[weakSelf.view viewWithTag:1998] removeFromSuperview];
    }];
    self.commentView.tag = 1998;
    [self.commentView.txtComment becomeFirstResponder];
    [self.view addSubview:self.commentView];
    //        [self.view bringSubviewToFront:commentView];
}

//点赞
-(void)agreeFriendWithId:(FriendCircleModel *)model section:(NSInteger)section{
    __weak typeof(self)weakSelf = self;
    UserModel *userModel = [[UserModel alloc]initWithDict:[UserDefaults readUserDefaultObjectValueForKey:user_info]];

    FriendCircleViewModel *viewModel = [[FriendCircleViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {

        FriendCircleModel *newmodel = [[FriendCircleModel alloc] initWithDict:[model dictionaryRepresentation]];
        newmodel.is_agree = @(![model.is_agree boolValue]);
        if ([newmodel.is_agree boolValue]) {
            NSMutableArray *agrees = [[NSMutableArray alloc] initWithArray:model.agrees];
            
            AgreesModel *agreesModel = [[AgreesModel alloc] init];
            agreesModel.nickname = userModel.nickname;
            agreesModel.uid = userModel.Id;
            
            [agrees addObject:agreesModel];
            newmodel.agrees = agrees;
        }
        else{
            //取消点赞
            NSMutableArray *agrees = [[NSMutableArray alloc] initWithArray:model.agrees];

            for (AgreesModel *agreesModel in agrees) {
                if ([agreesModel.nickname isEqualToString:userModel.nickname]) {
                    [agrees removeObject:agreesModel];
                    break;
                }
            }
            
            newmodel.agrees = agrees;

        }
        newmodel.follows = model.follows;
        newmodel.imgs = model.imgs;
        
        [weakSelf.muFriendArray replaceObjectAtIndex:section withObject:newmodel];
        [weakSelf.itemTableView reloadData];
        
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel agreeFriendWithToken:[self getToken] Id:model.Id];
}

//删除朋友圈
-(void)delCircleWithId:(FriendCircleModel *)model section:(NSInteger)section{
    __weak typeof(self)weakSelf = self;

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"确定要删除吗？"
                                                                      preferredStyle:UIAlertControllerStyleAlert ];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.itemTableView reloadData];
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        FriendCircleViewModel *viewModel = [[FriendCircleViewModel alloc]init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            
            [self showJGProgressWithMsg:@"删除成功"];
            [weakSelf.muFriendArray removeObject:model];
            [weakSelf.itemTableView reloadData];
            
            [self.itemTableView reloadData];
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel delCircleWithCircleId:model.Id Token:[self getToken]];

    }];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];

}
//查看图片
-(void)lookPhoto:(FriendCircleModel *)model index:(NSInteger)index{
    NSMutableArray *photosURL = [[NSMutableArray alloc] init];
    
    for ( int i = 0; i < model.imgs.count; i ++) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,model.imgs[i]]];
        [photosURL addObject:url];
    }
    
    // Create an array to store IDMPhoto objects
    NSMutableArray *photos = [NSMutableArray new];
    
    for (NSURL *url in photosURL) {
        IDMPhoto *photo = [IDMPhoto photoWithURL:url];
        [photos addObject:photo];
    }
    
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    [browser setInitialPageIndex:index];
    [self presentViewController:browser animated:YES completion:nil];
}

//回复评论
-(void)replyComment:(FriendCircleModel *)model followsModel:(FollowsModel *)followsModel section:(NSInteger)section{
    [[self.view viewWithTag:1998] removeFromSuperview];
    UserModel *userModel = [[UserModel alloc]initWithDict:[UserDefaults readUserDefaultObjectValueForKey:user_info]];
    if ([userModel.Id isEqualToString:followsModel.uid]) {
        [self showJGProgressWithMsg:@"不能评论自己！"];
        return;
    }
    self.commentView = [[[NSBundle mainBundle]loadNibNamed:@"KeyBoardView" owner:self options:nil]firstObject];
    self.commentView.placestr = @"回复";
    self.commentView.frame = CGRectMake(0, self.view.bounds.size.height, ScreenWidth, 50);
    __weak typeof(self)weakSelf = self;
    [self.commentView initViewWithName:followsModel.nickname];
    [self.commentView setSendBlcok:^(NSString *str) {
        NSLog(@"%@",str);
        FriendCircleViewModel *viewModel = [[FriendCircleViewModel alloc]init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            
            //评论成功
            
            FriendCircleModel *newmodel = [[FriendCircleModel alloc] initWithDict:[model dictionaryRepresentation]];
            newmodel.agrees = model.agrees;
            newmodel.imgs = model.imgs;
            
            NSMutableArray *followarr = [[NSMutableArray alloc] initWithArray:model.follows];
            
            
            FollowsModel *newFollowsModel = [[FollowsModel alloc] init];
            newFollowsModel.uid = userModel.Id;
            newFollowsModel.atnickname = followsModel.nickname;
            newFollowsModel.content = weakSelf.commentView.txtComment.text;
            newFollowsModel.friend_id = userModel.Id;
            newFollowsModel.nickname = userModel.nickname;
            
            [followarr addObject:newFollowsModel];
            
            newmodel.follows = followarr;
            
            [weakSelf.muFriendArray replaceObjectAtIndex:section withObject:newmodel];
            [weakSelf.itemTableView reloadData];
            
            
        } WithErrorBlock:^(id errorCode) {
            [weakSelf showJGProgressWithMsg:errorCode];
        }];
        [viewModel discussFriendWithToken:[weakSelf getToken] Id:model.Id friendId:followsModel.uid content:str];
        [[weakSelf.view viewWithTag:1998] removeFromSuperview];
    }];
    self.commentView.tag = 1998;
    [self.commentView.txtComment becomeFirstResponder];
    [self.view addSubview:self.commentView];
}
- (void)keyboardWillHide:(NSNotification*)notification {
    
    [[self.view viewWithTag:1998] removeFromSuperview];

}

- (void)keyboardWillShow:(NSNotification*)notification {
    
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]; //获得键盘的rect

    self.commentView.frame = CGRectMake(0, self.view.bounds.size.height - keyboardFrame.size.height - 50, ScreenWidth, 50);
}
@end
