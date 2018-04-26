//
//  SingleChooseListView.m
//  TheWorker
//
//  Created by yanghao on 8/23/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "SingleChooseListView.h"

@implementation SingleChooseListView

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
    if (itemArr.count <= 7) {
        rect.size.height = 44 * itemArr.count;
    }
    else{
        rect.size.height = 44 * 7;
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
    NSString *str = self.itemArr[indexPath.row][@"name"] ? self.itemArr[indexPath.row][@"name"] : self.itemArr[indexPath.row][@"title"];
    [itemBtn setTitle:str forState:UIControlStateNormal];
    itemBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [itemBtn setImage:[UIImage imageNamed:self.normalItemBtnImgStr] forState:UIControlStateNormal];
    [cell addSubview:itemBtn];
    
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectedBtn.enabled = NO;
    selectedBtn.tag = 999 + indexPath.row;
    selectedBtn.frame = CGRectMake(ScreenWidth - 15 - 44, 0, 44, 44);
    selectedBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [selectedBtn setImage:[UIImage imageNamed:self.selectedBtnImgStr] forState:UIControlStateNormal];
    if (indexPath.row == self.currentSelectIndex) {
        [itemBtn setTitleColor:[UIColor colorWithHexString:self.colorStr] forState:UIControlStateNormal];
        [cell addSubview:selectedBtn];
        [itemBtn setImage:[UIImage imageNamed:self.selectedItemBtnImgStr] forState:UIControlStateNormal];

    }
    else{
        [itemBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [itemBtn setImage:[UIImage imageNamed:self.normalItemBtnImgStr] forState:UIControlStateNormal];

    }
    
    
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
