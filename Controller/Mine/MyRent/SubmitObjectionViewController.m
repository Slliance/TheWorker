//
//  SubmitObjectionViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/18.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "SubmitObjectionViewController.h"
#import "RentViewModel.h"
#import "UploadImgViewModel.h"
#import "PicModel.h"
#import "MyRentViewModel.h"
@interface SubmitObjectionViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UITextView *txtInputView;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIView *imgBgView;

@property (nonatomic, assign) NSInteger imageNums;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (nonatomic, retain) NSMutableArray *imageUrlArray;

@end

@implementation SubmitObjectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txtInputView.layer.masksToBounds = YES;
    self.txtInputView.layer.cornerRadius = 4.f;
    self.txtInputView.returnKeyType = UIReturnKeyDone;
    self.imageNums = 0;
    self.imageArray = [[NSMutableArray alloc] init];
    self.imageUrlArray = [[NSMutableArray alloc] init];
    [self.imageArray addObject:@"1"];
    int i = 0;
    CGFloat w = (ScreenWidth - 40 ) / 3;
    CGFloat sw = ScreenWidth / 3;
    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(10*(i%3+1)+i % 3 * w, 10*(i/3+1)+i / 3 * w, w, w)];
    backview.tag = 801 + i;
    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, w, w);
    [addBtn setBackgroundImage:[UIImage imageNamed:@"icon_upload_picture"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(chooseImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:addBtn];
    [self.imageScrollView addSubview:backview];
    
    self.imageScrollView.contentSize = CGSizeMake(ScreenWidth, sw*(self.imageArray.count-1)/3+sw);
    CGRect rect = self.imageScrollView.frame;
    rect.size.height = sw*(self.imageArray.count-1)/3+sw + 30;
    self.imageScrollView.frame = rect;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesBegan:withEvent:)];
    [self.mainScrollView addGestureRecognizer:tapGR];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)submitAction:(id)sender {
    
    if (self.txtInputView.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入内容"];
        return;
    }
    MyRentViewModel *viewModel = [[MyRentViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self backBtnAction:nil];
        self.returnBlock();
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    if (self.isUserOrRent == 1) {
        [viewModel submitDissentWithToken:[self getToken] remark:self.txtInputView.text img:self.imageUrlArray Id:self.orderId];
    }else{
        [viewModel submitNoMeetWithToken:[self getToken] remark:self.txtInputView.text img:self.imageUrlArray Id:self.orderId];
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
        [self.imageUrlArray addObject:model.img_url];
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
        __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [weakSelf.imageArray addObject:image];
        [weakSelf initScrollView];
        [self uploadImgToService:image];
        
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
    CGRect rectImg = self.imgBgView.frame;
    rectImg.size.height = (self.imageArray.count-1)/3 * (sw+20) + sw + 30;
    if (rectImg.size.height < 180) {
        rectImg.size.height = 180;
    }
    self.imgBgView.frame = rectImg;
    CGRect rect = self.imageScrollView.frame;
    rect.size.height = (self.imageArray.count-1)/3 * (sw+20) + sw;
    NSLog(@"%f",rect.size.height);
    self.imageScrollView.frame = rect;
    
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
//            [addBtn setBackgroundColor:[UIColor greenColor]];
            [backview addSubview:addBtn];
            
            
            [self.imageScrollView addSubview:backview];
            
        }
        else{
            
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(10*(i%3+1)+i % 3 * w, 10*(i/3+1)+i / 3 * w, w, w)];
            backview.tag = 801 + i;
            backview.backgroundColor = [UIColor blueColor];
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, w, w )];
            [imgview setImage:self.imageArray[i+1]];
            [backview addSubview:imgview];
            
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
    
    CGRect rectInfo = self.infoView.frame;
    rectInfo.origin.y = rectImg.origin.y + rectImg.size.height + 10;
    self.infoView.frame = rectInfo;
//    CGRect rectBtn = self.btnSubmit.frame;
//    rectBtn.origin.y = rectInfo.origin.y + rectInfo.size.height < ScreenHeight-55 ? rectInfo.origin.y + rectInfo.size.height + 10 : ScreenHeight-45;
//    self.btnSubmit.frame = rectBtn;
    CGFloat heigth = rectInfo.origin.y + rectInfo.size.height > ScreenHeight ? rectInfo.origin.y + rectInfo.size.height : ScreenHeight;
    self.mainScrollView.contentSize = CGSizeMake(ScreenWidth, heigth);
//    self.mainScrollView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
    NSLog(@"x=%f",self.infoView.frame.origin.x);
    NSLog(@"y=%f",self.infoView.frame.origin.y);
    NSLog(@"w=%f",self.infoView.frame.size.width);
    NSLog(@"h=%f",self.infoView.frame.size.height);
}


-(void)deleteAction:(UIButton *)btn{
    [self.imageArray removeObjectAtIndex:btn.tag - 800];
    [self.imageUrlArray removeObjectAtIndex:btn.tag - 801];
    [self initScrollView];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.txtInputView resignFirstResponder];
}
@end
