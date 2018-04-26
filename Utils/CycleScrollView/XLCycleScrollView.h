//
//  XLCycleScrollView.h
//  CycleScrollViewDemo
//
//  Created by xie liang on 9/14/12.
//  Copyright (c) 2012 xie liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFPageControl.h"

@protocol XLCycleScrollViewDelegate;
@protocol XLCycleScrollViewDatasource;

@interface XLCycleScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    AFPageControl *_pageControl;
    
    
    NSInteger _totalPages;
    NSInteger _curPage;
    
    NSMutableArray *_curViews;
}
@property (nonatomic,assign) BOOL isRedPoint;

@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,retain) AFPageControl *pageControl;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign,setter = setDataource:) id<XLCycleScrollViewDatasource> datasource;
@property (nonatomic,assign,setter = setDelegate:) id<XLCycleScrollViewDelegate> delegate;
@property (nonatomic,copy) void(^EndDeceleratingBlock)(void);
@property (nonatomic,copy) void(^BeginDraggingBlock)(void);
- (void)reloadData;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;
-(void)addPageControlWithCount:(NSInteger)totalCount;

//定时滚动
-(void)timerScrollView;
@end

@protocol XLCycleScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index;

@end

@protocol XLCycleScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;

@end
