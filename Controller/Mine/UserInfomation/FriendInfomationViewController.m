//
//  FriendInfomationViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/11/8.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "FriendInfomationViewController.h"
#import "UserModel.h"
#import "UserViewModel.h"
#import "IDMPhoto.h"
#import "IDMPhotoBrowser.h"
#import "FriendViewModel.h"

@interface FriendInfomationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *constellationLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *zoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *workPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *infoScrollView;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (nonatomic, retain) UserModel *infoModel;
@end

@implementation FriendInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = 25.f;
    
    self.delBtn.layer.masksToBounds = YES;
    self.delBtn.layer.cornerRadius = 6.f;
    self.infoScrollView.contentSize = CGSizeMake(ScreenWidth, 690);
    // Do any additional setup after loading the view from its nib.
    UserViewModel *viewModel = [[UserViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        self.infoModel = returnValue;
        [self reloadView];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchFriendInfomationWithToken:[self getToken] Id:self.Id];
    
    [self.headImg setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIconAction)];
    
    [self.headImg addGestureRecognizer:tap];

    // Do any additional setup after loading the view from its nib.
}
-(void)tapIconAction{
    if (self.infoModel.headimg.length < 5) {
        return;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,self.infoModel.headimg]];
    IDMPhoto *photo = [IDMPhoto photoWithURL:url];
    
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:@[photo]];
    [self presentViewController:browser animated:YES completion:nil];
    
}
-(void)reloadView{
    [self.headImg setImageWithString:self.infoModel.headimg placeHoldImageName:placeholderImage_user_headimg];
    self.nickName.text = self.infoModel.nickname;
    if ([self.infoModel.sex intValue] == 0) {
        self.sexLabel.text = @"女";
        
    }else if ([self.infoModel.sex intValue] == 1){
        self.sexLabel.text = @"男";
        
    }else{
        
    }
    self.userId.text = [NSString stringWithFormat:@"%@",self.infoModel.user_num];
    self.constellationLabel.text = self.infoModel.constellation;
    
    if ([self.infoModel.birthday isEqualToString:@"0000-00-00"]) {
        self.ageLabel.text = @"";
    }else{
        self.ageLabel.text = self.infoModel.birthday;
    }
    
    self.jobLabel.text = self.infoModel.job;
    if (!([self.infoModel.height integerValue] == 0)) {
        self.heightLabel.text = [NSString stringWithFormat:@"%@",self.infoModel.height];
    }
    if (!([self.infoModel.zone_code integerValue] == 0)) {
        self.zoneLabel.text = [NSString stringWithFormat:@"%@",self.infoModel.city];
    }
    
    self.workPlaceLabel.text = self.infoModel.work_address;

    self.signLabel.text = self.infoModel.sign;

    if (![self.infoModel.is_friend boolValue]) {
        self.delBtn.hidden = YES;
    }
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)delAction:(id)sender {
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
            if (self.flag == 1) {
                [self backAction:nil];
            }
            else if (self.flag == 0){
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel deleteFriendWithToken:[self getToken] Id:self.Id];
        
    }];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
