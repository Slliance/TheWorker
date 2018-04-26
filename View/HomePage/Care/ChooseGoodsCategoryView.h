//
//  ChooseGoodsCategoryView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreGoodsModel.h"
#import "GoodsPropertyModel.h"
@interface ChooseGoodsCategoryView : UIView{
    NSInteger       tag__;
}
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelMaxCount;
@property (weak, nonatomic) IBOutlet UIView *buyView;

@property (weak, nonatomic) IBOutlet UILabel *labelChoosedCount;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnMinus;
@property (weak, nonatomic) IBOutlet UIView *blackBgView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *btnNoSku;
@property (nonatomic, retain) NSNumber *price;
@property (nonatomic, retain) NSMutableArray  *recordSelectArr;
@property (nonatomic, retain) NSMutableArray *selectIdArray;//存放id的数组
@property (nonatomic, retain) NSMutableArray *selectStrArray;//存放名字的数组
@property (nonatomic, retain) NSMutableArray *selectNameStrArray;//存放属性名的数组
@property (nonatomic, copy) void(^cancelBlock)(NSInteger);
@property (nonatomic, copy) void(^confirmAddBlock)(NSDictionary *);
@property (nonatomic, copy) void(^confirmBuyBlock)(NSDictionary *);
@property (nonatomic, assign) NSInteger selectedTag;

@property (nonatomic, retain)NSMutableArray *rowArr;
@property (nonatomic, retain)NSMutableArray *columnArr;

@property (nonatomic, copy) void(^chooseBlock)(NSArray *,NSArray *);
@property (nonatomic, copy) void(^fetchInfoBlock)(NSArray *,NSInteger);
@property (nonatomic, retain) StoreGoodsModel  *model;

-(void)initCellWithData:(StoreGoodsModel *)model count:(NSInteger)count;
-(void)setSelectRowIndex:(NSArray *)row column:(NSArray *)column;

@end
