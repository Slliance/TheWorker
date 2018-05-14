//
//  BaseViewController.h
//  Analyst
//
//  Created by vic.hu on 15/5/6.
//  Copyright (c) 2015年 vic.hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+ValueString.h"
#import "H_Date_PickerView.h"
#import "NavgationView.h"
//#import "UIImageView+AFNetworking.h"
@interface HYBaseViewController : UIViewController<NavgationViewDelegate>
typedef enum
{
    code_success = 0,
    code_fail = 100,
    code_account_stop = 101,
    code_account_none = 102,
    code_exception = 103,
    code_account_had_register = 104,
    code_account_no_register = 105
}CodeStae;

@property (strong, nonatomic) UIView *topNavigationView;
@property(nonatomic,strong)NavgationView *navView;

-(UIImage*)imageWithColor:(UIColor*)color;
- (void)initNavgationBarWithTitle:(NSString *)titleStr;
-(void)setNavgationBackGroundImgWithImgName:(NSString *)imgName;
-(void)setNavgationBackGroundImgWithImg:(UIImage *)img;
-(void)setNavigationBar:(NSString *)title;
-(void)addBackButton;

-(void)setNavgationBack;
-(void)backBtnAction:(id)sender;
-(void)setNavgationBackGroundImg;
-(void)setNavgationLeftWithName:(NSString *)name font:(UIFont *)font color:(UIColor *)color size:(CGSize)size action:(SEL)action;
-(void)setNavgationLeftWithName:(NSString *)name img:(UIImage *)img font:(UIFont *)font color:(UIColor *)color size:(CGSize)size action:(SEL)action;
-(void)setNavgationRightWithName:(NSString *)name font:(UIFont *)font color:(UIColor *)color size:(CGSize)size action:(SEL)action;
-(void)setNavgationLeftWithImgName:(NSString *)normalImgName highlighted:(NSString *)highlightedImaName size:(CGSize)size action:(SEL)action;

-(void)setNavgationRightWithImgName:(NSString *)normalImgName highlighted:(NSString *)highlightedImaName size:(CGSize)size action:(SEL)action;
-(void)initTabBarItemWithTitle:(NSString *)titleStr normalImg:(NSString *)normalImg selectImg:(NSString *)selectImg  tag:(NSInteger)tag;

-(void)setNavgationRightWithImgName:(NSString *)normalImgName highlighted:(NSString *)highlightedImaName size:(CGSize)size action:(SEL)action
                      normalImgName:(NSString *)normalImgName2 highlighted:(NSString *)highlightedImaName2 size:(CGSize)size2 action:(SEL)action2;


-(void)setNavgationRightWithImgName:(NSString *)normalImgName highlighted:(NSString *)highlightedImaName size:(CGSize)size action:(SEL)action negativeSpacer:(BOOL)negativeSpacer width:(CGFloat)width;
-(void)addShadow:(UIView *)shadowView offset:(CGSize)offset;
-(NSString *)getRequestUrlWithPath:(NSString *)path;

-(void)skiptoLogin;
-(void)skiptoLoginAndBackRootVC;
-(void)setTextFieldLeftView:(UITextField *)textField :(NSString *)imgStr :(NSInteger)width;
-(void)shareWithPageUrl:(NSString *)url shareTitle:(NSString *)shareTitle shareDes:(NSString *)shareDes thumImage:(id)thumImage;
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;
-(NSString *)getToken;
-(BOOL)isLogin;
-(void)skipToRenZhenVC:(NSNumber *)auth;
/**在屏幕中央弹出一个view*/
- (void)popView:(UIView *)view withOffset:(CGFloat) offset;
- (void)hidPopView;
@end
