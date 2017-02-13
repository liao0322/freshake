
//  Http.h
//  InformPub
//
//  Created by Linf on 1%@/6/8.
//  Copyright (c) 2015年 Linf. All rights reserved.
//

#ifndef Shop_Http_h
#define Shop_Http_h

//域名
#define HTTP_TEST_TYPE 2

#if HTTP_TEST_TYPE == 0

#define LMMC(name) [NSString stringWithFormat:@"http://p2na.freshake.cn/%@", name]   // 测试环境 9970

#elif HTTP_TEST_TYPE == 1
#define LMMC(name) [NSString stringWithFormat:@"http://h5.freshake.cn/%@", name]   // 运营环境

#elif HTTP_TEST_TYPE == 2
//#define LMMC(name) [NSString stringWithFormat:@"http://h5.p2na.com/%@", name]     // 开发环境
//#define LMMC(name) [NSString stringWithFormat:@"http://192.168.1.147:7100/%@", name]     // 开发环境
#define LMMC(name) [NSString stringWithFormat:@"http://122.144.136.72:9970/%@", name]
#endif

#define Path(name) [NSString stringWithFormat:@"api/Phone/Fifth/index.aspx?page=%@", name]     // 路径

// 首页
#define HOMEPAGEURL LMMC(Path(@"GetIndex&mid=%@&pageIndex=1&pagesize=1000"))
#define HomePageGoodsList LMMC(Path(@"GetProductList&mid=%@&pageIndex=1&pagesize=1000&upselling=1&userId=%@&recommended=1"))

// 支付回调地址
#define ALIPAYURL LMMC(@"ShopWeb/Alipay/notify_url.aspx")

// 新品与促销
#define GETPRUCTLIST LMMC(Path(@"GetProductList&categoryId=&recommended=&productName=&pageIndex=1&pagesize=1000&mid=%@&upselling=1&userId=%@&specialOffer=%@&latest=%@"))

// 类别
#define CLASSIFYURL LMMC(Path(@"GetProduct&mid=%@&pageIndex=1&pagesize=1000&upselling=1&userId=%@"))

// 单类别
#define PUSHCLASSIFYURL LMMC(Path(@"GetProduct&mid=%@&pageIndex=1&pagesize=1000&categoryId=%zd&upselling=1&userId=%@"))

#define GETCODE LMMC(Path(@"GetCode&Phone=%@&type=%@"))

//注册获取验证码
#define GETCODER LMMC(Path(@"GetIsUserName&strName=%@&type=%@"))

//普通登录//快捷登录
#define ZLLOGIN LMMC(Path(@"ZLLogin&phone=%@&pwd=%@&type=%d"))

//注册
#define REGISTER LMMC(Path(@"GetZLLRegistered&phone=%@&pwd=%@&code=%@"))

//商品详情
#define GETPRODUCTINFO LMMC(Path(@"GetProductInfo&ProductId=%@&userId=%@"))

//商品详情图片
#define RODUCTINFOPIC LMMC(@"")

// 商品详情加入购物车
#define ADDSHOPPINGART LMMC(Path(@"AddCart&productId=%zd&openid=%@&wid=%zd&telphone=%@&address=%@&totPrice=%@&productNum=%zd&mid=%@&storeId=%@"))

// 删除购物车商品（购物车）
#define DELCartGoods LMMC(Path(@"DelCart&id=%@"))

// 添加购物车
#define ADDCARTURL LMMC(Path(@"AddCart&productId=%@&openid=%@&wid=%@&totPrice=%@&productNum=%@&mid=%@&storeId=%@"))

// 删除购物车
#define DelCartUrl LMMC(Path(@"DelCart&openid=%@&mid=%@&productId=%@&userId=%@"))

// 更新购物车数量
#define UpCart LMMC(Path(@"UpCart&openid=%@&mid=%@&productId=%@&userId=%@&num=%@&type=%@"))

//我的订单
#define ORDER LMMC(Path(@"GetMyOrderList&pageIndex=%d&pageSize=%d&userId=%@&orderBy=0"))

//待支付
#define WAITPAY LMMC(Path(@"GetMyOrderList&pageIndex=%d&pageSize=%d&userId=%@&isPay=1&state=1&orderBy=0"))

//待提货
#define SHIPED LMMC(Path(@"GetMyOrderList&pageIndex=%d&pageSize=%d&userId=%@&state=2&orderBy=1"))

//待评价
#define WAITCOMMENT LMMC(Path(@"GetMyOrderList&pageIndex=%d&pageSize=%d&userId=%@&state=3&isReview=1&orderBy=3"))

//已完成
#define FINISHED LMMC(Path(@"GetMyOrderList&pageIndex=%d&pageSize=%d&userId=%@&state=3&orderBy=3"))

// 订单评价列表
#define GetProductReview LMMC(Path(@"GetProductReview&userId=%@&orderId=%d&pageIndex=1&pageSize=1000"))

//获取门店地址
#define STOREADDRESS LMMC(Path(@"GetUserStore&user_id=%zd&pageIndex=%d&pageSize=%d"))

//订单详情
#define ORDERDETAILS LMMC(Path(@"GetOrderInfo&id=%@"))

// 订单
#define GetOrder LMMC(Path(@"GetOrderInfo&userId=%d&order_no=%@&mid=%@"))

// 订单
#define GetGroupOrderInfo LMMC(Path(@"GetOrderInfo&userId=%@&order_no=%@&mid=%@"))

// 订单详情
#define GetOrderInfo LMMC(Path(@"GetOrderInfo&id=%@&order_no=%@&userId=%@&mid=%@"))

//订单评价列表
#define ORDERREVIEW LMMC(Path(@"GetProductReview&userId=%@&orderId=%d&pageIndex=%d&pageSize=%d"))

// 获取购物车数量
#define SHOPPINGCARTNUM LMMC(Path(@"GetMyCartCount&openId=%@&userId=%@&mid=%@"))

// 我的优惠券
#define GetMyTickList LMMC(Path(@"GetMyTickList&pageIndex=%d&pageSize=%d&userId=%@"))

// 获取购物车商品
#define SHOPPINGCARTGOODS LMMC(Path(@"GetShopCart&openid=%@&uid=%@&mid=%@"))

// 选好了修改购物车
#define SUMBITORDER LMMC(Path(@"UpdateCart&strjson=%@"))

//评价订单
#define PUBLISHCOMMENT LMMC(Path(@"AddProductReview&strjsons=%@"))
//

//上传用户信息
#define UPDATEUSER LMMC(Path(@"UpdateUser&id=%@&%@=%@"))

//上传用户头像
#define UPDATEUSERIMAGE LMMC(Path(@"SetUserImg"))

// 上传订单
#define UPLOADORDER LMMC(Path(@"GetPayOrder&context=%@&OrderId=%@&sttAwardId=%@&user_id=%@&openid=%@"))

// 购物车生成订单
#define ORDERNUMBER LMMC(Path(@"NewOrderNumber&list=%@"))
//#define ORDERNUMBER LMMC(Path(@"NewOrderNumber")

// 立即购买生成订单
#define ADDORDERNUMBER LMMC(Path(@"AddNewOrderNumber&list=%@"))

#define GETCITY LMMC(Path(@"GetCity"))

//取消订单
#define CANCELORDER LMMC(Path(@"CancelOrder&OrderId=%@&user_id=%@"))


//摇一摇
//#define GETRANDPRIZE LMMC(Path(@"GetRandPrize&user_id=%@&uuid=%@&major=%@&minor=%@")

// 获取新版本
#define GETNEW LMMC(Path(@"GetCheck&appNo=%@"))

// 地图
#define MAPURL LMMC(Path(@"GetAround&pageIndex=1&pageSize=1000&lat=%.6f&lon=%.6f&raidus=-1"))

// 获取自提点
#define GETMSTORE LMMC(Path(@"GetMStore&mid=%@&lat=%.6f&lon=%.6f&cityId=%@"))

// 保存地址
#define SAVEADDRESS LMMC(Path(@"AddUserStore&id=%@&userid=%@&storeid=%@&contacts=%@&telephone=%@&address=%@&provnce=%@&city=%@&area=%@"))

// 查询商品
#define QUERYGOODS LMMC(Path(@"GetProduct&ProductName=%@&pageIndex=%@&pagesize=1000&upselling=1&mid=%@&userId=%@"))

// 删除商家购物车
#define DelStoreCartUrl LMMC(Path(@"DelCart&openid=%@&mid=%@&userId=%@"))

// 拼团列表
#define GETPURCHASELIST LMMC(Path(@"GetPurchaseList&sid=%@&state=%@&pageIndex=1&pageSize=1000"))

// 加入/取消收藏
#define ADDFOLDER LMMC(Path(@"AddFolder&FavoritesId=0&Goods_Id=%@&UserId=%@&mid=%@&stroeId=%@"))

// 我的收藏
#define GETFOLDERPRODUCT LMMC(Path(@"GetFolderProduct&FavoritesId=0&UserId=%@&pageIndex=1&pageSize=1000"))

// 删除收藏
#define DELFOLDER LMMC(Path(@"AddFolder&id=%@"))

// 历史
#define HISTORYURL LMMC(Path(@"GetSearch&userid=%@"))

// 查询
#define HOTURL LMMC(Path(@"GetHotSearch&mid=%@"))

// 删除历史记录
#define DELSEARCH LMMC(Path(@"DelSearch&userid=%@"))

// 用户信息
#define GetOrderHost LMMC(Path(@"GetOrderHost&userid=%@"))

// 获取积分、优惠券、余额数
#define GetUSERINFO LMMC(Path(@"GetTopMessger&userId=%@"))

// 帮助中心
#define GetHelpLeve LMMC(Path(@"GetHelpLeve"))

//再购一次
#define ADDCOPYORDERCART LMMC(Path(@"AddCopyOrderCart&orderId=%@&openid=%@&wid=%@&telphone=%@"))

#define ScoreUrl LMMC(Path(@"GetProductReview&userId=%@&productId=%@&orderId=%@&pageIndex=1&pageSize=1000&level=%@"))

//重置密码
#define ResetUserPwdUrl LMMC(Path(@"resetUserPwd&newPwd=%@&phone=%@&code=%@&type=1"))

//获取积分记录
#define GETPOINTRECATD LMMC(Path(@"GetPoint&userId=%@&pageSize=1000&pageIndex=1"))

// 获取搜索信息
#define GetHotS LMMC(Path(@"GetHotS&mid=%@"))

// 订单状态总条数
#define GetOrderSum LMMC(Path(@"GetOrderSum&userId=%@"))

// 充值
#define WeiPay LMMC(Path(@"WeiPay&user_id=%@&user_name=%@&total_fee=%@&payment_id=%@&rechargeId=%@"))

// 获取充值记录
#define GetRechargeLog LMMC(Path(@"GetRechargeLog&userId=%@&pageSize=1000&pageIndex=1"))

// 摇一摇
#define GetShake LMMC(Path(@"GetRandPrize&List=%@&uuid=%@"))

// 修改支付密码
#define UpdatePayPwd LMMC(Path(@"UpdatePayPwd&userid=%@&oldPayPwd=%@&newPayPwd=%@"))

// 设置支付密码
#define SetPayPwd LMMC(Path(@"SetPayPwd&phone=%@&pwd=%@&type=%@&payPwd=%@"))

// 支付接口
#define AmountPay LMMC(Path(@"AmountPay&orderNo=%@&payPwd=%@"))

// 判断用户是否有支付密码
#define IsPayPwd LMMC(Path(@"IsPayPwd&userid=%@"))

// 获取送货地址列表
#define GetUserAddressList LMMC(Path(@"GetUserAddressList&pageIndex=1&pageSize=1000&userid=%@"))

// 新增接口
#define EditAddress LMMC(Path(@"EditAddress&userId=%@&userName=%@&sex=%@&id=%@&City=%@&Area=%@&Address=%@&Phone=%@&X=%.6f&Y=%.6f&CityId=%@&isdefault=%d"))

// 删除接口
#define DeleteAdress LMMC(Path(@"DeleteAdress&id=%@"))

// 获取城市
#define GetCity LMMC(Path(@"GetCity"))

// 团购列表
#define GetProduct_ActivityList LMMC(Path(@"GetProduct_ActivityList&pageIndex=1&pageSize=1000&mid=%@"))

// 团购付款
#define AddActivityOrder LMMC(Path(@"AddActivityOrder&list=%@"))

// 获取团购信息
#define GetActivityInfo LMMC(Path(@"GetActivityInfo&ActivityId=%@&userId=%@"))

// 获取团购记录列表
#define ActivityOrderList LMMC(Path(@"ActivityOrderList&pageIndex=1&pageSize=1000&userId=%@"))

// 修改支付方式
#define UpdatePayment_id LMMC(Path(@"UpdatePayment_id&orderId=%@&Payment_id=%@"))

// 获取商家提货方式
#define GetStorePament LMMC(Path(@"GetStorePament&sid=%@"))

// 添加收藏视频
#define AddVedioCollection LMMC(Path(@"AddVedioCollection&vedioid=%@&userid=%@&title=%@"))

// 增加浏览次数
#define ReckonFlow LMMC(Path(@"ReckonFlow&id=%@"))

// 获取视频详情
#define GetVedioInfo LMMC(Path(@"GetVedioInfo&id=%@"))

// 获取视频列表
#define GetVedioList LMMC(Path(@"GetVedioList&sid=%@&userId=%@&pageIndex=1&pageSize=1000"))

// 获取收藏视频列表
#define GetVedioCollection LMMC(Path(@"GetVedioCollection&sid=%@&userId=%@&pageIndex=1&pageSize=1000"))

// 取消收藏
#define RemoveVedioCollection LMMC(Path(@"RemoveVedioCollection&id=%@&userId=%@"))

#define UpdateActivityOrder LMMC(Path(@"UpdateActivityOrder&list=%@"))

// 更新拼团支付方式
#define UpdateActivityPayment_id LMMC(Path(@"UpdateActivityPayment_id&ActivityId=%@&Payment_id=%@"))

#endif
