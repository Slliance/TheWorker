//
//  CircleTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/11.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "CircleTableViewCell.h"
#import "AgreesModel.h"
#import "UIButton+WebCache.h"
//#import "IQKeyboardManager.h"
//#import "CircleCommentTableViewCell.h"
@implementation CircleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initCellWithData:(FriendCircleModel *)model section:(NSInteger)section{
    self.circleUserModel  = model;
    self.section = section;
    
    for (UIView *view in self.subviews) {
        if (view.tag > 799) {
            [view removeFromSuperview];
        }
    }
    for (UIView *view in self.commentBgView.subviews) {
        if (view.tag > 799) {
            [view removeFromSuperview];
        }
    }
    
    
    CGFloat pointY = 55;
    
    UserModel *userModel = [[UserModel alloc]initWithDict:[UserDefaults readUserDefaultObjectValueForKey:user_info]];
    if ([userModel.Id isEqualToString:model.uid]) {
        self.btnDelete.hidden = NO;
    }else{
        self.btnDelete.hidden = YES;
    }
    self.userId = model.uid;
    //赋值
    [self.userIconImg setImageWithString:model.headimg placeHoldImageName:placeholderImage_user_headimg];
//    [self.userIconImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,model.headimg]] placeholderImage:[UIImage imageNamed:@"icon_personal_center_default_avatar"]];
    self.labelUserName.text = model.nickname;
    
    self.labelTime.text = model.createtime;
    
    self.btnThump.selected = [model.is_agree boolValue];
    
    NSAttributedString *contentString = [[NSAttributedString alloc] initWithString:model.content
                                                                        attributes:@{
                                                                                     (id)kCTForegroundColorAttributeName : (id)[UIColor colorWithHexString:@"333333"].CGColor,
                                                                                     NSFontAttributeName : [UIFont boldSystemFontOfSize:14],
                                                                                     NSKernAttributeName : [NSNull null],
                                                                                     (id)kTTTBackgroundFillColorAttributeName : (id)[UIColor clearColor].CGColor
                                                                                     }];
    self.labelContent.lineSpacing = 8.f;
    [self.labelContent setText:contentString];
    self.labelContent.enabledTextCheckingTypes = NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber;
    self.labelContent.showMenuController = YES;

    __block CGFloat contentHeight = 0;
    [self.labelContent setText:model.content afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
     {
         contentHeight = [TTTAttributedLabel sizeThatFitsAttributedString:mutableAttributedString withConstraints:CGSizeMake(ScreenWidth - 73, MAXFLOAT) limitedToNumberOfLines:0].height;
         
         return mutableAttributedString;
     }
     ];
    
    
    
    self.userIconImg.layer.masksToBounds = YES;
    self.userIconImg.layer.cornerRadius = 22.5f;
    
    
    CGRect rectContent = self.labelContent.frame;
    rectContent.size.height = contentHeight;
    self.labelContent.frame = rectContent;
    
    pointY += contentHeight;
    
    pointY += 10;
    //图片
    
    CGFloat w = (ScreenWidth-72) / 3;
    CGFloat margin = 3;
    for (int i = 0; i < model.imgs.count; i ++) {
        
//        UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        imgBtn.tag = 800 + i;
//        imgBtn.frame = CGRectMake(62 + (i%3)*(w+margin), pointY + (i/3)*(w+margin), w, w);

        
        UIImageView *image = [[UIImageView alloc]init];
        [image setContentMode:UIViewContentModeScaleAspectFill];
        image.clipsToBounds = YES;
        [image setUserInteractionEnabled:YES];
        image.tag = 800 + i;
        image.frame = CGRectMake(62 + (i%3)*(w+margin), pointY + (i/3)*(w+margin), w, w);
//        [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,model.imgs[i]]] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
        [image setImageWithString:model.imgs[i] placeHoldImageName:@"bg_no_pictures"];
        [self addSubview:image];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [image addGestureRecognizer:tap];
    }
    //图片背景view（可以隐藏）
    CGRect rectPic = self.picBgView.frame;
    rectPic.origin.y = pointY;
    self.picBgView.frame = rectPic;
    if (model.imgs.count) {
        pointY += model.imgs.count % 3 ? (model.imgs.count / 3 + 1) * (w + margin) + 10 : model.imgs.count / 3 * (w + margin) + 10;
    }
    //点赞，评论，删除按钮
    CGRect rectBtn = self.btnBgView.frame;
    rectBtn.origin.y = pointY;
    self.btnBgView.frame = rectBtn;
    pointY += rectBtn.size.height;
    
    CGFloat  thumpY = 10.f;
    //先判断是否有点赞的人
    if (!model.agrees.count) {//没有点赞的人
        self.imgThump.hidden = YES;
        self.labelThumpPeople.hidden = YES;
        [self.btnThump setTitle:@"点赞" forState:UIControlStateNormal];
    }
    else{
        [self.btnThump setTitle:[NSString stringWithFormat:@" %lu",(unsigned long)model.agrees.count] forState:UIControlStateNormal];
        self.imgThump.hidden = NO;
        self.labelThumpPeople.hidden = NO;
        //点赞的人label
        NSString *agreeStr = [[NSString alloc]init];
        for (int i = 0; i < model.agrees.count; i ++) {
            
            AgreesModel *agreesModel = model.agrees[i];
            agreeStr = [agreeStr stringByAppendingFormat:@",%@",agreesModel.nickname];
        }
        agreeStr = [agreeStr substringFromIndex:1];
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:agreeStr
                                                                        attributes:@{
                                                                                     (id)kCTForegroundColorAttributeName : (id)[UIColor colorWithHexString:@"6398f1"].CGColor,
                                                                                     (id)kTTTBackgroundFillColorAttributeName : (id)[UIColor clearColor].CGColor
                                                                                     }];
        
        
        [self.labelThumpPeople setText:attString];
        self.labelThumpPeople.font = [UIFont systemFontOfSize:13];
        __block CGFloat thumpHeight = 0;
        [self.labelThumpPeople setText:agreeStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
         {
             thumpHeight = [TTTAttributedLabel sizeThatFitsAttributedString:mutableAttributedString withConstraints:CGSizeMake(ScreenWidth - 110, MAXFLOAT) limitedToNumberOfLines:0].height;
             
             return mutableAttributedString;
         }
         ];
        
        CGRect rectThump = self.labelThumpPeople.frame;
        rectThump.origin.x = 32.f;
        rectThump.origin.y = self.imgThump.frame.origin.y;
        rectThump.size.height = thumpHeight;
        rectThump.size.width = ScreenWidth - 110;
        self.labelThumpPeople.frame = rectThump;
        
        thumpY += thumpHeight + 10;
        
        //lineLabel
        self.lineLabel.frame = CGRectMake(0, thumpY, ScreenWidth - 90, 1);
        if (model.follows.count) {
            thumpY += 10;
        }

    }
    
    //判断是否有评论的人
    
    if (!model.follows.count) {//没有评论的人
        self.imgComment.hidden = YES;
        [self.btnComment setTitle:@"评论" forState:UIControlStateNormal];
    }
    else{
        self.imgComment.hidden = NO;
        //评论的img
        self.imgComment.frame = CGRectMake(8, thumpY + 3 , 13, 13);
        for (UIView *view in self.commentBgView.subviews) {
            if (view.tag > 996) {
                [view removeFromSuperview];
            }
        }
        [self.btnComment setTitle:[NSString stringWithFormat:@" %lu",(unsigned long)model.follows.count] forState:UIControlStateNormal];

        
        //评论的内容
        for (int i = 0; i <model.follows.count; i ++) {
            FollowsModel *followsModel = model.follows[i];
            
            
            TTTAttributedLabel *attributedLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(32, thumpY, ScreenWidth - 110, 20)];
            attributedLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
//            attributedLabel.activeLinkAttributes = @{NSForegroundColorAttributeName:[UIColor clearColor],(NSString *)kCTBackgroundColorAttributeName:[UIColor colorWithHexString:@"#D4D4D4"]};
            
            //点击link样式
            NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
            [mutableActiveLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
            [mutableActiveLinkAttributes setValue:(__bridge id)[UIColor blackColor].CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
//            [mutableActiveLinkAttributes setValue:(__bridge id)[UIColor lightGrayColor].CGColor forKey:(NSString *)kCTBackgroundColorAttributeName];
            attributedLabel.activeLinkAttributes = mutableActiveLinkAttributes;
            
            attributedLabel.delegate = self;
            NSString *commentstr = followsModel.nickname;
            if (followsModel.atnickname.length) {
                commentstr = [commentstr stringByAppendingFormat:@"回复%@",followsModel.atnickname];
            }
            commentstr = [commentstr stringByAppendingFormat:@":%@",followsModel.content];
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:commentstr
                                                                            attributes:@{
                                                                                         (id)kCTForegroundColorAttributeName : (id)[UIColor colorWithHexString:@"333333"].CGColor,
                                                                                         NSFontAttributeName : [UIFont systemFontOfSize:13],
                                                                                         NSKernAttributeName : [NSNull null],
                                                                                         (id)kTTTBackgroundFillColorAttributeName : (id)[UIColor clearColor].CGColor
                                                                                         }];
            
            // The attributed string is directly set, without inheriting any other text
            // properties of the label.
            attributedLabel.text = attString;
            attributedLabel.numberOfLines = 0;
            attributedLabel.lineSpacing = 6.f;

            __block CGFloat commentHeight = 0;
            commentHeight = [self getStringRect:attString width:ScreenWidth - 110 height:9000];
            [attributedLabel setFrame:CGRectMake(32, thumpY, ScreenWidth - 110, commentHeight)];
            
            thumpY += commentHeight;
            thumpY += 5.f;
            attributedLabel.font = [UIFont systemFontOfSize:13];
            
            [attributedLabel setText:commentstr afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
             
             {
                 
                 
                 //设置可点击文字的范围
                 
                 NSRange boldRange = [[mutableAttributedString string] rangeOfString:followsModel.nickname options:NSCaseInsensitiveSearch];
                 
                 
                 //设定可点击文字的的大小
                 
                 UIFont *boldSystemFont = [UIFont systemFontOfSize:13];
                 
                 CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
                 
                 
                 
                 if (font) {
                     
                     
                     
                     //设置可点击文本的大小
                     
                     [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
                     

                     //设置可点击文本的颜色
                     
                     [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"6398f1"] CGColor] range:boldRange];
                     if (followsModel.atnickname.length) {
                         NSRange atnickNameRange = [[mutableAttributedString string] rangeOfString:followsModel.atnickname options:NSCaseInsensitiveSearch];
                         
                         [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"6398f1"] CGColor] range:atnickNameRange];
                         
                     }
                     
                     
                     CFRelease(font);
                 }
                 
                 return mutableAttributedString;
                 
             }];

            [attributedLabel addLinkToAddress:@{@"model":followsModel} withRange:NSMakeRange(0, attributedLabel.attributedText.length)];
            
            attributedLabel.tag = 997 + i;
            [self.commentBgView addSubview:attributedLabel];
            
            
        }
        
        
    }
    
    //评论的背景view
    CGRect rectComment = self.commentBgView.frame;
    rectComment.origin.y = self.btnBgView.frame.origin.y + self.btnBgView.frame.size.height + 10;
    rectComment.size.width = ScreenWidth - 70;
    rectComment.size.height = thumpY;
    
    self.commentBgView.frame = rectComment;
    
    if (self.imgThump.hidden && self.imgComment.hidden) {
        self.commentBgView.hidden = YES;
    }
    else{
        self.commentBgView.hidden = NO;
    }

    if (model.agrees.count && model.follows.count) {
        self.lineLabel.hidden = NO;
    }
    else{
        self.lineLabel.hidden = YES;
    }
    
}


#pragma mark - UIActionSheetDelegate


- (void)actionSheet:(UIActionSheet *)actionSheet

clickedButtonAtIndex:(NSInteger)buttonIndex

{
    
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        
        return;
        
    }
    
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionSheet.title]];
    
}
-(CGFloat)getCellHeightWithData:(FriendCircleModel *)model{
    CGFloat pointY = 55;
    
    UserModel *userModel = [[UserModel alloc]initWithDict:[UserDefaults readUserDefaultObjectValueForKey:user_info]];
    if ([userModel.Id isEqualToString:model.uid]) {
        self.btnDelete.hidden = NO;
    }
    else{
        self.btnDelete.hidden = YES;
    }
    //赋值
    [self.userIconImg setImageWithString:model.headimg placeHoldImageName:placeholderImage_user_headimg];
//    [self.userIconImg setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[UIImage imageNamed:@"icon_personal_center_default_avatar"]];
    self.labelUserName.text = model.nickname;
    
    self.labelTime.text = model.createtime;
    
    
    
    
    NSAttributedString *contentString = [[NSAttributedString alloc] initWithString:model.content
                                                                        attributes:@{
                                                                                     (id)kCTForegroundColorAttributeName : (id)[UIColor colorWithHexString:@"333333"].CGColor,
                                                                                     NSFontAttributeName : [UIFont boldSystemFontOfSize:14],
                                                                                     NSKernAttributeName : [NSNull null],
                                                                                     (id)kTTTBackgroundFillColorAttributeName : (id)[UIColor clearColor].CGColor
                                                                                     }];
    self.labelContent.lineSpacing = 8.f;
    [self.labelContent setText:contentString];
    
    __block CGFloat contentHeight = 0;
    [self.labelContent setText:model.content afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
     {
         contentHeight = [TTTAttributedLabel sizeThatFitsAttributedString:mutableAttributedString withConstraints:CGSizeMake(ScreenWidth - 73, MAXFLOAT) limitedToNumberOfLines:0].height;
         
         return mutableAttributedString;
     }
     ];
    
    
    
    self.userIconImg.layer.masksToBounds = YES;
    self.userIconImg.layer.cornerRadius = 22.5f;
    
    
    CGRect rectContent = self.labelContent.frame;
    rectContent.size.height = contentHeight;
    self.labelContent.frame = rectContent;
    
    pointY += contentHeight;
    
    pointY += 10;
    //图片
    
    CGFloat w = (ScreenWidth-72) / 3;
    CGFloat margin = 3;
    for (int i = 0; i < model.imgs.count; i ++) {
        UIImageView *image = [[UIImageView alloc]init];
        [image setContentMode:UIViewContentModeScaleAspectFill];
        image.clipsToBounds = YES;
        image.tag = 800 + i;
        image.frame = CGRectMake(62 + (i%3)*(w+margin), pointY + (i/3)*(w+margin), w, w);
//        [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,model.imgs[i]]] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
        [image setImageWithString:model.imgs[i] placeHoldImageName:@"bg_no_pictures"];

    }
    //图片背景view（可以隐藏）
    CGRect rectPic = self.picBgView.frame;
    rectPic.origin.y = pointY;
    self.picBgView.frame = rectPic;
    if (model.imgs.count) {
        pointY += model.imgs.count % 3 ? (model.imgs.count / 3 + 1) * (w + margin) + 10 : model.imgs.count / 3 * (w + margin) + 10;
    }
    //点赞，评论，删除按钮
    CGRect rectBtn = self.btnBgView.frame;
    rectBtn.origin.y = pointY;
    self.btnBgView.frame = rectBtn;
    pointY += rectBtn.size.height;
    
    CGFloat  thumpY = 10.f;
    //先判断是否有点赞的人
    if (!model.agrees.count) {//没有点赞的人
        self.imgThump.hidden = YES;
        self.labelThumpPeople.hidden = YES;
    }
    else{
        self.labelThumpPeople.hidden = NO;
        self.imgThump.hidden = NO;
        
        //点赞的人label
        NSString *agreeStr = [[NSString alloc]init];
        for (int i = 0; i < model.agrees.count; i ++) {
            
            AgreesModel *agreesModel = model.agrees[i];
            agreeStr = [agreeStr stringByAppendingFormat:@",%@",agreesModel.nickname];
        }
        agreeStr = [agreeStr substringFromIndex:1];
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:agreeStr
                                                                        attributes:@{
                                                                                     (id)kCTForegroundColorAttributeName : (id)[UIColor colorWithHexString:@"6398f1"].CGColor,
                                                                                     (id)kTTTBackgroundFillColorAttributeName : (id)[UIColor clearColor].CGColor
                                                                                     }];
        
        
        [self.labelThumpPeople setText:attString];
        self.labelThumpPeople.font = [UIFont boldSystemFontOfSize:13];
        __block CGFloat thumpHeight = 0;
        [self.labelThumpPeople setText:agreeStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
         {
             thumpHeight = [TTTAttributedLabel sizeThatFitsAttributedString:mutableAttributedString withConstraints:CGSizeMake(ScreenWidth - 110, MAXFLOAT) limitedToNumberOfLines:0].height;
             
             return mutableAttributedString;
         }
         ];
        
        CGRect rectThump = self.labelThumpPeople.frame;
        rectThump.origin.x = 32.f;
        rectThump.origin.y = self.imgThump.frame.origin.y;
        rectThump.size.height = thumpHeight;
        rectThump.size.width = ScreenWidth - 110;
        self.labelThumpPeople.frame = rectThump;
        
        thumpY += thumpHeight + 10;
        
        //lineLabel
        self.lineLabel.frame = CGRectMake(0, thumpY, ScreenWidth - 90, 1);
        if (model.follows.count) {
            thumpY += 10;
        }

        
    }
    
    
    //判断是否有评论的人
    
    if (!model.follows.count) {//没有评论的人
        self.imgComment.hidden = YES;
    }
    else{
        thumpY += 10;
        self.imgComment.hidden = NO;
        //评论的img
        self.imgComment.frame = CGRectMake(8, thumpY + 3 , 13, 13);
        for (UIView *view in self.commentBgView.subviews) {
            if (view.tag > 996) {
                [view removeFromSuperview];
            }
        }
        
        
        //评论的内容
        for (int i = 0; i <model.follows.count; i ++) {
            FollowsModel *followsModel = model.follows[i];
            
            
            TTTAttributedLabel *attributedLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(32, thumpY, ScreenWidth - 110, 20)];
            
            
            NSString *commentstr = followsModel.nickname;
            if (followsModel.atnickname.length) {
                commentstr = [commentstr stringByAppendingFormat:@"回复%@",followsModel.atnickname];
            }
            commentstr = [commentstr stringByAppendingFormat:@":%@",followsModel.content];
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:commentstr
                                                                            attributes:@{
                                                                                         (id)kCTForegroundColorAttributeName : (id)[UIColor colorWithHexString:@"333333"].CGColor,
                                                                                         NSFontAttributeName : [UIFont systemFontOfSize:13],
                                                                                         NSKernAttributeName : [NSNull null],
                                                                                         (id)kTTTBackgroundFillColorAttributeName : (id)[UIColor clearColor].CGColor
                                                                                         }];
            
            // The attributed string is directly set, without inheriting any other text
            // properties of the label.
            attributedLabel.text = attString;
            
            
            CGFloat commentHeight = 0;
            
            commentHeight = [self getStringRect:attString width:ScreenWidth - 110 height:9000];
            
            [attributedLabel setFrame:CGRectMake(32, thumpY, ScreenWidth - 110, commentHeight)];
            
            
            thumpY += commentHeight;
            thumpY += 5.f;
            attributedLabel.font = [UIFont systemFontOfSize:13];
            
            [attributedLabel setText:commentstr afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
             
             {
                 
                 
                 //设置可点击文字的范围
                 
                 NSRange boldRange = [[mutableAttributedString string] rangeOfString:followsModel.nickname options:NSCaseInsensitiveSearch];
                 
                 
                 //设定可点击文字的的大小
                 
                 UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:13];
                 
                 CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
                 
                 
                 
                 if (font) {
                     
                     
                     
                     //设置可点击文本的大小
                     
                     [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
                     
                     
                     
                     //设置可点击文本的颜色
                     
                     [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"6398f1"] CGColor] range:boldRange];
                     if (followsModel.atnickname.length) {
                         NSRange atnickNameRange = [[mutableAttributedString string] rangeOfString:followsModel.atnickname options:NSCaseInsensitiveSearch];
                         
                         [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"6398f1"] CGColor] range:atnickNameRange];
                         
                     }
                     
                     
                     CFRelease(font);
                 }
                 
                 return mutableAttributedString;
                 
             }];
            
            
            attributedLabel.tag = 997 + i;

            
            
        }
        
        
    }
    
    //评论的背景view
    CGRect rectComment = self.commentBgView.frame;
    rectComment.origin.y = self.btnBgView.frame.origin.y + self.btnBgView.frame.size.height;
    rectComment.size.width = ScreenWidth - 70;
    rectComment.size.height = thumpY;
    
    self.commentBgView.frame = rectComment;
    
    if (self.imgThump.hidden && self.imgComment.hidden) {
        self.commentBgView.hidden = YES;
    }
    else{
        self.commentBgView.hidden = NO;
        thumpY += 10;
    }
    
    return self.btnBgView.frame.origin.y + self.btnBgView.frame.size.height + thumpY + 10;
}


- (CGFloat)getStringRect:(NSAttributedString *)aString width:(CGFloat)width height:(CGFloat)height {
    NSMutableAttributedString *atrString = [[NSMutableAttributedString alloc] initWithAttributedString:aString];
    NSRange range = NSMakeRange(0, atrString.length);
    //获取指定位置上的属性信息，并返回与指定位置属性相同并且连续的字符串的范围信息。
    NSDictionary* dic = [atrString attributesAtIndex:0 effectiveRange:&range];
    //不存在段落属性，则存入默认值
    NSMutableParagraphStyle *paragraphStyle = dic[NSParagraphStyleAttributeName]; if (!paragraphStyle || nil == paragraphStyle) { paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineSpacing = 8.0;
        //增加行高
        paragraphStyle.headIndent = 0;
        //头部缩进，相当于左padding
        paragraphStyle.tailIndent = 0;
        //相当于右padding
        paragraphStyle.lineHeightMultiple = 0;
        //行间距是多少倍
        paragraphStyle.alignment = NSTextAlignmentLeft;
        //对齐方式
        paragraphStyle.firstLineHeadIndent = 0;
        //首行头缩进
        paragraphStyle.paragraphSpacing = 0;
        //段落后面的间距
        paragraphStyle.paragraphSpacingBefore = 0;
        //段落之前的间距
        [atrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range]; }
    //设置默认字体属性
    UIFont *font = dic[NSFontAttributeName];
    if (!font || nil == font) { font = [UIFont systemFontOfSize:13]; [atrString addAttribute:NSFontAttributeName value:font range:range];
    }
    NSMutableDictionary *attDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [attDic setObject:font forKey:NSFontAttributeName];
    [attDic setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    CGSize strSize = [[aString string] boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attDic context:nil].size;
    
    
    return strSize.height;

}
    


#pragma mark - TTTAttributedLabelDelegate 

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents {

    NSLog(@"detailAdd:%@",addressComponents[@"model"]);
     UserModel *userModel = [[UserModel alloc]initWithDict:[UserDefaults readUserDefaultObjectValueForKey:user_info]];
    FollowsModel *model = addressComponents[@"model"];
    if ([model.uid isEqualToString:userModel.Id]) {
        return;
    }
    self.replyCommentBlock(self.circleUserModel, addressComponents[@"model"],self.section);
}

- (IBAction)skipAction:(id)sender {
    self.skipBlock(self.userId,self.circleUserModel.nickname,self.circleUserModel.headimg);
}
 //评论
- (IBAction)showKeyBoard:(id)sender {
    self.showKeyBoardBlock(self.circleUserModel,self.section);
}
//删除评论
-(void)delDiscussWith:(UIButton *)btn{
    self.deleteDiscussBlock(self.circleUserModel.Id);
}

-(void)replaySomeoneWith:(UIButton *)btn{
    
    self.showKeyBoardBlock(self.circleUserModel,self.section);
}

//点赞

- (IBAction)thumpAction:(id)sender {
    if (self.btnThump.selected == NO) {
        self.btnThump.selected = YES;
        
    }else{
        self.btnThump.selected = NO;
    }
    self.thumpBlock(self.circleUserModel,self.section);
}
//删除帖子

- (IBAction)deleteAction:(id)sender {
    self.deleteCircleBlock(self.circleUserModel,self.section);
}

-(void)tapAction:(UITapGestureRecognizer *)ges{
    
    self.photoBlock(self.circleUserModel, ges.view.tag - 800);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
