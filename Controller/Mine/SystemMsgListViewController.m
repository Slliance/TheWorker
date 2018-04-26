//
//  SystemMsgListViewController.m
//  jishikangUser
//
//  Created by yanghao on 6/30/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "SystemMsgListViewController.h"
#import "TimeHeadView.h"

#import "SystemMsgTextListCell.h"
#import "MessageViewModel.h"
#import "MJRefresh.h"
#import "UserModel.h"
#import "SystemMsgModel.h"
@interface SystemMsgListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (nonatomic, assign) NSInteger     pageIndex;
@property (nonatomic, retain) NSMutableArray *itemArr;
@property (nonatomic, retain) MessageViewModel *viewModel;
@end

@implementation SystemMsgListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.itemArr = [[NSMutableArray alloc] init];

    [self.itemTableView registerNib:[UINib nibWithNibName:@"SystemMsgTextListCell" bundle:nil] forCellReuseIdentifier:@"SystemMsgTextListCell"];
    __weak typeof (self)weakSelf = self;
    self.viewModel = [[MessageViewModel alloc] init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        [weakSelf.itemArr addObjectsFromArray:returnValue];
        [weakSelf.itemTableView reloadData];
        if (self.pageIndex == 1) {
            [weakSelf.itemTableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
        if (self.pageIndex == 1) {
            [weakSelf.itemTableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
        if ([returnValue count]<10) {
            [weakSelf.itemTableView.mj_footer removeFromSuperview];
        }

    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
        if (self.pageIndex == 1) {
            [weakSelf.itemTableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.itemTableView.mj_footer endRefreshing];
        }
    }];
    
    [self setupRefresh];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    [self backBtnAction:nil];
}
/**
 *  设置刷新
 */
-(void)setupRefresh
{
    self.itemTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    self.itemTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    [self.itemTableView.mj_header beginRefreshing];
    
}
/**
 *  下拉刷新
 */
-(void)headerRefreshing
{
    self.pageIndex = 0;
    [self.itemArr removeAllObjects];
    [self.itemTableView reloadData];
    [self footerRefreshing];
}
/**
 *  上拉刷新
 */
-(void)footerRefreshing
{
    [self.viewModel fetchMsg:++ self.pageIndex token:[self getToken]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SystemMsgTextListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystemMsgTextListCell" forIndexPath:indexPath];
    [cell initCell:self.itemArr[indexPath.section]];
    
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGR:)];
    //    设定最小的长按时间 按不够这个时间不响应手势
    [cell addGestureRecognizer:longPressGR];
    longPressGR.view.tag = indexPath.section;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SystemMsgModel *model = self.itemArr[indexPath.section];
    CGSize size = [model.content sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ScreenWidth - 36, 3000)];
    return size.height + 50.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TimeHeadView *headview = [[[NSBundle mainBundle] loadNibNamed:@"TimeHeadView" owner:self options:nil] firstObject];
    headview.labelTime.layer.masksToBounds = YES;
    headview.labelTime.layer.cornerRadius = 4.f;
    SystemMsgModel *model = self.itemArr[section];
    headview.labelTime.text = [model.createtime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    return headview;
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


-(void)longPressGR:(UILongPressGestureRecognizer *)lpGR{
    
    if(lpGR.state==UIGestureRecognizerStateBegan){
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"提示"                                                                             message: @""                                                                           preferredStyle:UIAlertControllerStyleAlert];
        //修改title
        NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"提示"];
        [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1d1d1d"] range:NSMakeRange(0, 2)];
        [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 2)];
        [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
        
        //修改message
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"是否删除消息!"];
        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(0, 7)];
        [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 7)];
        [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
        
        //添加Button
        UIAlertAction *okAction = [UIAlertAction actionWithTitle: @"确认" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
            UserModel *userModel = [[UserModel alloc]initWithDict:userinfo];
            //获取目标cell
            NSInteger section=lpGR.view.tag;
            MessageViewModel *viewModel = [[MessageViewModel alloc]init];
            [viewModel setBlockWithReturnBlock:^(id returnValue) {
                //删除操作
                [self.itemArr removeObjectAtIndex:section];
                [self.itemTableView reloadData];
                [self showJGProgressWithMsg:@"删除成功"];
            } WithErrorBlock:^(id errorCode) {
                
            }];
            SystemMsgModel *model = self.itemArr[section];
            [viewModel delMessageWithId:model.Id token:userModel.token];
            
        }];
        
        UIAlertAction *cancelAction =  [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil];
        
        [cancelAction setValue:[UIColor colorWithHexString:@"999999"] forKey:@"titleTextColor"];
        [okAction setValue:[UIColor colorWithHexString:@"26bc54"] forKey:@"titleTextColor"];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController: alertController animated: YES completion: nil];
        
    }
}

@end
