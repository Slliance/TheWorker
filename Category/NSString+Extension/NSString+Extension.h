//
//  NSString+Extension.h
//  QQ聊天布局
//
//  Created by TianGe-ios on 14-8-20.
//  Copyright (c) 2014年 TianGe-ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

- (id)getStrByNull;
@end
