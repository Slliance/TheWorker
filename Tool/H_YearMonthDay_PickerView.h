//
//  H_YearMonthDay_PickerView.h
//  JJRC
//
//  Created by cl z on 13-1-25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol H_YearMonthDay_PickerViewDelegate;
@interface H_YearMonthDay_PickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray              *yearMuArr;
    NSMutableArray              *monthMuArr;
    NSMutableArray              *dayMuArr;
    __unsafe_unretained id<H_YearMonthDay_PickerViewDelegate> delegate;
    
}

@property(assign,nonatomic)id<H_YearMonthDay_PickerViewDelegate> delegate;
@property(retain,nonatomic)UIPickerView             *pickerView;
@property (retain, nonatomic)UIImageView                 *backView;

-(void)setSelectedRowInYearAndMonth:(NSInteger)_yearIndex monthIndex:(NSInteger)_monthIndex dayIndex:(NSInteger)_dayIndex;
@end


@protocol H_YearMonthDay_PickerViewDelegate <NSObject>

-(void)getYearMonthDay:(H_YearMonthDay_PickerView *)_H_YearMonth_PickerView date:(NSString *)_selectDate;

@end

