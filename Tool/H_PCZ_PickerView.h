//
//  myPickView.h
//  WLT
//
//  Created by cl z on 12-12-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol H_PCZ_PickerViewDelegate;
@interface H_PCZ_PickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray              *provinceMuArr;
    NSMutableArray              *zoneMuArr;
    NSMutableArray              *cityMuArr;
}
@property (assign, nonatomic)id<H_PCZ_PickerViewDelegate>    delegate;

@property (retain, nonatomic)UIPickerView               *pickerView;
@property (retain, nonatomic)UIImageView                     *backView;
@end


@protocol H_PCZ_PickerViewDelegate <NSObject>

@optional
-(void)getChooseIndex:(H_PCZ_PickerView *)_myPickerView addressStr:(NSString *)addressStr areaCode:(NSString *)areaCode;

@end
