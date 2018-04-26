//
//  HYNetworkwork.m
//  KuaiMa
//
//  Created by kuaima on 15/8/13.
//  Copyright (c) 2015年 Kuaima. All rights reserved.
//

#import "HYNetwork.h"
#import "Reachability.h"
#import "AppDelegate.h"

static HYNetwork* hyNetwork = nil;

@implementation HYNetwork

+ (HYNetwork*) sharedHYNetwork{
    @synchronized(hyNetwork){
        if(hyNetwork == nil){
            hyNetwork = [[HYNetwork alloc] init];
        }
    }
    return hyNetwork;
}

-(InterNetWorkStutus)interNetWorkStatus{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            //            NSLog(@"没有网络连接");
            return NoNetworkConnection;
            break;
            
        case ReachableViaWWAN:
            //            NSLog(@"使用3G网络");
            return Use3GOrGPRSNetwork;
            break;
            
        case ReachableViaWiFi:
            //            NSLog(@"使用WiFi网络");
            return UseWifiNetwork;
            break;
        default:
            break;
    }
}

/*
 * 处理返回的NSDictionary value为NSNull时访问崩溃
 */
- (NSDictionary *)dictionaryByReplacingNullsWithDictionary:(NSDictionary*)_dic {
    return [self processDictionaryIsNSNull:_dic];
}

- (id) processDictionaryIsNSNull:(id)obj{
    const NSString *blank = @"";
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dt = [(NSMutableDictionary*)obj mutableCopy];
        for(NSString *key in [dt allKeys]) {
            id object = [dt objectForKey:key];
            if([object isKindOfClass:[NSNull class]]) {
                [dt setObject:blank
                       forKey:key];
            }
            else if ([object isKindOfClass:[NSString class]]){
                NSString *strobj = (NSString*)object;
                if ([strobj isEqualToString:@"<null>"]) {
                    [dt setObject:blank
                           forKey:key];
                }
                else{//替换 &quot; = "    &gt; = >    &lt; =  <   &#039; = '
                    strobj = [strobj stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
                    strobj = [strobj stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
                    strobj = [strobj stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
                    strobj = [strobj stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
                    strobj = [strobj stringByReplacingOccurrencesOfString:@"▪" withString:@"•"];
                    strobj = [strobj stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
                    [dt setObject:strobj
                           forKey:key];
                    
                }
            }
            else if ([object isKindOfClass:[NSArray class]]){
                NSArray *da = (NSArray*)object;
                da = [self processDictionaryIsNSNull:da];
                [dt setObject:da
                       forKey:key];
            }
            else if ([object isKindOfClass:[NSDictionary class]]){
                NSDictionary *ddc = (NSDictionary*)object;
                ddc = [self processDictionaryIsNSNull:object];
                [dt setObject:ddc forKey:key];
            }
        }
        return [dt copy];
    }
    else if ([obj isKindOfClass:[NSArray class]]){
        NSMutableArray *da = [(NSMutableArray*)obj mutableCopy];
        for (int i=0; i<[da count]; i++) {
            NSDictionary *dc = [obj objectAtIndex:i];
            dc = [self processDictionaryIsNSNull:dc];
            [da replaceObjectAtIndex:i withObject:dc];
        }
        return [da copy];
    }
    else{
        return obj;
    }
}


-(NSString*)countTimeWithString:(NSString*)_string{
    NSString *result = @"";
    
    if (_string) {
        [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_string floatValue]];
        //    date = [date dateByAddingTimeInterval:8*60];
        int t = [date timeIntervalSinceReferenceDate];
        if (t > 24*60*60) {
            NSString *r = [NSString stringWithFormat:@"%@",date];
            result =  [[r componentsSeparatedByString:@" "]firstObject];
        }
        else{
            if (t < 60*60) {
                result =  [NSString stringWithFormat:@"约 %i 分钟前",t/60];
            }
            else{
                result =  [NSString stringWithFormat:@"约 %i 小时前",t/(60*60)];
            }
        }
        
    }
    
    //    NSLog(@"result:%@",result);
    return result;
}

- (NSString*)appendOtherParameters:(NSString*)_url{
    
    //    NSMutableArray *arrTemp = [[NSMutableArray alloc]initWithArray:_arr];
    //    [arrTemp addObject:[NSDictionary dictionaryWithObjectsAndKeys:[self getAccessToken],@"access_token", nil]];
    
    //    //API版本
    //    [arrTemp addObject:[NSDictionary dictionaryWithObjectsAndKeys:APIVERSION,@"version", nil]];
    //    //语言设置
    //    [arrTemp addObject:[NSDictionary dictionaryWithObjectsAndKeys:LanguageKey,@"lang", nil]];
    
    //添加API版本,语言设置
    //        _url = [NSString stringWithFormat:@"%@?access_token=%@&version=%@&lang=%@",_url,[self getAccessToken],APIVERSION,LanguageKey];
    
    return _url;
}


-(void)sendRequestWithURL:(NSString*)_url
                   Method:(NSString*)_method
                Parameter:(NSDictionary*)_parameter
                 callBack:(void (^)(id data))block
{
    @try {
        
        if (_url && _method) {
            //检测网络连接
            if ([self interNetWorkStatus] == NoNetworkConnection) {
                NSError *err = [[NSError alloc]initWithDomain:@"Could not connect to the server" code:-1004 userInfo:nil];
                block(err);
                return;
            }
            if (![_url containsString:@"http"]) {//不是全路径
                _url = [NSString stringWithFormat:@"%@%@",BaseUrl,_url];
            }
            
            //添加附加参数
            _url = [self appendOtherParameters:_url];
            
//            NSString *strTemp = _url;
//            for (int i=0;i<[_parameter count];i++) {
//                NSDictionary *d = [_parameter objectAtIndex:i];
//                if (i == 0) {
//                    strTemp = [NSString stringWithFormat:@"%@?%@=%@",strTemp,[[d allKeys]firstObject],[d objectForKey:[[d allKeys]firstObject]]];
//                }
//                else{
//                    strTemp = [NSString stringWithFormat:@"%@&%@=%@",strTemp,[[d allKeys]firstObject],[d objectForKey:[[d allKeys]firstObject]]];
//                }
//            }
//            NSLog(@"RequestUrl:%@",strTemp);
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            //GET 方法
            if ([_method isEqualToString:@"GET"] || [_method isEqualToString:@"get"]) {
                NSString *token = [UserDefaults readUserDefaultObjectValueForKey:user_token];
                if (token) {
                    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
                }
                [manager GET:_url parameters:_parameter progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"%@",responseObject);
                    if (responseObject) {
                        if ([responseObject isKindOfClass:[NSDictionary class]]) {
                            responseObject = (NSDictionary*)responseObject;
                            responseObject = [self dictionaryByReplacingNullsWithDictionary:responseObject];
                        }
                        
                        //存cookie
                        //                    NSDictionary *fields= [operation.response allHeaderFields];
                        //                        NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:_url]];
                        //                        NSDictionary* requestFields=[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
                        //                    [[NSUserDefaults standardUserDefaults] setObject:[fields objectForKey:@"Cookie"] forKey:PostCookisName];
                        //                    [[NSUserDefaults standardUserDefaults]synchronize];
                        
                        block(responseObject);
                        
                    }
                    else{
                        NSData *daz = responseObject;
                        NSString *strJson =  [[NSString alloc]initWithData:daz encoding:NSUTF8StringEncoding];
                        if (strJson) {
                            NSError *err = [[NSError alloc]initWithDomain:strJson code:1001 userInfo:nil];
                            block(err);
                        }
                        else{
                            NSError *err = [[NSError alloc]initWithDomain:@"have no return string" code:1002 userInfo:nil];
                            block(err);
                        }
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"Error: %@", error);
                    block(error);
                }];
                
                
            }
            else if([_method isEqualToString:@"POST"] || [_method isEqualToString:@"post"]){
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                if ([_parameter.allKeys containsObject:@"token"]) {
                    [manager.requestSerializer setValue:_parameter[@"token"] forHTTPHeaderField:@"token"];
                }

                [manager POST:_url parameters:_parameter progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"%@",responseObject);
                    if (responseObject) {
                        if ([responseObject isKindOfClass:[NSDictionary class]]) {
                            responseObject = (NSDictionary*)responseObject;
                            responseObject = [self dictionaryByReplacingNullsWithDictionary:responseObject];
                        }
                        
                        //存cookie
                        //                    NSDictionary *fields= [operation.response allHeaderFields];
                        //                        NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:_url]];
                        //                        NSDictionary* requestFields=[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
                        //                    [[NSUserDefaults standardUserDefaults] setObject:[fields objectForKey:@"Cookie"] forKey:PostCookisName];
                        //                    [[NSUserDefaults standardUserDefaults]synchronize];
                        
                        block(responseObject);
                        
                    }
                    else{
                        NSData *daz = responseObject;
                        NSString *strJson =  [[NSString alloc]initWithData:daz encoding:NSUTF8StringEncoding];
                        if (strJson) {
                            NSError *err = [[NSError alloc]initWithDomain:strJson code:1001 userInfo:nil];
                            block(err);
                        }
                        else{
                            NSError *err = [[NSError alloc]initWithDomain:@"have no return string" code:1002 userInfo:nil];
                            block(err);
                        }
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"Error: %@", error);
                    block(error);
                }];
            }
            else if([_method isEqualToString:@"delete"] || [_method isEqualToString:@"DELETE"]){
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                //申明返回的结果是json类型
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                
                
                [manager DELETE:_url parameters:_parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"%@",responseObject);
                    if (responseObject) {
                        if ([responseObject isKindOfClass:[NSDictionary class]]) {
                            responseObject = (NSDictionary*)responseObject;
                            responseObject = [self dictionaryByReplacingNullsWithDictionary:responseObject];
                        }
                        
                        //存cookie
                        //                    NSDictionary *fields= [operation.response allHeaderFields];
                        //                        NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:_url]];
                        //                        NSDictionary* requestFields=[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
                        //                    [[NSUserDefaults standardUserDefaults] setObject:[fields objectForKey:@"Cookie"] forKey:PostCookisName];
                        //                    [[NSUserDefaults standardUserDefaults]synchronize];
                        
                        block(responseObject);
                        
                    }
                    else{
                        NSData *daz = responseObject;
                        NSString *strJson =  [[NSString alloc]initWithData:daz encoding:NSUTF8StringEncoding];
                        if (strJson) {
                            NSError *err = [[NSError alloc]initWithDomain:strJson code:1001 userInfo:nil];
                            block(err);
                        }
                        else{
                            NSError *err = [[NSError alloc]initWithDomain:@"have no return string" code:1002 userInfo:nil];
                            block(err);
                        }
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"Error: %@", error);
                    block(error);

                }];
                
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Request Error:%@",exception);
        block(exception);
        
    }
    @finally {
        
    }
}

-(void)sendRequestWithURL:(NSString *)_url
                   method:(NSString *)_method
                parameter:(NSDictionary *)_parameter
                  success:(void (^)(NSDictionary *))success
                     fail:(void (^)(NSString *))fail
{
    @try {
        
        if (_url && _method) {
            
            [self sendRequestWithURL:_url  Method:_method Parameter:_parameter callBack:^(id data){
                if ([data isKindOfClass:[NSDictionary class]]) {
                    if ([data[@"code"] integerValue] == 600) {
                        success(data);
                        [HYNotification postLoginDateNOtification:nil];
                    }else{
                        success(data);
                    }
                }
                else if([data isKindOfClass:[NSError class]]){
                    NSError *err = (NSError*)data;
                    if (err.code == -1004 || err.code == -1005) {
                        fail(@"无法连接，请检查当前网络");
                    }
                    else if (err.code == 1002){
                        fail(@"无数据返回");
                    }
                    else if (err.code == -1001){
                        fail(@"无数据返回");
                    }
                    else{
                        fail(err.description);
                    }
                }
                else if([data isKindOfClass:[NSString class]]){
                    fail(@"无数据返回");
                }
                else{
                    NSException *exception = (NSException*)data;
                    fail(exception.description);
                }
                
            }];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Request Error:%@",exception);
        fail(exception.description);
        
    }
    @finally {
        
    }
    
}

-(void)uploadImageWithURL:(NSString*)_url
                    Image:(UIImage*)_image
                    Filed:(NSString*)_filed
                    parameter:(NSDictionary*)parameter
                  success:(void (^)(NSDictionary *data))_success
                     fail:(void (^)(NSString *error))_fail
{
    NSString *url = [NSString stringWithFormat:@"%@%@", BaseUrl,_url];
    
    NSData *imageData = nil;
    
    if (UIImagePNGRepresentation(_image)) {
//        imageData = UIImagePNGRepresentation(_image);
        imageData = UIImageJPEGRepresentation(_image, 0.6);
    }else {
        imageData = UIImageJPEGRepresentation(_image, 1.0);
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSLog(@"imageData：%@",imageData);
    [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:_filed fileName:[NSString stringWithFormat:@"%@.png",_filed] mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                responseObject = (NSDictionary*)responseObject;
                responseObject = [self dictionaryByReplacingNullsWithDictionary:responseObject];
            }
            
            //存cookie
//            NSDictionary *fields= [operation.response allHeaderFields];
//            NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:_url]];
//            NSDictionary* requestFields=[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
//            [[NSUserDefaults standardUserDefaults] setObject:[requestFields objectForKey:@"Cookie"] forKey:PostCookisName];
//            [[NSUserDefaults standardUserDefaults]synchronize];
            
            
            _success(responseObject);
            
        }
        else{
            
            NSData *daz = responseObject;
            NSString *strJson =  [[NSString alloc]initWithData:daz encoding:NSUTF8StringEncoding];
            if (strJson) {
                _fail(strJson);
            }
            else{
                _fail(@"have no return string");
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _fail(error.description);

    }];
}

-(void)uploadVideoWithURL:(NSString*)_url
                    video:(NSData*)_data
                    Filed:(NSString*)_filed
                parameter:(NSDictionary*)parameter
                  success:(void (^)(NSDictionary *data))_success
                     fail:(void (^)(NSString *error))_fail
{
    NSString *url = [NSString stringWithFormat:@"%@%@", BaseUrl,_url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:_data name:@"img" fileName:[NSString stringWithFormat:@"%@.MP4",_filed] mimeType:@"image/MP4"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                responseObject = (NSDictionary*)responseObject;
                responseObject = [self dictionaryByReplacingNullsWithDictionary:responseObject];
            }

            
            _success(responseObject);
            
        }
        else{
            
            NSData *daz = responseObject;
            NSString *strJson =  [[NSString alloc]initWithData:daz encoding:NSUTF8StringEncoding];
            if (strJson) {
                _fail(strJson);
            }
            else{
                _fail(@"have no return string");
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _fail(error.description);
        
    }];
}

@end
