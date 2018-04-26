//
//  AddressBookViewController.m
//  TheWorker
//
//  Created by yanghao on 9/4/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "AddressBookViewController.h"
#import "SubLBXScanViewController.h"
#import "FriendDetailViewController.h"
#import "AddFriendViewController.h"
#import "SearchHeaderView.h"
#import "AddressBookTableViewCell.h"
#import "FriendViewModel.h"
#import "AddressBookModel.h"
#import "AddressBookFriendModel.h"
#import "SearchFriendResultViewController.h"
@interface AddressBookViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *addressBookTableView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UIView *noLoginView;
@property (nonatomic, retain) SearchHeaderView *headView;
@property (nonatomic, assign) NSInteger skipTag;
@property (nonatomic, retain) NSMutableArray *itemArr;
@property (nonatomic, retain) FriendViewModel *viewModel;
@property (nonatomic, copy) NSString *searchName;
@end

@implementation AddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemArr = [[NSMutableArray alloc] init];
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"SearchHeaderView" owner:self options:nil]firstObject];
    __weak typeof(self)weakSelf = self;
    [self.headView setReturnSearchBlock:^(NSString *name) {
        weakSelf.searchName = name;
        [weakSelf headerRefreshing];
    }];
    [weakSelf.headView initSearchViewWithState:0];
    self.addressBookTableView.tableHeaderView = self.headView;
    self.addressBookTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.addressBookTableView registerNib:[UINib nibWithNibName:@"AddressBookTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressBookTableViewCell"];
     self.addressBookTableView.sectionIndexBackgroundColor = [UIColor clearColor];// 设置默认时，索引的背景颜色
    self.addressBookTableView.sectionIndexColor = [UIColor colorWithHexString:@"666666"];
    self.addressBookTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self setupRefresh];
    

    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    if ([self isLogin]) {
        self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
            __weak typeof (self)weakSelf = self;
            self.viewModel = [[FriendViewModel alloc] init];
        
            [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
                [weakSelf.addressBookTableView.mj_header endRefreshing];
                weakSelf.addressBookTableView.hidden = NO;
                [weakSelf.itemArr removeAllObjects];
                [weakSelf.itemArr addObjectsFromArray:returnValue[0]];
                [weakSelf.headView initSearchViewWithState:returnValue[1]];
                [HYNotification postNewFrientCountUpdateNotification:@{@"count": returnValue[1]}];
                if (weakSelf.itemArr.count == 0) {
//                    self.addressBookTableView.hidden = YES;
                    weakSelf.noDataView.hidden = NO;
                    weakSelf.noLoginView.hidden = YES;
                    
                }else{
                    weakSelf.addressBookTableView.hidden = NO;
                    weakSelf.noDataView.hidden = YES;
                    weakSelf.noLoginView.hidden = YES;
                }
                
                [weakSelf.addressBookTableView reloadData];
            } WithErrorBlock:^(id errorCode) {
                [weakSelf.addressBookTableView.mj_header endRefreshing];
//                self.addressBookTableView.hidden = YES;
                [weakSelf.itemArr removeAllObjects];
                weakSelf.noDataView.hidden = NO;
                weakSelf.noLoginView.hidden = YES;
                [weakSelf showJGProgressWithMsg:errorCode];
                [weakSelf.addressBookTableView reloadData];
            }];
        [self headerRefreshing];
        
    }else{
//        if (self.skipTag == 0) {
//            [self showJGProgressWithMsg:@"登录过期，请重新登录"];
//            [self skiptoLogin];
//            self.skipTag += 1;
//        }else{
//            self.addressBookTableView.hidden = YES;
//            self.skipTag = 0;
//        }
        self.view.backgroundColor = [UIColor whiteColor];
        self.addressBookTableView.hidden = YES;
        self.noDataView.hidden = YES;
        self.noLoginView.hidden = NO;
    }

}

/**
 *  设置刷新
 */
-(void)setupRefresh
{
    self.addressBookTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    [self.addressBookTableView.mj_header beginRefreshing];
}
/**
 *  下拉刷新
 */
-(void)headerRefreshing
{
    [self.viewModel fetchMyFriendListWithToken:[self getToken] name:self.searchName];
//    [self footerRefreshing];
}
/**
 *  上拉刷新
 */
-(void)footerRefreshing
{
    [self.viewModel fetchMyFriendListWithToken:[self getToken] name:self.searchName];

}

- (IBAction)loginAction:(id)sender {
    [self skiptoLogin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)qqStyle
    {
        if (![self isLogin]) {
            [self skiptoLogin];
            return;
        }
        //设置扫码区域参数设置
        
        //创建参数对象
        LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
        
        //矩形区域中心上移，默认中心点为屏幕中心点
        style.centerUpOffset = 44;
        
        //扫码框周围4个角的类型,设置为外挂式
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
        
        //扫码框周围4个角绘制的线条宽度
        style.photoframeLineW = 6;
        
        //扫码框周围4个角的宽度
        style.photoframeAngleW = 24;
        
        //扫码框周围4个角的高度
        style.photoframeAngleH = 24;
        
        //扫码框内 动画类型 --线条上下移动
        style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
        
        //线条上下移动图片
        style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
        
        //SubLBXScanViewController继承自LBXScanViewController
        //添加一些扫码或相册结果处理
        SubLBXScanViewController *vc = [SubLBXScanViewController new];
        vc.style = style;
        vc.isPay = NO;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
- (IBAction)addFriendAction:(id)sender {
    if (![self isLogin]) {
        [self skiptoLogin];
        return;
    }
    AddFriendViewController *vc = [[AddFriendViewController alloc] init];
    NSMutableArray *muArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.itemArr.count; i ++) {
        AddressBookModel *model = self.itemArr[i];
        NSArray *array = model.friends;
        for (int j = 0; j < array.count; j ++) {
            AddressBookFriendModel *model = array[j];
            NSString *str = [NSString stringWithFormat:@"%@",model.mobile];
            [muArray addObject:str];
        }
    }
    vc.hidesBottomBarWhenPushed = YES;
    vc.friendArray = muArray;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.itemArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.itemArr.count) {
        AddressBookModel *model = self.itemArr[section];
        return model.friends.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressBookTableViewCell"];
    AddressBookModel *model = self.itemArr[indexPath.section];
    [cell initCellWithData:model.friends[indexPath.row] isHidden:1];
    return cell;
}

#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 66.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FriendDetailViewController *vc = [[FriendDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    AddressBookModel *model = self.itemArr[indexPath.section];
    AddressBookFriendModel *friendModel = model.friends[indexPath.row];
    vc.mobile = [NSString stringWithFormat:@"%@",friendModel.mobile];
    [self.navigationController pushViewController:vc animated:YES];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    backView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    AddressBookModel *model = self.itemArr[section];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth - 15, 40)];
    name.font = [UIFont systemFontOfSize:13];
    name.textColor = [UIColor colorWithHexString:@"6398f1"];
    name.text = model.letter;
    [backView addSubview:name];
    return backView;
}


//添加索引栏标题数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
//    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSMutableArray *resultArray =[NSMutableArray arrayWithObject:UITableViewIndexSearch];
//    for (AddressBookModel *model in self.itemArr) {
    NSArray *array = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
//        [resultArray addObject:model.letter];
    [resultArray addObjectsFromArray:array];
//    }
    return resultArray;
}


//点击索引栏标题时执行
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
//    这里是为了指定索引index对应的是哪个section的，默认的话直接返回index就好。其他需要定制的就针对性处理
    if ([title isEqualToString:UITableViewIndexSearch])
    {
        [tableView setContentOffset:CGPointZero animated:NO];//tabview移至顶部
        return NSNotFound;
    }
    else
    {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 添加了搜索标识
    }
}
@end
