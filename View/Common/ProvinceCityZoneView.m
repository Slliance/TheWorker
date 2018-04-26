//
//  ProvinceCityZoneView.m
//  TheWorker
//
//  Created by yanghao on 8/29/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "ProvinceCityZoneView.h"
#import "ZoneViewTableViewCell.h"
#define row_count 8
typedef enum{
    provinceTag = 0,
    cityTag,
    zoneTag,
}tableViewTag;
@implementation ProvinceCityZoneView

-(void)initView{
    self.provinceArr = [[NSMutableArray alloc] init];
    self.cityArr = [[NSMutableArray alloc] init];
    self.zoneArr = [[NSMutableArray alloc] init];
    
    CGFloat w = ScreenWidth / 3;
    CGFloat h = row_count * 45;
    CGRect rect1 = self.provinceTableView.frame;
    rect1.origin.x = 0;
    rect1.size.width = w;
    rect1.size.height = h ;
    self.provinceTableView.frame = rect1;
    
    CGRect rect2 = self.cityTableView.frame;
    rect2.origin.x = w;
    rect2.size.width = w;
    rect2.size.height = h ;
    self.cityTableView.frame = rect2;
    
    CGRect rect3 = self.zoneTableView.frame;
    rect3.origin.x = w * 2;
    rect3.size.width = w;
    rect3.size.height = h ;
    self.zoneTableView.frame = rect3;
    
    self.provinceTableView.tag = provinceTag;
    self.cityTableView.tag = cityTag;
    self.zoneTableView.tag = zoneTag;
    [self.provinceTableView registerNib:[UINib nibWithNibName:@"ZoneViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZoneViewTableViewCell"];
    [self.cityTableView registerNib:[UINib nibWithNibName:@"ZoneViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZoneViewTableViewCell"];
    [self.zoneTableView registerNib:[UINib nibWithNibName:@"ZoneViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZoneViewTableViewCell"];
//    [self.provinceTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ZoneViewTableViewCell"];
//
//    [self.cityTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ZoneViewTableViewCell"];
//
//    [self.zoneTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ZoneViewTableViewCell"];
    self.provinceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.zoneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.provinceTableView.showsVerticalScrollIndicator = NO;
    self.cityTableView.showsVerticalScrollIndicator = NO;
    self.zoneTableView.showsVerticalScrollIndicator = NO;
    [self initData];
    if (self.showAll) {
        [self.cityArr removeAllObjects];
        [self.zoneArr removeAllObjects];
        self.curProvinceIndex = -1;
    }
    [self.provinceTableView reloadData];
    [self.cityTableView reloadData];
    [self.zoneTableView reloadData];
    
    self.provinceTableView.backgroundColor = [UIColor whiteColor];
    self.cityTableView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    self.zoneTableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
}
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    if (!CGRectContainsPoint(self.provinceTableView.frame, [sender locationInView:self]) && !CGRectContainsPoint(self.cityTableView.frame, [sender locationInView:self]) && !CGRectContainsPoint(self.zoneTableView.frame, [sender locationInView:self])) {
        [self removeFromSuperview];
        self.removeBlock();
    }
}

-(void)initData{
    [self.provinceArr removeAllObjects];
    [self.cityArr removeAllObjects];
    [self.zoneArr removeAllObjects];

    NSArray *provinceArr = [[FMDBHandle sharedManager] searchDataWithSql:sql_get_province fileName:sql_file_name];
    [self.provinceArr addObjectsFromArray:provinceArr];
    
    NSString *code = provinceArr[self.curProvinceIndex][@"Code"];
    
    NSArray *cityArr = [[FMDBHandle sharedManager] searchDataWithSql:[NSString stringWithFormat:sql_get_city_by_code,code] fileName:sql_file_name];
    
    [self.cityArr addObjectsFromArray:cityArr];
    NSLog(@"%@====%@",@(self.curCityIndex),@(self.curProvinceIndex));
//    if (self.curProvinceIndex > 30) {
//        return;
//    }
    NSString *cityCode = cityArr[self.curCityIndex][@"Code"];
    NSArray *zoneArr = [[FMDBHandle sharedManager] searchDataWithSql:[NSString stringWithFormat:sql_get_city_by_code,cityCode] fileName:sql_file_name];

    [self.zoneArr addObjectsFromArray:zoneArr];
    
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
        case zoneTag:
        {
            
            rowCount = self.zoneArr.count;
        }
            break;
            
        default:
            break;
    }
    return rowCount;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZoneViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZoneViewTableViewCell"];
    cell.titleLabel.font = [UIFont systemFontOfSize:15];
    cell.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    cell.backgroundColor = [UIColor clearColor];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor=[UIColor colorWithHexString:@"f5f5f5"];
    cell.selectedBackgroundView=view;
    switch (tableView.tag) {
        case provinceTag:
        {
            if (indexPath.row == 0 && self.showAll) {
                cell.titleLabel.text = @"全国";
                
            }
            else{
                cell.titleLabel.text = self.provinceArr[indexPath.row - 1][@"Name"];
                if (indexPath.row - 1 == self.curProvinceIndex) {
                    [self.provinceTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                    
                }

            }
        }
            break;
            
        case cityTag:
        {
            cell.titleLabel.text = self.cityArr[indexPath.row][@"Name"];
            if (indexPath.row == self.curCityIndex) {
                [self.cityTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
            break;
            
        case zoneTag:
        {
            cell.titleLabel.text = self.zoneArr[indexPath.row][@"Name"];
            if (indexPath.row == self.curZoneIndex) {
                [self.zoneTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
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
                self.returnBlock(-1,self.curCityIndex,self.curZoneIndex, self.zoneArr);
                [self removeFromSuperview];
                return;
            }
            self.curProvinceIndex = indexPath.row-1;
            self.curCityIndex = 0;
            [self initData];
            [self.cityTableView reloadData];
            [self.zoneTableView reloadData];
            
        }
            break;
            
        case cityTag:
        {
            self.curCityIndex = indexPath.row;
            [self initData];
            [self.zoneTableView reloadData];
        }
            break;
            
        case zoneTag:
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            self.curZoneIndex = indexPath.row;
            self.returnBlock(self.curProvinceIndex,self.curCityIndex,self.curZoneIndex, self.zoneArr);
            [self removeFromSuperview];
        }
            break;
            
        default:
            break;
    }
}



@end
