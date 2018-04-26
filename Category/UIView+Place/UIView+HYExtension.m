//
//  UIView+HYExtension.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/11/18.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "UIView+HYExtension.h"
#import "GoodsDetailViewController.h"
#import "CareGoodsDetailsViewController.h"
#import "InfoDetailViewController.h"
#import "BannerWebViewController.h"
#import "ShopListDetailViewController.h"
#import "WorkerDetailViewController.h"
#import "WelfareViewController.h"
@implementation UIView (HYExtension)
-(void)bannerSkipActionWithModel:(BannerModel *)model skipVC:(HYBaseViewController *)skipVC{
  
    switch ([model.type integerValue]) {
        case 0:
            if (model.url.length > 5) {
                BannerWebViewController *vc = [[BannerWebViewController alloc]init];
                vc.bannerUrl = model.url;
                vc.hidesBottomBarWhenPushed = YES;
                [skipVC.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 1:
            if (model.relation_id.length > 0) {
                GoodsDetailViewController *vc = [[GoodsDetailViewController alloc]init];
                vc.goodsId = model.relation_id;
                vc.hidesBottomBarWhenPushed = YES;
                [skipVC.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 2:
            if (model.relation_id.length > 0) {
                CareGoodsDetailsViewController *vc = [[CareGoodsDetailsViewController alloc]init];
                vc.goodsId = model.relation_id;
                vc.hidesBottomBarWhenPushed = YES;
                [skipVC.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 3:
            if (model.relation_id.length > 0) {
                ShopListDetailViewController *vc = [[ShopListDetailViewController alloc]init];
                vc.storeId = model.relation_id;
                vc.hidesBottomBarWhenPushed = YES;
                [skipVC.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 4:
            if (model.relation_id.length > 0) {
                WorkerDetailViewController *vc = [[WorkerDetailViewController alloc]init];
                vc.handInId = model.relation_id;
                vc.hidesBottomBarWhenPushed = YES;
                [skipVC.navigationController pushViewController:vc animated:YES];
            }
            break;
        default:
            break;
    }
}
@end
