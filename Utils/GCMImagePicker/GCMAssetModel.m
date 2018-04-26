//
//  GCMAssetModel.m
//  SelectMediumFile
//
//  Created by macavilang on 16/6/28.
//  Copyright © 2016年 Snoopy. All rights reserved.
//

#import "GCMAssetModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@implementation GCMAssetModel

- (void)originalImage:(void (^)(UIImage *))returnImage{
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    [lib assetForURL:self.imageURL resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *rep = asset.defaultRepresentation;
        CGImageRef imageRef = rep.fullResolutionImage;
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:rep.scale orientation:(UIImageOrientation)rep.orientation];
        if (image) {
            returnImage(image);
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void) convertVideoWithModel:(GCMAssetModel *) model
{
    
    [self creatSandBoxFilePathIfNoExist];
    //保存至沙盒路径
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *videoPath = [NSString stringWithFormat:@"%@/Video", pathDocuments];
    model.sandboxPath = [videoPath stringByAppendingPathComponent:model.fileName];
    
    //转码配置
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:model.imageURL options:nil];
    
    //AVAssetExportPresetMediumQuality可以更改，是枚举类型，官方有提供，更改该值可以改变视频的压缩比例
    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputURL = [NSURL fileURLWithPath:model.sandboxPath];
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
                NSData *data = [NSData dataWithContentsOfFile:model.sandboxPath];
                model.fileData = data;
                
                
                //创建AFHTTPSessionManager
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                
                //设置响应文件类型为JSON类型
                manager.responseSerializer    = [AFJSONResponseSerializer serializer];
                
                //初始化requestSerializer
                manager.requestSerializer     = [AFHTTPRequestSerializer serializer];
                
                manager.responseSerializer.acceptableContentTypes = nil;
                
                //设置timeout
                [manager.requestSerializer setTimeoutInterval:20.0];
                
                //设置请求头类型
                [manager.requestSerializer setValue:@"form/data" forHTTPHeaderField:@"Content-Type"];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                //设置请求头, 授权码
                //    [manager.requestSerializer setValue:@"YgAhCMxEehT4N/DmhKkA/M0npN3KO0X8PMrNl17+hogw944GDGpzvypteMemdWb9nlzz7mk1jBa/0fpOtxeZUA==" forHTTPHeaderField:@"Authentication"];
                
                //上传服务器接口
                NSString *url = [NSString stringWithFormat:@"http://47.92.83.233:3389/index.php/index/index/uploadImg"];
                
                //开始上传
                [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    //        NSError *error;
                    //        NSURL *videoURL = [NSURL fileURLWithPath:model.path];
                    //        NSLog(@"videoUrl%@",videoURL);
                    NSData *videoData = [NSData dataWithContentsOfFile:model.path];
                    //        [NSData dataWithContentsOfURL:videoURL];
                    //            NSLog(@"videoData%@",videoData);
                    //            NSData *videoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.path]];
                    //            NSLog(@"***%@",videoData);
                    [formData appendPartWithFileData:videoData name:model.name fileName:model.name mimeType:@"video/mp4"];
                    //        BOOL success = [formData appendPartWithFileURL:[NSURL fileURLWithPath:model.path] name:model.name fileName:model.name mimeType:mimeType error:&error];
                    
                    
                    //        if (!success) {
                    //
                    //            NSLog(@"appendPartWithFileURL error: %@", error);
                    //        }
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                    NSLog(@"上传进度: %f", uploadProgress.fractionCompleted);
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    NSLog(@"成功返回: %@", responseObject);
                    model.isUploaded = YES;
                    [self.uploadedArray addObject:model];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    NSLog(@"上传失败: %@", error);
                    model.isUploaded = NO;
                }];
            }
        }
    }];
    
}


- (void)creatSandBoxFilePathIfNoExist
{
    //沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSLog(@"databse--->%@",documentDirectory);
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //创建目录
    NSString *createPath = [NSString stringWithFormat:@"%@/Video", pathDocuments];
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"FileImage is exists.");
    }
}

@end
