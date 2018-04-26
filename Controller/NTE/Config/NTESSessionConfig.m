//
//  NTESSessionConfig.m
//  NIM
//
//  Created by amao on 8/11/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESSessionConfig.h"
#import "NIMMediaItem.h"
//#import "NTESSnapchatAttachment.h"
//#import "NTESWhiteboardAttachment.h"
#import "NTESBundleSetting.h"
#import "NIMKitUIConfig.h"
#import "NSString+NTES.h"

@interface NTESSessionConfig()

@end

@implementation NTESSessionConfig

- (NSArray *)mediaItems
{
    NSArray *defaultMediaItems = [NIMKitUIConfig sharedConfig].defaultMediaItems;
    

    
    NIMMediaItem *audioChat =  [NIMMediaItem item:@"onTapMediaItemAudioChat:"
                                      normalImage:[UIImage imageNamed:@"icon_voice_chat"]
                                    selectedImage:nil
                                           title:@"实时语音"];
    
    NIMMediaItem *videoChat =  [NIMMediaItem item:@"onTapMediaItemVideoChat:"
                                      normalImage:[UIImage imageNamed:@"icon_video_chat"]
                                    selectedImage:nil
                                            title:@"视频聊天"];

    NSArray *items = @[audioChat,videoChat];
    
    NSMutableArray *itemMuArr = [[NSMutableArray alloc] initWithArray:defaultMediaItems];
    [itemMuArr removeLastObject];
    [itemMuArr addObjectsFromArray:items];
    return itemMuArr;
    
}

- (BOOL)shouldHandleReceipt{
    return YES;
}

- (NSArray<NSNumber *> *)inputBarItemTypes{
    if (self.session.sessionType == NIMSessionTypeP2P && [[NIMSDK sharedSDK].robotManager isValidRobot:self.session.sessionId])
    {
        //和机器人 点对点 聊天
        return @[
                 @(NIMInputBarItemTypeTextAndRecord),
                ];
    }
    return @[
             @(NIMInputBarItemTypeVoice),
             @(NIMInputBarItemTypeTextAndRecord),
             @(NIMInputBarItemTypeEmoticon),
             @(NIMInputBarItemTypeMore)
            ];
}

- (BOOL)shouldHandleReceiptForMessage:(NIMMessage *)message
{
    //文字，语音，图片，视频，文件，地址位置和自定义消息都支持已读回执，其他的不支持
    NIMMessageType type = message.messageType;
    if (type == NIMMessageTypeCustom) {
        NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
        id attachment = object.attachment;
        
        
    }
    
    
    
    return type == NIMMessageTypeText ||
           type == NIMMessageTypeAudio ||
           type == NIMMessageTypeImage ||
           type == NIMMessageTypeVideo ||
           type == NIMMessageTypeFile ||
           type == NIMMessageTypeLocation ||
           type == NIMMessageTypeCustom;
}

//- (NSArray<NIMInputEmoticonCatalog *> *)charlets
//{
//    return [self loadChartletEmoticonCatalog];
//}

- (BOOL)disableProximityMonitor{
    return [[NTESBundleSetting sharedConfig] disableProximityMonitor];
}

- (NIMAudioType)recordType
{
    return [[NTESBundleSetting sharedConfig] usingAmr] ? NIMAudioTypeAMR : NIMAudioTypeAAC;
}


- (NSArray *)loadChartletEmoticonCatalog{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"NIMDemoChartlet.bundle"
                                         withExtension:nil];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    NSArray  *paths   = [bundle pathsForResourcesOfType:nil inDirectory:@""];
    NSMutableArray *res = [[NSMutableArray alloc] init];
    for (NSString *path in paths) {
        BOOL isDirectory = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
            NIMInputEmoticonCatalog *catalog = [[NIMInputEmoticonCatalog alloc]init];
            catalog.catalogID = path.lastPathComponent;
            NSArray *resources = [NSBundle pathsForResourcesOfType:nil inDirectory:[path stringByAppendingPathComponent:@"content"]];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSString *path in resources) {
                NSString *name  = path.lastPathComponent.stringByDeletingPathExtension;
                NIMInputEmoticon *icon  = [[NIMInputEmoticon alloc] init];
                icon.emoticonID = name.stringByDeletingPictureResolution;
                icon.filename   = path;
                [array addObject:icon];
            }
            catalog.emoticons = array;
            
            NSArray *icons     = [NSBundle pathsForResourcesOfType:nil inDirectory:[path stringByAppendingPathComponent:@"icon"]];
            for (NSString *path in icons) {
                NSString *name  = path.lastPathComponent.stringByDeletingPathExtension.stringByDeletingPictureResolution;
                if ([name hasSuffix:@"normal"]) {
                    catalog.icon = path;
                }else if([name hasSuffix:@"highlighted"]){
                    catalog.iconPressed = path;
                }
            }
            [res addObject:catalog];
        }
    }
    return res;
}


@end
