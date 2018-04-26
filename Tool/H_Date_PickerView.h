//
//  H_Date_PickerView.h
//  WLT
//
//  Created by cl z on 12-12-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol H_Date_PickerViewDelegate;
@interface H_Date_PickerView : UIView
{
    __unsafe_unretained id<H_Date_PickerViewDelegate> delegate;
}
@property (assign,nonatomic)id<H_Date_PickerViewDelegate> delegate;
@property(retain,nonatomic)UIDatePicker             *datePicker;
@property (retain, nonatomic)UIImageView                 *backView;
@end

@protocol H_Date_PickerViewDelegate <NSObject>

-(void)getSelect:(H_Date_PickerView *)_datePickerView date:(NSString *)_selectDate;


@end