//
//  UIViewControler+Extension.h
//  GoodDoctor
//
//  Created by yanghao on 8/25/16.
//  Copyright © 2016 wikj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(Extension)

-(UIImage*)imageWithColor:(UIColor*)color;
- (void)initNavgationBarWithTitle:(NSString *)titleStr;
-(void)setNavgationBackGroundImgWithImgName:(NSString *)imgName;
-(void)setNavgationBackGroundImgWithImg:(UIImage *)img;
-(void)backRootController;
-(void)setNavgationBack;
-(UIButton *)getNavgationBackBtn;
-(void)backBtnAction:(id)sender;

-(void)setNavgationLeftWithName:(NSString *)name font:(UIFont *)font color:(UIColor *)color size:(CGSize)size action:(SEL)action;
-(void)setNavgationRightWithName:(NSString *)name font:(UIFont *)font color:(UIColor *)color size:(CGSize)size action:(SEL)action;
-(void)setNavgationRightWithImgUrl:(NSString *)normalImgName highlighted:(NSString *)highlightedImaName size:(CGSize)size action:(SEL)action;
-(void)setNavgationLeftWithImgName:(NSString *)normalImgName highlighted:(NSString *)highlightedImaName size:(CGSize)size action:(SEL)action;

-(void)setNavgationRightWithImgName:(NSString *)normalImgName highlighted:(NSString *)highlightedImaName size:(CGSize)size action:(SEL)action;
-(void)initTabBarItemWithTitle:(NSString *)titleStr normalImg:(NSString *)normalImg selectImg:(NSString *)selectImg  tag:(NSInteger)tag;

-(void)setNavgationRightWithImgName:(NSString *)normalImgName highlighted:(NSString *)highlightedImaName size:(CGSize)size action:(SEL)action
                      normalImgName:(NSString *)normalImgName2 highlighted:(NSString *)highlightedImaName2 size:(CGSize)size2 action:(SEL)action2;



-(void)setNavgationSearchBarWithPlaceholder:(NSString *)placeholder tag:(NSInteger)tag target:(id)target;
-(void)removeNavgationSearchBar;
-(void)addShadow:(UIView *)shadowView offset:(CGSize)offset;
-(void)showJGProgressWithMsg:(NSString *)msg;
-(void)showJGProgressLoadingWithTag:(NSInteger)tag;
-(void)dissJGProgressLoadingWithTag:(NSInteger)tag;

-(NSString *)getHHMMSSFromSS:(NSInteger)seconds;
-(NSString *)getMMSSFromSS:(NSInteger)seconds;
@end
