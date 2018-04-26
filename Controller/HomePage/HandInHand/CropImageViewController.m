//
//  CropImageViewController.m
//  ImageTailor
//
//  Created by yinyu on 15/10/10.
//  Copyright © 2015年 yinyu. All rights reserved.
//

#import "CropImageViewController.h"

#import "TKImageView.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define CROP_PROPORTION_IMAGE_WIDTH 30.0f
#define CROP_PROPORTION_IMAGE_SPACE 48.0f
#define CROP_PROPORTION_IMAGE_PADDING 20.0f

@interface CropImageViewController () {
    
    NSArray *proportionImageNameArr;
    NSArray *proportionImageNameHLArr;
    NSArray *proportionArr;
    NSMutableArray *proportionBtnArr;

}
@property (weak, nonatomic) IBOutlet UIScrollView *cropProportionScrollView;
@property (weak, nonatomic) IBOutlet TKImageView *tkImageView;

@end

@implementation CropImageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUpTKImageView];
//    [self setUpCropProportionView];
//    [self clickProportionBtn: proportionBtnArr[0]];
    _tkImageView.cropAspectRatio = self.currentProportion;

}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}
- (void)setUpTKImageView {
    
    _tkImageView.toCropImage = _image;
    _tkImageView.showMidLines = YES;
    _tkImageView.needScaleCrop = YES;
    _tkImageView.showCrossLines = YES;
    _tkImageView.cornerBorderInImage = NO;
    _tkImageView.cropAreaCornerWidth = 44;
    _tkImageView.cropAreaCornerHeight = 44;
    _tkImageView.minSpace = 30;
    _tkImageView.cropAreaCornerLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaBorderLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCornerLineWidth = 4;
    _tkImageView.cropAreaBorderLineWidth = 1;
    _tkImageView.cropAreaMidLineWidth = 20;
    _tkImageView.cropAreaMidLineHeight = 0;
    _tkImageView.cropAreaMidLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCrossLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCrossLineWidth = 1;
    _tkImageView.initialScaleFactor = .5f;
    
}

#pragma mark - IBActions
- (IBAction)clickCancelBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
//    [self.navigationController popViewControllerAnimated: YES];
    
}
- (IBAction)clickOkBtn:(id)sender {
    
//    CropResultViewController *cropResultViewController = [[CropResultViewController alloc] initWithNibName: @"CropResultViewController" bundle: nil];
//    cropResultViewController.cropResultImage = [_tkImageView currentCroppedImage];
//    [self.navigationController pushViewController: cropResultViewController animated: YES];
    self.finishBlock([_tkImageView currentCroppedImage]);
    [self clickCancelBtn:nil];
}
@end
