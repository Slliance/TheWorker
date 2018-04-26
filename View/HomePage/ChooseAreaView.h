//
//  ChooseAreaView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/21.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChooseAreaView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain) UITableView *leftItemTableView;
@property (nonatomic,retain) UITableView *middleItemTableView;
@property (nonatomic,retain) UITableView *rightItemTableView;
@property (nonatomic, copy) void(^returnMenublock)(NSInteger);
@property (nonatomic, copy) void(^returnItemblock)(NSString *);
@property (nonatomic, retain) NSArray *provinceArr;
@property (nonatomic, retain) NSArray *cityArr;
@property (nonatomic, retain) NSArray *zoneArr;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, assign) NSInteger areaId;
-(void)initViewWithData;
@end
