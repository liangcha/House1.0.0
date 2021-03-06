//
//  NSDate+Formatter.m
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "NSDate+Formatter.h"

@implementation NSDate (Formatter)

/**
 *  @author             yangshengmeng, 15-01-21 20:01:51
 *
 *  @brief              将时间戳转化为NSDate对象
 *
 *  @param timeStamp    时间戳
 *
 *  @return             返回NSDate
 *
 *  @since              1.0.0
 */
+ (NSDate *)timeStampStringToNSDate:(NSString *)timeStamp
{

    //转换为有效日期
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    
    return confromTimesp;

}

/**
 *  @author yangshengmeng, 15-01-21 21:01:01
 *
 *  @brief  返回一个当前日期的日期戳
 *
 *  @return 时间戳
 *
 *  @since  1.0.0
 */
+ (NSString *)currentDateTimeStamp
{
    
    return [self formatNSDateToTimeStamp:[NSDate date]];
    
}

/**
 *  @author     yangshengmeng, 14-12-21 17:12:46
 *
 *  @brief      将给定的日期，转换为时间戳
 *
 *  @param date 给定的日期
 *
 *  @return     返回时间戳
 *
 *  @since      1.0.0
 */
+ (NSString *)formatNSDateToTimeStamp:(NSDate *)date
{
    
    NSTimeInterval interval = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%f",interval];
    
}

@end
