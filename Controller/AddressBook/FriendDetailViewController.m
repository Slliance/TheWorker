//
//  FriendDetailViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/20.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "MyStateViewController.h"
#import "FriendViewModel.h"
#import "RentPersonViewModel.h"
#import <NIMSDK/NIMSDK.h>
#import "NTESSessionViewController.h"
#import "FriendInfomationViewController.h"
#import "JMDropMenu.h"

@interface FriendDetailViewController ()<UITextFieldDelegate,JMDropMenuDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IdLabel;
@property (weak, nonatomic) IBOutlet UITextField *txtRemark;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnSendMsg;
@property (weak, nonatomic) IBOutlet UIButton *btnAddFriend;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@property (weak, nonatomic) IBOutlet UIView *stateView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (nonatomic, retain) AddressBookFriendModel *friendModel;
@property (nonatomic,readonly) NSMutableArray * recentSessions;
/** titleArr */
@property (nonatomic, strong) NSArray *titleArr;
/** imgArr */
@property (nonatomic, strong) NSArray *imageArr;

@end

@implementation FriendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnAddFriend.hidden = YES;
    self.btnAddFriend.layer.cornerRadius = 4.f;
    self.btnAddFriend.layer.masksToBounds = YES;
    self.btnDelete.layer.cornerRadius = 4.f;
    self.btnDelete.layer.masksToBounds = YES;
    self.btnSendMsg.layer.cornerRadius = 4.f;
    self.btnSendMsg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = 30.f;
    self.headImg.layer.masksToBounds = YES;
    self.txtRemark.returnKeyType = UIReturnKeyDone;
    
    self.friendModel = [[AddressBookFriendModel alloc] init];
    FriendViewModel *viewModel = [[FriendViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        self.friendModel = returnValue;
//        if (!self.status) {
            self.status = [self.friendModel.status integerValue];
//        }
        
        [self.headImg setImageWithString:self.friendModel.headimg placeHoldImageName:placeholderImage_user_headimg];
//        [self.headImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,self.friendModel.headimg]] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
        self.nameLabel.text = self.friendModel.nickname;
        self.IdLabel.text = [NSString stringWithFormat:@"ID：%@",self.friendModel.user_num];
        if (self.status == 0) {
            self.btnDelete.hidden = YES;
            self.btnMore.hidden = self.btnDelete.hidden;
            self.btnSendMsg.hidden = YES;
            self.btnAddFriend.hidden = NO;
            self.stateView.hidden = YES;
//            self.txtRemark.enabled = NO;
            self.titleLabel.text = @"详情";
        }else if (self.status == 1){
            [self.btnDelete setTitle:@"删除好友" forState:UIControlStateNormal];
            [self.btnSendMsg setTitle:@"发消息" forState:UIControlStateNormal];
            self.stateView.hidden = NO;
            self.titleLabel.text = @"好友详情";
        }
        self.txtRemark.text = self.friendModel.remark;

    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    if (self.mobile) {
        [viewModel fetchFriendInfomationWithToken:[self getToken] mobile:self.mobile];
    }
    else if (self.uid){
        [viewModel fetchFriendInfomationWithToken:[self getToken] Id:self.uid];
    }
    self.titleArr = @[@"删除好友"];
    self.imageArr = @[@"img1"];

    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)skipToInfomationVC:(id)sender {
    FriendInfomationViewController *vc = [[FriendInfomationViewController alloc] init];
    vc.Id = self.friendModel.Id;
    vc.flag = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)skipToHisState:(id)sender {
    MyStateViewController *vc = [[MyStateViewController alloc] init];
    vc.uid = [NSString stringWithFormat:@"%@",self.friendModel.Id];
    vc.name = self.friendModel.nickname;
    vc.image = self.friendModel.headimg;
    vc.mobile = self.friendModel.mobile;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)sendMessage:(id)sender {
    NIMSession *session = [NIMSession session:self.mobile type:NIMSessionTypeP2P];
    NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)deleteFriend:(id)sender {
 
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"确定删除好友？"
                                                                      preferredStyle:UIAlertControllerStyleAlert ];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FriendViewModel *viewModel = [[FriendViewModel alloc] init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
//            self.btnDelete.hidden = YES;
//            self.btnSendMsg.hidden = YES;
//            self.btnAddFriend.hidden = NO;
//            self.stateView.hidden = YES;
            
            
//            _recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
//            for (NIMRecentSession *ss in _recentSessions) {
//                if ([ss.session.sessionId isEqualToString:[NSString stringWithFormat:@"%@",self.friendModel.mobile]]) {
//                    id<NIMConversationManager> manager = [[NIMSDK sharedSDK] conversationManager];
//                    [manager deleteRecentSession:ss];
//                    break;
//                }
//            }

            [self backAction:nil];
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel deleteFriendWithToken:[self getToken] Id:[NSString stringWithFormat:@"%@",self.friendModel.Id]];

    }];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];

}
- (IBAction)moreAction:(id)sender {
    [JMDropMenu showDropMenuFrame:CGRectMake(self.view.frame.size.width - 118, 64, 110, 48) ArrowOffset:90.f TitleArr:self.titleArr ImageArr:self.imageArr Type:JMDropMenuTypeQQ LayoutType:JMDropMenuLayoutTypeNormal RowHeight:40.f Delegate:self];

}
- (IBAction)addFriend:(id)sender {
    if (self.applyId) {
        FriendViewModel *viewModel = [[FriendViewModel alloc] init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            self.btnDelete.hidden = NO;
            self.btnMore.hidden = self.btnDelete.hidden;
            self.btnSendMsg.hidden = NO;
            self.btnAddFriend.hidden = YES;
            self.stateView.hidden = NO;
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel handleFriendApplyWithToken:[self getToken] Id:self.applyId type:@(1)];
    }else{
        RentPersonViewModel *viewModel = [[RentPersonViewModel alloc] init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
//            self.btnDelete.hidden = NO;
//            self.btnSendMsg.hidden = NO;
//            self.btnAddFriend.hidden = YES;
//            self.stateView.hidden = YES;
            [self showJGProgressWithMsg:@"好友请求已发送"];
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel addFriendWithToken:[self getToken] Id:[NSString stringWithFormat:@"%@",self.friendModel.Id]];
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.status == 0) {
        [self showJGProgressWithMsg:@"未添加好友不能设置备注"];
        [textField resignFirstResponder];
        return;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    if (textField.text.length > 0) {
        FriendViewModel *viewModel = [[FriendViewModel alloc] init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [self.txtRemark resignFirstResponder];
            [self showJGProgressWithMsg:@"修改成功"];
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel setRemarkWithToken:[self getToken] Id:[NSString stringWithFormat:@"%@",self.friendModel.Id] remark:textField.text];
//    }else{
//        [textField resignFirstResponder];
//    }
    
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.txtRemark resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)didSelectRowAtIndex:(NSInteger)index Title:(NSString *)title Image:(NSString *)image {
    NSLog(@"index----%zd,  title---%@, image---%@", index, title, image);
    [self deleteFriend:nil];
}

@end
