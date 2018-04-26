//
//  UserInfomationViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/24.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "UserInfomationViewController.h"
#import "ShippingAddressViewController.h"
#import "H_Single_PickerView.h"
#import "H_PCZ_PickerView.h"
#import "UserModel.h"
#import "UserViewModel.h"
#import "UploadImgViewModel.h"
#import "PicModel.h"
#import "WSDatePickerView.h"

@interface UserInfomationViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,H_Single_PickerViewDelegate,H_PCZ_PickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *infoScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *btnConstellation;//星座
@property (weak, nonatomic) IBOutlet UIButton *btnAge;
@property (weak, nonatomic) IBOutlet UIButton *btnSex;
@property (weak, nonatomic) IBOutlet UIButton *btnCity;
@property (weak, nonatomic) IBOutlet UIButton *btnAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtOccupation;
@property (weak, nonatomic) IBOutlet UITextField *txtHeight;
@property (weak, nonatomic) IBOutlet UITextField *txtWorkPlace;
@property (weak, nonatomic) IBOutlet UITextView *txtSignature;

@property (nonatomic, copy) NSString *conStr;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, copy) NSString *ageStr;

@property (nonatomic, assign) NSInteger singleType;
@property (nonatomic, retain) UserModel *infoModel;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) NSInteger zone_code;
@end

@implementation UserInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageUrl = [[NSString  alloc]init];
    self.conStr = [[NSString  alloc]init];
    self.ageStr = [[NSString  alloc]init];
    
    
    
    [self.btnAge setImagePositionWithType:SSImagePositionTypeRight spacing:10.f];
    [self.btnSex setImagePositionWithType:SSImagePositionTypeRight spacing:10.f];
    [self.btnCity setImagePositionWithType:SSImagePositionTypeRight spacing:10.f];
    [self.btnAddress setImagePositionWithType:SSImagePositionTypeRight spacing:10.f];
    [self.btnConstellation setImagePositionWithType:SSImagePositionTypeRight spacing:10.f];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 25.f;
    self.infoScrollView.contentSize = CGSizeMake(ScreenWidth, 603);
    // Do any additional setup after loading the view from its nib.
    UserViewModel *viewModel = [[UserViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        self.infoModel = returnValue;
        [self reloadView];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchUserInfomationWithToken:[self getToken]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextViewTextDidChangeNotification" object:self.txtSignature];
    
    
}

-(void)reloadView{
    self.imageUrl = self.infoModel.headimg;
    [self.iconImageView setImageWithString:self.infoModel.headimg placeHoldImageName:placeholderImage_user_headimg];
    self.txtName.text = self.infoModel.nickname;
    if ([self.infoModel.sex intValue] == 0) {
        [self.btnSex setTitle:@"女" forState:UIControlStateNormal];
        self.sex = 0;
    }else if ([self.infoModel.sex intValue] == 1){
        [self.btnSex setTitle:@"男" forState:UIControlStateNormal];
        self.sex = 1;
    }else{
        self.sex = 2;
        [self.btnSex setTitle:@"请选择性别" forState:UIControlStateNormal];
    }
    if (self.infoModel.constellation.length < 1) {
        self.conStr = self.infoModel.constellation;
        [self.btnConstellation setTitle:@"请选择星座" forState:UIControlStateNormal];
    }else{
        self.conStr = self.infoModel.constellation;
        [self.btnConstellation setTitle:self.infoModel.constellation forState:UIControlStateNormal];
    }
    if ([self.infoModel.birthday isEqualToString:@"0000-00-00"]) {
        [self.btnAge setTitle:@"请选择出生日期" forState:UIControlStateNormal];
        self.ageStr = @"";
    }else{
        [self.btnAge setTitle:self.infoModel.birthday forState:UIControlStateNormal];
        self.ageStr = self.infoModel.birthday;
    }

    self.txtOccupation.text = self.infoModel.job;
    if (!([self.infoModel.height integerValue] == 0)) {
        self.txtHeight.text = [NSString stringWithFormat:@"%@",self.infoModel.height];
    }
    if (!([self.infoModel.zone_code integerValue] == 0)) {
        [self.btnCity setTitle:[NSString stringWithFormat:@"%@",self.infoModel.city] forState:UIControlStateNormal];
    }
    
    self.txtWorkPlace.text = self.infoModel.work_address;
    self.zone_code = [self.infoModel.zone_code integerValue];
    self.txtSignature.text = self.infoModel.sign;
    
    [self.btnAge setImagePositionWithType:SSImagePositionTypeRight spacing:10.f];
    [self.btnSex setImagePositionWithType:SSImagePositionTypeRight spacing:10.f];
    [self.btnCity setImagePositionWithType:SSImagePositionTypeRight spacing:10.f];
    [self.btnAddress setImagePositionWithType:SSImagePositionTypeRight spacing:10.f];
    [self.btnConstellation setImagePositionWithType:SSImagePositionTypeRight spacing:10.f];
}


- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)saveAction:(id)sender {
//    if (self.imageUrl.length < 1) {
//        [self showJGProgressWithMsg:@"请选择头像"];
//        return;
//    }
    NSString *nameStr = @"";
    if (self.txtName.text.length == 0) {
        nameStr = self.infoModel.nickname;
    }else{
        nameStr = self.txtName.text;
    }
//    if (self.btnConstellation.titleLabel.text.length > 3) {
//        [self showJGProgressWithMsg:@"请选择星座"];
//        return;
//    }
//    if (self.btnAge.titleLabel.text.length < 10) {
//        [self showJGProgressWithMsg:@"请选择出生日期"];
//        return;
//    }
//    if (self.txtOccupation.text.length == 0) {
//        [self showJGProgressWithMsg:@"请填写职业"];
//        return;
//    }
//    if (self.txtHeight.text.length == 0) {
//        [self showJGProgressWithMsg:@"请填写身高"];
//        return;
//    }
//    if (self.zone_code == 0) {
//        [self showJGProgressWithMsg:@"请选择地区"];
//        return;
//    }
//    if (self.txtWorkPlace.text.length == 0) {
//        [self showJGProgressWithMsg:@"请填写工作地点"];
//        return;
//    }
//    if (self.txtSignature.text.length == 0) {
//        [self showJGProgressWithMsg:@"请填写签名"];
//        return;
//    }
    UserViewModel *viewModel = [[UserViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self showJGProgressWithMsg:@"保存成功"];
        [self backBtnAction:nil];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    
    [viewModel updateUserInfomationWithHeadImg:self.imageUrl nickname:nameStr sex:@(self.sex) constellation:self.conStr birthday:self.ageStr job:self.txtOccupation.text work_address:self.txtWorkPlace.text height:self.txtHeight.text sign:self.txtSignature.text zone_code:@(self.zone_code) token:[self getToken]];
}
- (IBAction)chooseIconImg:(id)sender {
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
    __weak typeof(self) weakSelf = self;
    UploadImgViewModel *viewModel = [[UploadImgViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        PicModel *model = [returnValue firstObject];
        weakSelf.imageUrl = model.img_url;
        self.iconImageView.image = img;
        [self dissJGProgressLoadingWithTag:200];
    } WithErrorBlock:^(id errorCode) {
        [self dissJGProgressLoadingWithTag:200];
    }];
    [viewModel uploadImgWithImage:img];
    [self showJGProgressLoadingWithTag:200];
}

//选择星座
- (IBAction)chooseConstelation:(id)sender {
    [self txtResignFirstResponder];
    H_Single_PickerView *pickerView = [[H_Single_PickerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) arr:@[@{@"Name": @"白羊座",@"Id":@(0)},@{@"Name":@"金牛座",@"Id":@(1)},@{@"Name":@"双子座",@"Id":@(2)},@{@"Name":@"巨蟹座",@"Id":@(3)},@{@"Name":@"狮子座",@"Id":@(4)},@{@"Name":@"处女座",@"Id":@(5)},@{@"Name":@"天秤座",@"Id":@(6)},@{@"Name":@"天蝎座",@"Id":@(7)},@{@"Name":@"射手座",@"Id":@(8)},@{@"Name":@"摩羯座",@"Id":@(9)},@{@"Name":@"水瓶座",@"Id":@(10)},@{@"Name":@"双鱼座",@"Id":@(11)}]];
    pickerView.delegate = self;
    self.singleType = 1;
    [self.view addSubview:pickerView];

}
- (IBAction)chooseAge:(id)sender {
    [self txtResignFirstResponder];
    NSString *str = [NSString stringWithFormat:@"%@",[self getNowDateFromatAnDate:[NSDate date]]];
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay dateStr:str CompleteBlock:^(NSDate *startDate)  {
        NSString *date = [startDate stringWithFormat:@"yyyy-MM-dd"];
        self.ageStr = date;
        [self.btnAge setTitle:date forState:UIControlStateNormal];
        [self.btnAge setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.btnAge setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
//        self.birthDay = date;
    }];
    datepicker.maxLimitDate = [self getNowDateFromatAnDate:[NSDate date]];
    datepicker.doneButtonColor = [UIColor colorWithHexString:@"6398f1"];//确定按钮的颜色
    [datepicker show];
}
- (IBAction)chooseSex:(id)sender {
    [self txtResignFirstResponder];
    H_Single_PickerView *pickerView = [[H_Single_PickerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) arr:@[@{@"Name": @"男",@"Id":@(1)},@{@"Name":@"女",@"Id":@(0)}]];
    pickerView.delegate = self;
    self.singleType = 0;
    [self.view addSubview:pickerView];

}
- (IBAction)chooseCity:(id)sender {
    [self txtResignFirstResponder];
    H_PCZ_PickerView *pickerView = [[H_PCZ_PickerView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
    pickerView.delegate = self;
    [self.view addSubview:pickerView];
}
- (IBAction)setAddress:(id)sender {
    ShippingAddressViewController *vc = [[ShippingAddressViewController alloc]init];
    vc.isChooseOrChange = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - H_PCZ_PickerViewDelegate
-(void)getChooseIndex:(H_PCZ_PickerView *)_myPickerView addressStr:(NSString *)addressStr areaCode:(NSString *)areaCode{
    [self.btnCity setTitle:addressStr forState:UIControlStateNormal];
    [self.btnCity setImagePositionWithType:SSImagePositionTypeRight spacing:10.f];
    //    self.btnArea.titleLabel.textAlignment = NSTextAlignmentRight;
        self.zone_code = [areaCode integerValue];
}
#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
//    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        self.iconImageView.image = image;
        CGSize defaultSize = CGSizeMake(128, 128);
        UIImage *newImage = [self newSizeImage:defaultSize image:image];
        [self uploadImgToService:newImage];
//        [weakSelf.imageArray ad`dObject:image];
//        [weakSelf initScrollView];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - H_Single_PickerViewDelegate
-(void)SinglePickergetObjectWithArr:(H_Single_PickerView *)_h_Single_PickerView arr:(NSArray *)_arr index:(NSInteger)_index chooseStr:(NSString *)chooseStr chooseId:(NSNumber *)chooseId{
    if (self.singleType == 0) {
        [self.btnSex setTitle:chooseStr forState:UIControlStateNormal];
        if ([chooseStr isEqualToString:@"女"]) {
            self.sex = 0;
        }else if([chooseStr isEqualToString:@"男"]){
            self.sex = 1;
        }
        [self.btnSex setImagePositionWithType:SSImagePositionTypeRight spacing:10.f];
    }else if (self.singleType == 1){
        self.conStr = chooseStr;
        [self.btnConstellation setTitle:chooseStr forState:UIControlStateNormal];
        [self.btnConstellation setImagePositionWithType:SSImagePositionTypeRight spacing:10.f];
    }else{
        [self.btnAge setTitle:chooseStr forState:UIControlStateNormal];
        [self.btnAge setImagePositionWithType:SSImagePositionTypeRight spacing:10.f];
        NSLog(@"%@%@",chooseStr,chooseId);
    }
    NSLog(@"%@%@",chooseStr,chooseId);
//    [self.btnSex setTitleEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 10)];
//    [self.btnSex setImage:[UIImage imageNamed:@"icon_more-"] forState:UIControlStateNormal];
//    [self.btnSex setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -15)];
//    self.selectSex = chooseId;
}

-(void)txtResignFirstResponder{
    [self.txtSignature resignFirstResponder];
    [self.txtHeight resignFirstResponder];
    [self.txtWorkPlace resignFirstResponder];
    [self.txtOccupation resignFirstResponder];
    [self.txtName resignFirstResponder];
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
            if (toBeString.length >= 15) {
                inputTextView.text = [toBeString substringToIndex:15];
//                self.labelCount.text = [NSString stringWithFormat:@"%lu/30",(unsigned long)inputTextView.text.length];
            }
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length >= 15) {
            inputTextView.text = [toBeString substringToIndex:15];
        }
    }
}
 
 - (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize {
 //先判断当前质量是否满足要求，不满足再进行压缩
 __block NSData *finallImageData = UIImageJPEGRepresentation(source_image,1.0);
 NSUInteger sizeOrigin   = finallImageData.length;
 NSUInteger sizeOriginKB = sizeOrigin / 1024;
 
 if (sizeOriginKB <= maxSize) {
 return finallImageData;
 }
 
 //先调整分辨率
 CGSize defaultSize = CGSizeMake(1024, 1024);
 UIImage *newImage = [self newSizeImage:defaultSize image:source_image];
 
 finallImageData = UIImageJPEGRepresentation(newImage,1.0);
 
 //保存压缩系数
 NSMutableArray *compressionQualityArr = [NSMutableArray array];
 CGFloat avg   = 1.0/250;
 CGFloat value = avg;
 for (int i = 250; i >= 1; i--) {
 value = i*avg;
 [compressionQualityArr addObject:@(value)];
 }
 
 /*
 调整大小
 说明：压缩系数数组compressionQualityArr是从大到小存储。
 */
//思路：使用二分法搜索
finallImageData = [self halfFuntion:compressionQualityArr image:newImage sourceData:finallImageData maxSize:maxSize];
//如果还是未能压缩到指定大小，则进行降分辨率
while (finallImageData.length == 0) {
    //每次降100分辨率
    if (defaultSize.width-100 <= 0 || defaultSize.height-100 <= 0) {
        break;
    }
    defaultSize = CGSizeMake(defaultSize.width-100, defaultSize.height-100);
    UIImage *image = [self newSizeImage:defaultSize
                                  image:[UIImage imageWithData:UIImageJPEGRepresentation(newImage,[[compressionQualityArr lastObject] floatValue])]];
    finallImageData = [self halfFuntion:compressionQualityArr image:image sourceData:UIImageJPEGRepresentation(image,1.0) maxSize:maxSize];
}
return finallImageData;
}
#pragma mark 调整图片分辨率/尺寸（等比例缩放）
- (UIImage *)newSizeImage:(CGSize)size image:(UIImage *)source_image {
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    
    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth = newSize.width / size.width;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark 二分法
- (NSData *)halfFuntion:(NSArray *)arr image:(UIImage *)image sourceData:(NSData *)finallImageData maxSize:(NSInteger)maxSize {
    NSData *tempData = [NSData data];
    NSUInteger start = 0;
    NSUInteger end = arr.count - 1;
    NSUInteger index = 0;
    
    NSUInteger difference = NSIntegerMax;
    while(start <= end) {
        index = start + (end - start)/2;
        
        finallImageData = UIImageJPEGRepresentation(image,[arr[index] floatValue]);
        
        NSUInteger sizeOrigin = finallImageData.length;
        NSUInteger sizeOriginKB = sizeOrigin / 1024;
        NSLog(@"当前降到的质量：%ld", (unsigned long)sizeOriginKB);
        NSLog(@"\nstart：%zd\nend：%zd\nindex：%zd\n压缩系数：%lf", start, end, (unsigned long)index, [arr[index] floatValue]);
        
        if (sizeOriginKB > maxSize) {
            start = index + 1;
        } else if (sizeOriginKB < maxSize) {
            if (maxSize-sizeOriginKB < difference) {
                difference = maxSize-sizeOriginKB;
                tempData = finallImageData;
            }
            if (index<=0) {
                break;
            }
            end = index - 1;
        } else {
            break;
        }
    }
    return tempData;
}

@end
