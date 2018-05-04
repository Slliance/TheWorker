//
//  Archive.m
//  AgentApp
//
//  Created by 张舒 on 2017/4/21.
//  Copyright © 2017年 liujianzhong. All rights reserved.
//

#import "Archive.h"

@implementation Archive
@synthesize dicloan = _dicloan;
@synthesize key = _key;
#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_dicloan forKey:_key];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _dicloan = [aDecoder decodeObjectForKey:_key];
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone {
    Archive *copy = [[[self class] allocWithZone:zone] init];
    copy.dicloan = [self.dicloan copyWithZone:zone];
    return copy;
}
@end
