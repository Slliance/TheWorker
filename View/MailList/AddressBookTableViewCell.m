//
//  AddressBookTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/20.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "AddressBookTableViewCell.h"

@implementation AddressBookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 18.f;
    // Initialization code
}
-(void)initCellWithData:(AddressBookFriendModel *) model isHidden:(NSInteger)isHidden{
    self.Id = [[NSString alloc] init];
    self.btnAccept.layer.masksToBounds = YES;
    self.btnAccept.layer.cornerRadius = 4.f;
    self.Id = [NSString stringWithFormat:@"%@",model.Id];
    if (model.remark.length > 0) {
        self.nameLabel.text = model.remark;
    }else{
        self.nameLabel.text = model.nickname;
    }
    
    [self.headerImageView setImageWithString:model.headimg placeHoldImageName:placeholderImage_user_headimg];
//    [self.headerImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,model.headimg]] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
    if ([model.status integerValue] == 1) {
        self.btnAccept.enabled = YES;
        [self.btnAccept setTitle:@"接受" forState:UIControlStateNormal];
        [self.btnAccept setBackgroundColor:[UIColor colorWithHexString:@"6398f1"]];
        [self.btnAccept setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if([model.status integerValue] == 2){
        self.btnAccept.enabled = NO;
        [self.btnAccept setBackgroundColor:[UIColor whiteColor]];
    }else{
        self.btnAccept.enabled = NO;
        [self.btnAccept setTitle:@"已拒绝" forState:UIControlStateDisabled];
        [self.btnAccept setBackgroundColor:[UIColor whiteColor]];
    }

    if (isHidden == 0) {
        self.btnAccept.hidden = NO;
    }else{
        self.btnAccept.hidden = YES;
    }
}

- (IBAction)acceptAction:(id)sender {
        self.btnAccept.enabled = NO;
        [self.btnAccept setBackgroundColor:[UIColor whiteColor]];
    self.returnAgreeApplyBlock(self.Id);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
