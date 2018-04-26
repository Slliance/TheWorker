//
//  RentRangeTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/6.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RentRangeTableViewCell.h"
#import "SkillModel.h"
@implementation RentRangeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initCellWithData:(NSArray *)array index:(NSInteger)index{

    self.skillArray = [[NSMutableArray alloc]initWithArray:array];
    for (UIView *subview in self.skillBgView.subviews) {
        if (subview.tag > 800) {
            [subview removeFromSuperview];
        }
    }
    
    CGFloat w = (ScreenWidth - 95 ) / 2;
    CGFloat h = w/111*58;
    CGFloat margin = ScreenWidth-80-2*w;
    CGRect rectView = self.skillBgView.frame;
    rectView.size.height = (self.skillArray.count+1)/2*(h+margin);
    self.skillBgView.frame = rectView;
//    self.skillBgView.contentSize = CGSizeMake(ScreenWidth, sw*(self.imageArray.count-1)/3+sw);
    
    for (int i = 0; i < self.skillArray.count; i ++) {
        SkillModel *model = self.skillArray[i];
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(40+i%2*(w+margin), 10 +(h+10)*(i/2), w, h)];
            backview.tag = 801 + i;
            backview.backgroundColor = [UIColor whiteColor];
        backview.layer.borderColor = [UIColor colorWithHexString:@"ef5f7d"].CGColor;
        backview.layer.borderWidth = 1;
        UILabel *skillLabel = [[UILabel alloc] init];
        if (index == 0) {
            skillLabel.text = model.skill;
        }else{
            skillLabel.text = model.name;
        }
        CGSize size = [skillLabel.text sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(300, 300)];
        skillLabel.frame = CGRectMake((w-size.width)/2 , 15, size.width, size.height );
        skillLabel.textColor = [UIColor colorWithHexString:@"333333"];
        skillLabel.font = [UIFont systemFontOfSize:13];
            [backview addSubview:skillLabel];
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.text = [NSString stringWithFormat:@"%@元/小时",model.price];
        CGSize sizeTwo = [priceLabel.text sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(300, 300)];
        priceLabel.frame = CGRectMake((w-sizeTwo.width)/2 , 35, sizeTwo.width, sizeTwo.height );
        priceLabel.textColor = [UIColor colorWithHexString:@"999999"];
        priceLabel.font = [UIFont systemFontOfSize:13];
//        priceLabel.text = [NSString stringWithFormat:@"%@",model.price];
        [backview addSubview:priceLabel];

        
        
            UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [delBtn setImageEdgeInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
        CGRect rect = backview.frame;
            delBtn.frame = CGRectMake(rect.origin.x+rect.size.width - 18, rect.origin.y - 18, 36, 36);
            delBtn.tag = 801 + i;
            [delBtn setImage:[UIImage imageNamed:@"icon_cancel1"] forState:UIControlStateNormal];
            [delBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
         [self.skillBgView addSubview:backview];
        [self.skillBgView addSubview:delBtn];
    }
}

-(void)initCellWithData:(NSArray *)array{
    self.skillArray = [[NSMutableArray alloc]initWithArray:array];
    for (UIView *subview in self.skillBgView.subviews) {
        if (subview.tag > 800) {
            [subview removeFromSuperview];
        }
    }
    
    CGFloat w = (ScreenWidth - 95 ) / 2;
    CGFloat h = w/111*58;
    CGFloat margin = ScreenWidth-80-2*w;
    CGRect rectView = self.skillBgView.frame;
    rectView.size.height = (self.skillArray.count+1)/2*(h+margin);
    self.skillBgView.frame = rectView;
    //    self.skillBgView.contentSize = CGSizeMake(ScreenWidth, sw*(self.imageArray.count-1)/3+sw);
    
    for (int i = 0; i < self.skillArray.count; i ++) {
        
        UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(40+i%2*(w+margin), 10+(h+10)*(i/2), w, h)];
        backview.tag = 801 + i;
        backview.backgroundColor = [UIColor whiteColor];
        backview.layer.borderColor = [UIColor colorWithHexString:@"ef5f7d"].CGColor;
        backview.layer.borderWidth = 1;
        UILabel *skillLabel = [[UILabel alloc] init];
        
        SkillModel *model = self.skillArray[i];
        skillLabel.text = model.name;
        
        
        CGSize size = [skillLabel.text sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(300, 300)];
        skillLabel.frame = CGRectMake((w-size.width)/2 , 15, size.width, size.height );
        skillLabel.textColor = [UIColor colorWithHexString:@"333333"];
        skillLabel.font = [UIFont systemFontOfSize:13];
        [backview addSubview:skillLabel];
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.text = [NSString stringWithFormat:@"%@元/小时",model.price];
        CGSize sizeTwo = [priceLabel.text sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(300, 300)];
        priceLabel.frame = CGRectMake((w-sizeTwo.width)/2 , 35, sizeTwo.width, sizeTwo.height );
        priceLabel.textColor = [UIColor colorWithHexString:@"999999"];
        priceLabel.font = [UIFont systemFontOfSize:13];
//        priceLabel.text = [NSString stringWithFormat:@"%@",model.price];
        [backview addSubview:priceLabel];
        
        
        
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setImageEdgeInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
        CGRect rect = backview.frame;
        delBtn.frame = CGRectMake(rect.origin.x+rect.size.width - 18, rect.origin.y - 18, 36, 36);
        delBtn.tag = 801 + i;
        [delBtn setImage:[UIImage imageNamed:@"icon_cancel1"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.skillBgView addSubview:backview];
        [self.skillBgView addSubview:delBtn];
    }
}

-(void)deleteAction:(UIButton *)btn{
    [self.skillArray removeObjectAtIndex:btn.tag - 801];
//    [self initCellWithData:self.imageArray];
    NSInteger tag = btn.tag - 801;
    self.returnDelTag(tag);
    NSLog(@"%@",self.skillArray);
    NSLog(@"%ld",(long)btn.tag);
//    [self initScrollView];
}

+(CGFloat)getCellHeightWithData:(NSArray*)model{
    CGFloat w = (ScreenWidth - 95 ) / 2;
    CGFloat h = w/111*58;
    CGFloat margin = ScreenWidth-80-2*w;
    return (model.count+1)/2*(h+margin)+40;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
