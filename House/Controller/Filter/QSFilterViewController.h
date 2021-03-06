//
//  QSFilterViewController.h
//  House
//
//  Created by ysmeng on 15/1/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

/**
 *  @brief  过滤器集中创建类
 */
@interface QSFilterViewController : QSTurnBackViewController

/**
 *  @author             yangshengmeng, 15-01-23 13:01:52
 *
 *  @brief              根据过滤器类型创建不同的过滤设置器
 *
 *  @param filterType   过滤类型：二手器、出租房等
 *
 *  @return             返回过滤器对象
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFilterType:(FILTER_MAIN_TYPE)filterType;

@end
