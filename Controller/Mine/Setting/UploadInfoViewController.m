//
//  UploadInfoViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/31.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "UploadInfoViewController.h"
#import "UploadImgViewModel.h"
#import "PicModel.h"
#import "UploadModel.h"
#import "VertificationViewModel.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SettingViewController.h"
#import "HandInHandViewController.h"
#import "RentSelfViewController.h"
#define VIDEOCACHEPATH [NSTemporaryDirectory() stringByAppendingPathComponent:@"videoCache"]
@interface UploadInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate>{
    UIImagePickerController *videoPicker;
}
@property (weak, nonatomic) IBOutlet UITextView *txtCardName;
@property (weak, nonatomic) IBOutlet UIButton *btnUploadImg;
@property (weak, nonatomic) IBOutlet UIButton *btnUploadVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *show_img;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, retain) NSMutableArray *uploadArray;
@property (nonatomic, retain) NSMutableArray *uploadedArray;
@end

@implementation UploadInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnSubmit.layer.masksToBounds = YES;
    self.btnSubmit.layer.cornerRadius = 4.f;
    self.txtCardName.layer.masksToBounds = YES;
    self.txtCardName.layer.cornerRadius = 4.f;
    [self.txtCardName.layer setBorderColor:[UIColor colorWithHexString:@"e6e6e6"].CGColor];
    [self.txtCardName.layer setBorderWidth:1];
    self.uploadArray = [[NSMutableArray alloc] init];
    self.uploadedArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    
    
    [self backBtnAction:sender];
}
- (IBAction)submitAction:(id)sender {
    if (self.imgUrl.length == 0) {
        [self showJGProgressWithMsg:@"请上传身份证正面照"];
        return;
    }
    if (self.txtCardName.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入您的真实姓名"];
        return;
    }
    if (self.videoUrl.length == 0) {
        [self showJGProgressWithMsg:@"请上传视频"];
        return;
    }
    
    VertificationViewModel *viewModel = [[VertificationViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self showJGProgressWithMsg:@"认证信息提交成功，请等待审核"];
        NSInteger tag = 0;
        if (self.type == 0) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                
                if ([controller isKindOfClass:[SettingViewController class]]) {
                    SettingViewController *vc =(SettingViewController *)controller;
                    [self.navigationController popToViewController:vc animated:NO];
                }else if([controller isKindOfClass:[RentSelfViewController class]]){
                    RentSelfViewController *vc =(RentSelfViewController *)controller;
                    [self.navigationController popToViewController:vc animated:NO];
                }else if([controller isKindOfClass:[HandInHandViewController class]]){
                    for (UIViewController *conVC in self.navigationController.viewControllers) {
                        if([conVC isKindOfClass:[RentSelfViewController class]]){
                            RentSelfViewController *vc =(RentSelfViewController *)conVC;
                            [self.navigationController popToViewController:vc animated:NO];
                        }
                    }
                    HandInHandViewController *vc =(HandInHandViewController *)controller;
                    [self.navigationController popToViewController:vc animated:NO];
                }else{
                    tag = 1;
                }
            }
            if (tag == 1) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }else{
            [self backAction:nil];
        }
        
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel uploadInfomationWith:self.txtCardName.text authImg:self.imgUrl video:self.videoUrl token:[self getToken] showImg:self.show_img];
}
- (IBAction)uploadImage:(id)sender {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    //添加Button
    [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self uploadImg:UIImagePickerControllerSourceTypeCamera];
        
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"相册" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self uploadImg:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }]];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];
}
- (void)uploadImg:(UIImagePickerControllerSourceType)xtype{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = xtype;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
}
-(void)uploadImgToService:(UIImage *)img{
    __weak typeof(self) weakSelf = self;
    UploadImgViewModel *viewModel = [[UploadImgViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        PicModel *model = [returnValue firstObject];
        weakSelf.imgUrl = model.img_url;
        [self.btnUploadImg setBackgroundImage:img forState:UIControlStateNormal];
        [self dissJGProgressLoadingWithTag:200];
    } WithErrorBlock:^(id errorCode) {
        [self dissJGProgressLoadingWithTag:200];
    }];
    [viewModel uploadImgWithImage:img];
    [self showJGProgressLoadingWithTag:200];
}
- (IBAction)uploadVideo:(id)sender {
    videoPicker = [[UIImagePickerController alloc]init];
    videoPicker.view.backgroundColor = [UIColor orangeColor];
    videoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    videoPicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:videoPicker.sourceType];
    videoPicker.delegate = self;
    videoPicker.allowsEditing = YES;
  
    UIAlertController *alertController = \
    [UIAlertController alertControllerWithTitle:@""
                                        message:@"上传视频"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
//    UIAlertAction *photoAction = \
//    [UIAlertAction actionWithTitle:@"从视频库选择"
//                             style:UIAlertActionStyleDefault
//                           handler:^(UIAlertAction * _Nonnull action) {
//
//                               NSLog(@"从视频库选择");
//                               videoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                               videoPicker.mediaTypes = @[(NSString *)kUTTypeMovie];
//                               videoPicker.allowsEditing = NO;
//
//                               [self presentViewController:videoPicker animated:YES completion:nil];
//                           }];
    
    UIAlertAction *cameraAction = \
    [UIAlertAction actionWithTitle:@"录像"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * _Nonnull action) {
                               
                               NSLog(@"录像");
                               videoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                               videoPicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                               videoPicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
                               videoPicker.videoQuality = UIImagePickerControllerQualityType640x480;
                               videoPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
                               videoPicker.allowsEditing = YES;
                               
                               [self presentViewController:videoPicker animated:YES completion:nil];
                           }];
    
    UIAlertAction *cancelAction = \
    [UIAlertAction actionWithTitle:@"取消"
                             style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction * _Nonnull action) {
                               
                               NSLog(@"取消");
                           }];
    
//    [alertController addAction:photoAction];
    [alertController addAction:cameraAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

//将视频保存到缓存路径中
- (void)saveVideoFromPath:(NSString *)videoPath toCachePath:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:VIDEOCACHEPATH]) {
        
        NSLog(@"路径不存在, 创建路径");
        [fileManager createDirectoryAtPath:VIDEOCACHEPATH
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    } else {
        
        NSLog(@"路径存在");
    }
    
    NSError *error;
    [fileManager copyItemAtPath:videoPath toPath:path error:&error];
    if (error) {
        
        NSLog(@"文件保存到缓存失败");
    }
    
}
//以当前时间合成视频名称
- (NSString *)getVideoNameBaseCurrentTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter stringFromDate:[NSDate date]];
//stringByAppendingString:@".MOV"];
}
//获取视频的第一帧截图, 返回UIImage
//需要导入AVFoundation.h
- (UIImage*) getVideoPreViewImageWithPath:(NSURL *)videoPath
{
//    NSURL *paghUrl = [NSURL fileURLWithPath:videoPath];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
    
    AVAssetImageGenerator *gen         = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time      = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error   = nil;
    
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img     = [[UIImage alloc] initWithCGImage:image];
    [self.btnUploadVideo setBackgroundImage:img forState:UIControlStateNormal];
//    [self.btnUploadVideo setImage:img forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    UploadImgViewModel *viewModel = [[UploadImgViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        PicModel *model = [returnValue firstObject];
        weakSelf.show_img = model.img_url;
        [self dissJGProgressLoadingWithTag:200];
    } WithErrorBlock:^(id errorCode) {
        [self dissJGProgressLoadingWithTag:200];
    }];
    [viewModel uploadImgWithImage:img];
    [self showJGProgressLoadingWithTag:200];
    return img;
}

//上传视频
- (void)uploadImageAndMovieBaseModel:(UploadModel *)model {
    
    __weak typeof(self) weakSelf = self;
    UploadImgViewModel *viewModel = [[UploadImgViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        PicModel *model = [returnValue firstObject];
        weakSelf.videoUrl = model.img_url;
//        [self.btnUploadImg setBackgroundImage:img forState:UIControlStateNormal];
        [self dissJGProgressLoadingWithTag:200];
    } WithErrorBlock:^(id errorCode) {
        [self dissJGProgressLoadingWithTag:200];
    }];
    NSData *videoData = [NSData dataWithContentsOfFile:model.path];
    [viewModel uploadVideoWith:videoData name:model.name];
    [self showJGProgressLoadingWithTag:200];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    

//
    //获取用户选择或拍摄的是照片还是视频
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
            UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
            //    __weak typeof(self) weakSelf = self;
            [picker dismissViewControllerAnimated:YES completion:^{
        //        self.iconImageView.image = image;
                [self uploadImgToService:image];
                [self.btnUploadImg setBackgroundImage:image forState:UIControlStateNormal];
                //        [weakSelf.imageArray addObject:image];
                //        [weakSelf initScrollView];
        
            }];
    }
    
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        [picker dismissViewControllerAnimated:YES completion:^{
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                
                //如果是拍摄的视频, 则把视频保存在系统多媒体库中
                NSLog(@"video path: %@", info[UIImagePickerControllerMediaURL]);
//                NSURL *videoURL=[info objectForKey:@"UIImagePickerControllerMediaURL"];
                //[ProgressHUD show:@"转换中..."];
//                [self convertMovSourceURL:videoURL uploadModel:<#(UploadModel *)#>];
//                [picker dismissViewControllerAnimated:YES completion:nil];

                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library writeVideoAtPathToSavedPhotosAlbum:info[UIImagePickerControllerMediaURL] completionBlock:^(NSURL *assetURL, NSError *error) {

                    if (!error) {

                        NSLog(@"视频保存成功");
                    } else {

                        NSLog(@"视频保存失败");
                    }
                }];
            }

            //生成视频名称
            NSString *mediaName = [self getVideoNameBaseCurrentTime];
            NSLog(@"mediaName: %@", mediaName);

            //将视频存入缓存
            NSLog(@"将视频存入缓存");
            [self saveVideoFromPath:info[UIImagePickerControllerMediaURL] toCachePath:[VIDEOCACHEPATH stringByAppendingPathComponent:mediaName]];


            //创建uploadmodel
            UploadModel *model = [[UploadModel alloc] init];


            model.path       =        [VIDEOCACHEPATH stringByAppendingPathComponent:mediaName];
            model.name       = mediaName;
            model.type       = @"moive";
            model.isUploaded = NO;

            //将model存入待上传数组
            NSURL *videoURL=[info objectForKey:UIImagePickerControllerMediaURL];
//            [self convertMovSourceURL:videoURL uploadModel:model];
            [self getVideoPreViewImageWithPath:videoURL];
            [self uploadImageAndMovieBaseModel:model];
            [self.uploadArray addObject:model];
            
            
        }];

    }
}

/**mov转mp4格式*/
-(void)convertMovSourceURL:(NSURL *)sourceUrl uploadModel:(UploadModel *)model
{
    sourceUrl = [NSURL fileURLWithPath:model.path];
    //保存至沙盒路径
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *videoPath = [NSString stringWithFormat:@"%@/Video", pathDocuments];
    NSString *outPath  = [videoPath stringByAppendingPathComponent:model.name];
    
    //转码配置
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
    
    //AVAssetExportPresetMediumQuality可以更改，是枚举类型，官方有提供，更改该值可以改变视频的压缩比例
    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputURL = [NSURL fileURLWithPath:outPath];
    //AVFileTypeMPEG4 文件输出类型，可以更改，是枚举类型，官方有提供，更改该值也可以改变视频的压缩比例
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        int exportStatus = exportSession.status;
        NSLog(@"%d",exportStatus);
        switch (exportStatus)
        {
            case AVAssetExportSessionStatusFailed:
            {
                // log error to text view
                NSError *exportError = exportSession.error;
                NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                break;
            }
            case AVAssetExportSessionStatusCompleted:
            {
                NSLog(@"视频转码成功");
                model.path = outPath;
                NSData *data = [NSData dataWithContentsOfFile:model.path];
                [self getVideoPreViewImageWithPath:sourceUrl];
                [self uploadImageAndMovieBaseModel:model];
//                model.fileData = data;
                
                
                
            }
        }
    }];
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//
//}

@end
