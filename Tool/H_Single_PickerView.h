//
//  H_Single_PickerView.h
//  WLT
//
//  Created by cl z on 12-12-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol H_Single_PickerViewDelegate;
@interface H_Single_PickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray              *getMuArr;
}
@property (assign,nonatomic)id<H_Single_PickerViewDelegate> delegate;
@property (retain, nonatomic)UIPickerView               *pickerView;
@property (retain, nonatomic)UIImageView                     *backView;
- (id)initWithFrame:(CGRect)frame arr:(NSArray *)_arr;

@end


@protocol H_Single_PickerViewDelegate <NSObject>

-(void)SinglePickergetObjectWithArr:(H_Single_PickerView *)_h_Single_PickerView arr:(NSArray *)_arr index:(NSInteger)_index chooseStr:(NSString *)chooseStr chooseId:(NSNumber *)chooseId;

@end
