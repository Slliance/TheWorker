//
//  V_TanTan.h
//  TanTanDemo
//
//  Created by zhujiamin on 2017/9/17.
//  Copyright © 2017年 zhujiamin. All rights reserved.
//

#import "V_SlideCardCell.h"
#import "HandInModel.h"


@interface V_TanTan : V_SlideCardCell

@property (nonatomic, strong) HandInModel  *dataItem;

@property (nonatomic, strong) UIImageView   *iv_like;
@property (nonatomic, strong) UIImageView   *iv_hate;
@property(nonatomic,strong)UIImageView *bgImageView;
@property(nonatomic,strong)UIView *bgview;
@property(nonatomic,strong)UIImageView *sexImage;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *yearLabel;
@property(nonatomic,strong)UILabel *distanceLabel;
@property(nonatomic,strong)UILabel *loveLabel;
@property(nonatomic,strong)UILabel *loveContentLabel;
@property(nonatomic,strong)UIButton *inputBtn;
@end
