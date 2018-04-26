//
//  FillApplicationViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/29.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "FillApplicationViewController.h"
#import "JobChooseViewController.h"
#import "FillResumeViewController.h"
#import "ApplySuccessViewController.h"
#import "JobViewModel.h"
#import "ResumeModel.h"
#import "UploadImgViewModel.h"
#import "PicModel.h"
#import "UIButton+WebCache.h"
@interface FillApplicationViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnChooseEdu;
@property (weak, nonatomic) IBOutlet UIButton *btnChooseSex;
@property (weak, nonatomic) IBOutlet UIButton *btnChooseNation;
@property (weak, nonatomic) IBOutlet UIButton *btnResume;
@property (weak, nonatomic) IBOutlet UIScrollView *jobScrollView;
@property (weak, nonatomic) IBOutlet UITextField *txtReferrer;//推荐人
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtIdCardNo;
@property (weak, nonatomic) IBOutlet UITextField *txtInterest;
@property (weak, nonatomic) IBOutlet UITextField *txtContent;
@property (weak, nonatomic) IBOutlet UIButton *btnIdCardFirst;
@property (weak, nonatomic) IBOutlet UIButton *btnIdCardSecond;
@property (weak, nonatomic) IBOutlet UITextField *txtHealthCardNO;
@property (weak, nonatomic) IBOutlet UIButton *btnMajorCertificate;

@property (nonatomic, assign) NSInteger curEduIndex;
@property (nonatomic, assign) NSInteger curSexIndex;
@property (nonatomic, assign) NSInteger curNationIndex;
@property (nonatomic, copy) NSString *curEduStr;
@property (nonatomic, copy) NSString *curSexStr;
@property (nonatomic, copy) NSString *curNationStr;
@property (nonatomic, copy) NSString *curResumeStr;
@property (nonatomic, retain) NSMutableArray *imgArray;
@property (nonatomic, copy) NSString *skillImgUrl;
@property (nonatomic, copy) NSString *IdFirstImgUrl;
@property (nonatomic, copy) NSString *IdSecondImgUrl;
@property (nonatomic, assign) NSInteger imgType;//0身份证正面1身份证反面2技能证书
@end

@implementation FillApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgArray = [[NSMutableArray alloc] init];
//    self.curNationStr = [[NSString alloc]init];
//    self.curSexStr = [[NSString alloc]init];
//    self.curEduStr = [[NSString alloc]init];
//    self.curResumeStr = [[NSString alloc]init];
    self.btnSubmit.layer.masksToBounds = YES;
    self.btnSubmit.layer.cornerRadius = 4.f;
    [self.btnChooseEdu setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.btnChooseSex setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.btnChooseNation setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.btnResume setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    self.jobScrollView.contentSize = CGSizeMake(ScreenWidth, 875);
    // Do any additional setup after loading the view from its nib.
//    [sel f initView];
}

-(void)initView{
    JobViewModel *viewModel = [[JobViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        ResumeModel *model = returnValue;
        self.txtReferrer.text = model.recommend_user;
        self.txtName.text = model.name;
        self.txtMobile.text = model.mobile;
        self.txtIdCardNo.text = model.cardno;
        self.txtInterest.text = model.interest;
        self.curEduStr = model.edu;
        [self.btnChooseEdu setTitle:model.edu forState:UIControlStateNormal];
        if ([model.sex integerValue] == 0) {
            self.curSexStr = @"女";
            [self.btnChooseSex setTitle:@"女" forState:UIControlStateNormal];
        }else{
            self.curSexStr = @"男";
            [self.btnChooseSex setTitle:@"男" forState:UIControlStateNormal];
        }
        self.curNationStr = model.nation;
        [self.btnChooseNation setTitle:model.nation forState:UIControlStateNormal];
        self.curResumeStr = model.resume;
        [self.btnResume setTitle:model.resume forState:UIControlStateNormal];
        [self.btnChooseEdu setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        [self.btnChooseSex setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        [self.btnChooseNation setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        [self.btnResume setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchMyResumeWithToken:[self getToken]];
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)submitAction:(id)sender {
    [self applyResume];
//    if (self.txtName.text.length == 0) {
//        [self showJGProgressWithMsg:@"请填写姓名"];
//        return;
//    }
//    if (self.txtMobile.text.length == 0) {
//        [self showJGProgressWithMsg:@"请填写电话"];
//        return;
//    }
//    if (self.txtIdCardNo.text.length == 0) {
//        [self showJGProgressWithMsg:@"请填写身份证号"];
//        return;
//    }
//    if (self.txtIdCardNo.text.length != 18) {
//        [self showJGProgressWithMsg:@"请填写正确的身份证号"];
//        return;
//    }
//    if (self.curEduStr.length == 0) {
//        [self showJGProgressWithMsg:@"请选择学历"];
//        return;
//    }
//    if (self.curSexStr.length == 0) {
//        [self showJGProgressWithMsg:@"请选择性别"];
//        return;
//    }
//    if (self.curNationStr.length == 0) {
//        [self showJGProgressWithMsg:@"请选择民族"];
//        return;
//    }
//    if (self.txtInterest.text.length == 0) {
//        [self showJGProgressWithMsg:@"请填写兴趣"];
//        return;
//    }
//    if (self.curResumeStr.length == 0) {
//        [self showJGProgressWithMsg:@"请填写简历"];
//        return;
//    }
//    NSInteger sex = 0;
//    if ([self.curSexStr isEqualToString:@"男"]) {
//        sex = 1;
//    }
//    JobViewModel *viewModel = [[JobViewModel alloc]init];
//    [viewModel setBlockWithReturnBlock:^(id returnValue) {
//        [self applyResume];
//    } WithErrorBlock:^(id errorCode) {
//        [self showJGProgressWithMsg:errorCode];
//    }];
//    [viewModel updateResumeWithName:self.txtName.text cradNo:self.txtIdCardNo.text edu:self.curEduStr nation:self.curNationStr interest:self.txtInterest.text resume:self.curResumeStr mobile:self.txtMobile.text sex:@(sex) recommendUser:self.txtReferrer.text token:[self getToken]];
}
//投递简历
-(void)applyResume{
    
    if (self.txtContent.text.length == 0) {
        [self showJGProgressWithMsg:@"请填写职位"];
        return;
    }
    if (self.txtName.text.length == 0) {
        [self showJGProgressWithMsg:@"请填写姓名"];
        return;
    }
    if (![CustomTool isValidtePhone:self.txtMobile.text]){
        [self showJGProgressWithMsg:@"请填写正确的电话号码"];
        return;
    }

    if (self.txtIdCardNo.text.length == 0) {
        [self showJGProgressWithMsg:@"请填写身份证号"];
        return;
    }
    if (![CustomTool isValidateIdentityCard:self.txtIdCardNo.text]) {
        [self showJGProgressWithMsg:@"请填写正确的身份证号"];
        return;
    }
    NSInteger sex = 2;
    if ([self.curSexStr isEqualToString:@"男"]) {
        sex = 1;
    }
    if ([self.curSexStr isEqualToString:@"女"]) {
        sex = 0;
    }
    [self.imgArray removeAllObjects];
    if (self.IdFirstImgUrl.length > 1) {
        [self.imgArray addObject:self.IdFirstImgUrl];
    }
    if (self.IdSecondImgUrl.length > 1) {
        [self.imgArray addObject:self.IdSecondImgUrl];
    }
    
    JobViewModel *viewModel = [[JobViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        ApplySuccessViewController *vc = [[ApplySuccessViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel applyWorkWithId:self.workId token:[self getToken] job:self.txtContent.text cardImg:self.imgArray healthNo:self.txtHealthCardNO.text skillImg:self.skillImgUrl name:self.txtName.text cardno:self.txtIdCardNo.text edu:self.curEduStr nation:self.curNationStr interest:self.txtInterest.text resume:self.curResumeStr mobile:self.txtMobile.text sex:@(sex) recommendUser:self.txtReferrer.text];
}

- (IBAction)chooseEduction:(id)sender {
    [self txtResignFirstResponder];
    JobChooseViewController *vc = [[JobChooseViewController alloc]init];

    [vc setReturnText:^(NSString *textStr,NSInteger index) {
        [self.btnChooseEdu setTitle:textStr forState:UIControlStateNormal];
        [self.btnChooseEdu setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [self.btnChooseEdu setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        self.curEduIndex = index;
        self.curEduStr = textStr;
        [self CalculateTheIntegrity];
    }];
    vc.currentSelectIndex = self.curEduIndex;
    vc.currentSelectType = 0;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)chooseSex:(id)sender {
    [self txtResignFirstResponder];
    JobChooseViewController *vc = [[JobChooseViewController alloc]init];
    [vc setReturnText:^(NSString *textStr,NSInteger index) {
        [self.btnChooseSex setTitle:textStr forState:UIControlStateNormal];
        [self.btnChooseSex setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [self.btnChooseSex setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        self.curSexIndex = index;
        self.curSexStr = textStr;
        [self CalculateTheIntegrity];
    }];
    vc.currentSelectIndex = self.curSexIndex;
    vc.currentSelectType = 1;
    [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)chooseNation:(id)sender {
    [self txtResignFirstResponder];
    JobChooseViewController *vc = [[JobChooseViewController alloc]init];
    [vc setReturnText:^(NSString *textStr,NSInteger index) {
        [self.btnChooseNation setTitle:textStr forState:UIControlStateNormal];
        [self.btnChooseNation setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [self.btnChooseNation setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        self.curNationIndex = index;
        self.curNationStr = textStr;
        [self CalculateTheIntegrity];
    }];
    vc.currentSelectIndex = self.curNationIndex;
    vc.currentSelectType = 2;
    [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)fillResume:(id)sender {
    
    FillResumeViewController *vc = [[FillResumeViewController alloc]init];
    [vc setReturnResumeBlock:^(NSString *str) {
        [self.btnResume setTitle:str forState:UIControlStateNormal];
        [self.btnResume setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        self.curResumeStr = str;
        [self CalculateTheIntegrity];
    }];
    [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)uploadIdCardFirst:(id)sender {
    [self txtResignFirstResponder];
    self.imgType = 0;
    [self showUploadTypeAlert];
}
- (IBAction)uploadIdCardSecond:(id)sender {
    [self txtResignFirstResponder];
    self.imgType = 1;
    [self showUploadTypeAlert];
}
- (IBAction)uploadHealthCertificate:(id)sender {
    [self txtResignFirstResponder];
    self.imgType = 2;
    [self showUploadTypeAlert];
}

-(void)showUploadTypeAlert{
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
        if (weakSelf.imgType == 0) {
            weakSelf.IdFirstImgUrl = model.img_url;
            [weakSelf.btnIdCardFirst setBackgroundImage:img forState:UIControlStateNormal];
        }else if (weakSelf.imgType == 1){
            weakSelf.IdSecondImgUrl = model.img_url;
            [weakSelf.btnIdCardSecond setBackgroundImage:img forState:UIControlStateNormal];
        }else{
            weakSelf.skillImgUrl = model.img_url;
            [weakSelf.btnMajorCertificate setBackgroundImage:img forState:UIControlStateNormal];
        }
        [self CalculateTheIntegrity];
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
            //        self.iconImageView.image = image;
            [self uploadImgToService:image];
//            [self.btnUploadImg setBackgroundImage:image forState:UIControlStateNormal];
            //        [weakSelf.imageArray addObject:image];
            //        [weakSelf initScrollView];
            
        }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)txtResignFirstResponder{
    
    [self.txtInterest resignFirstResponder];
    [self.txtIdCardNo resignFirstResponder];
    [self.txtContent resignFirstResponder];
    [self.txtMobile resignFirstResponder];
    [self.txtName resignFirstResponder];
    [self.txtReferrer resignFirstResponder];
    [self.txtHealthCardNO resignFirstResponder];
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self CalculateTheIntegrity];
    return YES;
}
-(void)CalculateTheIntegrity{
    int num = 0;
    num += [self calculateNumber: self.txtName.text];
    num += [self calculateNumber: self.txtMobile.text];
    num += [self calculateNumber: self.txtContent.text];
    num += [self calculateNumber: self.txtIdCardNo.text];
    num += [self calculateNumber: self.txtInterest.text];
    num += [self calculateNumber: self.txtReferrer.text];
    num += [self calculateNumber: self.txtHealthCardNO.text];
    num += [self calculateNumber: self.curEduStr];
    num += [self calculateNumber: self.curSexStr];
    num += [self calculateNumber: self.curNationStr];
    num += [self calculateNumber: self.curResumeStr];
    num += [self calculateNumber: self.IdFirstImgUrl];
    num += [self calculateNumber: self.IdSecondImgUrl];
    num += [self calculateNumber: self.skillImgUrl];
    int percent = num*100/14;
    
    [self.btnSubmit setTitle:[NSString stringWithFormat:@"立即提交(%ld%%)",(long)percent] forState:UIControlStateNormal];
    
}
-(int)calculateNumber:(NSString *)string{
    
    if (string.length == 0) {
        return 0;
    }
    return 1;
}
@end
