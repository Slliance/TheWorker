//
//  RentPersonInfoTableViewCell.m
//  TheWorker
//
//  Created by yanghao on 8/21/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "RentPersonInfoTableViewCell.h"
#import "SkillModel.h"
#define max_tag   999
@implementation RentPersonInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initCell:(RentPersonModel *)model section:(NSInteger)section{
    for (UIView *subview in self.subviews) {
        if (subview.tag >= max_tag) {
            [subview removeFromSuperview];
        }
    }
    if (section == 0) {
        NSArray *arr = model.server;
        for (int i = 0; i < arr.count; i ++) {
            SkillModel *subModel = arr[i];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 30 * i , 100, 30)];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
            titleLabel.text = subModel.name;
            titleLabel.font = [UIFont systemFontOfSize:13];
            titleLabel.tag = max_tag + i;
            [self addSubview:titleLabel];
            
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 100 - 25, 30 * i , 100, 30)];
            priceLabel.textAlignment = NSTextAlignmentRight;
            priceLabel.textColor = [UIColor colorWithHexString:@"666666"];
            priceLabel.text = [NSString stringWithFormat:@"%@元/小时",subModel.price];
            priceLabel.font = [UIFont systemFontOfSize:14];
            priceLabel.tag = max_tag + i + 80;
            [self addSubview:priceLabel];
        }
    }
    else if (section == 1){
        NSArray *arr = model.tag;
        CGFloat pointx = 45.f;
        CGFloat pointy = 10.f;
        for (int i = 0; i < arr.count; i++) {
            
            //剩余宽度
            
            CGFloat remainW = ScreenWidth - pointx - 25.f;
            NSString *str = arr[i][@"name"];
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:11] maxSize:CGSizeMake(200, 16)];
            if (size.width + 20 > remainW) {
                pointy += 30.f;
                pointx = 45.f;
            }
            
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(pointx, pointy, size.width + 20, 20)];
            backview.tag = max_tag + i;
            backview.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
            backview.layer.masksToBounds = YES;
            backview.layer.cornerRadius = 3.f;
            UIButton *markBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            markBtn.frame = CGRectMake(10, 2, size.width, 16);
            markBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            [markBtn setTitle:str forState:UIControlStateNormal];
            [markBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
            [backview addSubview:markBtn];
            [self addSubview:backview];
            pointx += size.width + 30;
            
            
        }
    }
    else if(section == 2){
        NSArray *arr = @[@"年龄",@"星座",@"职业",@"身高",@"工作地点"];
        NSMutableArray *muArr = [[NSMutableArray alloc]init];
        [muArr addObject:[NSString stringWithFormat:@"%@",model.age]];
        [muArr addObject:[NSString stringWithFormat:@"%@",model.constellation]];
        [muArr addObject:[NSString stringWithFormat:@"%@",model.job]];
        [muArr addObject:[NSString stringWithFormat:@"%@",model.height]];
        [muArr addObject:[NSString stringWithFormat:@"%@",model.work_address]];
        for (int i = 0; i < arr.count; i ++) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 30 * i , 100, 30)];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
            titleLabel.text = arr[i];
            titleLabel.font = [UIFont systemFontOfSize:13];
            titleLabel.tag = max_tag + i;
            [self addSubview:titleLabel];
            
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 100 - 25, 30 * i , 100, 30)];
            priceLabel.textAlignment = NSTextAlignmentRight;
            priceLabel.textColor = [UIColor colorWithHexString:@"666666"];
            priceLabel.text = muArr[i];
            priceLabel.font = [UIFont systemFontOfSize:14];
            priceLabel.tag = max_tag + i + 80;
            [self addSubview:priceLabel];
        }
    }
    
}
+(CGFloat)getHeightCell:(RentPersonModel *)model section:(NSInteger)section{
    if (section == 0) {
        NSArray *arr = model.server;
        return arr.count * 30.f;
    }
    else if (section == 1){
        CGFloat pointx = 45.f;
        CGFloat pointy = 10.f;
        NSArray *arr = model.tag;
        for (int i = 0; i < arr.count; i++) {
            
            //剩余宽度
            
            CGFloat remainW = ScreenWidth - pointx - 25.f;
            NSString *str = arr[i][@"name"];
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:11] maxSize:CGSizeMake(200, 16)];
            if (size.width + 20 > remainW) {
                pointy += 30.f;
            }
            
            
            pointx += size.width + 30;
            
            
        }

        return pointy + 10 + 20;
        
    }else{
        NSArray *arr = @[@"年龄",@"星座",@"职业",@"身高",@"工作地点"];
        return arr.count * 30.f;
    }
    return 100;
}



@end
