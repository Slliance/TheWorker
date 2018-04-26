//
//  ApplyRefundViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/4.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ApplyRefundViewController.h"
#import "OrderViewModel.h"
#import "H_Single_PickerView.h"
#import "RefundReasonModel.h"
#import "UploadImgViewModel.h"
#import "PicModel.h"

@interface ApplyRefundViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,H_Single_PickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *imageBgView;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (weak, nonatomic) IBOutlet UIButton *refundReasonBtn;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UITextView *txtView;
@property (nonatomic, retain) OrderViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,copy) NSString *refundStr;
@property (nonatomic, retain) NSMutableArray *imgIdArr;
@end

@implementation ApplyRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageArray = [[NSMutableArray alloc]init];
    self.imgIdArr = [[NSMutableArray alloc]init];
    [self.imageArray addObject:@(1)];
    [self.refundReasonBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
    [self initView];
    [self.mainScrollView setContentSize:CGSizeMake(ScreenWidth, 610)];
    if (self.type == 1) {
        self.labelPrice.text = [NSString stringWithFormat:@"%.2f元",[self.storeModel.price floatValue] * [self.storeModel.goods_number floatValue]];
    }
    else{
        self.labelPrice.text = [NSString stringWithFormat:@"%.2f元",[self.model.refund_price floatValue]];
//        self.labelPrice.text = [NSString stringWithFormat:@"%.2f元",[self.model.price floatValue] - [self.model.trans_price floatValue]];
    }
    __weak typeof (self)weakSelf = self;
    self.viewModel = [[OrderViewModel alloc] init];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        
        
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)commit:(id)sender {
    if (!self.refundStr) {
        [self showJGProgressWithMsg:@"请选择退款原因！"];
        return;
    }
    
    __weak typeof (self)weakSelf = self;
    OrderViewModel *viewModel = [[OrderViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [weakSelf showJGProgressWithMsg:@"提交成功"];
        weakSelf.finishBlock();
        [weakSelf backAction:nil];
        
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    
    if (self.applyOnce) {
        
        [viewModel applyOnceRefund:self.model.order_id
                             token:[self getToken]
                       user_reason:self.refundStr
                            remark:self.txtView.text
                               img:self.imgIdArr
                              type:self.type];
    }
    else{
        [viewModel applyRefund:self.type == 1 ? self.storeModel.order_id : self.model.order_id
                         token:[self getToken]
                   user_reason:self.refundStr
                        remark:self.txtView.text
                           img:self.imgIdArr
                          type:self.type];
    }
    
}

- (IBAction)refundReasonAction:(id)sender {
    
    
    __weak typeof (self)weakSelf = self;
    OrderViewModel *viewModel = [[OrderViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i = 0; i < [returnValue count]; i ++) {
            RefundReasonModel *model = (RefundReasonModel *)returnValue[i];
            [arr addObject:@{@"name": model.reason,@"Id":@""}];
        }
        H_Single_PickerView *single = [[H_Single_PickerView alloc] initWithFrame:self.view.bounds arr:arr];
        single.delegate = weakSelf;
        [self.view addSubview:single];
        
        
    } WithErrorBlock:^(id errorCode) {
        [weakSelf showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchRefundReason:[self getToken]];
    
    
    
}

-(void)chooseImageAction{
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
        [weakSelf.imgIdArr addObject:model.img_url];
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
        [self uploadImgToService:image];
        [weakSelf initView];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)initView{
    for (UIView *subview in self.imageBgView.subviews) {
        if (subview.tag > 800) {
            [subview removeFromSuperview];
        }
    }
    
    CGFloat w = (ScreenWidth - 40 ) / 3;
    CGFloat sw = ScreenWidth / 3;
    //    self.imageBgView.contentSize = CGSizeMake(ScreenWidth, sw*(self.imageArray.count-1)/3+sw);
    
    for (int i = 0; i < self.imageArray.count; i ++) {
        if (i == 3) {
            break;
        }
        
        if (i == self.imageArray.count - 1) {
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(10*(i%3+1)+i % 3 * w, 10*(i/3+1)+i / 3 * w, w, w)];
            backview.tag = 801 + i;
            
            
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addBtn.frame = CGRectMake(0, 0, w, w);
            [addBtn setBackgroundImage:[UIImage imageNamed:@"icon_upload_picture"] forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(chooseImageAction) forControlEvents:UIControlEventTouchUpInside];
            [backview addSubview:addBtn];
            
            
            [self.imageBgView addSubview:backview];
            
        }
        else{
            
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(10*(i%3+1)+i % 3 * w, 10*(i/3+1)+i / 3 * w, w, w)];
            backview.tag = 801 + i;
            backview.backgroundColor = [UIColor blueColor];
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, w, w )];
            [imgview setImage:self.imageArray[i + 1]];
            [backview addSubview:imgview];
            
            
            UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //            [delBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 44 - 30, 44 - 12, 0)];
            delBtn.frame = CGRectMake(backview.frame.origin.x + backview.frame.size.width - 22, backview.frame.origin.y - 22, 44, 44);
            [delBtn setImage:[UIImage imageNamed:@"icon_cancel1"] forState:UIControlStateNormal];
            delBtn.tag = 801 + i ;
            [delBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.imageBgView addSubview:backview];
            [self.imageBgView addSubview:delBtn];
            
        }
        
    }
    
}


-(void)deleteAction:(UIButton *)btn{
    [self.imageArray removeObjectAtIndex:btn.tag - 800];
    [self.imgIdArr removeObjectAtIndex:btn.tag - 800-1];
    
    [self initView];
    //    [self imageBgView];
}

#pragma mark - H_Single_PickerViewDelegate

-(void)SinglePickergetObjectWithArr:(H_Single_PickerView *)_h_Single_PickerView arr:(NSArray *)_arr index:(NSInteger)_index chooseStr:(NSString *)chooseStr chooseId:(NSNumber *)chooseId{
    self.refundStr = chooseStr;
    [self.refundReasonBtn setTitle:chooseStr forState:UIControlStateNormal];
    [self.refundReasonBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5.f];
}
@end
