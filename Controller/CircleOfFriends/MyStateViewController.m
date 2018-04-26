//
//  MyStateViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/14.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyStateViewController.h"
#import "CircleTableViewCell.h"
#import "FriendCircleViewModel.h"
#import "FriendCircleModel.h"
#import "KeyBoardView.h"
#import "IDMPhoto.h"
#import "IDMPhotoBrowser.h"
#import "MyStateHeadView.h"
#import "UploadImgViewModel.h"
#import "PicModel.h"
#import "UserModel.h"
#import "AddressModel.h"
#import "AgreesModel.h"
#import "FriendDetailViewController.h"

@interface MyStateViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIView *bgview;

@property (nonatomic, retain) KeyBoardView *commentView;
@property (nonatomic, retain) NSMutableArray *muFriendArray;
@property (nonatomic, retain) FriendCircleViewModel *viewModel;
@property (nonatomic, retain) MyStateHeadView *headView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, copy) NSString *imgUrl;
@end

@implementation MyStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
            if (@available(iOS 11.0, *)) {
                self.itemTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                self.automaticallyAdjustsScrollViewInsets = NO;
            }

    self.muFriendArray = [[NSMutableArray alloc]init];
    [self.itemTableView registerNib:[UINib nibWithNibName:@"CircleTableViewCell" bundle:nil] forCellReuseIdentifier:@"CircleTableViewCell"];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (self.isMyState == YES) {
        self.labelTitle.text = @"我的动态";
    }else{
        self.labelTitle.text = @"好友动态";
    }
    UserModel *userModel = [[UserModel alloc]initWithDict:[UserDefaults readUserDefaultObjectValueForKey:user_info]];
    if ([userModel.Id isEqualToString:self.uid]) {
        self.labelTitle.text = @"我的动态";
    }else{
        self.labelTitle.text = @"好友动态";
    }
    __weak typeof(self)weakSelf = self;

    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"MyStateHeadView" owner:self options:nil] firstObject];
    [self.headView initView:self.name headUrl:[NSString stringWithFormat:@"%@%@",BaseUrl,self.image] bgUrl:self.imgUrl];
    [self.headView setFriendDetailBlock:^{
        UserModel *userModel = [[UserModel alloc]initWithDict:[UserDefaults readUserDefaultObjectValueForKey:user_info]];
        if (![userModel.Id isEqualToString:weakSelf.uid]) {
            [weakSelf friendDetail:weakSelf.uid];
        }
    }];
    [self.headView setLookHeadImgBlock:^(NSString *imgUrl) {
        if (imgUrl.length > 26) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,weakSelf.image]];
            
            IDMPhoto *photo = [IDMPhoto photoWithURL:url];
            IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:@[photo]];
            [weakSelf presentViewController:browser animated:YES completion:nil];
        }
        
    }];

    FriendCircleViewModel *imgViewModel = [[FriendCircleViewModel alloc] init];
    [imgViewModel setBlockWithReturnBlock:^(id returnValue) {
        NSString *str = returnValue[@"show_img"];
        [self.headView initView:self.name headUrl:[NSString stringWithFormat:@"%@%@",BaseUrl,self.image] bgUrl:str];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [imgViewModel fetchShowImageWithToken:[self getToken] uid:self.uid];
    

    [self.headView setShowImgBlock:^{
        UserModel *userModel = [[UserModel alloc]initWithDict:[UserDefaults readUserDefaultObjectValueForKey:user_info]];
        if (![userModel.Id isEqualToString:weakSelf.uid]) {
            return ;
        }

        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
        //添加Button
        [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [weakSelf uploadImg:UIImagePickerControllerSourceTypeCamera];
            
        }]];
        [alertController addAction: [UIAlertAction actionWithTitle: @"相册" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [weakSelf uploadImg:UIImagePickerControllerSourceTypePhotoLibrary];
            
        }]];
        
        [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
        
        [weakSelf presentViewController: alertController animated: YES completion: nil];
    }];
    self.itemTableView.tableHeaderView = self.headView;

    
    [HYNotification addLoginNotification:self action:@selector(setupRefresh)];
    
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

    } WithErrorBlock:^(id errorCode) {
        if (self.pageIndex == 1) {
            [weakSelf.itemTableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
        
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    [self setupRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillChangeFrameNotification
     
                                               object:nil];


}

-(void)friendDetail:(NSString *)userId{
    NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    UserModel *userModel = [[UserModel alloc] initWithDict:userinfo];
    if (![userModel.Id isEqualToString:userId]) {
        FriendDetailViewController *vc = [[FriendDetailViewController alloc] init];
        vc.uid = userId;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
    [self.viewModel fetchUserCircleDataWithToken:[self getToken] page:@(++ self.pageIndex) uid:self.uid size:@(10)];
}

- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
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
//    if (self.isMyState == NO) {
//        cell.btnDelete.hidden = YES;
//    }
//    cell.btnDelete.hidden = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initCellWithData:self.muFriendArray[indexPath.section] section:indexPath.section];
    //跳转用户
    [cell setSkipBlock:^(NSString *str,NSString *nameStr,NSString *imgStr){
        NSLog(@"");
//        [self skipToUserWithUid:str name:nameStr headImage:imgStr];
        [self friendDetail:str];
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
    return 0.0001f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[self.view viewWithTag:1998] removeFromSuperview];
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
            newFollowsModel.Id = userModel.Id;
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
        [viewModel discussFriendWithToken:[weakSelf getToken] Id:model.Id friendId:model.friend_id content:str];
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
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        FriendCircleViewModel *viewModel = [[FriendCircleViewModel alloc]init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [self showJGProgressWithMsg:@"删除成功"];
            [weakSelf.muFriendArray removeObject:model];
            [weakSelf.itemTableView reloadData];
            
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
            newFollowsModel.Id = userModel.Id;
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat y = self.itemTableView.contentOffset.y;

    CGFloat aplha = y/300;

    self.bgview.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:150.0/255.0 blue:240.0/255.0 alpha:aplha];
}
- (void)uploadImg:(UIImagePickerControllerSourceType)xtype{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = xtype;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
}
-(void)uploadImgToService:(UIImage *)img{
        __weak typeof(self) weakSelf = self;
    
    UploadImgViewModel *viewModel = [[UploadImgViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        PicModel *model = [returnValue firstObject];
        weakSelf.imgUrl = model.img_url;
        [weakSelf setShowImage];
        //        self.iconImageView.image = img;
        [self dissJGProgressLoadingWithTag:200];
    } WithErrorBlock:^(id errorCode) {
        [self dissJGProgressLoadingWithTag:200];
    }];
    [viewModel uploadImgWithImage:img];
    [self showJGProgressLoadingWithTag:200];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [weakSelf uploadImgToService:image];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)setShowImage{
    FriendCircleViewModel *viewModel = [[FriendCircleViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
       [self.headView initView:self.name headUrl:[NSString stringWithFormat:@"%@%@",BaseUrl,self.image] bgUrl:self.imgUrl];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel setShowImageWithToken:[self getToken] showImg:self.imgUrl];
}
@end
