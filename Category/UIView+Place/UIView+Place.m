//
//  UIView+Place.m
//  DotHome
//
//  Created by chou on 2016/12/7.
//  Copyright © 2016年 chou. All rights reserved.
//

#import "UIView+Place.h"

@implementation UIView (Place)

- (CGFloat)marginY
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)marginX
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)Width
{
    return self.frame.size.width;
}

- (CGFloat)Height
{
    return self.frame.size.height;
}

- (CGFloat)orginX
{
    return self.frame.origin.x;
}

- (CGFloat)orginY
{
    return self.frame.origin.y;
}

@end
