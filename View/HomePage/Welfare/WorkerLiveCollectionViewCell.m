//
//  WorkerLiveCollectionViewCell.m
//  TheWorker
//
//  Created by yanghao on 8/19/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "WorkerLiveCollectionViewCell.h"

@implementation WorkerLiveCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initCell{
    
    self.labelEye.layer.masksToBounds = YES;
    self.labelEye.layer.cornerRadius = 8.f;
    
    [self.eyeBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:3.f];
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = 15.f;
    
    self.labelAddress.textColor = [UIColor colorWithHexString:@"666666"];
    
}


@end
