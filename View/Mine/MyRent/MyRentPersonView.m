//
//  MyRentPersonView.m
//  TheWorker
//
//  Created by yanghao on 9/2/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "MyRentPersonView.h"

@implementation MyRentPersonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initView:(RentOrderModel *)model type:(NSInteger)type{
    self.state = [model.status integerValue];
    self.labelShow.textColor = [UIColor colorWithHexString:@"ff6666"];
    [self.firstBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.secondBtn setTitleColor:[UIColor colorWithHexString:@"ef5f7d"] forState:UIControlStateNormal];
    
    self.firstBtn.layer.masksToBounds = YES;
    self.firstBtn.layer.cornerRadius = 4.f;
    self.firstBtn.layer.borderColor = [[UIColor colorWithHexString:@"cccccc"] CGColor];
    self.firstBtn.layer.borderWidth = 1.;
    
    self.secondBtn.layer.masksToBounds = YES;
    self.secondBtn.layer.cornerRadius = 4.f;
    self.secondBtn.layer.borderColor = [[UIColor colorWithHexString:@"ef5f7d"] CGColor];
    self.secondBtn.layer.borderWidth = 1.;
    switch (self.state) {
        case 0:
            
            break;
        
        case 1:
            if (type == 1) {
                self.firstBtn.hidden = YES;
                [self.secondBtn setTitle:@"取消" forState:UIControlStateNormal];
                self.labelShow.text = @"等待同意";
            }else{
                [self.firstBtn setTitle:@"不同意" forState:UIControlStateNormal];
                [self.secondBtn setTitle:@"同意" forState:UIControlStateNormal];
                self.labelShow.hidden = YES;
            }
            

            break;
        case 2:
            
            if (type == 1) {
                if ([model.status2 integerValue] == 2) {
                    self.firstBtn.hidden = YES;
                    self.secondBtn.hidden = YES;
                    self.labelShow.text = @"等待出租方确认见面";
                }else{
                    [self.firstBtn setTitle:@"提出异议" forState:UIControlStateNormal];
                    [self.secondBtn setTitle:@"确认已见面" forState:UIControlStateNormal];
                    self.labelShow.hidden = YES;
                }
                
            }else{
                [self.firstBtn setTitle:@"已见面" forState:UIControlStateNormal];
                [self.secondBtn setTitle:@"未见面" forState:UIControlStateNormal];
                self.labelShow.hidden = YES;
            }
            
            break;
        case 3:
        {
            self.firstBtn.hidden = YES;
            self.secondBtn.hidden = YES;
            self.labelShow.text = [NSString stringWithFormat:@"已拒绝"];
            UILabel *label = [[UILabel alloc] init];
            label.text = [NSString stringWithFormat:@"原因：%@",model.refund_reason];
            label.font = [UIFont systemFontOfSize:12];
            label.frame = CGRectMake(70, 15, ScreenWidth-100, 20);
            [self addSubview:label];
            break;
        }

        case 4:
            self.firstBtn.hidden = YES;
            [self.secondBtn setTitle:@"去评价" forState:UIControlStateNormal];
            self.labelShow.hidden = YES;
            if (type == 1) {
                if ([model.status2 integerValue] == 2) {
                    self.labelShow.hidden = NO;
                    self.firstBtn.hidden = YES;
                    self.secondBtn.hidden = YES;
                }
            }else{
                if ([model.status2 integerValue] == 2) {
                    self.labelShow.hidden = NO;
                    self.firstBtn.hidden = YES;
                    self.secondBtn.hidden = YES;
                }
            }
            
            
            
            
            break;
        case 5:
            self.firstBtn.hidden = YES;
            [self.secondBtn setTitle:@"去评价" forState:UIControlStateNormal];
            
            if ([model.exception_status integerValue] == 1) {
                self.labelShow.text = [NSString stringWithFormat:@"等待平台审核"];
                self.secondBtn.hidden = YES;
            }else if ([model.exception_status integerValue] == 2){
                self.labelShow.text = [NSString stringWithFormat:@"已通过"];
            }else{
                self.labelShow.text = [NSString stringWithFormat:@"未通过"];
            }
           
            break;
        case 6:
        {
            self.firstBtn.hidden = YES;
            self.secondBtn.hidden = YES;
            self.labelShow.hidden = YES;
            for (int i = 0; i < [model.point integerValue]; i ++) {
                UIImageView *imgView = [[UIImageView alloc] init];
                imgView.frame = CGRectMake(10 + (i%5)*25, 15, 22, 21);
                imgView.image = [UIImage imageNamed:@"icon_yellow_star"];
                [self addSubview:imgView];
            }
            UILabel *label = [[UILabel alloc] init];
            label.text = [NSString stringWithFormat:@"%@",model.evaluate];
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont systemFontOfSize:12];
            label.frame = CGRectMake(135, 15, ScreenWidth-145, 20);
            [self addSubview:label];
            break;
        }
        case 7:
        {
            self.firstBtn.hidden = YES;
            self.secondBtn.hidden = YES;
            self.labelShow.text = @"已取消";
            UILabel *label = [[UILabel alloc] init];
            label.text = [NSString stringWithFormat:@"原因：%@",model.refund_reason];
            label.font = [UIFont systemFontOfSize:12];
            label.frame = CGRectMake(70, 15, ScreenWidth-100, 20);
            [self addSubview:label];
            break;
        }
        
            
        default:
            break;
    }
    
}
- (IBAction)firstBtnAction:(id)sender {
    self.firstReturnBlock(self.state);
}
- (IBAction)secondBtnAction:(id)sender {
    self.secondReturnBlock(self.state);
}


@end
