//
//  UILabel_Extension.m
//  kuaiyonggong
//
//  Created by vic.hu on 9/13/15.
//  Copyright (c) 2015 vic.hu. All rights reserved.
//

#import "UILabel_Extension.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+Extension.h"
#import "UIColor+ValueString.h"
@implementation UILabel_Extension

-(CGSize)setBordColorWithText:(NSString *)txt colorValue:(NSString*)colorValue
{
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [[UIColor colorWithHexString:colorValue] CGColor];
    self.layer.borderWidth = 1.f;
    self.textColor = [UIColor colorWithHexString:colorValue];
    self.textAlignment = NSTextAlignmentCenter;
    self.text = txt;
    self.font = [UIFont systemFontOfSize:10];
    return [txt sizeWithFont:self.font maxSize:CGSizeMake(200, 16)];
}

@end
