//
//  HYNetworkwork.h
//  KuaiMa
//
//  Created by kuaima on 15/8/13.
//  Copyright (c) 2015年 Kuaima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifdef __OPTIMIZE__
# define NSLog(...) {}
#else
# define NSLog(...) NSLog(__VA_ARGS__)
# define HYBaseUrl                     @"http://120.76.160.229:8080"

#endif


typedef enum InterNetWorkStutus
{
    NoNetworkConnection = 0,
    Use3GOrGPRSNetwork,
    UseWifiNetwork,
}InterNetWorkStutus;

#define PostCookisName                  @"HYNetworkCookieKey"
#define AccessTokenKey                  @"AccessToken"

@interface HYNetwork : NSObject{
    
}

+ (HYNetwork*) sharedHYNetwork;


/*
 * 发送请求
 */
-(void)sendRequestWithURL:(NSString*)_url
                   method:(NSString*)_method
                parameter:(NSDictionary*)_parameter
                  success:(void (^)(NSDictionary *data))_success
                     fail:(void (^)(NSString *error))_fail;

/*
 * 上传图片
 */
-(void)uploadImageWithURL:(NSString*)_url
                    Image:(UIImage*)_image
                    Filed:(NSString*)_filed
                parameter:(NSDictionary*)parameter
                  success:(void (^)(NSDictionary *data))_success
                     fail:(void (^)(NSString *error))_fail;
/*
 *上传视频
*/
-(void)uploadVideoWithURL:(NSString*)_url
                    video:(NSData*)_data
                    Filed:(NSString*)_filed
                parameter:(NSDictionary*)parameter
                  success:(void (^)(NSDictionary *data))_success
                     fail:(void (^)(NSString *error))_fail;
/*
 * 处理返回的NSDictionary value为NSNull时访问崩溃
 */
- (NSDictionary *)dictionaryByReplacingNullsWithDictionary:(NSDictionary*)_dic;

/**
 *  检测网络连接
 *  NoNetworkConnection:没有网络连接;
 *  Use3GOrGPRSNetwork:使用3G网络
 *  UseWifiNetwork:使用WiFi网络;
 **/
-(InterNetWorkStutus)interNetWorkStatus;

//计算时间戳
-(NSString*)countTimeWithString:(NSString*)_string;


@end
