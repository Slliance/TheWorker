//
//  UploadImgViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/8.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "UploadImgViewModel.h"
#import "PicModel.h"

@implementation UploadImgViewModel
//上传图片
-(void)uploadImgWithImage:(UIImage *)file  {
    [[HYNetwork sharedHYNetwork] uploadImageWithURL:url_upload_img
                                              Image:file
                                              Filed:@"img"
                                          parameter:nil
                                            success:^(NSDictionary *data) {
                                                PublicModel *publicModel = [self publicModelInitWithData:data];
                                                if ([publicModel.code integerValue] == CODE_SUCCESS) {
                                                    [self handleUploadImgWithData:publicModel];
                                                }
                                                else{
                                                    [self errorCodeWithDescribe:publicModel.message];
                                                }
                                            } fail:^(NSString *error) {
                                                [self errorCodeWithDescribe:error];
                                            }];
}


//上传图片后，处理数据，封装对象

-(void)handleUploadImgWithData:(PublicModel *)publicModel{
    //底部图片
    
    PicModel *model = [[PicModel alloc] initWithDict:publicModel.data];
    self.returnBlock(@[model]);
}

-(void)uploadVideoWith:(NSData *)data name:(NSString *)name{
    [[HYNetwork sharedHYNetwork] uploadVideoWithURL:url_upload_img video:data Filed:name parameter:nil success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleUploadImgWithData:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

@end
