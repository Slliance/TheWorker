//
//  AddFriendTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/20.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "AddFriendTableViewCell.h"

@implementation AddFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = 18.f;
    // Initialization code
}
- (IBAction)addFriendAction:(id)sender {
    self.returnAddBlcok(self.uid);
//        self.btnAdd.enabled = NO;
//        [self.btnAdd setBackgroundColor:[UIColor whiteColor]];
}

-(void)initCellWithData:(AddressBookFriendModel *)model{
    self.nameLabel.text = model.nickname;
    self.uid = [NSString stringWithFormat:@"%@",model.Id];
    [self.headImgView setImageWithString:model.headimg placeHoldImageName:placeholderImage_user_headimg];
//    [self.headImgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,model.headimg]] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
    self.btnAdd.layer.masksToBounds = YES;
    self.btnAdd.layer.cornerRadius = 4.f;
    if ([model.status integerValue] == 0) {
        self.btnAdd.enabled = YES;
    }else if([model.status integerValue] == 1){
        self.btnAdd.enabled = NO;
        [self.btnAdd setBackgroundColor:[UIColor whiteColor]];
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
