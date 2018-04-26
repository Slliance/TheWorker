//
//  IdentityVerificationViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/31.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "IdentityVerificationViewController.h"
#import "VertificationViewModel.h"
#import "AuthModel.h"
#import "RentSelfViewController.h"
#import "UIButton+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface IdentityVerificationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIImageView *imageVerification;
@property (weak, nonatomic) IBOutlet UIImageView *imageIDCard;
@property (weak, nonatomic) IBOutlet UIButton *btnRent;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIScrollView *authScrollView;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, retain) MPMoviePlayerViewController *playerVc;
@property (nonatomic, retain) AVPlayer *player;
@end

@implementation IdentityVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    VertificationViewModel *viewModel = [[VertificationViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        AuthModel *model = returnValue;
        self.labelName.text = model.name;
        [self.imageIDCard setImageWithString:model.auth_img placeHoldImageName:@"bg_no_pictures"];
        self.videoUrl = model.video;
        [self.btnPlay sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,model.show_img]] forState:UIControlStateNormal];
//        [self.imageIDCard setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,model.auth_img]] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchUserAuthInfomationWithToken:[self getToken]];
    self.authScrollView.contentSize = CGSizeMake(ScreenWidth, 603);
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)skipToLive:(id)sender {
}
- (IBAction)skipToRent:(id)sender {
    RentSelfViewController *vc = [[RentSelfViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)playVideo:(id)sender {
//    AVPlayer *player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,self.videoUrl]]];
//    [player play];
//    MPMoviePlayerViewController
    [self presentMoviePlayerViewControllerAnimated:self.playerVc];
//    [self.player play];
}

#pragma mark - 懒加载
- (MPMoviePlayerViewController *)playerVc
{
    if (_playerVc == nil) {
        
        _playerVc = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,self.videoUrl]]];
    }
    return _playerVc;
    
}
#pragma mark - 懒加载代码
- (AVPlayer *)player
{
    if (_player == nil) {
        // 1.获取URL(远程/本地)
        // NSURL *url = [[NSBundle mainBundle] URLForResource:@"01-知识回顾.mp4" withExtension:nil];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,self.videoUrl]];
        
        // 2.创建AVPlayerItem
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
        
        // 3.创建AVPlayer
        _player = [AVPlayer playerWithPlayerItem:item];
        
        // 4.添加AVPlayerLayer
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        layer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
        [self.view.layer addSublayer:layer];
    }
    return _player;
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
