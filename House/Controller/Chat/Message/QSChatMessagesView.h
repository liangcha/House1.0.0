//
//  QSChatMessagesView.h
//  House
//
//  Created by ysmeng on 15/2/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief  消息列表
 */
@interface QSChatMessagesView : UIView

/**
 *  @author         yangshengmeng, 15-02-09 11:02:57
 *
 *  @brief          创建一个当前用户类型的消息列表
 *
 *  @param frame    大小和位置
 *  @param userType 用户类型
 *
 *  @return         返回当前创建的消息列表
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andUserType:(USER_COUNT_TYPE)userType;

@end
