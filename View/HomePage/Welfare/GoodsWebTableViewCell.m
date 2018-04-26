//
//  GoodsWebTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/16.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "GoodsWebTableViewCell.h"

@implementation GoodsWebTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initCellWithData:(NSString *)urlStr{
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.goodsWebView loadRequest:[NSURLRequest requestWithURL:url]];
    self.goodsWebView.scalesPageToFit = YES;
    self.goodsWebView.dataDetectorTypes = UIDataDetectorTypeAll;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
