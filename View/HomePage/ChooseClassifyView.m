//
//  ChooseClassifyView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/22.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ChooseClassifyView.h"
#import "ClassifyLeftTableViewCell.h"
#import "ClassifyRightTableViewCell.h"
@implementation ChooseClassifyView
-(void)initViewWithData:(NSArray *)array{
    self.leftArr = [[NSMutableArray alloc]init];
    self.rightArr = [[NSMutableArray alloc]init];
    
    [self.leftArr addObjectsFromArray:array];
    self.leftItemTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 90, 360) style:UITableViewStylePlain];
    self.rightItemTableView = [[UITableView alloc]initWithFrame:CGRectMake(90, 0, ScreenWidth-90, 360) style:UITableViewStylePlain];
    [self.leftItemTableView registerNib:[UINib nibWithNibName:@"ClassifyLeftTableViewCell" bundle:nil] forCellReuseIdentifier:@"ClassifyLeftTableViewCell"];
       [self.rightItemTableView registerNib:[UINib nibWithNibName:@"ClassifyRightTableViewCell" bundle:nil] forCellReuseIdentifier:@"ClassifyRightTableViewCell"];
    self.leftItemTableView.delegate = self;
    self.leftItemTableView.dataSource = self;
       self.rightItemTableView.delegate = self;
    self.rightItemTableView.dataSource = self;
    self.leftItemTableView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    self.rightItemTableView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    self.leftItemTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.rightItemTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.leftItemTableView];
    [self addSubview:self.rightItemTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftItemTableView) {
        return self.leftArr.count;
    }
    return self.rightArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftItemTableView) {
        ClassifyLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassifyLeftTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        [cell initCellWithData:self.leftArr[indexPath.row]];
//        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
//        cell.titleLabel.text = [NSString stringWithFormat:@"%ld省",(long)indexPath.row];
        return cell;
    }
    ClassifyRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassifyRightTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    cell.labelGoodsName.text = self.rightArr[indexPath.row][@"name"];
//    cell.titleLabel.text = [NSString stringWithFormat:@"%ld区",(long)indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftItemTableView) {
        NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:self.leftArr[indexPath.row]];
        NSArray *array = dic[@"category"];
        [self.rightArr removeAllObjects];
        [self.rightArr addObjectsFromArray:array];
        [self.rightItemTableView reloadData];
        self.returnItemblock(indexPath.row);
    }else{
        NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:self.rightArr[indexPath.row]];
        NSString *Id = dic[@"Id"];
        NSString *str = dic[@"name"];
        self.returnMenublock(Id,str);
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
