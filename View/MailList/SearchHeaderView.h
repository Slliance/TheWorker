//
//  SearchHeaderView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/19.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchHeaderView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIImageView *imgSearch;

@property (nonatomic, copy) void(^returnSearchBlock)(NSString *);
-(void)initSearchViewWithState:(NSNumber *)isNew;
@end
