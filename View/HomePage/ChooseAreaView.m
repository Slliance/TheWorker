//
//  ChooseAreaView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/21.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ChooseAreaView.h"
#import "AreaMenuTableViewCell.h"

//SQL语句
#define select_province  @"select * from addr_position where pcode=0"
#define select_city_by_province  @"select * from addr_position where pcode=%@"
#define select_zone_by_province  @"select * from addr_position where pcode=%@"

@implementation ChooseAreaView

-(void)initViewWithData{
    FMDBHandle *handle = [FMDBHandle sharedManager];
    
    [handle copySqliteFileToDocmentWithFileName:sql_file_name];

    self.leftItemTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/3, 360) style:UITableViewStylePlain];
    self.middleItemTableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth/3, 0, ScreenWidth/3, 360) style:UITableViewStylePlain];
    self.rightItemTableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth*2/3, 0, ScreenWidth/3, 360) style:UITableViewStylePlain];
    [self.leftItemTableView registerNib:[UINib nibWithNibName:@"AreaMenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"AreaMenuTableViewCell"];
    [self.middleItemTableView registerNib:[UINib nibWithNibName:@"AreaMenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"AreaMenuTableViewCell"];
    [self.rightItemTableView registerNib:[UINib nibWithNibName:@"AreaMenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"AreaMenuTableViewCell"];
    self.leftItemTableView.delegate = self;
    self.leftItemTableView.dataSource = self;
    self.middleItemTableView.delegate = self;
    self.middleItemTableView.dataSource = self;
    self.rightItemTableView.delegate = self;
    self.rightItemTableView.dataSource = self;
    [self addSubview:self.leftItemTableView];
    [self addSubview:self.middleItemTableView];
    [self addSubview:self.rightItemTableView];
    self.provinceArr = [[FMDBHandle sharedManager] searchDataWithSql:select_province fileName:sql_file_name];
    self.cityArr = [[FMDBHandle sharedManager] searchDataWithSql:[NSString stringWithFormat:select_city_by_province,[self.provinceArr[0] objectForKey:@"Code"]] fileName:sql_file_name];
    self.zoneArr = [[FMDBHandle sharedManager] searchDataWithSql:[NSString stringWithFormat:select_city_by_province,[self.cityArr[0] objectForKey:@"Code"]] fileName:sql_file_name];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftItemTableView) {
        return self.provinceArr.count;
    }else if (tableView == self.middleItemTableView){
        return self.cityArr.count;
    }
    return self.zoneArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftItemTableView) {
        AreaMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AreaMenuTableViewCell"];
        
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",self.provinceArr[indexPath.row][@"Name"]];
        return cell;
    }else if (tableView == self.middleItemTableView){
        AreaMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AreaMenuTableViewCell"];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",self.cityArr[indexPath.row][@"Name"]];
        return cell;
    }
    AreaMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AreaMenuTableViewCell"];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",self.zoneArr[indexPath.row][@"Name"]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftItemTableView) {
        self.returnMenublock(0);
//        self.returnItemblock(self.provinceArr[indexPath.row][@"Name"]);
        self.cityArr = [[FMDBHandle sharedManager] searchDataWithSql:[NSString stringWithFormat:select_city_by_province,[self.provinceArr[indexPath.row] objectForKey:@"Code"]] fileName:sql_file_name];
        [self.middleItemTableView reloadData];
    }else if (tableView == self.middleItemTableView){
        self.returnMenublock(1);
//        self.returnItemblock(self.cityArr[indexPath.row][@"Name"]);
        self.zoneArr = [[FMDBHandle sharedManager] searchDataWithSql:[NSString stringWithFormat:select_city_by_province,[self.cityArr[indexPath.row] objectForKey:@"Code"]] fileName:sql_file_name];
        [self.rightItemTableView reloadData];
    }else{
        self.returnMenublock(2);
        self.returnItemblock(self.zoneArr[indexPath.row][@"Name"]);
    }
    

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
