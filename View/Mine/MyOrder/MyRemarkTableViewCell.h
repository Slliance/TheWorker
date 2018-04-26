//
//  MyRemarkTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/5.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMLStarView.h"
#import "StoreGoodsModel.h"
@interface MyRemarkTableViewCell : UITableViewCell<FMLStarViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (nonatomic, assign) NSInteger star;
@property (weak, nonatomic) IBOutlet UITextView *txtView;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *propertyOneLabel;

@property (nonatomic,retain) NSMutableDictionary *parameterDic;
@property (nonatomic, copy) void(^returnBlock)(NSDictionary *);

-(void)initCellWithData:(StoreGoodsModel *)model;
@end
