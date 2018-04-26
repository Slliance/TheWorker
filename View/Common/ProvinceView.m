//
//  ProvinceCityZoneView.m
//  TheWorker
//
//  Created by yanghao on 8/29/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "ProvinceView.h"

#define row_count 8

@implementation ProvinceView

-(void)initView{
    self.provinceArr = [[NSMutableArray alloc] init];
    
    CGFloat h = row_count * 45;
    CGRect rect1 = self.provinceTableView.frame;
    rect1.origin.x = 0;
    rect1.size.width = ScreenWidth;
    rect1.size.height = h ;
    self.provinceTableView.frame = rect1;
    
    [self.provinceTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

    [self initData];
    [self.provinceTableView reloadData];
    
    self.provinceTableView.backgroundColor = [UIColor whiteColor];
}
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    if (!CGRectContainsPoint(self.provinceTableView.frame, [sender locationInView:self])) {
        [self removeFromSuperview];
        self.removeBlock();
    }
}

-(void)initData{
    NSArray *provinceArr = [[FMDBHandle sharedManager] searchDataWithSql:[NSString stringWithFormat:sql_get_city_by_code,self.code] fileName:sql_file_name];
    [self.provinceArr addObjectsFromArray:provinceArr];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.provinceArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    cell.backgroundColor = [UIColor clearColor];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor=[UIColor colorWithHexString:@"f5f5f5"];
    cell.selectedBackgroundView=view;
   [[cell.selectedBackgroundView viewWithTag:899] removeFromSuperview];
    cell.textLabel.text = self.provinceArr[indexPath.row][@"Name"];
    if (indexPath.row == self.curProvinceIndex) {
        [self.provinceTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        if (self.showIcon) {
            UILabel *icon = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 5, 15)];
            icon.backgroundColor = [UIColor colorWithHexString:self.iconColorStr];
            icon.tag = 899;
            [cell.selectedBackgroundView addSubview:icon];
        }
    }

    return cell;
    
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.curProvinceIndex = indexPath.row;
    
    self.returnBlock(self.curProvinceIndex, self.provinceArr);
    [self removeFromSuperview];

}



@end
