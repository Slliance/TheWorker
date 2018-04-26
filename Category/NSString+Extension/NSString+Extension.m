//
//  NSString+Extension.m
//  QQ聊天布局
//
//  Created by TianGe-ios on 14-8-20.
//  Copyright (c) 2014年 TianGe-ios. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (id)getStrByNull{
    if ([self isKindOfClass:[NSNull class]] || [self isEqualToString:@"<null>"] || [self isEqual:nil]) {
        return @"";
    }
    else{
        return self;
    }
}
@end
