//
//  MobileFriendTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MobileFriendTableViewCell.h"

@implementation MobileFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)addFriendAction:(id)sender {
    self.returnAddBlcok(self.uid);
    //        self.btnAdd.enabled = NO;
    //        [self.btnAdd setBackgroundColor:[UIColor whiteColor]];
}

-(void)initCellWithData:(FriendModel *)model{
    self.nameLabel.text = model.nickname;
    self.phoneNumLabel.text = model.mobile;
    self.uid = model.mobile;
    self.btnAddFriend.layer.masksToBounds = YES;
    self.btnAddFriend.layer.cornerRadius = 4.f;
    if ([model.status integerValue] == 1) {
        self.btnAddFriend.enabled = YES;
        [self.btnAddFriend setTitle:@"加为好友" forState:UIControlStateNormal];
        [self.btnAddFriend setBackgroundColor:[UIColor colorWithHexString:@"6398f1"]];
        [self.btnAddFriend setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        if ([model.mobile isEqualToString:@"15390431403"]) {
            NSLog(@"%@",model);
        }
    }else if([model.status integerValue] == 2){
        self.btnAddFriend.enabled = NO;
        [self.btnAddFriend setTitle:@"已是好友" forState:UIControlStateDisabled];
        [self.btnAddFriend setBackgroundColor:[UIColor whiteColor]];
        [self.btnAddFriend setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        
    }
    //    else{
    //        self.btnAdd.enabled = NO;
    //        [self.btnAdd setTitle:@"已拒绝" forState:UIControlStateDisabled];
    //        [self.btnAdd setBackgroundColor:[UIColor whiteColor]];
    //    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
