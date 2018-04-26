//
//  MyQrViewController.m
//  TheWorker
//
//  Created by yanghao on 9/2/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "MyQrViewController.h"
#import "UserModel.h"
@interface MyQrViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIImageView *imgQr;
@property (weak, nonatomic) IBOutlet UIImageView *imgSex;

@end

@implementation MyQrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = 30.f;
    NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    UserModel *userModel = [[UserModel alloc] initWithDict:userinfo];

    self.labelName.text = userModel.nickname;
    [self.headImgView setImageWithString:userModel.headimg placeHoldImageName:@"icon_personal_center_default_avatar"];
//    [self.headImgView setImageWithURL:[NSURL URLWithString:userModel.headimg] placeholderImage:[UIImage imageNamed:@"icon_personal_center_default_avatar"]];
    if ([userModel.sex integerValue] == 0) {
        [self.imgSex setImage:[UIImage imageNamed:@"icon_gules_female_sex"]];
    }
    else if ([userModel.sex integerValue] == 1) {
        [self.imgSex setImage:[UIImage imageNamed:@"icon_gules_male_sex"]];
    }
    else{
        self.imgSex.hidden = YES;
    }
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];

    NSString *codestr = @"%@";
    NSData *data = [[NSString stringWithFormat:codestr,userModel.share] dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"InputMessage"];
    CIImage *ciImage = [filter outputImage];
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:ciImage withSize:130];
    
    self.imgQr.image = image;

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}



- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    //设置比例
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap（位图）;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
    
}


@end
