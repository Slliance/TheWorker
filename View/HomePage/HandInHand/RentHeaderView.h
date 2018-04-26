//
//  RentHeaderView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/31.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RentPersonModel.h"
@interface RentHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageSex;
@property (weak, nonatomic) IBOutlet UILabel *labelTrust;
-(void)initViewWith:(RentPersonModel *)model;
@end
