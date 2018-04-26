//
//  OnlySearchHeadView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/20.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlySearchHeadView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnSkipToSearch;

@property (nonatomic, copy) void(^returnSearchBlock)(NSString *);
-(void)initSearchViewWithType:(NSInteger)skipOrSearch;  //0 skip  1  search
@end
