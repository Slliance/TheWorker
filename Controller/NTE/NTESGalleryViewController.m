//
//  NTESGalleryViewController.m
//  NIMDemo
//
//  Created by ght on 15-2-3.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESGalleryViewController.h"
#import "UIImageView+WebCache.h"
#import "UIView+NTES.h"
#import "NTESSessionUtil.h"
#import "UIView+Toast.h"
#import "NTESMediaPreviewViewController.h"

@implementation NTESGalleryItem
@end


@interface NTESGalleryViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *galleryImageView;
@property (nonatomic,strong)    NTESGalleryItem *currentItem;
@property (nonatomic,strong)    NIMSession *session;
@end

@implementation NTESGalleryViewController

- (instancetype)initWithItem:(NTESGalleryItem *)item session:(NIMSession *)session
{
    if (self = [super initWithNibName:@"NTESGalleryViewController"
                               bundle:nil])
    {
        _currentItem = item;
        _session = session;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _galleryImageView.contentMode = UIViewContentModeScaleAspectFit;
    NSURL *url = [NSURL URLWithString:_currentItem.imageURL];
    [_galleryImageView sd_setImageWithURL:url
                         placeholderImage:[UIImage imageWithContentsOfFile:_currentItem.thumbPath]
                                  options:SDWebImageRetryFailed];
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_galleryImageView addGestureRecognizer:ges];
    


}
-(void)rightBarButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tapAction:(UITapGestureRecognizer *)ges{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupRightNavItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(onMore:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"icon_gallery_more_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_gallery_more_pressed"] forState:UIControlStateHighlighted];
    [button sizeToFit];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
}


- (void)onMore:(id)sender
{
    NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc] init];
    option.limit = 0;
    option.messageTypes = @[@(NIMMessageTypeImage),@(NIMMessageTypeVideo)];
    __weak typeof(self) weakSelf = self;
    [[NIMSDK sharedSDK].conversationManager searchMessages:self.session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        if (weakSelf)
        {
            NSMutableArray *objects = [[NSMutableArray alloc] init];
            NTESMediaPreviewObject *focusObject;
            
            //显示的时候新的在前老的在后，逆序排列
            //如果需要微信的显示顺序，则直接将这段代码去掉即可
            NSArray *array = messages.reverseObjectEnumerator.allObjects;
            
            for (NIMMessage *message in array)
            {
                switch (message.messageType) {
                    case NIMMessageTypeVideo:{
                        NTESMediaPreviewObject *object = [weakSelf previewObjectByVideo:message.messageObject];
                        [objects addObject:object];
                        break;
                    }
                    case NIMMessageTypeImage:{
                        NTESMediaPreviewObject *object = [weakSelf previewObjectByImage:message.messageObject];
                        //图片 thumbPath 一致，就认为是本次浏览的图片
                        if ([message.messageId isEqualToString:weakSelf.currentItem.itemId])
                        {
                            focusObject = object;
                        }
                        [objects addObject:object];
                        break;
                    }
                    default:
                        break;
                }
            }
            NTESMediaPreviewViewController *vc = [[NTESMediaPreviewViewController alloc] initWithPriviewObjects:objects focusObject:focusObject];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }        
    }];
    
}

- (NTESMediaPreviewObject *)previewObjectByVideo:(NIMVideoObject *)object
{
    NTESMediaPreviewObject *previewObject = [[NTESMediaPreviewObject alloc] init];
    previewObject.objectId  = object.message.messageId;
    previewObject.thumbPath = object.coverPath;
    previewObject.thumbUrl  = object.coverUrl;
    previewObject.path      = object.path;
    previewObject.url       = object.url;
    previewObject.type      = NTESMediaPreviewTypeVideo;
    previewObject.timestamp = object.message.timestamp;
    previewObject.displayName = object.displayName;
    previewObject.duration  = object.duration;
    return previewObject;
}

- (NTESMediaPreviewObject *)previewObjectByImage:(NIMImageObject *)object
{
    NTESMediaPreviewObject *previewObject = [[NTESMediaPreviewObject alloc] init];
    previewObject.objectId = object.message.messageId;
    previewObject.thumbPath = object.thumbPath;
    previewObject.thumbUrl  = object.thumbUrl;
    previewObject.path      = object.path;
    previewObject.url       = object.url;
    previewObject.type      = NTESMediaPreviewTypeImage;
    previewObject.timestamp = object.message.timestamp;
    previewObject.displayName = object.displayName;
    return previewObject;
}

@end




@interface SingleSnapView : UIImageView

@property (nonatomic,strong) UIProgressView *progressView;

@property (nonatomic,copy)   NIMCustomObject *messageObject;

- (instancetype)initWithFrame:(CGRect)frame messageObject:(NIMCustomObject *)object;

- (void)setProgress:(CGFloat)progress;

@end


@implementation  NTESGalleryViewController(SingleView)


+ (void)downloadImage:(NSString *)url imageView:(SingleSnapView *)imageView{
    __weak typeof(imageView) wImageView = imageView;    
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        dispatch_async_main_safe(^{
            wImageView.progress = (CGFloat)receivedSize / expectedSize;
        });
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            [wImageView makeToast:@"下载图片失败"
                         duration:2
                         position:CSToastPositionCenter];
        }else{
            wImageView.progress = 1.0;
        }
    }];
}

@end


@implementation SingleSnapView

- (instancetype)initWithFrame:(CGRect)frame messageObject:(NIMCustomObject *)object{
    self = [super initWithFrame:frame];
    if (self) {
        _messageObject = object;
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
        CGFloat width = 200.f * UISreenWidthScale;
        _progressView.width = width;
        _progressView.hidden = YES;
        [self addSubview:_progressView];
        
    }
    return self;
}

- (void)setProgress:(CGFloat)progress{
    [self.progressView setProgress:progress];
    [self.progressView setHidden:progress>0.99];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.progressView.centerY = self.height *.5;
    self.progressView.centerX = self.width  *.5;
}


@end
