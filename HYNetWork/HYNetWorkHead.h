//
//  HYNetWorkHead.h
//  zhongchuan
//
//  Created by yanghao on 9/7/16.
//  Copyright © 2016 huying. All rights reserved.
//

#ifndef HYNetWorkHead_h
#define HYNetWorkHead_h
#define CODE_SUCCESS                        200

//基础接口网址
#define BaseUrl                                 @"http://47.92.83.233:3389/"
//#define BaseUrl                                 @"http://47.92.83.233:8888/"
//#define BaseUrl                                 @"http://47.92.83.233/"

//图片地址
#define img_path                                @"http://mgr.idianjiwang.com/"


/**
 *  自定义宏
 */
//用户信息
#define user_info                               @"user_info"

//token
#define user_token                              @"user_token"

//基础数据
#define base_data                               @"base_data"
//获取基础数据
#define url_base_data                           @"index.php/index/index/indexData"
/******************************** 接口地址 ********************************/
/**
 *  登录、注册、忘记密码
 */

//登录
#define url_user_login                          @"index.php/index/user/login"
//退出登录
#define url_user_logout                         @"index.php/index/index/logout"
//登录
#define url_user_register                       @"index.php/index/user/register"
//验证码
#define url_user_verification_code              @"index.php/index/index/mobileCode"
//忘记密码
#define url_user_forgot_pwd                     @"index.php/index/user/forgotPwd"



/**
 *  首页
 */
//首页数据
#define url_home_data                           @"index.php/index/index/index"
//资讯列表
#define url_home_info_list                      @"index.php/index/index/articleList"
//上传图片
#define url_upload_img                          @"index.php/index/index/uploadImg"


/*员工福利*/
//福利首页数据
#define url_welfare_data                        @"index.php/index/welfare/index"
//福利信息列表
#define url_welfare_article                     @"index.php/index/welfare/articleList"
//兑换物品列表
#define url_welfare_goods_list                  @"index.php/index/welfare/receiveGoods"
//兑换物品首页
#define url_welfare_convert_list                @"index.php/index/welfare/receiveGoodsIndex"
//兑换物品首页
#define url_welfare_convert                     @"index.php/index/welfare/exchange"
//积分商品详情
#define url_welfare_goods_detail                @"index.php/index/goods/pointGoodsDetail"


/*员工牵手*/

//首页
#define url_worker_hand_in_hand_home            @"index.php/index/fate/index"
//相亲员工列表
#define url_worker_hand_in_list                 @"index.php/index/fate/fateList"
//相亲人员详情
#define url_worker_hand_in_detail               @"index.php/index/fate/info"
//我的相亲详情
#define url_worker_hand_in_myfateinfo               @"index.php/index/fate/myFateInfo"
//发布个人信息
#define url_worker_hand_in_addfate              @"index.php/index/fate/addFate"
//租缘吧
#define url_worker_rent_list                    @"index.php/index/rent/index"
//获取我的形象照片
#define url_worker_rent_myownimg                  @"index.php/index/rent/myShowImg"
//设置为封面图片
#define url_worker_rent_showimg                  @"index.php/index/rent/showMyImg"
//发布个人形象照片
#define url_worker_rent_ownimg                  @"index.php/index/rent/showImg"
//添加个人技能
#define url_worker_rent_add_skill               @"index.php/index/rent/addSkill"
//提交出租范围
#define url_worker_rent_range                   @"index.php/index/rent/rentRange"
//获取个人出租范围
#define url_worker_rent_ownrange                @"index.php/index/rent/range"
//获取未设置价格技能
#define url_worker_rent_range_skill             @"index.php/index/rent/rangeSkill"
//获取出租人信息
#define url_worker_rent_rentinfo                @"index.php/index/rent/rentInfo"
//获取粉丝列表
#define url_worker_rent_fanslist                @"index.php/index/rent/rentFollow"
//关注/取关
#define url_worker_rent_follow                  @"index.php/index/rent/follow"
//添加好友
#define url_worker_rent_addfriend               @"index.php/index/friend/add"
//马上租他获取技能列表
#define url_worker_rent_rentskill               @"index.php/index/rent/rentSkill"
//我的租赁
#define url_worker_rent_myrent                  @"index.php/index/rent/myRent"
//马上租他
#define url_worker_rent_order                   @"index.php/index/rent/order"
//我的租赁订单
#define url_worker_rent_myrentorder             @"index.php/index/rent/myRentOrder"
//租赁订单详情
#define url_worker_rent_orderdetail             @"index.php/index/rent/orderInfo"
//处理订单
#define url_worker_rent_arrangerent             @"index.php/index/rent/arrangeRent"
//取消订单
#define url_worker_rent_cancel_order            @"index.php/index/rent/cancel"
//用户评价
#define url_worker_rent_userremark              @"index.php/index/rent/rentJudgeUser"
//被租人评价
#define url_worker_rent_remarkuser              @"index.php/index/rent/rentJudge"
//常用标签
#define url_worker_rent_usertag                 @"index.php/index/rent/userTag"
//设置常用标签
#define url_worker_rent_mytag                   @"index.php/index/rent/myTag"
//确认见面
#define url_worker_rent_meet                    @"index.php/index/rent/meet"
//提出未见面
#define url_worker_rent_rentdissent             @"index.php/index/rent/rentDissent"
//提出异议
#define url_worker_rent_userdissent             @"index.php/index/rent/userDissent"




/*员工创业*/
//员工创业首页
#define url_worker_business_home                @"index.php/index/Employee/index"
//员工创业资讯列表
#define url_worker_business_list                @"index.php/index/Employee/informationList"
//员工创业伙伴列表
#define url_worker_business_parter              @"index.php/index/Employee/cooperativeList"

/*员工求职*/
//员工求职首页
#define url_worker_job_home                     @"index.php/index/job/index"
//求职工作详情
#define url_worker_job_detail                   @"index.php/index/job/detail"
//求职搜索
#define url_worker_job_jobSearch                @"index.php/index/job/jobSearch"
//编辑简历
#define url_worker_job_resume                   @"index.php/index/job/resume"
//求职(职位分类)
#define url_worker_job_jobList                  @"index.php/index/job/jobList"
//投递简历
#define url_worker_job_applyFor                 @"index.php/index/job/applyFor"
//我的简历
#define url_worker_job_myresume                 @"index.php/index/job/myResume"
//我的简历
#define url_worker_job_myapplication            @"index.php/index/job/myApplication"
//我的应聘详情
#define url_worker_job_applicationInfo          @"index.php/index/job/applicationInfo"

/*员工关怀*/
//员工关怀首页
#define url_worker_food_careIndex               @"index.php/index/food/careIndex"
//衣食住行列表
#define url_worker_food_carelist                @"index.php/index/food/careList"
//员工餐饮
#define url_worker_food_index                   @"index.php/index/food/index"
//员工住宿
#define url_worker_room_index                    @"index.php/index/room/index"
//员工购物首页
#define url_worker_store_index                   @"index.php/index/store/index"
//店铺列表
#define url_worker_store_list                   @"index.php/index/store/storeList"
//店铺详情
#define url_worker_store_info                   @"index.php/index/store/storeInfo"
//商品详情
#define url_worker_goods_info                   @"index.php/index/goods/goodsDetail"
//商品规格详情
#define url_worker_goods_property_info          @"index.php/index/goods/propertyDetail"
//商品评价
#define url_worker_goods_remark                   @"index.php/index/goods/goodsInfoScore"
//搜索商品
#define url_worker_goods_search                   @"index.php/index/goods/searchGoods"
//店铺分类列表
#define url_worker_goods_list                   @"index.php/index/store/goodsList"



/**
 *  消息
 */





/**
 *  通讯录
 */






/**
 *  朋友圈
 */
//发布朋友圈

#define url_firend_circle_release               @"index.php/index/friend/announce"
//朋友圈
#define url_friend_circle                       @"index.php/index/friend/friendCircle"
//个人朋友圈
#define url_user_friend_circle                  @"index.php/index/friend/userCircle"
//点赞
#define url_user_friend_agree                   @"index.php/index/friend/agree"
//评论
#define url_user_friend_discuss                 @"index.php/index/friend/discuss"
//删除评论
#define url_user_friend_deldiscuss              @"index.php/index/friend/delDiscuss"
//删除朋友圈
#define url_user_friend_delcircle               @"index.php/index/friend/delCircle"
//设置朋友圈封面
#define url_user_friend_showImg               @"index.php/index/friend/showImg"
//获取朋友圈封面
#define url_user_friend_getShowImg               @"index.php/index/friend/getShowImg"
//处理好友申请
#define url_user_friend_apply                   @"index.php/index/friend/disposeApplyFriend"
//查找用户
#define url_user_search_user                    @"index.php/index/friend/searchFriend"
//好友申请列表
#define url_user_friend_applylist               @"index.php/index/friend/applyList"
//通讯录
#define url_user_friend_friendlist              @"index.php/index/friend/friendList"
//通过手机号码添加好友
#define url_user_friend_addbymobile             @"index.php/index/friend/addByMobile"
//删除好友
#define url_user_friend_delfriend               @"index.php/index/friend/delFriend"
//设置备注
#define url_user_friend_setremark               @"index.php/index/friend/setRemark"
//删除好友申请
#define url_user_friend_delapply                @"index.php/index/friend/delAPPly"
//通过手机号码获取用户信息
#define url_user_friend_infobymobile             @"index.php/index/friend/infoByMobile"
//通过id获取用户信息
#define url_user_friend_infobyid                 @"index.php/index/user/userInfo"

/**
 *  我的
 */

/*用户*/
//用户信息
#define url_mine_infomation                    @"index.php/index/user/userDetails"
//好友用户信息
#define url_friend_infomation                  @"index.php/index/user/userInfo"
//签到
#define url_mine_user_sign                      @"index.php/index/user/sign"
//修改签名
#define url_mine_user_signature                @"index.php/index/user/modifySignature"
//查询用户等级
#define url_mine_user_grade                    @"index.php/index/user/queryActive"
//更新用户信息
#define url_mine_user_update                   @"index.php/index/user/update"
//我的团队
#define url_mine_user_myteam                   @"index.php/index/user/myTeam"
//我的团队成员
#define url_mine_user_mobileteam               @"index.php/index/user/mobileTeam"
//邀请好友记录
#define url_mine_user_friendamount             @"index.php/index/user/friendAmount"
//我的客服
#define url_mine_user_service                  @"index.php/index/index/customerService"
/*设置*/
//绑定邮箱
#define url_mine_set_mail                      @"index.php/index/user/bindingEamil"
//修改手机号
#define url_mine_set_mobile                    @"index.php/index/user/updateMobile"
//获取邮箱验证码
#define url_set_verification_code               @"index.php/index/user/emailCode"
//修改密码
#define url_set_change_password                 @"index.php/index/user/updatePwd"
//提交用户认证信息
#define url_set_vertification                   @"index.php/index/user/authentication"
//获取用户认证信息
#define url_mine_auth_info                      @"index.php/index/user/authInfo"
//我的优惠券
#define url_my_coupon                           @"index.php/index/Coupon/mycoupon"
//领取优惠券
#define url_get_coupon                          @"index.php/index/Coupon/receive"
//使用优惠券
#define url_use_coupon                          @"index.php/index/Coupon/apply"
//意见反馈
#define url_user_feed_back                      @"index.php/index/index/feedback"
/*钱包*/
//
#define url_mine_wallet                        @"index.php/index/finance/wallet"
//添加银行卡
#define url_mine_add_bank                      @"index.php/index/finance/addBank"
//获取银行卡列表
#define url_mine_bank_list                     @"index.php/index/finance/bankList"
//我的银行卡
#define url_mine_bankcard                      @"index.php/index/finance/bankCard"
//余额提现
#define url_mine_withdraw                      @"index.php/index/finance/withdrawal"
//交易记录
#define url_mine_sale_record                   @"index.php/index/finance/transactionRecord"
//提现记录
#define url_mine_withdraw_record               @"index.php/index/finance/cashRegister"
//我的积分
#define url_mine_integral_record               @"index.php/index/finance/IntegralRecord"
//我的积分
#define url_mine_bank_bankInfo                 @"index.php/index/finance/bankInfo"
//我的积分
#define url_mine_bank_delete                   @"index.php/index/finance/delBank"
//我的奖励
#define url_mine_myreward                      @"index.php/index/finance/myReward"
//我的奖励记录
#define url_mine_reward                        @"index.php/index/finance/reward"
//我的聚友值奖励
#define url_mine_friend_amount                 @"index.php/index/finance/friendCoin"
//商品支付
#define url_order_goodspay                     @"index.php/index/finance/goodsPay"
//租缘订单支付
#define url_order_rent_goodspay                @"index.php/index/finance/rentPay"
//租缘订单支付
#define url_user_wallet_recharge               @"index.php/index/finance/recharge"
//系统消息
#define url_mine_system_msg                    @"index.php/index/index/sysMsg"
//删除系统消息
#define url_mine_system_msg_del                @"index.php/index/index/delMsg"

/*收藏*/
//收藏//取消收藏
#define url_mine_collect                       @"index.php/index/collect/enshrine"
//我的收藏
#define url_mine_collect_list                  @"index.php/index/collect/collectionList"
//批量删除收藏
#define url_mine_collect_delete                @"index.php/index/collect/delEnshrine"
//是否收藏
#define url_mine_article_iscollect             @"index.php/index/collect/isCollect"
/*购物车*/
//加入购物车
#define url_mine_add_car                       @"index.php/index/shop/addShop"
//我的购物车
#define url_mine_shopping_car                  @"index.php/index/shop/myShop"
//删除购物车
#define url_mine_shopping_car_delete           @"index.php/index/shop/delShop"
//修改购物车数量
#define url_mine_shopping_car_update           @"index.php/index/shop/updateShop"
//修改购物车状态
#define url_mine_shopping_car_check            @"index.php/index/shop/checkShop"
/*收货地址*/
//新增收货地址
#define url_mine_add_address                   @"index.php/index/order/addAddress"
//新增收货地址
#define url_mine_address_list                  @"index.php/index/order/addressList"
//设置默认收货地址
#define url_mine_address_default               @"index.php/index/order/defAddress"
//删除收货地址
#define url_mine_address_delete                @"index.php/index/order/delAddress"
//删除收货地址
#define url_mine_address_update                @"index.php/index/order/updateAddress"
//删除收货地址
#define url_mine_address_mydefault             @"index.php/index/order/myDefAddress"


/*我的订单*/
//立即购买添加订单
#define url_mine_order_addOrder                @"index.php/index/order/addOrder"
//从购物车添加订单
#define url_mine_order_addShopOrder            @"index.php/index/order/addShopOrder"
//确认订单
#define url_mine_confirm_order                 @"index.php/index/order/confirmOrder"
//我的订单列表
#define url_mine_order_list                    @"index.php/index/order/goodsOrderList"
//我的积分订单列表
#define url_mine_score_order_list              @"index.php/index/order/pointOrderList"
//取消订单
#define url_cancel_order                       @"index.php/index/order/delOrder"
//普通商品订单详情
#define url_order_detail                       @"index.php/index/order/orderInfo"
//积分订单详情
#define url_score_order_detail                 @"index.php/index/order/orderPointInfo"
//商品订单支付
#define url_order_pay                          @"index.php/index/finance/goodsPay"
//确认收货
#define url_confirm_get                        @"index.php/index/order/receipt"
//订单评价
#define url_order_comment                      @"index.php/index/order/judge"
//再次购买
#define url_buy_again                          @"index.php/index/shop/againOrder"
//退款原因
#define url_refund_reason                      @"index.php/index/order/returnReason"
//申请退款
#define url_apply_refund                       @"index.php/index/order/goodsReturn"
//再次申请退款
#define url_apply_refund_once                  @"index.php/index/order/refundOnce"
//退款订单获取价格
#define url_order_refund_price                 @"index.php/index/order/refundPrice"
//领取积分商品
#define url_order_get_goods                    @"index.php/index/order/receivePointGoods"

#endif /* HYNetWorkHead_h */
