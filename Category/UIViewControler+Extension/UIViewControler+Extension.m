//
//  UIViewControler+Extension.m
//  GoodDoctor
//
//  Created by yanghao on 8/25/16.
//  Copyright © 2016 wikj. All rights reserved.
//

#import "UIViewControler+Extension.h"
#import "UIButton+AFNetworking.h"
#import "JGProgressHUD.h"


@implementation UIViewController(Extension)


- (void)initNavgationBarWithTitle:(NSString *)titleStr
{
    UILabel *labelNavigation = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, ScreenWidth - 200, 64)];
    labelNavigation.text = titleStr;
    labelNavigation.textColor = [UIColor whiteColor];
    labelNavigation.font = [UIFont systemFontOfSize:17];
    labelNavigation.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = labelNavigation;
//    [self setNavgationBackGroundImg];
}
/**
 *  设置导航条背景图片
 */
-(void)setNavgationBackGroundImgWithImgName:(NSString *)imgName
{
    UIImage *nav_bg = [UIImage imageNamed:imgName];
    [self.navigationController.navigationBar setBackgroundImage:nav_bg forBarMetrics:UIBarMetricsDefault];
}
-(void)setNavgationBackGroundImgWithImg:(UIImage *)img{
    [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
}
-(void)setNavgationBackGroundImg{
    [self setNavgationBackGroundImgWithImg:[self imageWithColor:[UIColor colorWithHexString:NAGA_BACKGROUND_COLOR]]];
}
-(void)setNavgationBack
{
    UIButton *btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_back setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
    //    [btn_back setImage:[UIImage imageNamed:@"navigation_back_highlight"] forState:UIControlStateHighlighted];
    [btn_back addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn_back.frame = CGRectMake(0, 0, 23 , 40);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn_back];
}

-(UIButton *)getNavgationBackBtn
{
    UIButton *btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_back setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
    //    [btn_back setImage:[UIImage imageNamed:@"navigation_back_highlight"] forState:UIControlStateHighlighted];
    [btn_back addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn_back.frame = CGRectMake(0, 0, 23 , 40);
    
    return btn_back;
}
-(void)backRootController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setNavgationSearchBarWithPlaceholder:(NSString *)placeholder tag:(NSInteger)tag target:(id)target{
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.frame = CGRectMake(50.0f, 14.0f,self.navigationController.navigationBar.frame.size.width - 100.f , 20.0f);//
    searchBar.placeholder = placeholder;
    searchBar.delegate = target;
    searchBar.tag = 300;
    [self.navigationController.navigationBar addSubview:searchBar];
}

-(void)removeNavgationSearchBar{
    [[self.navigationController.navigationBar viewWithTag:300] removeFromSuperview];
}

-(void)setNavgationLeftWithName:(NSString *)name font:(UIFont *)font color:(UIColor *)color size:(CGSize)size action:(SEL)action
{
    UIButton *btn_left = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_left addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn_left.frame = CGRectMake(0, 0, 50 , 44);
    btn_left.titleLabel.font = font;
    [btn_left setTitleColor:color forState:UIControlStateNormal];
    [btn_left setTitle:name forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn_left];
    
}
-(void)setNavgationRightWithName:(NSString *)name font:(UIFont *)font color:(UIColor *)color size:(CGSize)size action:(SEL)action
{
    UIButton *btn_right = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_right addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn_right.frame = CGRectMake(0, 0, size.width , size.height);
    btn_right.titleLabel.font = font;
    [btn_right setTitle:name forState:UIControlStateNormal];
    [btn_right setTitleColor:color forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn_right];
    
}
-(void)setNavgationLeftWithImgName:(NSString *)normalImgName highlighted:(NSString *)highlightedImaName size:(CGSize)size action:(SEL)action
{
    UIButton *btn_left = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_left setImage:[UIImage imageNamed:normalImgName] forState:UIControlStateNormal];
    [btn_left setImage:[UIImage imageNamed:highlightedImaName] forState:UIControlStateHighlighted];
    [btn_left addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn_left.frame = CGRectMake(0, 0, size.width , size.height);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn_left];
}

-(void)setNavgationRightWithImgName:(NSString *)normalImgName highlighted:(NSString *)highlightedImaName size:(CGSize)size action:(SEL)action
{
    UIButton *btn_right = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_right setImage:[UIImage imageNamed:normalImgName] forState:UIControlStateNormal];
    if (highlightedImaName) {
        [btn_right setImage:[UIImage imageNamed:highlightedImaName] forState:UIControlStateHighlighted];
    }
    [btn_right addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn_right.frame = CGRectMake(0, 0, size.width , size.height);
    btn_right.layer.masksToBounds = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn_right];
}
-(void)setNavgationRightWithImgUrl:(NSString *)normalImgName highlighted:(NSString *)highlightedImaName size:(CGSize)size action:(SEL)action
{
    UIButton *btn_right = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_right setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:normalImgName] placeholderImage:[UIImage imageNamed:@"home_rihgt_head_img"]];
    [btn_right setImage:[UIImage imageNamed:highlightedImaName] forState:UIControlStateHighlighted];
    [btn_right addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn_right.frame = CGRectMake(0, 0, size.width , size.height);
    btn_right.layer.masksToBounds = YES;
    btn_right.layer.cornerRadius = 15.f;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn_right];
}

-(void)setNavgationRightWithImgName:(NSString *)normalImgName highlighted:(NSString *)highlightedImaName size:(CGSize)size action:(SEL)action
                      normalImgName:(NSString *)normalImgName2 highlighted:(NSString *)highlightedImaName2 size:(CGSize)size2 action:(SEL)action2
{
    UIButton *btn_right = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_right setImage:[UIImage imageNamed:normalImgName] forState:UIControlStateNormal];
    [btn_right setImage:[UIImage imageNamed:highlightedImaName] forState:UIControlStateHighlighted];
    [btn_right setImage:[UIImage imageNamed:highlightedImaName] forState:UIControlStateSelected];
    [btn_right addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn_right.frame = CGRectMake(0, 0, size.width , size.height);
    
    UIButton *btn_right2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_right2 setImage:[UIImage imageNamed:normalImgName2] forState:UIControlStateNormal];
    [btn_right2 setImage:[UIImage imageNamed:highlightedImaName2] forState:UIControlStateHighlighted];
    [btn_right2 setImage:[UIImage imageNamed:highlightedImaName2] forState:UIControlStateSelected];
    [btn_right2 addTarget:self action:action2 forControlEvents:UIControlEventTouchUpInside];
    btn_right2.frame = CGRectMake(0, 0, size2.width , size2.height);
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:btn_right],[[UIBarButtonItem alloc] initWithCustomView:btn_right2]] ;
}

-(void)initTabBarItemWithTitle:(NSString *)titleStr normalImg:(NSString *)normalImg selectImg:(NSString *)selectImg  tag:(NSInteger)tag{
    //构建TabBarItem
    
    //Normal文字颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11],NSFontAttributeName,[UIColor darkGrayColor],NSForegroundColorAttributeName ,nil] forState:UIControlStateNormal];
    
    //Selected文字颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11],NSFontAttributeName,[UIColor redColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    UITabBarItem *item = [[UITabBarItem alloc] init];
    [item setTitle:titleStr];
    
    item.image = [[UIImage imageNamed:normalImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [[UIImage imageNamed:selectImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item setTag:tag];
    self.tabBarItem = item;
}
-(UIImage*)imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

/**
 *  添加阴影
 */
-(void)addShadow:(UIView *)shadowView offset:(CGSize)offset
{
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowView.layer.shadowOpacity =  0.3f;
    shadowView.layer.shadowOffset = offset;
    shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowView.bounds].CGPath;
}


/**
 *  获取本地时间
 */
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}
//传入 秒  得到 xx:xx:xx
-(NSString *)getHHMMSSFromSS:(NSInteger)seconds{
    
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
    
}
//传入 秒  得到  xx分钟xx秒
-(NSString *)getMMSSFromSS:(NSInteger)seconds{
    if (seconds < 60) {
        NSString *format_time = [NSString stringWithFormat:@"%ld",(long)seconds];
        return format_time;
    }
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@：%@",str_minute,str_second];
    
    NSLog(@"format_time : %@",format_time);
    
    return format_time;
    
}
-(void)showJGProgressWithMsg:(NSString *)msg{
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.indicatorView = nil;
    HUD.textLabel.text = msg;
    HUD.position = JGProgressHUDPositionCenter;
    HUD.marginInsets = (UIEdgeInsets) {
        .top = 0.0f,
        .bottom = 20.0f,
        .left = 0.0f,
        .right = 0.0f,
    };
    [HUD showInView:[[[UIApplication sharedApplication] windows] firstObject]];
    
    [HUD dismissAfterDelay:2.0];
}
-(void)showJGProgressLoadingWithTag:(NSInteger)tag{
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.tag = tag;
    HUD.textLabel.text = @"加载中...";
    [HUD showInView:self.view];
}
-(void)dissJGProgressLoadingWithTag:(NSInteger)tag{
    JGProgressHUD *HUD = [self.view viewWithTag:tag];
    [HUD dismiss];
}
@end
