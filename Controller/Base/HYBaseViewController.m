//
//  BaseViewController.m
//  Analyst
//
//  Created by vic.hu on 15/5/6.
//  Copyright (c) 2015年 vic.hu. All rights reserved.
//

#import "HYBaseViewController.h"
#import <UShareUI/UShareUI.h>
#import <UMSocialCore/UMSocialCore.h>
#import "LoginViewController.h"
#import "NotVertificationViewController.h"
#import "VertificateDefeatViewController.h"
#import "VertificateResultViewController.h"
#import "IdentityVerificationViewController.h"
#import "UserModel.h"
static NSString* const UMS_THUMB_IMAGE = @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
static NSString* const UMS_IMAGE = @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
@interface HYBaseViewController ()

@end

@implementation HYBaseViewController
- (id)init
{
    self = [super init];
    if (self) {
        //Normal文字颜色
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11],NSFontAttributeName,[UIColor grayColor],NSForegroundColorAttributeName ,nil] forState:UIControlStateNormal];
        
        //Selected文字颜色
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11],NSFontAttributeName,[UIColor colorWithHexString:NAGA_BACKGROUND_COLOR],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        [self setNeedsStatusBarAppearanceUpdate];
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }     // Do any additional setup after loading the view from its nib.
    // Do any additional setup after loading the view.
    
    
}


-(NavgationView *)navView{
    if (!_navView) {
        _navView = [[NavgationView alloc]init];
        _navView.delegate = self;
    }
    return _navView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent; //白色
//    return UIStatusBarStyleDefault; //黑色
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initNavgationBarWithTitle:(NSString *)titleStr
{
    UILabel *labelNavigation = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, ScreenWidth - 200, 64)];
    labelNavigation.text = titleStr;
    labelNavigation.textColor = [UIColor whiteColor];
    labelNavigation.font = [UIFont systemFontOfSize:17];
    labelNavigation.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = labelNavigation;
    [self setNavgationBackGroundImg];
}

/**
 *  设置导航条背景图片
 */
-(void)setNavgationBackGroundImgWithImgName:(NSString *)imgName
{
    UIImage *nav_bg = [UIImage imageNamed:imgName];
    [self.navigationController.navigationBar setBackgroundImage:nav_bg forBarMetrics:UIBarMetricsDefault];
}
-(void)setNavgationBackGroundImgWithImg:(UIImage *)img{
    [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
}
-(void)setNavigationBar:(NSString *)title
{
    _topNavigationView = [UIView new];
    _topNavigationView.frame = CGRectMake(0, 0, ScreenWidth, 64);
    _topNavigationView.backgroundColor = UIColorFromRGB(0xffffff);
    
    [self.view addSubview:_topNavigationView];
    [self.view bringSubviewToFront:_topNavigationView];
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame = CGRectMake((ScreenWidth - 200) / 2, 20, 200, 44);
    titleLabel.textColor = UIColorFromRGB(0x1e83ee);
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18];
    [_topNavigationView addSubview:titleLabel];
    
    UIView *sepview = [UIView new];
    sepview.backgroundColor = UIColorFromRGB(0xe5e5e5);
    sepview.frame = CGRectMake(0, 63, ScreenWidth, 1);
    [_topNavigationView addSubview:sepview];
}
-(void)addBackButton
{
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 20, 44, 44);
    [btnBack setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [_topNavigationView addSubview:btnBack];
}
//-(void)back
//{
//     [self.navigationController popViewControllerAnimated:YES];
//}
-(void)setNavgationBackGroundImg{
    [self setNavgationBackGroundImgWithImg:[self imageWithColor:[UIColor colorWithHexString:NAGA_BACKGROUND_COLOR]]];

}
-(void)setNavgationBack
{
    UIButton *btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_back setImage:[UIImage imageNamed:@"icon_return" ] forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn_back.frame = CGRectMake(0, 0, 23 , 40);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn_back];
}

-(void)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setNavgationLeftWithName:(NSString *)name font:(UIFont *)font color:(UIColor *)color size:(CGSize)size action:(SEL)action
{
    UIButton *btn_left = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_left addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn_left.frame = CGRectMake(0, 0, 50 , 44);
    btn_left.titleLabel.font = font;
    [btn_left setTitleColor:color forState:UIControlStateNormal];
    [btn_left setTitle:name forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn_left];
    
}
-(void)setNavgationLeftWithName:(NSString *)name img:(UIImage *)img font:(UIFont *)font color:(UIColor *)color size:(CGSize)size action:(SEL)action
{
    UIButton *btn_left = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_left addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn_left.frame = CGRectMake(0, 0, 60 , 44);
    btn_left.titleLabel.font = font;
    [btn_left setImage:img forState:UIControlStateNormal];
    [btn_left setTitleColor:color forState:UIControlStateNormal];
    [btn_left setTitle:name forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn_left];
    
}

-(void)setNavgationRightWithName:(NSString *)name font:(UIFont *)font color:(UIColor *)color size:(CGSize)size action:(SEL)action
{
    UIButton *btn_right = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_right addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn_right.frame = CGRectMake(0, 0, size.width , size.height);
    btn_right.titleLabel.font = font;
    [btn_right setTitle:name forState:UIControlStateNormal];
    [btn_right setTitleColor:color forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn_right];
    
}
-(void)setNavgationLeftWithImgName:(NSString *)normalImgName highlighted:(NSString *)highlightedImaName size:(CGSize)size action:(SEL)action
{
    UIButton *btn_left = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_left setImage:[UIImage imageNamed:normalImgName] forState:UIControlStateNormal];
    [btn_left setImage:[UIImage imageNamed:highlightedImaName] forState:UIControlStateHighlighted];
    [btn_left addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn_left.frame = CGRectMake(0, 0, size.width , size.height);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn_left];
}

-(void)setNavgationRightWithImgName:(NSString *)normalImgName highlighted:(NSString *)highlightedImaName size:(CGSize)size action:(SEL)action
{
    UIButton *btn_right = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_right setImage:[UIImage imageNamed:normalImgName] forState:UIControlStateNormal];
    [btn_right setImage:[UIImage imageNamed:highlightedImaName] forState:UIControlStateHighlighted];
    [btn_right addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn_right.frame = CGRectMake(0, 0, size.width , size.height);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn_right];
}
-(void)setNavgationRightWithImgName:(NSString *)normalImgName highlighted:(NSString *)highlightedImaName size:(CGSize)size action:(SEL)action
                      normalImgName:(NSString *)normalImgName2 highlighted:(NSString *)highlightedImaName2 size:(CGSize)size2 action:(SEL)action2
{
    UIButton *btn_right = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_right setImage:[UIImage imageNamed:normalImgName] forState:UIControlStateNormal];
    [btn_right setImage:[UIImage imageNamed:highlightedImaName] forState:UIControlStateHighlighted];
    [btn_right setImage:[UIImage imageNamed:highlightedImaName] forState:UIControlStateSelected];
    [btn_right addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn_right.frame = CGRectMake(0, 0, size.width , size.height);
    
    UIButton *btn_right2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_right2 setImage:[UIImage imageNamed:normalImgName2] forState:UIControlStateNormal];
    [btn_right2 setImage:[UIImage imageNamed:highlightedImaName2] forState:UIControlStateHighlighted];
    [btn_right2 setImage:[UIImage imageNamed:highlightedImaName2] forState:UIControlStateSelected];
    [btn_right2 addTarget:self action:action2 forControlEvents:UIControlEventTouchUpInside];
    btn_right2.frame = CGRectMake(0, 0, size2.width , size2.height);

    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:btn_right],[[UIBarButtonItem alloc] initWithCustomView:btn_right2]] ;
}
-(void)setNavgationRightWithImgName:(NSString *)normalImgName highlighted:(NSString *)highlightedImaName size:(CGSize)size action:(SEL)action negativeSpacer:(BOOL)negativeSpacer width:(CGFloat)width
{
    UIButton *btn_right = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_right setImage:[UIImage imageNamed:normalImgName] forState:UIControlStateNormal];
    [btn_right setImage:[UIImage imageNamed:highlightedImaName] forState:UIControlStateHighlighted];
    [btn_right addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn_right.frame = CGRectMake(0, 0, size.width , size.height);
    btn_right.layer.masksToBounds = YES;
    btn_right.layer.cornerRadius = 15.f;
    if (negativeSpacer) {
        UIBarButtonItem *negativeSpacerItem = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                               target:nil action:nil];
        
        negativeSpacerItem.width = width;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacerItem, [[UIBarButtonItem alloc] initWithCustomView:btn_right], nil];
    }
    else{
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: [[UIBarButtonItem alloc] initWithCustomView:btn_right], nil];
    }
}
-(void)initTabBarItemWithTitle:(NSString *)titleStr normalImg:(NSString *)normalImg selectImg:(NSString *)selectImg  tag:(NSInteger)tag{
    //构建TabBarItem
    
    //Normal文字颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11],NSFontAttributeName,[UIColor darkGrayColor],NSForegroundColorAttributeName ,nil] forState:UIControlStateNormal];
    
    //Selected文字颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11],NSFontAttributeName,[UIColor redColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    UITabBarItem *item = [[UITabBarItem alloc] init];
    [item setTitle:titleStr];
    
    item.image = [[UIImage imageNamed:normalImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [[UIImage imageNamed:selectImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item setTag:tag];
    self.tabBarItem = item;
}
-(UIImage*)imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

/**
 *  添加阴影
 */
-(void)addShadow:(UIView *)shadowView offset:(CGSize)offset
{
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowView.layer.shadowOpacity =  0.3f;
    shadowView.layer.shadowOffset = offset;
    shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowView.bounds].CGPath;
}



/**
 *  获取本地时间
 */
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

//-(void)viewWillAppear:(BOOL)animated{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//}

//分享
-(void)shareWithPageUrl:(NSString *)url shareTitle:(NSString *)shareTitle shareDes:(NSString *)shareDes thumImage:(id)thumImage{
    NSString *imageUrl = @"";
    if([thumImage rangeOfString:@"http"].location !=NSNotFound)//_roaldSearchText
    {
        imageUrl = [NSString stringWithFormat:@"%@",thumImage];
        
    }
    else
    {
        imageUrl = [NSString stringWithFormat:@"%@%@",BaseUrl,thumImage];
        
    }
    [UMSocialUIManager removeAllCustomPlatformWithoutFilted];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRadius;
    
    NSMutableArray *platforms = [[NSMutableArray alloc] initWithArray:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Sina]) {
        [platforms addObject:@(UMSocialPlatformType_Sina)];
    }
    [UMSocialUIManager setPreDefinePlatforms:platforms];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareImageURLToPlatformType:platformType pageUrl:url shareTitle:shareTitle shareDes:shareDes thumImage:imageUrl];
    }];
    
    
}

//分享网络图片
- (void)shareImageURLToPlatformType:(UMSocialPlatformType)platformType pageUrl:(NSString *)pageUrl  shareTitle:(NSString *)shareTitle shareDes:(NSString *)shareDes  thumImage:(id)thumImage
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *webPageObject = [UMShareWebpageObject shareObjectWithTitle:shareTitle descr:shareDes thumImage:[NSData dataWithContentsOfURL:[NSURL URLWithString:thumImage]]];//[UIImage imageNamed:@"bg_no_pictures"]
    
    webPageObject.webpageUrl = pageUrl;
    
    // 设置Pinterest参数
    if (platformType == UMSocialPlatformType_Pinterest) {
        [self setPinterstInfo:messageObject];
    }
    
    // 设置Kakao参数
    if (platformType == UMSocialPlatformType_KakaoTalk) {
        messageObject.moreInfo = @{@"permission" : @1}; // @1 = KOStoryPermissionPublic
    }
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = webPageObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        
        if (error) {
            if (error.code == UMSocialPlatformErrorType_ShareFailed) {
                [self showJGProgressWithMsg:@"分享失败"];
            }
            else if (error.code == UMSocialPlatformErrorType_Cancel){
                [self showJGProgressWithMsg:@"分享取消"];
            }
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            [self showJGProgressWithMsg:@"分享成功"];
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
//                [self showJGProgressWithMsg:resp.message];
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

- (void)setPinterstInfo:(UMSocialMessageObject *)messageObj
{
    NSString *shareUrl = @"http://47.93.115.201:8080/jhgk/rest/Share/sharePage.jsp";
    
    messageObj.moreInfo = @{@"source_url": shareUrl,
                            @"app_name": @"员工的名义",
                            @"suggested_board_name": @"",
                            @"description": @""};
}

-(void)skiptoLogin{
    LoginViewController *vc = [[LoginViewController alloc] init];
    vc.loginType = 1;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)skiptoLoginAndBackRootVC{
    LoginViewController *vc = [[LoginViewController alloc] init];
    vc.loginType = 2;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)setTextFieldLeftView:(UITextField *)textField :(NSString *)imgStr :(NSInteger)width{
    UIImageView *LeftViewNum = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgStr]];
    //图片的显示模式
    LeftViewNum.contentMode= UIViewContentModeCenter;
    //图片的位置和大小
    LeftViewNum.frame= CGRectMake(10,0,width,30);
    //左视图默认是不显示的 设置为始终显示
    textField.leftViewMode= UITextFieldViewModeAlways;
    textField.leftView= LeftViewNum;

}

//获取token
-(NSString *)getToken{
    NSDictionary *userDic = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    if (userDic) {
        UserModel *userModel = [[UserModel  alloc] initWithDict:userDic];
        return userModel.token;
    }
    return @"";
}
-(BOOL)isLogin{
    NSDictionary *userDic = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    if (userDic) {
        return YES;
    }
    return NO;
}
-(void)skipToRenZhenVC:(NSNumber *)auth{
    NSInteger *authState = [auth integerValue];
    if (authState == 0) {
        NotVertificationViewController *vc = [[NotVertificationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (authState == 1){
        VertificateResultViewController *vc = [[VertificateResultViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (authState == 2){
        IdentityVerificationViewController *vc = [[IdentityVerificationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        VertificateDefeatViewController *vc = [[VertificateDefeatViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end

