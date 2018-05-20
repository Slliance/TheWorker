//
//  CommonAlertViewCell.m
//  TheWorker
//
//  Created by apple on 2018/5/19.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "CommonAlertViewCell.h"

@implementation CommonAlertViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
   
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.bgImage];
        [self.bgImage addSubview:self.nameLabel];
        [self.bgImage addSubview:self.typeLabel];
        [self.bgImage addSubview:self.dateLabel];
        [self.bgImage addSubview:self.contentLabel];
    }
    return self;
}
-(void)setModel:(CouponModel *)model{
    _model = model;
    _nameLabel.text = model.name;
    _typeLabel.text = model.type;
    if ([model.start_time isEqualToString:model.end_time]) {
        _dateLabel.text = @"长期有效";
    }else{
        _dateLabel.text = [NSString stringWithFormat:@"%@-%@",model.start_time,model.end_time];
    }
    _contentLabel.text = model.remark;
}
-(UIImageView *)bgImage{
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc]init];
        _bgImage.image = [UIImage imageNamed:@""];
        _bgImage.userInteractionEnabled = YES;
        _bgImage.frame = CGRectMake(0, 0, 290, 100);
    }
    return _bgImage;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.backgroundColor = [UIColor whiteColor];
        [_nameLabel.layer setCornerRadius:2];
        [_nameLabel.layer setMasksToBounds:YES];
        _nameLabel.font = [UIFont systemFontOfSize:20];
        _nameLabel.frame = CGRectMake(22, 21, 55, 59);
        _nameLabel.numberOfLines = 2;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}
-(UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.font = [UIFont systemFontOfSize:23];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.frame = CGRectMake(77, 20, 203, 23);
    }
    return _typeLabel;
}
-(UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.frame = CGRectMake(77, 51, 203, 12);
    }
    return _dateLabel;
}
-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:10];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.frame = CGRectMake(77, 70, 203, 23);
    }
    return _contentLabel;
}
@end
