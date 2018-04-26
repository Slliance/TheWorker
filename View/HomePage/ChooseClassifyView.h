//
//  ChooseClassifyView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/22.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseClassifyView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain) UITableView *leftItemTableView;
@property (nonatomic,retain) UITableView *rightItemTableView;

@property (nonatomic ,retain) NSMutableArray *leftArr;
@property (nonatomic, retain) NSMutableArray *rightArr;

@property (nonatomic, copy) void(^returnMenublock)(NSString *,NSString *);
@property (nonatomic, copy) void(^returnItemblock)(NSInteger );
-(void)initViewWithData:(NSArray *)array;


@end
