//
//  PublishMyInfoViewController.m
//  TheWorker
//
//  Created by yanghao on 9/1/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "PublishMyInfoViewController.h"
#import "UITextView+Placeholder.h"
#import "PicModel.h"
#import "UploadImgViewModel.h"
#import "WorkerHandInViewModel.h"
#import "HandInModel.h"
#import "IDMPhoto.h"
#import "IDMPhotoBrowser.h"
@interface PublishMyInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate>
@property (nonatomic, assign) NSInteger imageNums;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIView *loveView;
@property (weak, nonatomic) IBOutlet UIView *selfView;
@property (weak, nonatomic) IBOutlet UITextView *txtView;
@property (weak, nonatomic) IBOutlet UITextField *txtLove;
@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *picView;
@property (weak, nonatomic) IBOutlet UIView *stateView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (nonatomic, retain) NSMutableArray *imageUrlArray;
@property (nonatomic, retain) HandInModel *fateModel;
@property (nonatomic, assign) NSInteger fateStatus;
@property (nonatomic, assign) NSInteger imgOrImgUrl;//显示图片的方式
@end

@implementation PublishMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == 0) {
        self.titleLabel.text = @"发布信息";
    }else{
        self.titleLabel.text = @"我的相亲";
    }
    self.imageNums = 0;
    self.fateStatus = 1;
    self.imgOrImgUrl = 0;
    self.imageArray = [[NSMutableArray alloc] init];
    self.imageUrlArray = [[NSMutableArray alloc] init];
    [self.imageArray addObject:@"1"];
    [self initScrollView];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesBegan:withEvent:)];
    [self.mainScrollView addGestureRecognizer:tapGR];
    
    self.selfView.layer.masksToBounds = YES;
    self.selfView.layer.cornerRadius = 8.f;
    
    self.loveView.layer.masksToBounds = YES;
    self.loveView.layer.cornerRadius = 8.f;
    
    self.txtView.placeholder = @"请输入，200个字以内";
    
    WorkerHandInViewModel *viewModel =[[WorkerHandInViewModel alloc] init];
    self.fateModel = [[HandInModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        
        self.fateModel = returnValue;
        
        if (self.fateModel.uid) {
            self.imgOrImgUrl = 1;
            self.fateStatus = [self.fateModel.fate_status integerValue];
            if ([self.fateModel.fate_status integerValue] == 0) {
                [self.imageArray addObjectsFromArray:self.fateModel.imgs];
                [self.imageUrlArray addObjectsFromArray:self.fateModel.imgs];
                self.txtLove.text = self.fateModel.declaration;
                self.txtView.text = self.fateModel.introduce;
                self.txtLove.enabled = NO;
                self.txtView.editable = NO;
                [self.btnSubmit setTitle:@"审核中" forState:UIControlStateNormal];
                self.btnSubmit.enabled = NO;
                self.stateView.hidden = NO;
                self.statusLabel.text = @"审核中";
                self.timeLabel.text = self.fateModel.audite_time;
                [self.btnSubmit setBackgroundColor:[UIColor colorWithHexString:@"999999"]];
            }else if ([self.fateModel.fate_status integerValue] == 1){
                [self.imageArray addObjectsFromArray:self.fateModel.imgs];
                [self.imageUrlArray addObjectsFromArray:self.fateModel.imgs];
                self.txtLove.text = self.fateModel.declaration;
                self.txtView.text = self.fateModel.introduce;
                self.stateView.hidden = NO;
                self.statusLabel.text = @"成功";
                self.timeLabel.text = self.fateModel.audite_time;
                self.btnSubmit.hidden = NO;
            }else if ([self.fateModel.fate_status integerValue] == 2){
                [self.imageArray addObjectsFromArray:self.fateModel.imgs];
                [self.imageUrlArray addObjectsFromArray:self.fateModel.imgs];
                self.txtLove.text = self.fateModel.declaration;
                self.txtView.text = self.fateModel.introduce;
                self.stateView.hidden = NO;
                self.statusLabel.text = @"退回";
                self.timeLabel.text = self.fateModel.audite_time;
                self.btnSubmit.hidden = NO;
                
            }
            [self initScrollView];
        }
        
        
        
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchMyFateDetailWithToken:[self getToken]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.txtLove];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:@"UITextViewTextDidChangeNotification" object:self.txtView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
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
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        
//        [weakSelf.imageArray addObject:image];
        [weakSelf uploadImgToService:image];
//        [weakSelf initScrollView];
        
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
    
    NSInteger imgCount = self.imageArray.count == 10 ? 9 : self.imageArray.count;
    CGRect picrect = self.picView.frame;
    picrect.size.height =  30 + (imgCount - 1) / 3 * sw+sw;
    self.picView.frame = picrect;
    
    CGRect myrect = self.myView.frame;
    myrect.origin.y = self.picView.frame.origin.y + self.picView.frame.size.height + 15.f;
    self.myView.frame = myrect;
    self.imageScrollView.contentSize = CGSizeMake(ScreenWidth, 0);
    [self.mainScrollView setContentSize:CGSizeMake(ScreenWidth, self.myView.frame.origin.y + self.myView.frame.size.height + 10)];
    for (int i = 0; i < self.imageArray.count; i ++) {
        if (i == 9 ) {
            return;
        }
        
        if (i == self.imageArray.count - 1) {
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(10*(i%3+1)+i % 3 * w, 10*(i/3+1)+i / 3 * w, w, w)];
            backview.tag = 801 + i;
            
            
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addBtn.frame = CGRectMake(0, 0, w, w);
            [addBtn setBackgroundImage:[UIImage imageNamed:@"icon_upload_picture"] forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(chooseImageAction:) forControlEvents:UIControlEventTouchUpInside];
            if (self.fateStatus != 0) {
                [backview addSubview:addBtn];
            }

            [self.imageScrollView addSubview:backview];
            
        }
        else{
            
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(10*(i%3+1)+i % 3 * w, 10*(i/3+1)+i / 3 * w, w, w)];
            backview.tag = 801 + i;
            backview.backgroundColor = [UIColor blueColor];
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, w, w )];
            if (self.imgOrImgUrl == 0) {
                [imgview setImage:self.imageArray[i + 1]];
                
            }else{
                [imgview setImageWithString:self.imageUrlArray[i] placeHoldImageName:@"bg_no_pictures"];
//                [imgview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,self.imageUrlArray[i]]] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
            }
            
            
            [backview addSubview:imgview];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookPicture:)];
            [backview addGestureRecognizer:tap];
            
            CGRect backRect = backview.frame;
            UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [delBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 44 - 20, 44 - 27, 0)];
            delBtn.frame = CGRectMake(backRect.origin.x + backRect.size.width - 34.f, backRect.origin.y - 15, 44, 44);
            delBtn.tag = 801 + i;
            [delBtn setImage:[UIImage imageNamed:@"icon_cancel1"] forState:UIControlStateNormal];
            [delBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.imageScrollView addSubview:backview];
            if (self.fateStatus != 0) {
                [self.imageScrollView addSubview:delBtn];
            }
            
        }
    }
    
    
}

- (IBAction)submitAction:(id)sender {
    WorkerHandInViewModel *viewModel = [[WorkerHandInViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self backAction:nil];
        [self showJGProgressWithMsg:@"审核提交成功"];
        
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel publishUserInfoWithDeclaration:self.txtLove.text introduce:self.txtView.text imgs:self.imageUrlArray token:[self getToken]];
}

-(void)deleteAction:(UIButton *)btn{
    [self.imageArray removeObjectAtIndex:btn.tag - 800];
    [self.imageUrlArray removeObjectAtIndex:btn.tag - 801];
    [self initScrollView];
}
- (void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];       //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length >= 10) {
                textField.text = [toBeString substringToIndex:10];
            }
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length >= 10) {
            textField.text = [toBeString substringToIndex:10];
        }
    }
    
}
- (void)textViewEditChanged:(NSNotification *)obj
{
    UITextView *inputTextView = (UITextView *)obj.object;
    NSString *toBeString = inputTextView.text;
    
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [inputTextView markedTextRange];       //获取高亮部分
        UITextPosition *position = [inputTextView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length >= 200) {
                inputTextView.text = [toBeString substringToIndex:200];
                //                self.labelCount.text = [NSString stringWithFormat:@"%lu/30",(unsigned long)inputTextView.text.length];
            }
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length >= 200) {
            inputTextView.text = [toBeString substringToIndex:200];
        }
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.txtLove resignFirstResponder];
    [self.txtView resignFirstResponder];
}


//查看图片
-(void)lookPicture:(UITapGestureRecognizer *)ges{
    NSInteger index = ges.view.tag - 801;
    NSMutableArray *photosURL = [[NSMutableArray alloc] init];
    
    for ( int i = 0; i < self.imageUrlArray.count; i ++) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,self.imageUrlArray[i]]];
        [photosURL addObject:url];
    }
    
    // Create an array to store IDMPhoto objects
    NSMutableArray *photos = [NSMutableArray new];
    
    for (NSURL *url in photosURL) {
        IDMPhoto *photo = [IDMPhoto photoWithURL:url];
        [photos addObject:photo];
    }
    
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    [browser setInitialPageIndex:index];
    [self presentViewController:browser animated:YES completion:nil];
}

@end
