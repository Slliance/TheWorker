//
//  ReverseGeoCode.m
//  jhgk
//
//  Created by yanghao on 2/15/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "ReverseGeoCode.h"
@implementation ReverseGeoCode
+ (ReverseGeoCode *)sharedManager
{
    static ReverseGeoCode *getInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        getInstance = [[self alloc] init];
    });
    return getInstance;
}

-(void)reverseGeoCode:(CGFloat)latitude longitude:(CGFloat)longitude result:(void (^)(NSArray *))result{
    [self setResultBlock:^(NSArray *cityArr){
        result(cityArr);
    }];
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    //    发起反向地理编码检索
//    coor.latitude = 39.915;
//    
//    coor.longitude = 116.404;
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){latitude, longitude};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
    BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
      NSLog(@"反geo检索发送成功");
    }
    else
    {
      NSLog(@"反geo检索发送失败");
    }
}
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
errorCode:(BMKSearchErrorCode)error{
//  if (error == BMK_SEARCH_NO_ERROR) {
//      NSString *city = result.addressDetail.city;
//      NSString *citystr = [NSString stringWithFormat:@"%@%@%@",city,result.addressDetail.district,result.addressDetail.streetName];
//      self.resultBlock(citystr);
//
//  }
//  else {
//      NSLog(@"抱歉，未找到结果");
//  }
    
    [SVProgressHUD dismiss];
    NSString * resultAddress = @"";
    NSString * houseName = @"";
    
//    CLLocationCoordinate2D  coor = result.location;
    
    if(result.poiList.count > 0){
        BMKPoiInfo * info = result.poiList[0];
        if([info.name rangeOfString:@"-"].location != NSNotFound){
            houseName = [info.name componentsSeparatedByString:@"-"][0];
        }else{
            houseName = info.name;
        }
        resultAddress = [NSString stringWithFormat:@"%@%@",result.address,info.name];
    }else{
        resultAddress =result.address;
    }
    if (houseName && result.address) {
        NSArray *cityArr = @[houseName,result.address];
        self.resultBlock(cityArr);

    }
//    self.resultBlock(houseName);
//    if(resultAddress.length == 0){
//        self.addressLabel.text = @"位置解析错误，请拖动重试！";
//        return;
//    }
//
//    self.addressLabel.text = resultAddress;
//
//    self.location2D = coor;
//    self.name = houseName;
}

//不使用时将delegate设置为 nil
-(void)clearDelegate
{
    _searcher.delegate = nil;
}
@end
