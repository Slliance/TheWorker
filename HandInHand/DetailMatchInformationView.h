//
//  DetailMatchInformationView.h
//  TheWorker
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailMatchInformationView : UIView
///昵称
@property(nonatomic,strong)UIImageView *nikeImage;
@property(nonatomic,strong)UILabel *nikeNameLabel;
@property(nonatomic,strong)UILabel *detailNikeNameLabel;
///性别
@property(nonatomic,strong)UIImageView *sexImage;
@property(nonatomic,strong)UILabel *sexLabel;
@property(nonatomic,strong)UILabel *detailSexLabel;
///出生日期
@property(nonatomic,strong)UIImageView *birthdayImage;
@property(nonatomic,strong)UILabel *birthdayLabel;
@property(nonatomic,strong)UILabel *detailBirthdayLabel;
///身高
@property(nonatomic,strong)UIImageView *heightImage;
@property(nonatomic,strong)UILabel *heightLabel;
@property(nonatomic,strong)UILabel *detailHeightLabel;
///月收入
@property(nonatomic,strong)UIImageView *incomeImage;
@property(nonatomic,strong)UILabel *incomeLabel;
@property(nonatomic,strong)UILabel *detailIncomeLabel;
///居住地
@property(nonatomic,strong)UIImageView *addressImage;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)UILabel *detailAddressLabel;
///婚姻状况
@property(nonatomic,strong)UIImageView *marriageImage;
@property(nonatomic,strong)UILabel *marriageLabel;
@property(nonatomic,strong)UILabel *detailMarriageLabel;
@end
