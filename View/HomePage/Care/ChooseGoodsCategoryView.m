//
//  ChooseGoodsCategoryView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ChooseGoodsCategoryView.h"
#import <objc/runtime.h>

const char  view_char;
#define view_tag  9999
#define btn_tag  999
@implementation ChooseGoodsCategoryView
-(void)initCellWithData:(StoreGoodsModel *)model count:(NSInteger)count{
    for (UIView *view in self.bottomView.subviews) {
        if (view.tag > view_tag) {
            [view removeFromSuperview];
        }
    }
    self.model = model;
    self.rowArr = [[NSMutableArray alloc] init];
    self.columnArr = [[NSMutableArray alloc] init];

    self.selectIdArray = [[NSMutableArray alloc]init];
    self.selectStrArray = [[NSMutableArray alloc]init];
    self.selectNameStrArray = [[NSMutableArray alloc] init];
    self.recordSelectArr = [[NSMutableArray alloc] init];
    self.goodsImage.layer.masksToBounds= YES;
    self.goodsImage.layer.borderWidth = 2.f;
    self.goodsImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.goodsImage.layer.cornerRadius = 4.f;
    [self.goodsImage setImageWithString:model.img placeHoldImageName:@"bg_no_pictures"];
//    [self.goodsImage setImageWithURL:[NSURL URLWithString:model.show_img] placeholderImage:[UIImage imageNamed:placeholderImage_home_banner]];
    if ([model.have integerValue] == 0) {
        self.buyView.hidden = YES;
        self.btnNoSku.hidden = NO;
    }else{
        self.btnNoSku.hidden = YES;
        self.buyView.hidden = NO;
    }
    
    self.labelPrice.text = [NSString stringWithFormat:@"￥%.2f",[model.price floatValue]];
    self.price = model.price;
    self.labelMaxCount.text = [NSString stringWithFormat:@"库存：%@件",model.sku];
    self.labelChoosedCount.text = [NSString stringWithFormat:@"%li",(long)count];
    self.btnMinus.layer.masksToBounds = YES;
    self.btnMinus.layer.cornerRadius = 4.f;
    [self.btnMinus.layer setBorderColor:[UIColor colorWithHexString:@"e6e6e6"].CGColor];
    [self.btnMinus.layer setBorderWidth:1];
    self.btnAdd.layer.masksToBounds = YES;
    self.btnAdd.layer.cornerRadius = 4.f;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(turnOffView:)];
    [self.blackBgView addGestureRecognizer:tapGes];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:model.property];
    
    CGFloat pointx = 15.f;
    CGFloat pointy = 116.f;
    [self.selectNameStrArray removeAllObjects];
    for (int i = 0; i < arr.count; i++) {
        GoodsPropertyModel *goodsPropertyModel  = (GoodsPropertyModel *)arr[i];
        
        UILabel *subtitle = [[UILabel alloc] init];
        subtitle.frame = CGRectMake(10, pointy, 200, 20);
        subtitle.font = [UIFont systemFontOfSize:14];
        subtitle.textColor = [UIColor blackColor];
        subtitle.text = goodsPropertyModel.name;
        [self.bottomView addSubview:subtitle];
        pointy += 30.f;
        //剩余宽度
        [self.rowArr addObject:@(i)];
        [self.selectNameStrArray addObject:goodsPropertyModel.name];
        [self.recordSelectArr addObject:@[@(-1),@(i)]];
        for (int j = 0 ; j < [goodsPropertyModel.property count]; j ++) {
            GoodsPropertyModel *subModel = goodsPropertyModel.property[j];
            CGFloat remainW = ScreenWidth - pointx - 15;
            
            CGSize size = [subModel.name sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(300, 20)];
            if (size.width + 20 > remainW) {
                pointy += 30.f;
                pointx = 15.f;
            }
            
            
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(pointx, pointy, size.width + 20, 22)];
            
            objc_setAssociatedObject(backview, &view_char, @(i), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            backview.tag = view_tag + j + tag__;
            UIButton *markBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            markBtn.frame = CGRectMake(10, 0, size.width, 22);
            markBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [markBtn setTitle:subModel.name forState:UIControlStateNormal];
            [markBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
            backview.layer.masksToBounds = YES;
            backview.layer.cornerRadius = 3.f;
            [backview setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
            [backview.layer setBorderColor:[UIColor colorWithHexString:@"cccccc"].CGColor];
            [backview.layer setBorderWidth:1];
            if ([subModel.checked integerValue] == 1) {
                [self.columnArr addObject:@(j)];
                [self.selectIdArray addObject:subModel.property_id];
                [self.selectStrArray addObject:subModel.name];
                [backview setBackgroundColor:[UIColor colorWithHexString:@"f1a036"]];
                [backview.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
                [markBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                markBtn.selected = YES;
            }
            [markBtn addTarget:self action:@selector(chooseColor:) forControlEvents:UIControlEventTouchUpInside];
            markBtn.tag = backview.tag + btn_tag + j;
            
            [backview addSubview:markBtn];
            [self.bottomView addSubview:backview];
            pointx += size.width + 30;
            
            
        }
        tag__ += 50;

        pointx = 15.f;
        pointy += 30.f;
    }
    CGRect bottomRect = self.bottomView.frame;
    bottomRect.size.height = pointy + 128;
    bottomRect.origin.y = ScreenHeight - pointy - 128;
    self.bottomView.frame = bottomRect;
    NSLog(@"%@/n%@",self.rowArr,self.columnArr);

}
- (IBAction)turnOffView:(id)sender {
    self.chooseBlock(self.rowArr, self.columnArr);
    self.cancelBlock([self.labelChoosedCount.text integerValue]);
}
- (IBAction)subtractAction:(id)sender {
    NSInteger count = [self.labelChoosedCount.text integerValue];
    if (count == 1) {
        return;
    }
    count -= 1;
    self.labelChoosedCount.text = [NSString stringWithFormat:@"%ld",(long)count];
}
- (IBAction)addAction:(id)sender {
    NSInteger count = [self.labelChoosedCount.text integerValue];
    if (count == [self.model.sku integerValue]) {
        return;
    }
    count += 1;
    self.labelChoosedCount.text = [NSString stringWithFormat:@"%ld",(long)count];
    
}
- (IBAction)confirmAction:(id)sender {
    if (self.selectIdArray.count == 0) {
        [self turnOffView:nil];
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:self.labelChoosedCount.text forKey:@"count"];
    [dic setObject:self.model.sku forKey:@"sku"];
    [dic setObject:self.selectIdArray forKey:@"property_id"];
    [dic setObject:self.selectStrArray forKey:@"property_name"];
    [dic setObject:self.price forKey:@"price"];
    [dic setObject:self.selectNameStrArray forKey:@"name"];//属性名
    self.confirmAddBlock(dic);
}

- (IBAction)buyNowAction:(id)sender {
    if (self.selectIdArray.count == 0) {
        [self turnOffView:nil];
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:self.labelChoosedCount.text forKey:@"count"];
    [dic setObject:self.model.sku forKey:@"sku"];
    [dic setObject:self.selectIdArray forKey:@"property_id"];
    [dic setObject:self.selectStrArray forKey:@"property_name"];
    [dic setObject:self.price forKey:@"price"];
    [dic setObject:self.selectNameStrArray forKey:@"name"];//属性名
    self.confirmBuyBlock(dic);
}


-(void)chooseColor:(UIButton *)btn{
    NSNumber *viewNum = objc_getAssociatedObject(btn.superview, &view_char);
    if (btn.selected == YES) {
        [btn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [btn.superview setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [btn.superview.layer setBorderColor:[UIColor colorWithHexString:@"cccccc"].CGColor];
        btn.selected = NO;
        self.selectedTag = 0;
        [self.recordSelectArr replaceObjectAtIndex:[viewNum integerValue] withObject:@[@(-1),@(btn.superview.tag),viewNum]];

    }
    else{

        for (int i = 0; i < self.recordSelectArr.count; i ++) {
            NSNumber *x = self.recordSelectArr[i][0];
            if ([x integerValue]  != -1 && [viewNum isEqual:self.recordSelectArr[i][2]]) {
                NSNumber *y = self.recordSelectArr[i][1];
                UIView *subview = [self.bottomView viewWithTag: [y integerValue] ];
                [subview setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
                [subview.layer setBorderColor:[UIColor colorWithHexString:@"cccccc"].CGColor];
                UIButton *subbtn = [subview viewWithTag:[x integerValue]];
                [subbtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
                subbtn.selected = NO;
                
            }
        }
        
        
       
        
        
        //将选中按钮设置为选中状态
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.superview setBackgroundColor:[UIColor colorWithHexString:@"f1a036"]];
        [btn.superview.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
        btn.selected = YES;
        self.selectedTag = btn.tag;
        
        
        [self.recordSelectArr replaceObjectAtIndex:[viewNum integerValue] withObject:@[@(btn.tag),@(btn.superview.tag),viewNum]];
    }
//    NSMutableArray *selectID = [[NSMutableArray alloc] init];
 

    
    for (int i = 0; i < self.recordSelectArr.count; i ++) {
        NSNumber *x = self.recordSelectArr[i][0];
        if ([x integerValue]  != -1 ) {
            
            NSInteger row = [self.recordSelectArr[i][2] integerValue];
            NSInteger column = ([self.recordSelectArr[i][0] integerValue] -[self.recordSelectArr[i][1] integerValue] - btn_tag );
            
            
            [self.columnArr replaceObjectAtIndex:row withObject:@(column)];
            
            
            
            NSLog(@"当前选中数组对象：行%ld  列%ld",(long)[self.recordSelectArr[i][2] integerValue],(long)([self.recordSelectArr[i][0] integerValue] -[self.recordSelectArr[i][1] integerValue] - btn_tag ));
            
            
            GoodsPropertyModel *xmodel = self.model.property[[self.recordSelectArr[i][2] integerValue]];
            GoodsPropertyModel *ymodel = xmodel.property[([self.recordSelectArr[i][0] integerValue] -[self.recordSelectArr[i][1] integerValue] - btn_tag )];
            
            [self.selectIdArray replaceObjectAtIndex:[self.recordSelectArr[i][2] integerValue] withObject:ymodel.property_id];
            [self.selectStrArray replaceObjectAtIndex:[self.recordSelectArr[i][2] integerValue] withObject:ymodel.name];
//            [selectID addObject:ymodel.property_id];
        
        }
    }
    if (self.selectIdArray.count == self.model.property.count) {
        self.fetchInfoBlock(self.selectIdArray,[self.labelChoosedCount.text integerValue]);
    }
//    [self.selectArray removeAllObjects];
//    [self.selectArray addObjectsFromArray:selectID];
}
-(void)setSelectRowIndex:(NSArray *)row column:(NSArray *)column{
//    [self.rowArr addObjectsFromArray:row];
//    [self.columnArr addObjectsFromArray:column];
    for (int i= 0; i < self.rowArr.count; i ++) {
        //backview tag
        NSInteger tag = view_tag + [self.columnArr[i] integerValue] + [self.rowArr[i] integerValue] * 50;
        
        
        //backview
        UIView *backview = [self.bottomView viewWithTag:tag];
        //btn
        NSInteger btntag = tag + btn_tag + [self.columnArr[i] integerValue];
        UIButton *btn = [backview viewWithTag:btntag];
        
        [self chooseColor:btn];
    }
    
}

@end
