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
#import "MyResumeViewModel.h"
#import "MyResumeModel.h"


@interface FillApplicationViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic)  UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnChooseEdu;
@property(nonatomic,strong)UIButton *tmpBtn;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;

@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eduImage;

@property (weak, nonatomic) IBOutlet UIImageView *nationImage;
@property (weak, nonatomic) IBOutlet UITextView *introduceTextView;
@property (weak, nonatomic) IBOutlet UIButton *btnChooseSex;
@property (weak, nonatomic) IBOutlet UIButton *btnChooseNation;
@property (weak, nonatomic) IBOutlet UIButton *btnResume;
@property (weak, nonatomic) IBOutlet UIScrollView *jobScrollView;
///职位
@property (weak, nonatomic) IBOutlet UITextField *txtContent;
///推荐人
@property (weak, nonatomic) IBOutlet UITextField *txtReferrer;
///期望薪资
@property (weak, nonatomic) IBOutlet UITextField *expectationField;
///姓名
@property (weak, nonatomic) IBOutlet UITextField *txtName;
///电话
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
///身份证号
@property (weak, nonatomic) IBOutlet UITextField *txtIdCardNo;
///兴趣
@property (weak, nonatomic) IBOutlet UITextField *txtInterest;
///学历
@property (weak, nonatomic) IBOutlet UILabel *chooseEduLabel;
///民族
@property (weak, nonatomic) IBOutlet UILabel *chooseNationLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnIdCardFirst;
@property (weak, nonatomic) IBOutlet UIButton *btnIdCardSecond;
///健康证号
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
@property(nonatomic,strong)MyResumeViewModel *viewModel;
@property(nonatomic,strong)MyResumeModel*resultModel;

@end

@implementation FillApplicationViewController
-(UIButton *)btnSubmit{
    if (!_btnSubmit) {
        _btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSubmit setTitle:@"保存并提交" forState:UIControlStateNormal];
        _btnSubmit.backgroundColor = DSColorFromHex(0xFFCE00);
        [_btnSubmit addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSubmit;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
    switch (self.resumeType) {
        case ResumeTypeCreate:
            self.navView.titleLabel.text = @"创建简历";
            [self creatResumeUI];
            break;
        case ResumeTypePreview:
            self.navView.titleLabel.text = @"预览";
            [self previewUI];
            [self requestData];
            break;
        case ResumeTypeChange:
            self.navView.titleLabel.text = @"修改简历";
            [self creatResumeUI];
            [self requestData];
            break;
        default:
            break;
    }
    
    [self.view addSubview:self.btnSubmit];
    [self.btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(49);
    }];


    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    self.imgArray = [[NSMutableArray alloc] init];
    [self.maleBtn addTarget:self action:@selector(pressSexBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.femaleBtn addTarget:self action:@selector(pressSexBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)creatResumeUI{
    _eduImage.hidden = NO;
    _nationImage.hidden = NO;
    self.sexLabel.hidden = YES;
    self.maleBtn.hidden = NO;
    self.femaleBtn.hidden = NO;
    self.btnIdCardFirst.userInteractionEnabled= YES;
    self.btnIdCardSecond.userInteractionEnabled = YES;
    self.btnMajorCertificate.userInteractionEnabled = YES;
    self.btnSubmit.hidden = NO;
    self.btnSubmit.layer.masksToBounds = YES;
    self.btnSubmit.layer.cornerRadius = 4.f;
    [self.btnChooseEdu setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.btnChooseSex setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.btnChooseNation setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.btnResume setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    self.jobScrollView.contentSize = CGSizeMake(ScreenWidth, 975);
    self.btnChooseEdu.layer.masksToBounds = YES;
    [self.btnChooseEdu.layer setBorderColor:[UIColor colorWithHexString:@"999999"].CGColor];
    [self.btnChooseEdu.layer setBorderWidth:1];
    self.btnChooseNation.layer.masksToBounds = YES;
    [self.btnChooseNation.layer setBorderColor:[UIColor colorWithHexString:@"999999"].CGColor];
    [self.btnChooseNation.layer setBorderWidth:1];
    self.expectationField.layer.masksToBounds = YES;
    [self.expectationField.layer setBorderColor:[UIColor colorWithHexString:@"999999"].CGColor];
    [self.expectationField.layer setBorderWidth:1];
    [self setTextFieldLeftView:self.expectationField :nil :5];
    self.txtReferrer.layer.masksToBounds = YES;
    [self.txtReferrer.layer setBorderColor:[UIColor colorWithHexString:@"999999"].CGColor];
    [self.txtReferrer.layer setBorderWidth:1];
     [self setTextFieldLeftView:self.txtReferrer :nil :5];
    self.txtName.layer.masksToBounds = YES;
    [self.txtName.layer setBorderColor:[UIColor colorWithHexString:@"999999"].CGColor];
    [self.txtName.layer setBorderWidth:1];
     [self setTextFieldLeftView:self.txtName :nil :5];
    self.txtMobile.layer.masksToBounds = YES;
    [self.txtMobile.layer setBorderColor:[UIColor colorWithHexString:@"999999"].CGColor];
    [self.txtMobile.layer setBorderWidth:1];
     [self setTextFieldLeftView:self.txtMobile :nil :5];
    self.txtIdCardNo.layer.masksToBounds = YES;
    [self.txtIdCardNo.layer setBorderColor:[UIColor colorWithHexString:@"999999"].CGColor];
    [self.txtIdCardNo.layer setBorderWidth:1];
     [self setTextFieldLeftView:self.txtIdCardNo :nil :5];
    self.txtInterest.layer.masksToBounds = YES;
    [self.txtInterest.layer setBorderColor:[UIColor colorWithHexString:@"999999"].CGColor];
    [self.txtInterest.layer setBorderWidth:1];
     [self setTextFieldLeftView:self.txtInterest :nil :5];
    self.txtHealthCardNO.layer.masksToBounds = YES;
    [self.txtHealthCardNO.layer setBorderColor:[UIColor colorWithHexString:@"999999"].CGColor];
    [self.txtHealthCardNO.layer setBorderWidth:1];
     [self setTextFieldLeftView:self.txtHealthCardNO :nil :5];
    self.introduceTextView.layer.masksToBounds = YES;
    [self.introduceTextView.layer setBorderColor:[UIColor colorWithHexString:@"999999"].CGColor];
    [self.introduceTextView.layer setBorderWidth:1];
   
    self.txtContent.layer.masksToBounds = YES;
    [self.txtContent.layer setBorderColor:[UIColor colorWithHexString:@"999999"].CGColor];
    [self.txtContent.layer setBorderWidth:1];
     [self setTextFieldLeftView:self.txtContent :nil :5];
}
-(void)previewUI{
    [self setTextFieldLeftView:self.expectationField :nil :5];
    [self setTextFieldLeftView:self.txtReferrer :nil :5];
    [self setTextFieldLeftView:self.txtName :nil :5];
    [self setTextFieldLeftView:self.txtMobile :nil :5];
    [self setTextFieldLeftView:self.txtIdCardNo :nil :5];
    [self setTextFieldLeftView:self.txtInterest :nil :5];
    [self setTextFieldLeftView:self.txtHealthCardNO :nil :5];
    [self setTextFieldLeftView:self.txtContent :nil :5];
    _eduImage.hidden = YES;
    _nationImage.hidden = YES;
    self.btnIdCardFirst.userInteractionEnabled= NO;
    self.btnIdCardSecond.userInteractionEnabled = NO;
    self.btnMajorCertificate.userInteractionEnabled = NO;
    self.btnSubmit.hidden = YES;
    self.btnSubmit.layer.masksToBounds = YES;
    self.btnSubmit.layer.cornerRadius = 4.f;
    [self.btnChooseEdu setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.btnChooseSex setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.btnChooseNation setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self.btnResume setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    self.jobScrollView.contentSize = CGSizeMake(ScreenWidth, 875);
    self.btnChooseEdu.layer.masksToBounds = YES;
    [self.btnChooseEdu.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.btnChooseEdu.layer setBorderWidth:1];
    self.btnChooseNation.layer.masksToBounds = YES;
    [self.btnChooseNation.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.btnChooseNation.layer setBorderWidth:1];
    self.expectationField.layer.masksToBounds = YES;
    [self.expectationField.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.expectationField.layer setBorderWidth:1];
    self.txtReferrer.layer.masksToBounds = YES;
    [self.txtReferrer.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.txtReferrer.layer setBorderWidth:1];
    self.txtName.layer.masksToBounds = YES;
    [self.txtName.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.txtName.layer setBorderWidth:1];
    self.txtMobile.layer.masksToBounds = YES;
    [self.txtMobile.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.txtMobile.layer setBorderWidth:1];
    self.txtIdCardNo.layer.masksToBounds = YES;
    [self.txtIdCardNo.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.txtIdCardNo.layer setBorderWidth:1];
    self.txtInterest.layer.masksToBounds = YES;
    [self.txtInterest.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.txtInterest.layer setBorderWidth:1];
    self.txtHealthCardNO.layer.masksToBounds = YES;
    [self.txtHealthCardNO.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.txtHealthCardNO.layer setBorderWidth:1];
    self.introduceTextView.layer.masksToBounds = YES;
    [self.introduceTextView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.introduceTextView.layer setBorderWidth:1];
    self.txtContent.layer.masksToBounds = YES;
    [self.txtContent.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.txtContent.layer setBorderWidth:1];
    self.sexLabel.hidden = NO;
    self.maleBtn.hidden = YES;
    self.femaleBtn.hidden = YES;
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
- (void)submitAction:(UIButton*)sender {
    [self editMyResume];

}



- (IBAction)chooseEduction:(id)sender {
    [self txtResignFirstResponder];
    JobChooseViewController *vc = [[JobChooseViewController alloc]init];

    [vc setReturnText:^(NSString *textStr,NSInteger index) {
        self.chooseEduLabel.text = textStr;
        self.chooseEduLabel.textColor = DSColorFromHex(0x4D4D4D);
        [self.btnChooseEdu setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        self.curEduIndex = index;
        self.curEduStr = textStr;
//        [self CalculateTheIntegrity];
    }];
    vc.currentSelectIndex = self.curEduIndex;
    vc.currentSelectType = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)chooseNation:(id)sender {
    [self txtResignFirstResponder];
    JobChooseViewController *vc = [[JobChooseViewController alloc]init];
    [vc setReturnText:^(NSString *textStr,NSInteger index) {
        self.chooseNationLabel.text = textStr;
        self.chooseNationLabel.textColor = DSColorFromHex(0x4D4D4D);
        [self.btnChooseNation setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
        self.curNationIndex = index;
        self.curNationStr = textStr;
//        [self CalculateTheIntegrity];
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
//        [self CalculateTheIntegrity];
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
-(void)pressBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)pressSexBtn:(UIButton*)sender {
    if (_tmpBtn == nil){
        sender.selected = YES;
        _tmpBtn = sender;
    }
    else if (_tmpBtn !=nil && _tmpBtn == sender){
       sender.selected = YES;
        
    }
    else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
    if ([sender.titleLabel.text isEqualToString:@"男"]) {
        self.curSexStr = @"1";
    }else if ([sender.titleLabel.text isEqualToString:@"女"]){
        self.curSexStr = @"0";
    }
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
            [weakSelf.btnIdCardFirst setImage:nil forState:UIControlStateNormal];
            [weakSelf.btnIdCardFirst setTitle:nil forState:UIControlStateNormal];
        }else if (weakSelf.imgType == 1){
            weakSelf.IdSecondImgUrl = model.img_url;
            [weakSelf.btnIdCardSecond setBackgroundImage:img forState:UIControlStateNormal];
            [weakSelf.btnIdCardSecond setImage:nil forState:UIControlStateNormal];
            [weakSelf.btnIdCardSecond setTitle:nil forState:UIControlStateNormal];
        }else{
            weakSelf.skillImgUrl = model.img_url;
            [weakSelf.btnMajorCertificate setBackgroundImage:img forState:UIControlStateNormal];
            [weakSelf.btnMajorCertificate setImage:nil forState:UIControlStateNormal];
            [weakSelf.btnMajorCertificate setTitle:nil forState:UIControlStateNormal];
        }
//        [self CalculateTheIntegrity];
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
//    [self CalculateTheIntegrity];
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
#pragma RequestData
///我的简历
-(void)requestData{
    self.viewModel = [[MyResumeViewModel alloc]init];
    [self.viewModel previewMyResumeToken:[self getToken]];
    __weak __typeof(&*self) weakSelf = self;
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        _resultModel = [[MyResumeModel alloc]init];
        _resultModel = returnValue;
        [weakSelf reloadData];
    } WithErrorBlock:^(id errorCode) {
        
    }];
}

-(void)editMyResume{
    self.viewModel = [[MyResumeViewModel alloc]init];
    EditMyResumeReq *req = [[EditMyResumeReq alloc]init];
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
    
    [self.imgArray removeAllObjects];
    if (self.IdFirstImgUrl.length > 1) {
        [self.imgArray addObject:self.IdFirstImgUrl];
    }
    if (self.IdSecondImgUrl.length > 1) {
        [self.imgArray addObject:self.IdSecondImgUrl];
    }
    
    req.token = [self getToken];
    req.name =  self.txtName.text;
    req.cardno = self.txtIdCardNo.text;
    req.edu = self.chooseEduLabel.text;
    req.nation = self.chooseNationLabel.text;
    req.interest = self.txtInterest.text;
    req.mobile = self.txtMobile.text;
    req.sex = [self.curSexStr integerValue];
    req.recommend_user = self.txtReferrer.text;
    req.job_name = self.txtContent.text;
    req.salary = @([self.expectationField.text integerValue]);;
    req.card_img = self.imgArray;
    req.health_no = self.txtHealthCardNO.text;
    req.skill_img = self.skillImgUrl;
    req.introduction = self.introduceTextView.text;
    [self.viewModel editMyResumeParam:req];
    __weak __typeof(&*self) weakSelf = self;
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        weakSelf.resultModel = [[MyResumeModel alloc]init];
        weakSelf.resultModel = returnValue;
         [weakSelf showJGProgressWithMsg:@"保存成功，请投递简历"];
        NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
        UserModel *userModel = [[UserModel alloc] initWithDict:userinfo];
        userModel.resume = 1;
        [UserDefaults writeUserDefaultObjectValue:[userModel dictionaryRepresentation] withKey:user_info];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } WithErrorBlock:^(id errorCode) {
        
    }];
}
-(void)reloadData{
    self.txtContent.text = _resultModel.job_name;
    self.txtReferrer.text = _resultModel.recommend_user;
    self.expectationField.text = [NSString stringWithFormat:@"%@",_resultModel.salary];
    self.txtName.text = _resultModel.name;
    self.txtMobile.text  = _resultModel.mobile;
    self.txtIdCardNo.text = _resultModel.cardno;
    self.txtInterest.text = _resultModel.interest;
    self.chooseNationLabel.text = _resultModel.nation;
    self.chooseEduLabel.text = _resultModel.edu;
    if (_resultModel.nation.length>0) {
        self.chooseNationLabel.textColor = DSColorFromHex(0x4D4D4D);
    }
    if (_resultModel.edu.length>0) {
         self.chooseEduLabel.textColor = DSColorFromHex(0x4D4D4D);
    }
    self.txtHealthCardNO.text = _resultModel.health_no;
    self.introduceTextView.text = _resultModel.introduction;
    if (_resultModel.sex==0) {
        self.femaleBtn.selected = YES;
        _tmpBtn = self.femaleBtn;
        self.sexLabel.text = @"女";
        self.curSexStr= @"0";
    }else if (_resultModel.sex ==1){
        _tmpBtn = self.maleBtn;
        self.maleBtn.selected=YES;
        self.sexLabel.text = @"男";
        self.curSexStr = @"1";
    }
    
    if (_resultModel.card_img.count ==1) {
                [self.btnIdCardFirst setImage:nil forState:UIControlStateNormal];
                [self.btnIdCardFirst setTitle:nil forState:UIControlStateNormal];
        NSURL *url = [[NSURL alloc] init];
        if([_resultModel.card_img[0] rangeOfString:@"http"].location !=NSNotFound)//_roaldSearchText
        {
            url = [NSURL URLWithString:_resultModel.card_img[0]];
            
        }
        else
        {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,_resultModel.card_img[0]]];
            
        }
        self.IdFirstImgUrl = _resultModel.card_img[0];
   [self.btnIdCardFirst sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];

    }else if (_resultModel.card_img.count ==2){
        [self.imgArray removeAllObjects];
        [self.imgArray addObjectsFromArray:_resultModel.card_img];
       NSURL *url = [[NSURL alloc] init];
        if([_resultModel.card_img[0] rangeOfString:@"http"].location !=NSNotFound)//_roaldSearchText
        {
            url = [NSURL URLWithString:_resultModel.card_img[0]];
            
        }
        else
        {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,_resultModel.card_img[0]]];
            
        }
        
        [self.btnIdCardFirst sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
      
        [self.btnIdCardFirst setImage:nil forState:UIControlStateNormal];
        [self.btnIdCardFirst setTitle:nil forState:UIControlStateNormal];
        NSURL *url2 = [[NSURL alloc] init];
        if([_resultModel.card_img[1] rangeOfString:@"http"].location !=NSNotFound)//_roaldSearchText
        {
            url2 = [NSURL URLWithString:_resultModel.card_img[1]];
            
        }
        else
        {
            url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,_resultModel.card_img[1]]];
            
        }
        [self.btnIdCardSecond sd_setBackgroundImageWithURL:url2 forState:UIControlStateNormal];
        [self.btnIdCardSecond setImage:nil forState:UIControlStateNormal];
        [self.btnIdCardSecond setTitle:nil forState:UIControlStateNormal];
         self.IdFirstImgUrl = _resultModel.card_img[0];
         self.IdSecondImgUrl = _resultModel.card_img[1];
    }else{
        if (self.resumeType ==ResumeTypePreview) {
            self.btnIdCardFirst.hidden = YES;
            self.btnIdCardSecond.hidden = YES;
        }
    }
    if (_resultModel.skill_img.length>0) {
        NSURL *url = [[NSURL alloc] init];
        if([_resultModel.skill_img rangeOfString:@"http"].location !=NSNotFound)//_roaldSearchText
        {
            url = [NSURL URLWithString:_resultModel.skill_img];
            
        }
        else
        {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,_resultModel.skill_img]];
            
        }
        self.skillImgUrl = _resultModel.skill_img;
        [self.btnMajorCertificate setImage:nil forState:UIControlStateNormal];
        [self.btnMajorCertificate setTitle:nil forState:UIControlStateNormal];
        [self.btnMajorCertificate sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
    }else{
        if (self.resumeType ==ResumeTypePreview) {
            self.btnMajorCertificate.hidden = YES;
        }
    }
    
}
@end
