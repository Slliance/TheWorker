//
//  NTESSessionViewController.m
//  NIM
//
//  Created by amao on 8/11/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESSessionViewController.h"
#import "NTESSessionConfig.h"
#import "UIView+NIM.h"
#import "NIMCustomLeftBarView.h"
#import "Reachability.h"
#import "NTESGalleryViewController.h"
#import "NTESVideoChatViewController.h"
#import "NTESAudioChatViewController.h"
#import "NTESMediaPreviewViewController.h"
#import "IDMPhoto.h"
#import "IDMPhotoBrowser.h"
#import "UIImage+NIMKit.h"
#import "FriendDetailViewController.h"
#import "UserModel.h"
@import MobileCoreServices;
@import AVFoundation;


@interface NTESSessionViewController ()

@property (nonatomic,strong)    NTESSessionConfig       *sessionConfig;
@property (nonatomic,strong)    UILabel *titleLabel;

@end



@implementation NTESSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [HYNotification postMsgCountUpdateNotification:nil];
    [self setupNav];
}
- (void)setupNav
{
    [self setUpTitleView];
    NIMCustomLeftBarView *leftBarView = [[NIMCustomLeftBarView alloc] init];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarView];
    UIImage *image = [UIImage imageNamed:@"icon_return"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
      UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClicked)];
//    [leftItem setImage:[UIImage imageNamed:@"icon_return"]];
    self.navigationItem.leftBarButtonItems = @[barButton];
//    self.navigationItem.leftItemsSupplementBackButton = YES;
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"6398f1"]] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
    
    
    [self.sessionInputView.toolBar.voiceBtn setImage:[UIImage nim_imageInKit:@"icon_voice"] forState:UIControlStateNormal];
    [self.sessionInputView.toolBar.voiceBtn sizeToFit];
    
    
    self.sessionInputView.toolBar.emoticonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sessionInputView.toolBar.emoticonBtn setImage:[UIImage nim_imageInKit:@"icon_expression"] forState:UIControlStateNormal];
    [self.sessionInputView.toolBar.emoticonBtn sizeToFit];
    
}
-(void)rightBarButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setUpTitleView
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    self.titleLabel.text = self.sessionTitle;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    
    UIView *titleView = [[UIView alloc] init];
    [titleView addSubview:self.titleLabel];
    
    self.navigationItem.titleView = titleView;
    
    [self layoutTitleView];
    
}

- (void)layoutTitleView
{
    CGFloat maxLabelWidth = 150.f;
    [self.titleLabel sizeToFit];
    self.titleLabel.nim_width = maxLabelWidth;
    
    [self.subTitleLabel sizeToFit];
    self.subTitleLabel.nim_width = maxLabelWidth;
    
    
    UIView *titleView = self.navigationItem.titleView;
    
    titleView.nim_width  = MAX(self.titleLabel.nim_width, self.subTitleLabel.nim_width);
    titleView.nim_height = self.titleLabel.nim_height + self.subTitleLabel.nim_height;
    
    self.subTitleLabel.nim_bottom  = titleView.nim_height;
}


-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id<NIMSessionConfig>)sessionConfig
{
    if (_sessionConfig == nil) {
        _sessionConfig = [[NTESSessionConfig alloc] init];
        _sessionConfig.session = self.session;
    }
    return _sessionConfig;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NIMSDK sharedSDK].mediaManager stopRecord];
    [[NIMSDK sharedSDK].mediaManager stopPlay];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}


#pragma mark - 实时语音
- (void)onTapMediaItemAudioChat:(NIMMediaItem *)item
{
    if ([self checkRTSCondition]) {
        //由于音视频聊天里头有音频和视频聊天界面的切换，直接用present的话页面过渡会不太自然，这里还是用push，然后做出present的效果
        NTESAudioChatViewController *vc = [[NTESAudioChatViewController alloc] initWithCallee:self.session.sessionId];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.25;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:vc animated:NO];
    }
}

#pragma mark - 视频聊天
- (void)onTapMediaItemVideoChat:(NIMMediaItem *)item
{
    if ([self checkRTSCondition]) {
        //由于音视频聊天里头有音频和视频聊天界面的切换，直接用present的话页面过渡会不太自然，这里还是用push，然后做出present的效果
        NTESVideoChatViewController *vc = [[NTESVideoChatViewController alloc] initWithCallee:self.session.sessionId];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.25;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:vc animated:NO];
    }
}


- (BOOL)checkRTSCondition
{
    BOOL result = YES;
    
    if (![[Reachability reachabilityForInternetConnection] isReachable])
    {
        [self showJGProgressWithMsg:@"请检查网络"];
        result = NO;
    }
    NSString *currentAccount = [[NIMSDK sharedSDK].loginManager currentAccount];
    if (self.session.sessionType == NIMSessionTypeP2P && [currentAccount isEqualToString:self.session.sessionId])
    {
        [self showJGProgressWithMsg:@"不能和自己通话哦"];

        result = NO;
    }
    if (self.session.sessionType == NIMSessionTypeTeam)
    {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
        NSInteger memberNumber = team.memberNumber;
        if (memberNumber < 2)
        {
            [self showJGProgressWithMsg:@"无法发起，群人数少于2人"];
            result = NO;
        }
    }
    return result;
}
#pragma mark - 录音事件
- (void)onRecordFailed:(NSError *)error
{
//    [self.view makeToast:@"录音失败" duration:2 position:CSToastPositionCenter];
    [self showJGProgressWithMsg:@"录音失败"];
}

- (BOOL)recordFileCanBeSend:(NSString *)filepath
{
    NSURL    *URL = [NSURL fileURLWithPath:filepath];
    AVURLAsset *urlAsset = [[AVURLAsset alloc]initWithURL:URL options:nil];
    CMTime time = urlAsset.duration;
    CGFloat mediaLength = CMTimeGetSeconds(time);
    return mediaLength > 2;
}

- (void)showRecordFileNotSendReason
{
//    [self.view makeToast:@"录音时间太短" duration:0.2f position:CSToastPositionCenter];
    [self showJGProgressWithMsg:@"录音时间太短"];
}

#pragma mark - Cell事件
- (BOOL)onTapCell:(NIMKitEvent *)event
{
    BOOL handled = [super onTapCell:event];
    NSString *eventName = event.eventName;
    if ([eventName isEqualToString:NIMKitEventNameTapContent])
    {
        NIMMessage *message = event.messageModel.message;
        NSDictionary *actions = [self cellActions];
        NSString *value = actions[@(message.messageType)];
        if (value) {
            SEL selector = NSSelectorFromString(value);
            if (selector && [self respondsToSelector:selector]) {
                SuppressPerformSelectorLeakWarning([self performSelector:selector withObject:message]);
                handled = YES;
            }
        }
    }
    else if([eventName isEqualToString:NIMKitEventNameTapLabelLink])
    {
        NSString *link = event.data;
        [self openSafari:link];
        handled = YES;
    }

   
    if (!handled) {
        NSAssert(0, @"invalid event");
    }
    return handled;
}

- (BOOL)onTapAvatar:(NSString *)userId{
    NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    UserModel *userModel = [[UserModel alloc] initWithDict:userinfo];
    if ([userModel.mobile isEqualToString:userId]) {
        return YES;
    }
    
    FriendDetailViewController *vc = [[FriendDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.mobile = userId;
    [self.navigationController pushViewController:vc animated:YES];

    return YES;
}



#pragma mark - Cell Actions
- (void)showImage:(NIMMessage *)message
{
    NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc] init];
    option.limit = 0;
    option.messageTypes = @[@(NIMMessageTypeImage),@(NIMMessageTypeVideo)];
    __weak typeof(self) weakSelf = self;
    [[NIMSDK sharedSDK].conversationManager searchMessages:self.session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        if (weakSelf)
        {
            NSMutableArray *objects = [[NSMutableArray alloc] init];
            NTESMediaPreviewObject *focusObject;
            
            //显示的时候新的在前老的在后，逆序排列
            //如果需要微信的显示顺序，则直接将这段代码去掉即可
//            NSArray *array = messages.reverseObjectEnumerator.allObjects;
            NSInteger i = 0;
            NSInteger index = 0;
            for (NIMMessage *xmessage in messages)
            {
                switch (xmessage.messageType) {
                    
                    case NIMMessageTypeImage:{
                        NTESMediaPreviewObject *object = [weakSelf previewObjectByImage:xmessage.messageObject];
                        //图片 thumbPath 一致，就认为是本次浏览的图片
                        if ([xmessage.messageId isEqualToString:message.messageId])
                        {
                            focusObject = object;
                            index = i;
                        }
                        [objects addObject:object];
                        break;
                    }
                    default:
                        break;
                }
                i++;

            }
            [weakSelf lookPhoto:objects index:index];
        }
    }];
    
    
    
    
    
//    NIMImageObject *object = message.messageObject;
//    NTESGalleryItem *item = [[NTESGalleryItem alloc] init];
//    item.thumbPath      = [object thumbPath];
//    item.imageURL       = [object url];
//    item.name           = [object displayName];
//    item.itemId         = [message messageId];
//
//    NIMSession *session = [self isMemberOfClass:[NTESSessionViewController class]]? self.session : nil;
//
//    NTESGalleryViewController *vc = [[NTESGalleryViewController alloc] initWithItem:item session:session];
//    [self.navigationController pushViewController:vc animated:YES];
//    if(![[NSFileManager defaultManager] fileExistsAtPath:object.thumbPath]){
//        //如果缩略图下跪了，点进看大图的时候再去下一把缩略图
//        __weak typeof(self) wself = self;
//        [[NIMSDK sharedSDK].resourceManager download:object.thumbUrl filepath:object.thumbPath progress:nil completion:^(NSError *error) {
//            if (!error) {
//                [wself uiUpdateMessage:message];
//            }
//        }];
//    }
}
- (NTESMediaPreviewObject *)previewObjectByImage:(NIMImageObject *)object
{
    NTESMediaPreviewObject *previewObject = [[NTESMediaPreviewObject alloc] init];
    previewObject.objectId = object.message.messageId;
    previewObject.thumbPath = object.thumbPath;
    previewObject.thumbUrl  = object.thumbUrl;
    previewObject.path      = object.path;
    previewObject.url       = object.url;
    previewObject.type      = NTESMediaPreviewTypeImage;
    previewObject.timestamp = object.message.timestamp;
    previewObject.displayName = object.displayName;
    return previewObject;
}
//- (void)showVideo:(NIMMessage *)message
//{
//    NIMVideoObject *object = message.messageObject;
//    NIMSession *session = [self isMemberOfClass:[NTESSessionViewController class]]? self.session : nil;
//
//    NTESVideoViewItem *item = [[NTESVideoViewItem alloc] init];
//    item.path = object.path;
//    item.url  = object.url;
//    item.session = session;
//    item.itemId  = object.message.messageId;
//
//    NTESVideoViewController *playerViewController = [[NTESVideoViewController alloc] initWithVideoViewItem:item];
//    [self.navigationController pushViewController:playerViewController animated:YES];
//    if(![[NSFileManager defaultManager] fileExistsAtPath:object.coverPath]){
//        //如果封面图下跪了，点进视频的时候再去下一把封面图
//        __weak typeof(self) wself = self;
//        [[NIMSDK sharedSDK].resourceManager download:object.coverUrl filepath:object.coverPath progress:nil completion:^(NSError *error) {
//            if (!error) {
//                [wself uiUpdateMessage:message];
//            }
//        }];
//    }
//}

//- (void)showLocation:(NIMMessage *)message
//{
//    NIMLocationObject *object = message.messageObject;
//    NIMKitLocationPoint *locationPoint = [[NIMKitLocationPoint alloc] initWithLocationObject:object];
//    NIMLocationViewController *vc = [[NIMLocationViewController alloc] initWithLocationPoint:locationPoint];
//    [self.navigationController pushViewController:vc animated:YES];
//}


- (void)openSafari:(NSString *)link
{
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:link];
    if (components)
    {
        if (!components.scheme)
        {
            //默认添加 http
            components.scheme = @"http";
        }
        [[UIApplication sharedApplication] openURL:[components URL]];
    }
}



- (NSDictionary *)cellActions
{
    static NSDictionary *actions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actions = @{@(NIMMessageTypeImage) :    @"showImage:",
                    @(NIMMessageTypeVideo) :    @"showVideo:",
                    @(NIMMessageTypeLocation) : @"showLocation:",
                    @(NIMMessageTypeFile)  :    @"showFile:",
                    @(NIMMessageTypeCustom):    @"showCustom:"};
    });
    return actions;
}

//查看图片
-(void)lookPhoto:(NSArray *)arr index:(NSInteger)index{
    NSMutableArray *photosURL = [[NSMutableArray alloc] init];
    
    for ( int i = 0; i < arr.count; i ++) {
        NTESMediaPreviewObject *model = arr[i];
        if (model.url) {
            NSURL *url = [NSURL URLWithString:model.url];
            [photosURL addObject:url];
        }
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


@end
