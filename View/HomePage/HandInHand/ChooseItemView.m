//
//  ChooseItemView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/12.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ChooseItemView.h"
#import "RentPersonItemTableViewCell.h"
#import "SkillModel.h"
@implementation ChooseItemView

- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    if (!CGRectContainsPoint(self.itemTablView.frame, [sender locationInView:self])) {
        [self removeFromSuperview];
        self.removeBlock();
    }
}


-(void)initView:(NSArray *)itemArr{
    
    CGRect rect = self.itemTablView.frame;
    if (itemArr.count <= 6) {
        rect.size.height = 44 * itemArr.count;
    }
    else{
        rect.size.height = 44 * 6;
    }
    rect.origin.y = ScreenHeight-rect.size.height;
    self.itemTablView.frame = rect;
    self.itemArr = itemArr;
    [self.itemTablView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.itemTablView reloadData];
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    SkillModel *model = self.itemArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@    %@元/小时",model.name,model.price];
    return cell;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.returnBlock(self.itemArr[indexPath.row]);
    [self.itemTablView reloadData];
    [self removeFromSuperview];
    
}

@end
