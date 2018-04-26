//
//  AddFriendViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/20.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "AddFriendViewController.h"
#import "SearchFriendResultViewController.h"
#import "OnlySearchHeadView.h"
#import "MobileFriendTableViewCell.h"
#import "FriendViewModel.h"
#import "RentPersonViewModel.h"
#import "FriendModel.h"
#import <Contacts/Contacts.h>
@interface AddFriendViewController ()
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIView *mobileView;

@property (nonatomic, retain) OnlySearchHeadView *headView;
@property (nonatomic, retain) FriendViewModel *viewModel;
@property (nonatomic, retain) NSMutableArray *itemArr;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, retain) NSMutableArray *addressBookArr;
@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemArr = [[NSMutableArray alloc] init];
    self.addressBookArr = [[NSMutableArray alloc] init];
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"OnlySearchHeadView" owner:self options:nil]firstObject];
    [self.headView initSearchViewWithType:0];
    __weak typeof(self)weakSelf = self;
    [self.headView setReturnSearchBlock:^(NSString *name) {
        SearchFriendResultViewController *vc = [[SearchFriendResultViewController alloc] init];
//        vc.searchKey = name;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    self.itemTableView.tableHeaderView = self.headView;
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.itemTableView registerNib:[UINib nibWithNibName:@"MobileFriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"MobileFriendTableViewCell"];
    // Do any additional setup after loading the view from its nib.
    

    
}


- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)addFriendFromMobile:(id)sender {
    self.mobileView.hidden = YES;
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (authorizationStatus == CNAuthorizationStatusAuthorized) {
        NSLog(@"没有授权...");
    }
    
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
        
        NSString *nameStr = [NSString stringWithFormat:@"%@%@",familyName,givenName];
        FriendModel *model = [[FriendModel alloc] init];
        model.nickname = nameStr;
        NSArray *phoneNumbers = contact.phoneNumbers;
        for (CNLabeledValue *labelValue in phoneNumbers) {
//            NSString *label = labelValue.label;
            CNPhoneNumber *phoneNumber = labelValue.value;
            NSString *str = [NSString stringWithFormat:@"%@",phoneNumber.stringValue];
            NSString *mobileStr = [str stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            mobileStr = [mobileStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
            mobileStr = [mobileStr stringByReplacingOccurrencesOfString:@" " withString:@""];//汉字空格
            mobileStr = [mobileStr stringByReplacingOccurrencesOfString:@" " withString:@""];//英式空格
            model.mobile = mobileStr;
        }
        [self.addressBookArr addObject:model];
        //        *stop = YES;  // 停止循环，相当于break；
    }];
    [self.itemArr removeAllObjects];
//    [self.itemArr addObjectsFromArray:self.addressBookArr];
    
    for (int j = 0; j < self.addressBookArr.count; j ++) {
        FriendModel *model = self.addressBookArr[j];
        model.status = @(1);
        for (int i = 0; i < self.friendArray.count; i ++) {
            if ([model.mobile isEqualToString: self.friendArray[i]]) {
                model.status = @(2);
                NSLog(@"%@ =? %@",self.friendArray[i],model.mobile);
            }
        }
        if (model.mobile.length != 0) {
            [self.itemArr addObject:model];
        }
    }
    NSLog(@"%ld",(long)self.friendArray.count);
    NSLog(@"%ld",(long)self.addressBookArr.count);
    NSLog(@"%@",self.itemArr);
    [self.itemTableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MobileFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MobileFriendTableViewCell"];
    [cell initCellWithData:self.itemArr[indexPath.row]];
    [cell setReturnAddBlcok:^(NSString *uid) {
        FriendViewModel *viewModel = [[FriendViewModel alloc] init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [self showJGProgressWithMsg:@"好友请求已发送"];
//            [self headerRefreshing];
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        FriendModel *model = self.itemArr[indexPath.row];
        [viewModel addFriendWithToken:[self getToken] mobile:model.mobile];
    }];
    return cell;
}

#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 66.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
