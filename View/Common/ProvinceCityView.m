//
//  ProvinceCityZoneView.m
//  TheWorker
//
//  Created by yanghao on 8/29/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "ProvinceCityView.h"

#define row_count 8
typedef enum{
    provinceTag = 0,
    cityTag
}tableViewTag;
@implementation ProvinceCityView

-(void)initView{
    self.provinceArr = [[NSMutableArray alloc] init];
    self.cityArr = [[NSMutableArray alloc] init];
    
    CGFloat w = 120;
    CGFloat h = row_count * 45;
    CGRect rect1 = self.provinceTableView.frame;
    rect1.origin.x = 0;
    rect1.size.width = w;
    rect1.size.height = h ;
    self.provinceTableView.frame = rect1;
    
    CGRect rect2 = self.cityTableView.frame;
    rect2.origin.x = w;
    rect2.size.width = ScreenWidth - w;
    rect2.size.height = h ;
    self.cityTableView.frame = rect2;
    
    self.provinceTableView.tag = provinceTag;
    self.cityTableView.tag = cityTag;
    
    [self.provinceTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    [self.cityTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

    [self initData];
    if (self.showAll) {
        [self.cityArr removeAllObjects];
        self.curProvinceIndex = -2;
    }
    [self.provinceTableView reloadData];
    [self.cityTableView reloadData];
    
    self.provinceTableView.backgroundColor = [UIColor whiteColor];
    self.cityTableView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
}
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    if (!CGRectContainsPoint(self.provinceTableView.frame, [sender locationInView:self]) && !CGRectContainsPoint(self.cityTableView.frame, [sender locationInView:self])) {
        [self removeFromSuperview];
        self.removeBlock();
    }
}

-(void)initData{
    [self.provinceArr removeAllObjects];
    [self.cityArr removeAllObjects];

    NSArray *provinceArr = [[FMDBHandle sharedManager] searchDataWithSql:sql_get_province fileName:sql_file_name];
    [self.provinceArr addObjectsFromArray:provinceArr];
    
    NSString *code = provinceArr[self.curProvinceIndex][@"Code"];
    
    NSArray *cityArr = [[FMDBHandle sharedManager] searchDataWithSql:[NSString stringWithFormat:sql_get_city_by_code,code] fileName:sql_file_name];

    [self.cityArr addObjectsFromArray:cityArr];
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount = 0;
    switch (tableView.tag) {
        case provinceTag:
        {
            rowCount = self.provinceArr.count;
            if (self.showAll) {
                rowCount ++ ;
            }
        }
            break;
        case cityTag:
        {
            rowCount = self.cityArr.count;
        }
            break;
            
        default:
            break;
    }
    return rowCount;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    cell.backgroundColor = [UIColor clearColor];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor=[UIColor colorWithHexString:@"f5f5f5"];
    cell.selectedBackgroundView=view;
    switch (tableView.tag) {
        case provinceTag:
        {
            if (indexPath.row == 0 && self.showAll) {
                cell.textLabel.text = @"全国";
            }
            else{

                cell.textLabel.text = self.provinceArr[indexPath.row-1][@"Name"];
                if (indexPath.row - 1 == self.curProvinceIndex) {
                        [self.provinceTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

                }
                
            }
        }
            break;
            
        case cityTag:
        {
            cell.textLabel.text = self.cityArr[indexPath.row][@"Name"];
            if (indexPath.row == self.curCityIndex) {
                [self.cityTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
            break;
            
        default:
            break;
    }
    return cell;
    
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case provinceTag:
        {
            if (indexPath.row == 0 && self.showAll) {
                self.returnBlock(-1,self.curCityIndex, self.cityArr);
                [self removeFromSuperview];
                return;
            }

            self.curProvinceIndex = indexPath.row -1;
            self.curCityIndex = 0;
            [self initData];
            [self.cityTableView reloadData];
            
        }
            break;
            
        case cityTag:
        {
            self.curCityIndex = indexPath.row;
            [self initData];
            self.returnBlock(self.curProvinceIndex,self.curCityIndex, self.cityArr);
            [self removeFromSuperview];

        }
            break;
            
        default:
            break;
    }
}



@end
