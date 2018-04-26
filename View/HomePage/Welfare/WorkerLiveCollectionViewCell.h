//
//  WorkerLiveCollectionViewCell.h
//  TheWorker
//
//  Created by yanghao on 8/19/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkerLiveCollectionViewCell : UICollectionViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UIView *eyeView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *labelEye;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *eyeBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imgView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelContent;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *headImgView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelName;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelAddress;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelAge;


-(void)initCell;

@end
