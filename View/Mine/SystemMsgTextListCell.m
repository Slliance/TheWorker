//
//  SystemMsgTextListCell.m
//  jishikangUser
//
//  Created by yanghao on 6/30/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "SystemMsgTextListCell.h"

@implementation SystemMsgTextListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.f;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initCell:(SystemMsgModel *)model{
//    NSString *contentstr = [NSString stringWithFormat:@"<div style=\"font-size:14px; color:#000000;\"> %@</div>",model.Content];

    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[model.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,[UIFont systemFontOfSize:14]:NSFontAttributeName} documentAttributes:nil error:nil];
    self.labelName.text = model.title;
    self.labelContent.attributedText = attrStr;
    
    CGRect rect = self.labelContent.frame;
    CGSize size = [model.content sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ScreenWidth - 36, 3000)];
    rect.size.height = size.height + 5;
    self.labelContent.frame = rect;
    
}

@end
