//
//  ProvinceCityZoneView.h
//  TheWorker
//
//  Created by yanghao on 8/29/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProvinceCityZoneView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSInteger       curProvinceIndex;
@property (nonatomic, assign) NSInteger       curCityIndex;
@property (nonatomic, assign) NSInteger       curZoneIndex;

@property (weak, nonatomic) IBOutlet UITableView *provinceTableView;
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;
@property (weak, nonatomic) IBOutlet UITableView *zoneTableView;
@property (nonatomic, assign) BOOL          showAll;

@property (nonatomic, retain) NSMutableArray      *provinceArr;
@property (nonatomic, retain) NSMutableArray      *cityArr;
@property (nonatomic, retain) NSMutableArray      *zoneArr;

@property (nonatomic, copy) void(^returnBlock)(NSInteger,NSInteger,NSInteger,NSArray *);
@property (nonatomic, copy) void(^removeBlock)(void);


-(void)initView;

@end
