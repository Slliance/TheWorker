//
//  InfoDetailViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/10.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"
#import "ArticleModel.h"
@interface InfoDetailViewController : HYBaseViewController
@property (nonatomic, copy) NSString *bannerUrl;
@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, assign) NSInteger isCollect;
@property (nonatomic, retain) NSNumber *type;
@property (nonatomic, retain) ArticleModel *articleModel;
@property (nonatomic, copy) void(^returnReloadBlock)(void);
@end
