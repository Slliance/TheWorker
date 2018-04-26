//
//  SingleChooseListView.m
//  TheWorker
//
//  Created by yanghao on 8/23/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "SexChooseListView.h"

@implementation SexChooseListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    if (!CGRectContainsPoint(self.itemTableView.frame, [sender locationInView:self])) {
        [self removeFromSuperview];
        self.removeBlock();
    }
}

-(void)initView:(NSArray *)itemArr{
    
    CGRect rect = self.itemTableView.frame;
    if (itemArr.count <= 6) {
        rect.size.height = 44 * itemArr.count;
    }
    else{
        rect.size.height = 44 * 6;
    }
    self.itemTableView.frame = rect;
    self.itemArr = itemArr;
    [self.itemTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.itemTableView reloadData];
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    for (UIView *subview in cell.subviews) {
        if (subview.tag >= 999 ) {
            [subview removeFromSuperview];
        }
    }
    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    itemBtn.enabled = NO;
    itemBtn.frame = CGRectMake(15, 0, 200, 44);
    itemBtn.tag = 999 + indexPath.row;
    itemBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [itemBtn setTitle:self.itemArr[indexPath.row][@"name"] forState:UIControlStateNormal];
    itemBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [itemBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [cell addSubview:itemBtn];
    
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectedBtn.enabled = NO;
    selectedBtn.tag = 999 + indexPath.row;
    selectedBtn.frame = CGRectMake(ScreenWidth - 15 - 44, 0, 44, 44);
    selectedBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [selectedBtn setImage:[UIImage imageNamed:self.selectedBtnImgStr] forState:UIControlStateNormal];
    
    switch (indexPath.row) {
        case 0:
        {
            [itemBtn setImage:[UIImage imageNamed:self.normalMaleItemBtnImgStr] forState:UIControlStateNormal];
            
        }
            break;
            
        default:{
            [itemBtn setImage:[UIImage imageNamed:self.normalFemaleItemBtnImgStr] forState:UIControlStateNormal];

        }
            break;
    }
    
    if (indexPath.row == self.currentSelectIndex && indexPath.row == 0) {
        [itemBtn setTitleColor:[UIColor colorWithHexString:self.colorStr] forState:UIControlStateNormal];
        [cell addSubview:selectedBtn];
        [itemBtn setImage:[UIImage imageNamed:self.selectedMaleItemBtnImgStr] forState:UIControlStateNormal];

    }
    else if (indexPath.row == self.currentSelectIndex && indexPath.row == 1){
        [itemBtn setTitleColor:[UIColor colorWithHexString:self.colorStr] forState:UIControlStateNormal];
        [itemBtn setImage:[UIImage imageNamed:self.selectedFeMaleItemBtnImgStr] forState:UIControlStateNormal];
        [cell addSubview:selectedBtn];

    }
    [itemBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:5.f];
    
    return cell;
    
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.currentSelectIndex = indexPath.row;
    [self.itemTableView reloadData];
    self.returnBlock(self.currentSelectIndex,self.itemArr);
    [self removeFromSuperview];

}

@end
