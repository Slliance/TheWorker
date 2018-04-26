//
//  UploadImgViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/8.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface UploadImgViewModel : BaseViewModel
-(void)uploadImgWithImage:(UIImage *)file;
-(void)uploadVideoWith:(NSData *)data name:(NSString *)name;
@end
