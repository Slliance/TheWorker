//
//  JFCityCollectionViewCell.m
//  JFFootball
//
//  Created by 张志峰 on 2016/11/21.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import "JFCityCollectionViewCell.h"

#define JFRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]

@interface JFCityCollectionViewCell ()

@property (nonatomic, strong) UILabel *label;
@property(nonatomic,strong)UIImageView *image;


@end

@implementation JFCityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = DSColorFromHex(0x4D4D4D);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        self.label = label;
        UIImageView *image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:@"positioning_icon"];
        [self addSubview:image];
        self.image = image;
    }
    return self;    
}

/// 设置collectionView cell的border
- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = JFRGBAColor(155, 155, 165, 0.5).CGColor;
    self.layer.masksToBounds = YES;
}
-(void)setSections:(NSString *)sections{
    _sections = sections;
}
- (void)setTitle:(NSString *)title {
    self.label.text = title;
    
    if ([title isEqualToString:[kCurrentCityInfoDefaults objectForKey:@"locationCity"]]&&[_sections integerValue]== 0) {
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(13);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(12);
            make.height.mas_equalTo(15);
        }];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.image.mas_right).offset(4);
            make.right.equalTo(self).offset(-13);
        }];
        
    }else{
        
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(13);
            make.right.equalTo(self).offset(-13);
            make.centerY.equalTo(self);
        }];
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(13);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }];
    }
}

@end
