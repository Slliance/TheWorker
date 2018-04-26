//
//  CircleTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/11.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendCircleModel.h"
#import "UserModel.h"
#import "FollowsModel.h"
#import "TTTAttributedLabel.h"
@interface CircleTableViewCell : UITableViewCell<TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userIconImg;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *labelContent;
@property (weak, nonatomic) IBOutlet UIButton *btnThump;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *labelThumpPeople;
@property (weak, nonatomic) IBOutlet UIView *picBgView;
@property (weak, nonatomic) IBOutlet UIView *commentBgView;
@property (weak, nonatomic) IBOutlet UIView *btnBgView;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIImageView *imgThump;
@property (weak, nonatomic) IBOutlet UIImageView *imgComment;

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (nonatomic, retain) FriendCircleModel *circleUserModel;
@property (nonatomic, retain) NSArray *agreeArr;
@property (nonatomic, retain) NSArray *followArr;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) void(^skipBlock)(NSString *,NSString *,NSString *);
@property (nonatomic, copy) void(^showKeyBoardBlock)(FriendCircleModel *,NSInteger);
@property (nonatomic, copy) void(^thumpBlock)(FriendCircleModel *,NSInteger);
@property (nonatomic, copy) void(^deleteCircleBlock)(FriendCircleModel *,NSInteger);
@property (nonatomic, copy) void(^deleteDiscussBlock)(NSString *);
@property (nonatomic, copy) void(^photoBlock)(FriendCircleModel *,NSInteger);
@property (nonatomic, copy) void(^replyCommentBlock)(FriendCircleModel *,FollowsModel *,NSInteger);

@property (nonatomic, assign) NSInteger         section;

-(void)initCellWithData:(FriendCircleModel *)model section:(NSInteger)section;
-(CGFloat)getCellHeightWithData:(FriendCircleModel *)model;
@end
