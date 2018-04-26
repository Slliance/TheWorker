//
//  ReverseGeoCode.h
//  jhgk
//
//  Created by yanghao on 2/15/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface ReverseGeoCode : NSObject<BMKGeoCodeSearchDelegate>{
    BMKGeoCodeSearch            *_searcher;
}
@property (nonatomic, copy) NSString *citystr;
@property(nonatomic, copy) void(^resultBlock)(NSArray *);
+ (ReverseGeoCode *)sharedManager;

-(void)reverseGeoCode:(CGFloat)latitude longitude:(CGFloat)longitude result:(void(^)(NSArray *))result;
-(void)clearDelegate;


@end
