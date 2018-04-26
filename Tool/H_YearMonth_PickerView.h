//
//  H_YearMonth_PickerView.h
//  JJRC
//
//  Created by cl z on 13-1-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol H_YearMonth_PickerViewDelegate;
@interface H_YearMonth_PickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray              *yearMuArr;
    NSMutableArray              *monthMuArr;
    __unsafe_unretained id<H_YearMonth_PickerViewDelegate> delegate;
    
}

@property(assign,nonatomic)id<H_YearMonth_PickerViewDelegate> delegate;
@property(retain,nonatomic)UIPickerView             *pickerView;
@property (retain, nonatomic)UIImageView                 *backView;

-(void)setSelectedRowInYearAndMonth:(NSInteger)_yearIndex monthIndex:(NSInteger)_monthIndex;
@end


@protocol H_YearMonth_PickerViewDelegate <NSObject>

-(void)getYearMonth:(H_YearMonth_PickerView *)_H_YearMonth_PickerView date:(NSString *)_selectDate;

@end