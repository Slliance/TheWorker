//
//  ReleaseInfoViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/11.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ReleaseInfoViewController.h"
#import "MyStateViewController.h"
#import "UploadImgViewModel.h"
#import "PicModel.h"
#import "FriendCircleViewModel.h"
@interface ReleaseInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnRelease;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *btnChooseImage;
@property (nonatomic, assign) NSInteger imageNums;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UITextView *txtContentView;

@property (nonatomic, retain) NSMutableArray *imageUrlArray;

@end

@implementation ReleaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageNums = 0;
    self.imageArray = [[NSMutableArray alloc] init];
    [self.imageArray addObject:@"1"];
    self.imageUrlArray = [[NSMutableArray alloc]init];
    
    [self initScrollView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextViewTextDidChangeNotification" object:self.txtContentView];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)releaseAction:(id)sender {
    FriendCircleViewModel *viewModel = [[FriendCircleViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self showJGProgressWithMsg:@"发布成功"];
        [self backBtnAction:nil];
        self.reloadViewBlock();
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel releaseFriendCircleWith:self.txtContentView.text imgs:self.imageUrlArray token:[self getToken]];
}
- (IBAction)chooseImageAction:(id)sender {
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
        [self.imageUrlArray addObject:model.img_url];
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
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [weakSelf uploadImgToService:image];
        [weakSelf.imageArray addObject:image];
        NSLog(@"%@",weakSelf.imageArray);
        [weakSelf initScrollView];
        
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
            [addBtn addTarget:self action:@selector(chooseImageAction:) forControlEvents:UIControlEventTouchUpInside];
            [backview addSubview:addBtn];
            
            
            [self.imageScrollView addSubview:backview];
            
        }
        else{
            
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(10*(i%3+1)+i % 3 * w, 10*(i/3+1)+i / 3 * w, w, w)];
            backview.tag = 801 + i;
            backview.backgroundColor = [UIColor blueColor];
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, w, w )];
            [imgview setImage:self.imageArray[i + 1]];
            [backview addSubview:imgview];
            
            
            UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [delBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 44 - 30, 44 - 12, 0)];
            delBtn.frame = CGRectMake(sw - 44.f, -6, 44, 44);
            [delBtn setImage:[UIImage imageNamed:@"icon_cancel1"] forState:UIControlStateNormal];
            [delBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            [backview addSubview:delBtn];
            
            
            [self.imageScrollView addSubview:backview];
        }
        
    }
    
}


-(void)deleteAction:(UIButton *)btn{
    [self.imageArray removeObjectAtIndex:btn.superview.tag - 800];
    [self.imageUrlArray removeObjectAtIndex:btn.superview.tag - 801];
    [self initScrollView];
}

- (void)textFiledEditChanged:(NSNotification *)obj
{
    UITextView *inputTextView = (UITextView *)obj.object;
    NSString *toBeString = inputTextView.text;
    
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [inputTextView markedTextRange];       //获取高亮部分
        UITextPosition *position = [inputTextView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length >= 500) {
                inputTextView.text = [toBeString substringToIndex:500];
                //                self.labelCount.text = [NSString stringWithFormat:@"%lu/30",(unsigned long)inputTextView.text.length];
            }
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length >= 500) {
            inputTextView.text = [toBeString substringToIndex:500];
        }
    }
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
