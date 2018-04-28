//
//  MatchMakingInformationView.m
//  TheWorker
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "MatchMakingInformationView.h"

@implementation MatchMakingInformationView

-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}
-(UIImageView *)sexImage{
    if (!_sexImage) {
        _sexImage = [[UIImageView alloc]init];
        _sexImage.image = [UIImage imageNamed:@"icon_female"];
    }
    return _sexImage;
}
@end
