//
//  QSRequestManager.h
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @author yangshengmeng, 15-01-20 21:01:17
 *
 *  @brief  网络请求管理器
 *
 *  @since  1.0.0
 */
@interface QSRequestManager : NSObject

/**
 *  @author             yangshengmeng, 15-01-20 21:01:18
 *
 *  @brief              根据不同的请求类型，进行不同的请求，并返回对应的请求结果信息
 *
 *  @param requestType  请求类型
 *  @param callBack     请求结束时的回调
 *
 *  @since              1.0.0
 */
+ (void)requestDataWithType:(REQUEST_TYPE)requestType andCallBack:(void(^)(REQUEST_RESULT_STATUS resultStatus,id resultData,NSString *errorInfo,NSString *errorCode))callBack;

@end
