//
//  MineViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/9.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "MyStateViewController.h"
#import "MyWalletViewController.h"
#import "MyIntegralViewController.h"
#import "UserInfomationViewController.h"
#import "MyJobViewController.h"
#import "MyCouponsViewController.h"

#import "MyCollectionViewController.h"
#import "SettingViewController.h"
#import "PublishMyInfoViewController.h"
#import "MyResumeViewController.h"
#import "MyOrderFormViewController.h"
#import "MyTeamViewController.h"
#import "MyLikeListController.h"
#import "MyShoppingCartViewController.h"

#import "MyQrViewController.h"
#import "MyServiceViewController.h"
#import "MyRewardViewController.h"
#import "MyGradeViewController.h"
#import "MyFriendScoreViewController.h"
#import "NotVertificationViewController.h"
#import "VertificateDefeatViewController.h"
#import "VertificateResultViewController.h"
#import "MyShoppingCartViewController.h"
#import "MyQrViewController.h"

#import "UserModel.h"
#import "UIButton+WebCache.h"
#import "UserViewModel.h"
#import "BaseDataViewModel.h"

#import "SystemMsgListViewController.h"
#import "CommonAlertView.h"
#import "StartViewModel.h"
#import "PGDatePickManager.h"
#import "CGXPickerView.h"
@interface MineViewController ()<UITextFieldDelegate,CommonAlertViewDelegate,UIPickerViewDelegate,PGDatePickerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UIButton *markBtn;//签到
@property (weak, nonatomic) IBOutlet UIView *middleView;//
@property (weak, nonatomic) IBOutlet UITextField *txtMyRemark;//我的简介
@property (weak, nonatomic) IBOutlet UIButton *btnGrade;
@property (weak, nonatomic) IBOutlet UIButton *btnFriendScore;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelUserID;
@property (weak, nonatomic) IBOutlet UIButton *editingBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgMySex;

@property (weak, nonatomic) IBOutlet UIButton *myWalletBtn;//我的钱包
@property (weak, nonatomic) IBOutlet UIButton *myScoreBtn;//我的积分
@property (weak, nonatomic) IBOutlet UIButton *myGetBtn;//我的奖励

@property (weak, nonatomic) IBOutlet UIButton *myLiveBtn;//我的直播
@property (weak, nonatomic) IBOutlet UIButton *myJobBtn;//我的应聘
@property (weak, nonatomic) IBOutlet UIButton *myLeaseBtn;//我的租赁
@property (weak, nonatomic) IBOutlet UIButton *myBlindDateBtn;//我的相亲
@property (weak, nonatomic) IBOutlet UIButton *myMarkBtn;//我的收藏
@property (weak, nonatomic) IBOutlet UIButton *myCouponBtn;//我的优惠券
@property (weak, nonatomic) IBOutlet UIButton *myShopCarBtn;//我的购物车
@property (weak, nonatomic) IBOutlet UIButton *myOrderBtn;//我的订单
@property (weak, nonatomic) IBOutlet UIButton *myDynamicBtn;//我的动态
@property (weak, nonatomic) IBOutlet UIButton *myQrCodeBtn;//我的二维码
@property (weak, nonatomic) IBOutlet UIButton *myCustomerServiceBtn;//我的客服
@property (weak, nonatomic) IBOutlet UIButton *inviteFriendBtn;//邀请好友
@property (weak, nonatomic) IBOutlet UIScrollView *menuScrollView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property(nonatomic,strong)CommonAlertView *chooseAlertView;
@property(nonatomic,strong)CommonAlertView *checkUpAlertview;
@property(nonatomic,strong)CommonAlertView *finishedAlertview;
@property (nonatomic ,retain) UserModel *userModel;
@property(nonatomic,retain)StartViewModel *startModel;
@end

@implementation MineViewController

-(CommonAlertView *)chooseAlertView{
    if (!_chooseAlertView) {
        _chooseAlertView = [[CommonAlertView alloc]initWithFrame:CGRectMake(ScreenWidth/2-351/2,190, 351, 250)];
        [_chooseAlertView setCommonType:CommonTypeLogin];
        _chooseAlertView.delegate = self;
    }
    return _chooseAlertView;
}
-(CommonAlertView *)checkUpAlertview{
    if (!_checkUpAlertview) {
        _checkUpAlertview = [[CommonAlertView alloc]initWithFrame:CGRectMake(ScreenWidth/2-170,120, 340, 396)];
        [_checkUpAlertview setCommonType:CommonTypeCoupon];
        _checkUpAlertview.delegate = self;
    }
    return _checkUpAlertview;
}
-(CommonAlertView *)finishedAlertview{
    if (!_finishedAlertview) {
        _finishedAlertview = [[CommonAlertView alloc]initWithFrame:CGRectMake(ScreenWidth/2-170,120, 340, 396)];
        [_finishedAlertview setCommonType:CommonTypeCouponfinished];
        _finishedAlertview.delegate = self;
    }
    return _finishedAlertview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //初始化视图
    self.headBtn.layer.cornerRadius = 30.f;
    self.headBtn.layer.masksToBounds = YES;
    self.headBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.headBtn.layer.borderWidth = 1.f;
    
    self.markBtn.layer.cornerRadius = 4.f;
    self.markBtn.layer.masksToBounds = YES;
    self.markBtn.layer.borderWidth = 1.f;
    self.markBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    //    self.middleView.layer.masksToBounds = YES;
    self.middleView.layer.cornerRadius = 4.f;
    self.middleView.layer.shadowColor = [UIColor colorWithHexString:@"a4c1f1"].CGColor;
    self.middleView.layer.shadowOpacity = 0.5f;
    self.middleView.layer.shadowRadius = 4.f;
    self.middleView.layer.shadowOffset = CGSizeMake(0,4);
    [self.loginBtn setImagePositionWithType:SSImagePositionTypeRight spacing:10.f];
    [self.btnGrade setImagePositionWithType:SSImagePositionTypeLeft spacing:5.f];
    
    [self.myWalletBtn setImagePositionWithType:SSImagePositionTypeTop spacing:10.f];
    [self.myGetBtn setImagePositionWithType:SSImagePositionTypeTop spacing:10.f];
    [self.myScoreBtn setImagePositionWithType:SSImagePositionTypeTop spacing:10.f];
    
    [self.myLiveBtn setImagePositionWithType:SSImagePositionTypeTop spacing:12.0f];
    [self.myJobBtn setImagePositionWithType:SSImagePositionTypeTop spacing:12.0f];
    [self.myLeaseBtn setImagePositionWithType:SSImagePositionTypeTop spacing:12.0f];
    [self.myBlindDateBtn setImagePositionWithType:SSImagePositionTypeTop spacing:12.0f];
    
    [self.myMarkBtn setImagePositionWithType:SSImagePositionTypeTop spacing:12.0f];
    [self.myCouponBtn setImagePositionWithType:SSImagePositionTypeTop spacing:12.0f];
    [self.myShopCarBtn setImagePositionWithType:SSImagePositionTypeTop spacing:12.0f];
    [self.myOrderBtn setImagePositionWithType:SSImagePositionTypeTop spacing:12.0f];
    
    [self.myDynamicBtn setImagePositionWithType:SSImagePositionTypeTop spacing:12.0f];
    [self.myQrCodeBtn setImagePositionWithType:SSImagePositionTypeTop spacing:12.0f];
    [self.myCustomerServiceBtn setImagePositionWithType:SSImagePositionTypeTop spacing:12.0f];
    [self.inviteFriendBtn setImagePositionWithType:SSImagePositionTypeTop spacing:12.0f];
    
    
    
    [self.menuScrollView setContentSize:CGSizeMake(ScreenWidth, 250)];
    [HYNotification addLoginNotification:self action:@selector(reloadViewLogin)];
    [HYNotification addLogOutNotification:self action:@selector(reloadViewLogOut)];
    
    self.txtMyRemark.delegate = self;
    self.txtMyRemark.returnKeyType = UIReturnKeyDone;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"在这里输入签名(15字以内)" attributes:
                                      @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                        NSFontAttributeName:self.txtMyRemark.font
                                        }];
    self.txtMyRemark.attributedPlaceholder = attrString;
    [self.view addSubview:self.txtMyRemark];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.txtMyRemark];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    
    self.userModel = [[UserModel alloc] initWithDict:userinfo];
    [self reloadView];
    if (userinfo) {
        UserViewModel *viewModel = [[UserViewModel alloc]init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            NSLog(@"%@",self.userModel.token);
            self.userModel = returnValue;
            NSLog(@"%@",self.userModel.token);
            [self reloadView];
            if (self.userModel.firstlog ==0) {
                [self popView:self.chooseAlertView withOffset:0];
            }
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel fetchUserInfomationWithToken:[self getToken]];
    }
    
}
-(void)reloadViewLogin{
    self.loginBtn.hidden = YES;
    self.labelName.hidden = NO;
    self.labelUserID.hidden = NO;
    self.btnGrade.hidden = NO;
    self.btnFriendScore.hidden = NO;
    self.editingBtn.hidden = NO;
    self.markBtn.hidden = NO;
    self.txtMyRemark.hidden = NO;
    self.imgMySex.hidden = NO;
}
#pragma mark-CommonAlertViewDelegate
-(void)selecteddismissBtn{
    [self hidPopView];
}
-(void)selectedYearBtn{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *nowStr = [fmt stringFromDate:now];
     __weak typeof(self) weakSelf = self;
    [CGXPickerView showDatePickerWithTitle:@"出生年月" DateType:UIDatePickerModeDate DefaultSelValue:nil MinDateStr:@"1900-01-01 00:00:00" MaxDateStr:nowStr IsAutoSelect:YES Manager:nil ResultBlock:^(NSString *selectValue) {
        NSLog(@"%@",selectValue);
        
        weakSelf.chooseAlertView.yearBtn.titleLabel.text = selectValue;
        weakSelf.chooseAlertView.yearBtn.titleLabel.textColor = DSColorFromHex(0x4D4D4D);
    }];
    
    
}

-(void)commitCommonTypeLogin:(NSString *)year Sex:(NSString*)sex{
    self.startModel = [[StartViewModel alloc]init];
    if (sex.length<1) {
        [self showJGProgressWithMsg:@"请选择性别"];
        return;
    }
    if (year.length<1) {
        [self showJGProgressWithMsg:@"请选择年龄"];
        return;
    }
    [self.startModel addUserBaseWithToken:[self getToken] Sex:[sex integerValue] Birthday:year];
     __weak typeof (self)weakSelf = self;
    [self.startModel setBlockWithReturnBlock:^(id returnValue) {
        PublicModel *publicModel = (PublicModel*)returnValue;
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [weakSelf hidPopView];
            [weakSelf popView:weakSelf.checkUpAlertview withOffset:0];
        }else{
            [weakSelf showJGProgressWithMsg:publicModel.message];
        }
    } WithErrorBlock:^(id errorCode) {
        
    }];
    
}
-(void)commitCommonTypeCoupon{
     [self hidPopView];
}
-(void)commitCheckPackage{
     [self hidPopView];
}
-(void)reloadViewLogOut{
    self.userModel = [[UserModel alloc]init];
    self.loginBtn.hidden = NO;
    self.labelName.text = @"";
    self.labelName.hidden = YES;
    self.labelUserID.text = @"";
    self.labelUserID.hidden = YES;
    self.btnGrade.hidden = YES;
    [self.btnGrade setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.btnGrade setTitle:@"" forState:UIControlStateNormal];
    [self.btnFriendScore setTitle:@"" forState:UIControlStateNormal];
    self.btnFriendScore.hidden = YES;
    self.editingBtn.hidden = YES;
    self.markBtn.hidden = YES;
    self.txtMyRemark.text = @"";
    self.txtMyRemark.hidden = YES;
    self.imgMySex.hidden = YES;
    self.imgMySex.image = [UIImage imageNamed:@""];
    [self.headBtn setImage:[UIImage imageNamed:placeholderImage_user_headimg] forState:UIControlStateNormal];
    
}

-(void)reloadView{
    if (self.userModel.Id) {
        [self reloadViewLogin];
        //头像
        if(self.userModel.headimg.length < 5){
            [self.headBtn setImage:[UIImage imageNamed:placeholderImage_user_headimg] forState:UIControlStateNormal];
        }else{
            //            [self.headBtn setimage]
            NSURL *url = [[NSURL alloc] init];
            if([self.userModel.headimg rangeOfString:@"http"].location !=NSNotFound)//_roaldSearchText
            {
                url = [NSURL URLWithString:self.userModel.headimg];
                
            }
            else
            {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,self.userModel.headimg]];
                
            }
            [self.headBtn sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:placeholderImage_user_headimg]];
            
        }
        //性别图片
        
        self.imgMySex.layer.masksToBounds = YES;
        self.imgMySex.layer.cornerRadius = 7.f;
        if ([self.userModel.sex integerValue] == 0) {
            self.imgMySex.image = [UIImage imageNamed:@"icon_my_female_sex"];
        }else if ([self.userModel.sex integerValue] == 1){
            self.imgMySex.image = [UIImage imageNamed:@"icon_my_male"];
        }else{
            self.imgMySex.hidden = YES;
        }
        
        //姓名
        if ([self.userModel.nickname isEqualToString:@""]) {
            self.labelName.text = @"无";
        }else{
            self.labelName.text = self.userModel.nickname;
        }
        CGSize size = [self.userModel.nickname sizeWithFont:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(ScreenWidth - 200, 20)];
        CGRect rectName = self.labelName.frame;
        if (size.width < 90) {
            rectName.size.width = size.width;
        }else{
            rectName.size.width = 90;
        }
        self.labelName.frame = rectName;
        
        //ID
        self.labelUserID.text = [NSString stringWithFormat:@"ID:%@",self.userModel.user_num];
        
        //聚友值
        NSString *scoreStr = [NSString stringWithFormat:@"聚友值：%@",self.userModel.friend_amount];
        [self.btnFriendScore setTitle:scoreStr forState:UIControlStateNormal];
        
        //个人介绍
        if (self.userModel.sign.length > 0) {
            self.txtMyRemark.text = self.userModel.sign;
        }else{
            //            self.txtMyRemark.placeholder = @"在这里输入签名(20字以内)";
            self.txtMyRemark.text = @"";
        }
        
        //签到
        if ([self.userModel.sign_in integerValue] == 1) {
            [self.markBtn setTitle:@"已签到" forState:UIControlStateNormal];
            self.markBtn.enabled = NO;
        }else{
            [self.markBtn setTitle:@"签到" forState:UIControlStateNormal];
            self.markBtn.enabled = YES;
        }
        
        //等级
        CGRect rectGrade = self.btnGrade.frame;
        rectGrade.origin.x = rectName.origin.x+rectName.size.width+10;
        [self.btnGrade setFrame:rectGrade];
        id baseData = [UserDefaults readUserDefaultObjectValueForKey:base_data];
        NSDictionary *dic = baseData[@"user"];
        NSMutableArray *muLevelArr = [[NSMutableArray alloc]initWithArray:dic[@"level"]];
        for (int i = 0; i < muLevelArr.count; i ++) {
            NSDictionary *dic = muLevelArr[i];
            if (self.userModel.level_id == dic[@"Id"]) {
                [self.btnGrade setImage:[UIImage imageNamed:@"icon_grade"] forState:UIControlStateNormal];
                [self.btnGrade setTitle:dic[@"name"] forState:UIControlStateNormal];
                [self.btnGrade setImagePositionWithType:SSImagePositionTypeLeft spacing:5.f];
                break;
            }
        }
    }else{
        [self reloadViewLogOut];
        
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.txtMyRemark resignFirstResponder];
}


//一句话描述自己
- (IBAction)editMyRemark:(id)sender {
    self.txtMyRemark.enabled = YES;
    [self.txtMyRemark becomeFirstResponder];
}
//签到
- (IBAction)markAction:(id)sender {
    UserViewModel *viewModel = [[UserViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        //        [self showJGProgressWithMsg:returnValue];
        [self.markBtn setTitle:@"已签到" forState:UIControlStateNormal];
        self.markBtn.enabled = NO;
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel userSignWithToken:[self getToken]];
}


- (IBAction)skipToLogin:(id)sender {
    LoginViewController *vc = [[LoginViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc
                                         animated:YES];
    
}
//我的设置
- (IBAction)btnTest:(id)sender {
    if ([self isLogin]) {
        SettingViewController *vc = [[SettingViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }else{
        [self skiptoLogin];
    }
    
}
//我的等级
- (IBAction)skipToMyGrade:(id)sender {
    
    MyGradeViewController *vc = [[MyGradeViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc
                                         animated:YES];
    
}
//我的聚友值
- (IBAction)skipToFriendScore:(id)sender {
    
    if ([self isLogin]) {
        MyFriendScoreViewController *vc = [[MyFriendScoreViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }else{
        [self skiptoLogin];
    }
    
    
}

//我的动态
- (IBAction)skipToMyDynamic:(id)sender {
    if ([self isLogin]) {
        MyStateViewController *vc = [[MyStateViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.uid = self.userModel.Id;
        vc.name = self.userModel.nickname;
        vc.image = self.userModel.headimg;
        vc.mobile = self.userModel.mobile;
        vc.isMyState = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self skiptoLogin];
    }
    
}
//我的钱包
- (IBAction)skipToMyWallet:(id)sender {
    if ([self isLogin]) {
        MyWalletViewController *vc = [[MyWalletViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self skiptoLogin];
    }
    
    
}
//我的积分
- (IBAction)skipToMyScore:(id)sender {
    if ([self isLogin]) {
        MyIntegralViewController *vc = [[MyIntegralViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self skiptoLogin];
    }
    
}
//我的奖励
- (IBAction)skipToMyReward:(id)sender {
    if ([self isLogin]) {
        MyRewardViewController *vc = [[MyRewardViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self skiptoLogin];
    }
    
}

//个人资料
- (IBAction)skipToUserInfo:(id)sender {
    if ([self isLogin]) {
        UserInfomationViewController *vc = [[UserInfomationViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self skiptoLogin];
    }
    
}
//我的应聘
- (IBAction)skipToMyJob:(id)sender {
    if ([self isLogin]) {
        MyJobViewController *vc = [[MyJobViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self skiptoLogin];
    }
    
}
//我的收藏
- (IBAction)skipMyMark:(id)sender {
    if ([self isLogin]) {
        MyCollectionViewController *vc = [[MyCollectionViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self skiptoLogin];
    }
    
}

//我的优惠券
- (IBAction)skipToMyCoupon:(id)sender {
    if ([self isLogin]) {
        MyCouponsViewController *vc = [[MyCouponsViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self skiptoLogin];
    }
    
    
}
//我的订单
- (IBAction)skipToMyOrder:(id)sender {
    if ([self isLogin]) {
        MyOrderFormViewController *vc = [[MyOrderFormViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self skiptoLogin];
    }
    
}

//我的相亲
- (IBAction)myLoveAction:(id)sender {
    if ([self isLogin]) {
        
        MyLikeListController *mylikeVC = [[MyLikeListController alloc]init];
        mylikeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mylikeVC animated:YES];
        
    }else{
        [self skiptoLogin];
    }
    
}
//我的租赁
- (IBAction)myRentAction:(id)sender {
    if ([self isLogin]) {
        MyResumeViewController *vc = [[MyResumeViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self skiptoLogin];
    }
    
}

//我的购物车
- (IBAction)skipToMyShopCar:(id)sender {
    if ([self isLogin]) {
        MyShoppingCartViewController *vc = [[MyShoppingCartViewController alloc] init];
        [vc setReturnReloadGoodsBlock:^{
            
        }];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self skiptoLogin];
    }
    
    
}
//我的二维码
- (IBAction)MyQrAction:(id)sender {
    if ([self isLogin]) {
        MyQrViewController *vc = [[MyQrViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self skiptoLogin];
    }
    
}
//我的客服
- (IBAction)skipToMyService:(id)sender {
    
    MyServiceViewController *vc = [[MyServiceViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length == 0) {
        textField.enabled = NO;
        [textField resignFirstResponder];
        return YES;
    }
    UserViewModel *viewModel = [[UserViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        textField.enabled = NO;
        [self showJGProgressWithMsg:@"保存成功"];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    
    [viewModel updateSignatureWithToken:[self getToken] autograph:textField.text];
    return YES;
}

- (void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];       //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length >= 15) {
                textField.text = [toBeString substringToIndex:15];
            }
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length >= 15) {
            textField.text = [toBeString substringToIndex:15];
        }
    }
    
}

//邀请好友
- (IBAction)inviteFriendAction:(id)sender {
    if ([self isLogin]) {
        NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
        UserModel *userModel = [[UserModel alloc] initWithDict:userinfo];
        
        [self shareWithPageUrl:userModel.share shareTitle:userModel.share_title shareDes:userModel.share_content thumImage:userModel.show_img];
    }else{
        [self skiptoLogin];
    }
}
//我的团队
- (IBAction)skipToMyTeam:(id)sender {
    if ([self isLogin]) {
        MyTeamViewController *vc = [[MyTeamViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self skiptoLogin];
    }
}

- (IBAction)systemMsgAction:(id)sender {
    if ([self isLogin]) {
        SystemMsgListViewController *vc = [[SystemMsgListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self skiptoLogin];
    }
}


@end
