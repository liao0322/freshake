//
//  XFKVCPersistenceKeys.h
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/7.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#ifndef XFKVCPersistenceKeys_h
#define XFKVCPersistenceKeys_h

#define KEY_ACCOUNT @"KEY_ACCOUNT"
#define KEY_PASSWORD @"KEY_PASSWORD"

/**
 * 员工id
 */
#define KEY_USER_ID @"userId"

/**
 * 员工及用户显示名称
 */
#define KEY_USER_NAME @"userName"

/**
 * 状态{启用=001，禁用=000}
 */
#define KEY_USER_STATUS @"status"

/**
 * 所属组织id
 */
#define KEY_USER_OWNERID @"ownerId"

/**
 * 用户类型{管理员=001，仓库用户=002，派送用户=003}
 */
#define KEY_USER_TYPE @"userType"

/// 事件类型{商品=1，分类=2，跳转=3}
#define KEY_EVENT_TYPE_ID @"eventTypeId"
#define KEY_EVENT_URL @"eventUrl"
#define KEY_AD_IMAGE_NAME @"imageName"


#endif /* XFKVCPersistenceKeys_h */
