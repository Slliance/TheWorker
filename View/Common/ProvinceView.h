//
//  ProvinceCityZoneView.h
//  TheWorker
//
//  Created by yanghao on 8/29/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProvinceView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSInteger       curProvinceIndex;

@property (weak, nonatomic) IBOutlet UITableView *provinceTableView;

@property (nonatomic, retain) NSMutableArray      *provinceArr;
@property (nonatomic, assign) BOOL showIcon; //是否显示文字前面的图标
@property (nonatomic, copy) NSString *iconColorStr; //文字前面图标的颜色值

@property (nonatomic, copy) NSString *code;


@property (nonatomic, copy) void(^returnBlock)(NSInteger,NSArray *);
@property (nonatomic, copy) void(^removeBlock)(void);


-(void)initView;

@end
