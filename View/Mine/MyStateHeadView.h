//
//  MyStateHeadView.h
//  TheWorker
//
//  Created by yanghao on 2017/10/24.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MyStateHeadView : UIView

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelName;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *headImgView;

@property (nonatomic, copy) void(^friendDetailBlock)(void);
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (nonatomic, copy) void(^showImgBlock)(void);
@property (nonatomic, copy) void(^lookHeadImgBlock)(NSString *);
@property (nonatomic, copy) NSString *headImgUrl;
-(void)initView:(NSString *)name headUrl:(NSString *)headUrl bgUrl:(NSString *)bgUrl;
@end
