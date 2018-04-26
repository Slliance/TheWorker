//
//  NotMeetViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/13.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "NotMeetViewController.h"
#import "RentViewModel.h"
#import "UploadImgViewModel.h"
#import "PicModel.h"
#import "MyRentViewModel.h"
@interface NotMeetViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UITextField *txtInput;

@property (nonatomic, assign) NSInteger imageNums;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (nonatomic, retain) NSMutableArray *imageUrlArray;
@property (nonatomic, copy) NSString *showImgUrl;
@end

@implementation NotMeetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txtInput.layer.masksToBounds = YES;
    self.txtInput.layer.cornerRadius = 4.f;
    self.imageNums = 0;
    self.imageArray = [[NSMutableArray alloc] init];
    self.imageUrlArray = [[NSMutableArray alloc] init];
    [self.imageArray addObject:@"1"];
    [self initScrollView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)submitAction:(id)sender {
    MyRentViewModel *viewModel = [[MyRentViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self backBtnAction:nil];
        self.returnBlock();
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    if (self.isUserOrRent == 1) {
        [viewModel submitDissentWithToken:[self getToken] remark:self.txtInput.text img:self.imageUrlArray Id:self.orderId];
    }else{
        [viewModel submitNoMeetWithToken:[self getToken] remark:self.txtInput.text img:self.imageUrlArray Id:self.orderId];
    }
    
    
}

- (void)chooseImageAction:(id)sender {
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
    
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    //    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        
        //        [weakSelf.imageArray addObject:image];
        //        [weakSelf initScrollView];
        [self uploadImgToService:image];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)initScrollView{
    
    for (UIView *subview in self.mainScrollView.subviews) {
        if (subview.tag > 800) {
            [subview removeFromSuperview];
        }
    }
    
    CGFloat w = (ScreenWidth - 40 ) / 3;
    CGFloat sw = ScreenWidth / 3;
    self.imageScrollView.contentSize = CGSizeMake(ScreenWidth, sw*(self.imageArray.count-1)/3+sw);
    CGRect rect = self.imageScrollView.frame;
    self.imageScrollView.frame = CGRectMake(rect.origin.x, rect.origin.y, ScreenWidth, sw*(self.imageArray.count-1)/3+sw);
    for (int i = 0; i < self.imageArray.count; i ++) {
        if (i == 9) {
            return;
        }
        
        if (i == self.imageArray.count - 1) {
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(10*(i%3+1)+i % 3 * w, 10*(i/3+1)+i / 3 * w, w, w)];
            backview.tag = 801 + i;
            
            
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addBtn.frame = CGRectMake(0, 0, w, w);
            [addBtn setBackgroundImage:[UIImage imageNamed:@"icon_upload_picture"] forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(chooseImageAction:) forControlEvents:UIControlEventTouchUpInside];
            [backview addSubview:addBtn];
            
            
            [self.imageScrollView addSubview:backview];
            
        }
        else{
            
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(10*(i%3+1)+i % 3 * w, 10*(i/3+1)+i / 3 * w, w, w)];
            backview.tag = 801 + i;
            backview.backgroundColor = [UIColor blueColor];
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, w, w )];
            [imgview setImage:self.imageArray[i+1]];
//            [imgview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,self.imageUrlArray[i]]] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
            [backview addSubview:imgview];
            if ([self.imageUrlArray[i] isEqualToString:self.showImgUrl]) {
                UILabel *label = [[UILabel alloc] init];
                label.frame = CGRectMake(0, w - 20, 50, 20);
                label.text = @"封面";
                [backview addSubview:label];
            }
            
            
            UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [delBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 44 - 30, 44 - 12, 0)];
            delBtn.frame = CGRectMake(sw - 44.f, -6, 44, 44);
            [delBtn setImage:[UIImage imageNamed:@"icon_cancel1"] forState:UIControlStateNormal];
            [delBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            [backview addSubview:delBtn];
            
            
            [self.imageScrollView addSubview:backview];
        }
    }
    self.mainScrollView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
//    CGRect rectImgView = self.imageScrollView.frame;
//    rectImgView.size.height = 30 + (self.imageArray.count - 1) / 3 * sw+sw;
//    rectImgView.origin.y = 0;
//    self.imgView.frame = rectImgView;
    CGRect rectInfo = self.infoView.frame;
    rectInfo.origin.y = 100 + (self.imageArray.count - 1) / 3 * sw+sw;;
    self.infoView.frame = rectInfo;
    CGRect rectBtn = self.btnSubmit.frame;
    rectBtn.origin.y = rectInfo.origin.y + rectInfo.size.height < ScreenHeight-55 ? rectInfo.origin.y + rectInfo.size.height + 10 : ScreenHeight-45;
    self.btnSubmit.frame = rectBtn;
    CGFloat heigth = rectBtn.origin.y + rectBtn.size.height > ScreenHeight ? rectBtn.origin.y + rectBtn.size.height : ScreenHeight;
    self.mainScrollView.contentSize = CGSizeMake(ScreenWidth, heigth);
    NSLog(@"x=%f",self.btnSubmit.frame.origin.x);
    NSLog(@"y=%f",self.btnSubmit.frame.origin.y);
    NSLog(@"w=%f",self.btnSubmit.frame.size.width);
    NSLog(@"h=%f",self.btnSubmit.frame.size.height);
}


-(void)deleteAction:(UIButton *)btn{
    [self.imageArray removeObjectAtIndex:btn.superview.tag - 800];
    [self initScrollView];
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
