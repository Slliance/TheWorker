//
//  UIImageView+Extension.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/11/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

-(void)setImageWithString:(NSString *)string placeHoldImageName:(NSString *)name{
    NSURL *url = [[NSURL alloc] init];
    if([string rangeOfString:@"http"].location !=NSNotFound)//_roaldSearchText
    {
        url = [NSURL URLWithString:string];
        
    }
    else
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,string]];
   
    }
    [self setImageWithURL:url placeholderImage:[UIImage imageNamed:name]];
}
@end
