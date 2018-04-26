//
//  SingleChooseListView.h
//  TheWorker
//
//  Created by yanghao on 8/23/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleChooseListView : UIView
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (nonatomic, copy) NSString *colorStr;
@property (nonatomic, copy) NSString *selectedBtnImgStr;
@property (nonatomic, copy) NSString *selectedItemBtnImgStr;
@property (nonatomic, copy) NSString *normalItemBtnImgStr;
@property (nonatomic, assign) NSInteger currentSelectIndex;
@property (nonatomic, copy) NSArray *itemArr;

@property (nonatomic, copy) void(^returnBlock)(NSInteger,NSArray *);
@property (nonatomic, copy) void(^removeBlock)(void);

-(void)initView:(NSArray *)itemArr;
@end
