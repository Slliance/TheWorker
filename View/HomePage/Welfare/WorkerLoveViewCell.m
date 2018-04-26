//
//  BrandTableViewCell.m
//  TheWorker
//
//  Created by yanghao on 8/19/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "WorkerLoveViewCell.h"
#import "WorkerDetailViewController.h"
#import "HandInModel.h"
#import "UIButton+WebCache.h"
#define a_tag_max 999
#define row_count 4
@implementation WorkerLoveViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initCellWithData:(NSArray *)itemArr{
    for (UIView *subview in self.subviews) {
        if (subview.tag >= a_tag_max) {
            [subview removeFromSuperview];
        }
    }
    self.dataArr = [[NSArray alloc] initWithArray:itemArr];
    CGFloat w = (ScreenWidth - 50.f) / row_count;
    NSInteger h = ((int)w % 2 ? w - 21 : w - 20);
    for (int i = 0; i < itemArr.count; i ++) {
        HandInModel *model = itemArr[i];
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(10 + (w + 10) * (i % row_count), i / row_count * (h + 40.f), w, h + 10 + 10 + 20)];
        UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headBtn.frame = CGRectMake((w - h) / 2, 10, h, h);
        headBtn.layer.masksToBounds = YES;
        headBtn.layer.cornerRadius = h / 2;
        headBtn.tag = 400 + i;
        NSURL *url = [[NSURL alloc] init];
        if([model.headimg rangeOfString:@"http"].location !=NSNotFound)//_roaldSearchText
        {
            url = [NSURL URLWithString:model.headimg];
            
        }
        else
        {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,model.headimg]];
            
        }
        [headBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:placeholderImage_user_headimg]];
        headBtn.backgroundColor = [UIColor lightGrayColor];
        [headBtn addTarget:self action:@selector(headAction:) forControlEvents:UIControlEventTouchUpInside];
        [itemView addSubview:headBtn];
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0 , h + 20 , w, 20);
        label.text = model.nickname;
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithHexString:@"333333"];
        
        [itemView addSubview:label];
        itemView.tag = a_tag_max + i;
        [self addSubview:itemView];
    }
}
-(void)headAction:(UIButton *)sender{
    id next = [self nextResponder];
    while (![next isKindOfClass:[UIViewController class]]) {
        next = [next nextResponder];
    }
    UIViewController *vc = (UIViewController *)next;
    WorkerDetailViewController *detail = [[WorkerDetailViewController alloc] init];
    HandInModel *model = self.dataArr[sender.tag - 400];
    detail.handInId = model.Id;
    detail.hidesBottomBarWhenPushed = YES;
    [vc.navigationController pushViewController:detail animated:YES];
}
+(CGFloat)getCellHeightWithData:(NSArray *)itemArr{
    CGFloat w = (ScreenWidth - 50.f) / row_count;
    NSInteger h = ((int)w % 2 ? w - 21 : w - 20);
    CGFloat height = itemArr.count % row_count == 0 ? itemArr.count / row_count * (h + 40) : (itemArr.count / row_count + 1) * (h + 40);
    
    
    return height;
}

@end
