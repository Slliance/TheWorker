//
//  SetUserImgViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "SetUserImgViewController.h"
#import "RentRangeViewController.h"
#import "UploadImgViewModel.h"
#import "PicModel.h"
#import "RentViewModel.h"
#import "CropImageViewController.h"
#import "TKImageView.h"

@interface SetUserImgViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *imgBgView;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (nonatomic, assign) NSInteger imageNums;
@property (nonatomic, retain) NSMutableArray *imageUrlArray;
@property (nonatomic, copy) NSString *showImgUrl;
@property (nonatomic, assign) NSInteger status;//判断从本地显示图片(0)还是网络(1)
@end

@implementation SetUserImgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageNums = 0;
    self.imageArray = [[NSMutableArray alloc] init];
    self.imageUrlArray = [[NSMutableArray alloc] init];
    self.status = 0;
    [self.imageArray addObject:@"1"];
    [self fetchMyImage];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)fetchMyImage{
    RentViewModel *viewModel = [[RentViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        NSArray *array = returnValue[@"img"];
        [self.imageArray addObjectsFromArray:array];
        [self.imageUrlArray addObjectsFromArray:array];
        if (self.imageUrlArray.count > 0) {
            self.status = 1;
        }
        self.showImgUrl = returnValue[@"showimg"];
        [self initScrollView];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchMyImageWithToken:[self getToken]];
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)skipToNextStep:(id)sender {
    if (self.imageUrlArray.count == 0) {
        [self showJGProgressWithMsg:@"请上传个人形象照"];
        return;
    }
    
    RentViewModel *viewModel = [[RentViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        if (self.showImgUrl.length == 0) {
            self.showImgUrl = self.imageUrlArray[0];
            RentViewModel *viewModel = [[RentViewModel alloc] init];
            [viewModel setBlockWithReturnBlock:^(id returnValue) {
                
            } WithErrorBlock:^(id errorCode) {
                [self showJGProgressWithMsg:errorCode];
            }];
            
            [viewModel setShowImgWithToken:[self getToken] show_img:self.showImgUrl];
        }
        RentRangeViewController *vc = [[RentRangeViewController alloc]init];
        vc.backType = 1;
        [self.navigationController pushViewController:vc animated:YES];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel setOwnerImageWithToken:[self getToken] img:self.imageUrlArray];
    
}
-(void)chooseImgAction{
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
//    picker.allowsEditing = YES;
    picker.sourceType = xtype;
    [self presentViewController:picker animated:YES completion:^{
        
    }];

}

-(void)uploadImgToService:(UIImage *)img{
    //    __weak typeof(self) weakSelf = self;
    UploadImgViewModel *viewModel = [[UploadImgViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        PicModel *model = [returnValue firstObject];
        //        weakSelf.imgUrl = model.img_url;
        [self.imageArray addObject:img];
        [self.imageUrlArray addObject:model.img_url];
        [self initScrollView];
        //        self.iconImageView.image = img;
        [self dissJGProgressLoadingWithTag:200];
    } WithErrorBlock:^(id errorCode) {
        [self dissJGProgressLoadingWithTag:200];
    }];
    [viewModel uploadImgWithImage:img];
    [self showJGProgressLoadingWithTag:200];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
        CropImageViewController *cropImageViewController = [[CropImageViewController alloc]initWithNibName:@"CropImageViewController" bundle:nil];
        cropImageViewController.image = image;
        cropImageViewController.currentProportion = 16.0/9.0;

        [cropImageViewController setFinishBlock:^(UIImage *cropImage) {
                    [self uploadImgToService:cropImage];
        }];
        [self presentViewController:cropImageViewController animated:YES completion:nil];
//        [self.navigationController pushViewController: cropImageViewController animated: YES];

        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)initScrollView{
    
    for (UIView *subview in self.imageScrollView.subviews) {
        if (subview.tag > 800) {
            [subview removeFromSuperview];
        }
    }
    
    CGFloat w = (ScreenWidth - 40 ) / 3;
    CGFloat sw = ScreenWidth / 3;
    self.imageScrollView.contentSize = CGSizeMake(ScreenWidth, sw*(self.imageArray.count-1)/3+sw);
    
    for (int i = 0; i < self.imageArray.count; i ++) {
        if (i == 9) {
            break;
        }
        
        if (i == self.imageArray.count - 1) {
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(10*(i%3+1)+i % 3 * w, 10*(i/3+1)+i / 3 * w, w, w)];
            backview.tag = 801 + i;
            
            
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addBtn.frame = CGRectMake(0, 0, w, w);
            [addBtn setBackgroundImage:[UIImage imageNamed:@"icon_upload_picture"] forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(chooseImgAction) forControlEvents:UIControlEventTouchUpInside];
            [backview addSubview:addBtn];
            
            
            [self.imageScrollView addSubview:backview];
            
        }
        else{
            
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(10*(i%3+1)+i % 3 * w, 10*(i/3+1)+i / 3 * w, w, w)];
            backview.tag = 801 + i;
            backview.backgroundColor = [UIColor blueColor];
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, w, w )];
            if (self.status == 0) {
                [imgview setImage:self.imageArray[i+1]];
            }else{
                [imgview setImageWithString:self.imageUrlArray[i] placeHoldImageName:@"bg_no_pictures"];
//                [imgview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,self.imageUrlArray[i]]] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
            }
            
            [backview addSubview:imgview];
            
            if ([self.imageUrlArray[i] isEqualToString:self.showImgUrl]) {
                UILabel *label = [[UILabel alloc] init];
                label.frame = CGRectMake(5, 5, 30, 12);
                label.text = @"封面";
                label.font = [UIFont systemFontOfSize:10];
                label.textAlignment = NSTextAlignmentCenter;
                label.layer.masksToBounds = YES;
                label.layer.cornerRadius = 6.f;
                
                label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
                [backview addSubview:label];
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgAction:)];
            [backview addGestureRecognizer:tap];
//            [imgview setImage:self.imageArray[i + 1]];
            
            
            CGRect backRect = backview.frame;
            UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [delBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 44 - 20, 44 - 27, 0)];
            delBtn.frame = CGRectMake(backRect.origin.x + backRect.size.width - 34.f, backRect.origin.y - 15, 44, 44);
            delBtn.tag = 801 + i;
            [delBtn setImage:[UIImage imageNamed:@"icon_cancel1"] forState:UIControlStateNormal];
            [delBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.imageScrollView addSubview:backview];
            [self.imageScrollView addSubview:delBtn];
        }
        
    }
    
}

-(void)tapImgAction:(UITapGestureRecognizer *)ges{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    //添加Button
    [alertController addAction: [UIAlertAction actionWithTitle: @"设置为封面" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        RentViewModel *viewModel = [[RentViewModel alloc] init];
        NSString *imgUrl = self.imageUrlArray[ges.view.tag-801];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            //        [self fetchMyImage];
            self.showImgUrl = imgUrl;
            [self initScrollView];
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        
        [viewModel setShowImgWithToken:[self getToken] show_img:imgUrl];
        
    }]];
//    [alertController addAction: [UIAlertAction actionWithTitle: @"重新上传" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//
//
//    }]];
//
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];
}

-(void)deleteAction:(UIButton *)btn{
    [self.imageArray removeObjectAtIndex:btn.tag - 800];
    NSString *imgStr = self.imageUrlArray[btn.tag-801];
    if ([imgStr isEqualToString:self.showImgUrl]) {
        self.showImgUrl = @"";
    }
    [self.imageUrlArray removeObjectAtIndex:btn.tag - 801];
    [self initScrollView];
}

@end
