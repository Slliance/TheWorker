//
//  GoodsWebTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/16.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsWebTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIWebView *goodsWebView;
-(void)initCellWithData:(NSString *)urlStr;
@end
