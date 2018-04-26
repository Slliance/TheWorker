//
//  FMLStarView.m
//  TestDemo
//
//  Created by Felix on 16/7/14.
//  Copyright © 2016年 FelixMLians. All rights reserved.
//

#import "FMLStarView.h"

//static const NSInteger kDefaultNumberOfStars = 5;
//static const NSInteger kDefaultScorePercent = 0;
static NSString * const kStarImageStyleNormal = @"icon_gray_small_empty_star";
static NSString * const kStarImageStyleHighlight = @"icon_rent_it_star_rating";

@interface FMLStarView (){
    NSInteger time;
}

@property (nonatomic, strong) UIView *upperView;
@property (nonatomic, strong) UIView *belowView;
@property (nonatomic, assign) NSInteger numberOfStars;
@property (nonatomic, assign) BOOL isTouchable; // isTouchable: 是否可以点击

@end

@implementation FMLStarView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
                numberOfStars:(NSInteger)numberOfStars
                  isTouchable:(BOOL)isTouchable
                        index:(NSInteger)index
               starImgDefault:(NSString *)starImgDefault
                starImgSelect:(NSString *)starImgSelect{
    self.starImgNameDefault = [[NSString alloc]initWithString:starImgDefault];
    self.starImgNameSelect = [[NSString alloc]initWithString:starImgSelect];
    if (self = [super initWithFrame:frame]) {
        
        _numberOfStars = numberOfStars;
        _isTouchable = isTouchable;
        _index = index;
        _totalScore = 0;
        _currentScore = 0;
        time = 1;
        [self configureUI];
        
        if (_isTouchable == YES) {
            UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [self addGestureRecognizer:tapGr];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.currentScore > self.totalScore) {
        _currentScore = self.totalScore;
    }
    else if (self.currentScore < 0) {
        _currentScore = 0;
    }
    else {
        _currentScore = self.currentScore;
    }
    
    CGFloat scorePercent = self.currentScore / self.totalScore;
    if (self.isFullStarLimited == YES) {
        scorePercent = [self changeToCompleteStar:scorePercent];
    }
    if (time == 1) {
            self.upperView.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
    }else{
        self.upperView.frame = CGRectMake(0, 0, self.bounds.size.width * scorePercent, self.bounds.size.height);
    }
    
}

#pragma mark - Event Response

- (void)tapAction:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self];
    CGFloat offset = point.x;
    CGFloat offsetPercent = offset/self.bounds.size.width;
    
    if (self.isFullStarLimited == YES) {
        offsetPercent = [self changeToCompleteStar:offsetPercent];
    }
    
    self.currentScore = offsetPercent * self.totalScore;
    time = 2;
    if ([self.delegate respondsToSelector:@selector(fml_didClickStarViewByScore:atIndex:)]) {
        [self.delegate fml_didClickStarViewByScore:self.currentScore atIndex:self.index];
    }
}


#pragma mark - Private Methods

- (void)configureUI{

        _belowView = [self createStarViewWithImageName:self.starImgNameDefault];
        _upperView = [self createStarViewWithImageName:self.starImgNameSelect];
        [self addSubview:_belowView];
        [self addSubview:_upperView];

}

- (UIView *)createStarViewWithImageName:(NSString *)imageName {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = [UIColor clearColor];
    view.clipsToBounds = YES;
    
    for (NSInteger i = 0; i < _numberOfStars; i++) {
        UIImageView *starImageView = [[UIImageView alloc] init];
        starImageView.image = [UIImage imageNamed:imageName];
        CGFloat w = self.bounds.size.width/5;
        CGFloat h = self.bounds.size.height;
        CGFloat y = 0;
        if (h<20) {
            y = 5;
            h = 12;
        }
        starImageView.frame = CGRectMake(i * w,
                                         y,
                                         h,
                                         h);
        starImageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:starImageView];
    }
    return view;
}

- (CGFloat)changeToCompleteStar:(CGFloat)percent {
    if (percent <= 0.2) {
        percent = 0.2;
    }
    else if (percent > 0.2 && percent <= 0.4) {
        percent = 0.4;
    }
    else if (percent > 0.4 && percent <= 0.6) {
        percent = 0.6;
    }
    else if (percent > 0.6 && percent <= 0.8) {
        percent = 0.8;
    }
    else {
        percent = 1.0;
    }
    return percent;
}

#pragma mark - Accessor

- (void)setCurrentScore:(CGFloat)currentScore {
    if (_currentScore == currentScore) {
        return;
    }
    _currentScore = currentScore;
    
    [self setNeedsLayout];
}

@end
