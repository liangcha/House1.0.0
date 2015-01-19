//
//  QSAutoScrollView.h
//  House
//
//  Created by ysmeng on 15/1/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief  自定义类广告自滚动view的协议，主要是方便添加滚动相关的数据源信息
 */
@class QSAutoScrollView;
@protocol QSAutoScrollViewDelegate <NSObject>

@required

///自滚动的总数
- (int)numberOfScrollPage:(QSAutoScrollView *)autoScrollView;

/**
 *  @author                 yangshengmeng, 15-01-19 11:01:27
 *
 *  @brief                  获取需要显示信息的view，同时需要传入一个单击时回调的参数
 *
 *  @param autoScrollView   自滚动view
 *  @param index            显示view
 *  @param params           单击时回调的参数
 *
 *  @return                 返回显示view
 *
 *  @since                  1.0.0
 */
- (UIView *)autoScrollViewShowView:(QSAutoScrollView *)autoScrollView viewForShowAtIndex:(int)index;

/**
 *  @author yangshengmeng, 15-01-19 11:01:46
 *
 *  @brief  返回单击滚动栏时的回调参数
 *
 *  @return 返回单击时的参数
 *
 *  @since  1.0.0
 */
- (id)autoScrollViewTapCallBackParams:(QSAutoScrollView *)autoScrollView viewForShowAtIndex:(int)index;

@optional
///每一页的展示时间
- (CGFloat)displayTime:(QSAutoScrollView *)autoScrollView viewForShowAtIndex:(int)index;

@end

typedef enum
{

    aAutoScrollDirectionTypeTopToBottom = 200,  //!<从上往下滚动
    aAutoScrollDirectionTypeBottomToTop,        //!<从下往上滚动
    aAutoScrollDirectionTypeLeftToRight,        //!<从左到右滚动
    aAutoScrollDirectionTypeRightToLeft         //!<从右到左滚动

}AUTOSCROLL_DIRECTION_TYPE;                     //!<自滚动view的滚动方向类型

/**
 *  @author yangshengmeng, 15-01-19 10:01:02
 *
 *  @brief  类广告自滚动的自定义view
 *
 *  @since  1.0.0
 */
@interface QSAutoScrollView : UIView

/**
 *  @author                 yangshengmeng, 15-01-19 11:01:16
 *
 *  @brief                  根据代理和滚动类型，创建一个类广告自滚动的视图
 *
 *  @param frame            在父视图中的位置和大小
 *  @param delegate         滚动视图的代理
 *  @param directionType    滚动的方向
 *
 *  @return                 返回一个自滚动的视图
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id<QSAutoScrollViewDelegate>)delegate andScrollDirectionType:(AUTOSCROLL_DIRECTION_TYPE)directionType andTapCallBack:(void(^)(id params))callBack;

/**
 *  @author             yangshengmeng, 15-01-19 10:01:33
 *
 *  @brief              通过利用名字，返回当前滚动视图中是否存在对应的可用复用展示view
 *
 *  @param indentify    复用唯一标记
 *
 *  @return             返回复用view
 *
 *  @since              1.0.0
 */
- (UIView *)dequeueReusableViewWithIdentifier:(NSString *)indentify;

@end