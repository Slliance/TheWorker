//
//  HYTabBarBaseViewController.m
//  NewSale
//
//  Created by yanghao on 3/18/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "HYTabBarBaseViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import <NIMSDK/NIMSDK.h>

#define RED_DOT_TAG 899
//#import <Hyphenate/Hyphenate.h>
//#import "HYCallManager.h"
@interface HYTabBarBaseViewController ()<UITabBarDelegate,NIMChatManagerDelegate,NIMLoginManagerDelegate>

@end

@implementation HYTabBarBaseViewController
+ (instancetype)instance{
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc = delegete.window.rootViewController;
    if ([vc isKindOfClass:[HYTabBarBaseViewController class]]) {
        return (HYTabBarBaseViewController *)vc;
    }else{
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.tintColor = [UIColor colorWithHexString:NAGA_BACKGROUND_COLOR];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushToMessage:) name:@"tuisong" object:nil];
    [HYNotification addLoginDateNotification:self action:@selector(skiptoLogin)];
    [HYNotification addLoginNotification:self action:@selector(smallRedPointUpdate)];
    [HYNotification addLogOutNotification:self action:@selector(removeSmallRedPoint)];
    [HYNotification addMsgCountUpdateNotification:self action:@selector(smallRedPointUpdate)];
    [HYNotification addNewFrientCountUpdateNotification:self action:@selector(newFriendCountUpdate:)];
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    [self smallRedPointUpdate];
//    [[HYCallManager sharedManager] setMainController:self];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)skiptoLogin{
    LoginViewController *vc = [[LoginViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.selectedViewController.navigationController pushViewController:vc animated:YES];
    [UserDefaults clearUserDefaultWithKey:user_info];
    [UserDefaults clearUserDefaultWithKey:im_token_key];
    [self removeSmallRedPoint];
    [HYNotification postLogOutNotification:nil];
}

-(void)pushToMessage:(NSNotification *)noti{
//    self.selectedIndex = 1;
}
-(void)onRecvMessages:(NSArray<NIMMessage *> *)messages{
    [self smallRedPointUpdate];
}

-(void)onKick:(NIMKickReason)code
   clientType:(NIMLoginClientType)clientType{
    [self skiptoLogin];
    [self showJGProgressWithMsg:@"你的账号在其他地方登陆"];
}
//消息加小红点
-(void)smallRedPointUpdate{
    NSInteger readCount = [NIMSDK sharedSDK].conversationManager.allUnreadCount;
    UIViewController *msgvc = self.viewControllers[1];
    UITabBarItem *messageBar = msgvc.tabBarItem;

    [self removeSmallRedPoint];
    if (!readCount) {
        [messageBar setBadgeValue:nil];
        return;
    }
//    UIImageView *dotImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_pink_pressed"]];
//    dotImage.backgroundColor = [UIColor clearColor];
//    dotImage.tag = RED_DOT_TAG;
//    CGRect tabFrame = self.tabBar.frame;
//    CGFloat x = ceilf(0.88 * (tabFrame.size.width * 0.4));
//    CGFloat y = ceilf(0.15 * tabFrame.size.height);
//    dotImage.frame = CGRectMake(x, y, 6, 6);
//    [self.tabBar addSubview:dotImage];

    [messageBar setBadgeValue:[NSString stringWithFormat:@"%ld",(long)readCount]];
    if(readCount > 99){
        [messageBar setBadgeValue:@"99+"];
    }
}

-(void)newFriendCountUpdate:(NSNotification *)notifi{
    NSInteger readCount = [[notifi userInfo][@"count"] integerValue];
    UIViewController *msgvc = self.viewControllers[2];
    UITabBarItem *messageBar = msgvc.tabBarItem;
    if (!readCount) {
        [messageBar setBadgeValue:nil];
        return;
    }
    [messageBar setBadgeValue:[NSString stringWithFormat:@"%ld",(long)readCount]];
    if(readCount > 99){
        [messageBar setBadgeValue:@"99+"];
    }

}

-(void)removeSmallRedPoint{
    [[self.tabBar viewWithTag:RED_DOT_TAG] removeFromSuperview];
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
