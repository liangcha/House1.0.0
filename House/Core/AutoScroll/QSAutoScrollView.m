//
//  QSAutoScrollView.m
//  House
//
//  Created by ysmeng on 15/1/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSAutoScrollView.h"

///复用队列中的关键字宏定义
#define AUTOSCROLLVIEW_DEQUEUE_SHOWVIEW @"show_view"
#define AUTOSCROLLVIEW_DEQUEUE_SHOWTIME @"show_time"
#define AUTOSCROLLVIEW_DEQUEUE_TAPPARAMS @"tap_params"
#define AUTOSCROLLVIEW_DEQUEUE_IDENTIFY @"identify"

@interface QSAutoScrollView ()

@property (nonatomic,assign) AUTOSCROLL_DIRECTION_TYPE autoScrollDirectionType;//!<自滚动方向
@property (nonatomic,assign) int sumPage;                               //!<总的是滚动页数
@property (nonatomic,assign) int currentIndex;                          //!<当前显示的下标
@property (nonatomic,assign) CGFloat currentShowTime;                   //!<当前显示页的显示时间
@property (nonatomic,assign) id<QSAutoScrollViewDelegate> delegate;     //!<数据源代理
@property (nonatomic,copy) void(^autoScrollViewTapCallBack)(id params); //!<单击滚动view时的回调

@property (nonatomic,unsafe_unretained) UIView *currentShowCell;        //!<当前显示的视图
@property (nonatomic,unsafe_unretained) UIView *nextShowCell;           //!<准备显示视图
@property (nonatomic,assign) BOOL swipeGestureFlag;                     //!<当通过手势滑动时锁定

@end

@implementation QSAutoScrollView

#pragma mark - 初始化
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
- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id<QSAutoScrollViewDelegate>)delegate andScrollDirectionType:(AUTOSCROLL_DIRECTION_TYPE)directionType andTapCallBack:(void (^)(id))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
        ///保存代理
        self.delegate = delegate;
        
        ///保存回调
        if (callBack) {
            
            self.autoScrollViewTapCallBack = callBack;
            
        }
        
        ///保存滚动方向
        self.autoScrollDirectionType = directionType;
        
        ///创建UI
        [self createAutoShowViewUI];
        
        ///默认手势锁为NO
        self.swipeGestureFlag = NO;
        
        ///添加单击手势
        [self addTapGesture];
        
    }
    
    return self;

}

#pragma mark - 搭建滚动UI
///搭建滚动UI
- (void)createAutoShowViewUI
{
    
    ///如果代理不存在，则不执行
    if (nil == self.delegate) {
        
        return;
        
    }
    
    ///判断需要显示的数量
    int sumPage = [self.delegate numberOfScrollPage:self];
    
    ///如果没有提供显示的总数页，则不创建展示页
    if (0 >= sumPage) {
        
        return;
        
    }

    ///获取滚动的页数
    self.sumPage = sumPage;
    
    ///设置初始显示下标
    self.currentIndex = 0;
    
    ///判断是否只有一个
    if (1 == self.sumPage) {
        
        UIView *showView = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:0];
        
        ///显示
        showView.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
        [self addSubview:showView];
        
        return;
        
    }
    
    ///保存当前显示页面的显示时间
    self.currentShowTime = [self.delegate displayTime:self viewForShowAtIndex:0];
    
    ///通过代理获取当前显示view和下一个显示view
    self.currentShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:0];
    self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getRightPrepareShowViewIndex]];
    
    ///重置frame
    self.currentShowCell.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    
    if (self.autoScrollDirectionType == aAutoScrollDirectionTypeTopToBottom || self.autoScrollDirectionType == aAutoScrollDirectionTypeBottomToTop) {
        
        self.nextShowCell.frame = CGRectMake(0.0f, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
        
    } else {
    
        self.nextShowCell.frame = CGRectMake(-self.frame.size.width, 0.0f, self.frame.size.width, self.frame.size.height);
    
    }
    
    [self addSubview:self.currentShowCell];
    [self addSubview:self.nextShowCell];
    
    ///添加滑动手势
    [self addSwipeGesture];
    
    ///开始切换视图
    [self startAnimination];

}

#pragma mark - 开始动画
- (void)startAnimination
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.currentShowTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///如果当前通过手势滑动，则不执行
        if (self.swipeGestureFlag) {
            
            return;
            
        }
        
        switch (self.autoScrollDirectionType) {
                
                ///从上到下滚动
            case aAutoScrollDirectionTypeTopToBottom:
            {
                
                ///重置下一个页面的frame
                self.nextShowCell.frame = CGRectMake(0.0f, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
                
                ///动画切换后刷新左右指针
                [self animationChangeView:CGRectMake(0.0f, self.frame.size.height, self.frame.size.width, self.frame.size.height) andWillShowView:self.nextShowCell andFinishCallBack:^(BOOL finish) {
                    
                    if (finish) {
                        
                        ///移除原显示页
                        [self.currentShowCell removeFromSuperview];
                        
                        ///更新当前显示view
                        self.currentShowCell = self.nextShowCell;
                        
                        ///更新当前显示的下标
                        self.currentIndex = [self getRightPrepareShowViewIndex];
                        
                        ///更新当前页面的显示时间
                        self.currentShowTime = [self getCurrentPageShowTime];
                        
                        ///更新下一页视图
                        self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getRightPrepareShowViewIndex]];
                        
                        ///下一页添加到滚动视图上
                        self.nextShowCell.frame = CGRectMake(0.0f, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
                        
                        ///加载
                        [self addSubview:self.nextShowCell];
                        
                        ///开启下一次的动画
                        [self startAnimination];
                        
                    }
                    
                }];
                
            }
                break;
                
                ///从下到上滚动
            case aAutoScrollDirectionTypeBottomToTop:
            {
                
                ///重置下一个页面的frame
                self.nextShowCell.frame = CGRectMake(0.0f, self.frame.size.height, self.frame.size.width, self.frame.size.height);
                
                ///动画切换后刷新左右指针
                [self animationChangeView:CGRectMake(0.0f, -self.frame.size.height, self.frame.size.width, self.frame.size.height) andWillShowView:self.nextShowCell andFinishCallBack:^(BOOL finish) {
                    
                    if (finish) {
                        
                        ///移除原显示页
                        [self.currentShowCell removeFromSuperview];
                        
                        self.currentShowCell = self.nextShowCell;
                        
                        ///更新当前显示的下标
                        self.currentIndex = [self getLeftPrepareShowViewIndex];
                        
                        ///更新当前页面的显示时间
                        self.currentShowTime = [self getCurrentPageShowTime];
                        
                        ///更新下一页视图
                        self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getLeftPrepareShowViewIndex]];
                        
                        ///下一页添加到滚动视图上
                        self.nextShowCell.frame = CGRectMake(0.0f, self.frame.size.height, self.frame.size.width, self.frame.size.height);
                        
                        ///加载
                        [self addSubview:self.nextShowCell];
                        
                        ///开启下一次的动画
                        [self startAnimination];
                        
                    }
                    
                }];
                
            }
                break;
                
                ///从左到右滚动
            case aAutoScrollDirectionTypeLeftToRight:
            {
                
                ///重置下一个页面的frame
                self.nextShowCell.frame = CGRectMake(-self.frame.size.width, 0.0f, self.frame.size.width, self.frame.size.height);
                
                ///动画切换后刷新左右指针
                [self animationChangeView:CGRectMake(self.frame.size.width, 0.0f, self.frame.size.width, self.frame.size.height) andWillShowView:self.nextShowCell andFinishCallBack:^(BOOL finish) {
                    
                    if (finish) {
                        
                        ///移除原显示页
                        [self.currentShowCell removeFromSuperview];
                        
                        self.currentShowCell = self.nextShowCell;
                        
                        ///更新当前显示的下标
                        self.currentIndex = [self getLeftPrepareShowViewIndex];
                        
                        ///更新当前页面的显示时间
                        self.currentShowTime = [self getCurrentPageShowTime];
                        
                        ///更新下一页视图
                        self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getLeftPrepareShowViewIndex]];
                        
                        ///下一页添加到滚动视图上
                        self.nextShowCell.frame = CGRectMake(-self.frame.size.width, 0.0f, self.frame.size.width, self.frame.size.height);
                        
                        ///加载
                        [self addSubview:self.nextShowCell];
                        
                        ///开启下一次的动画
                        [self startAnimination];
                        
                    }
                    
                }];
                
            }
                break;
                
                ///从右到左滚动
            case aAutoScrollDirectionTypeRightToLeft:
            {
                
                ///重置下一个页面的frame
                self.nextShowCell.frame = CGRectMake(self.frame.size.width, 0.0f, self.frame.size.width, self.frame.size.height);
                
                ///动画切换后刷新左右指针
                [self animationChangeView:CGRectMake(-self.frame.size.width, 0.0f, self.frame.size.width, self.frame.size.height) andWillShowView:self.nextShowCell andFinishCallBack:^(BOOL finish) {
                    
                    if (finish) {
                        
                        ///移除原显示页
                        [self.currentShowCell removeFromSuperview];
                        
                        self.currentShowCell = self.nextShowCell;
                        
                        ///更新当前显示的下标
                        self.currentIndex = [self getRightPrepareShowViewIndex];
                        
                        ///更新当前页面的显示时间
                        self.currentShowTime = [self getCurrentPageShowTime];
                        
                        ///更新下一页视图
                        self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getRightPrepareShowViewIndex]];
                        
                        ///下一页添加到滚动视图上
                        self.nextShowCell.frame = CGRectMake(self.frame.size.width, 0.0f, self.frame.size.width, self.frame.size.height);
                        
                        ///加载
                        [self addSubview:self.nextShowCell];
                        
                        ///开启下一次的动画
                        [self startAnimination];
                        
                    }
                    
                }];
                
            }
                break;

        }
        
    });

}

///动画切换当前页面和将要显示页面
- (void)animationChangeView:(CGRect)currentViewChangedFrame andWillShowView:(UIView *)view andFinishCallBack:(void(^)(BOOL finish))callBack
{
    
    ///获取当前显示页的frame
    CGRect currentShowFrame = self.currentShowCell.frame;

    ///动画插入
    [UIView animateWithDuration:0.3 animations:^{
        
        self.currentShowCell.frame = currentViewChangedFrame;
        view.frame = currentShowFrame;
        
    } completion:^(BOOL finished) {
        
        ///回调
        callBack(finished);
        
    }];

}

#pragma mark - 返回左右将要显示view的下标
///返回左侧将要显示的view下标
- (int)getLeftPrepareShowViewIndex
{

    int leftIndex = self.currentIndex - 1;
    
    if (leftIndex <= 0) {
        
        leftIndex = self.sumPage - 1;
        
    }
    
    return leftIndex;

}

///返回右侧将要显示的view下标
- (int)getRightPrepareShowViewIndex
{
    
    int rightIndex = self.currentIndex + 1;
    
    if (rightIndex >= self.sumPage) {
        
        rightIndex = 0;
        
    }
    
    return rightIndex;
    
}

#pragma mark - 获取当前页显示的时间
- (CGFloat)getCurrentPageShowTime
{

    CGFloat showTime = [self.delegate displayTime:self viewForShowAtIndex:self.currentIndex];
    
    return showTime > 0.5f ? showTime : 1.0f;

}

#pragma mark - 添加单击手势
- (void)addTapGesture
{

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(autoScrollViewTapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];

}

///单击时将对应的参数回调
- (void)autoScrollViewTapAction:(UITapGestureRecognizer *)tap
{

    ///取出当前显示view相关参数
    id params = [self.delegate autoScrollViewTapCallBackParams:self viewForShowAtIndex:self.currentIndex];
    
    ///回调
    if (self.autoScrollViewTapCallBack) {
        
        self.autoScrollViewTapCallBack(params);
        
    }

}

#pragma mark - 添加滑动手势
- (void)addSwipeGesture
{

    
    switch (self.autoScrollDirectionType) {
            
            ///从上滑到下
        case aAutoScrollDirectionTypeTopToBottom:
            
            ///从下滑到上
        case aAutoScrollDirectionTypeBottomToTop:
            
            [self addUpSwipeGesture];
            [self addDownSwipeGesture];
            
            break;
            
            ///从左滑到右
        case aAutoScrollDirectionTypeLeftToRight:
            
            ///从右滑到左
        case aAutoScrollDirectionTypeRightToLeft:
            
            [self addLeftSwipeGesture];
            [self addRightSwipeGesture];
            
            break;
            
        default:
            break;
    }
    

}

///添加向左侧滑动手动
- (void)addLeftSwipeGesture
{

    ///向左滑动
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(autoScrollViewLeftSwipeAction:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeLeft];

}

///向左滑动时的事件
- (void)autoScrollViewLeftSwipeAction:(UISwipeGestureRecognizer *)swipe
{

    ///手势滑动时锁定
    self.swipeGestureFlag = YES;
    
    ///重置下一页的frame
    self.nextShowCell.frame = CGRectMake(self.frame.size.width, 0.0f, self.frame.size.width, self.frame.size.height);
    
    ///动画显示
    [self animationChangeView:CGRectMake(-self.frame.size.width, 0.0f, self.frame.size.width, self.frame.size.height) andWillShowView:self.nextShowCell andFinishCallBack:^(BOOL finish) {
        
        if (finish) {
            
            ///移除原显示页
            [self.currentShowCell removeFromSuperview];
            
            self.currentShowCell = self.nextShowCell;
            
            ///更新当前显示的下标
            self.currentIndex = [self getRightPrepareShowViewIndex];
            
            ///更新当前页面的显示时间
            self.currentShowTime = [self getCurrentPageShowTime];
            
            ///更新下一页视图
            self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getRightPrepareShowViewIndex]];
            
            ///下一页添加到滚动视图上
            self.nextShowCell.frame = CGRectMake(self.frame.size.width, 0.0f, self.frame.size.width, self.frame.size.height);
            
            ///加载
            [self addSubview:self.nextShowCell];
            
            ///开启下一次的动画
            [self startAnimination];
            
            ///开放锁定
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.currentShowTime - 0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                self.swipeGestureFlag = NO;
                
            });
            
        }
        
    }];

}

///添加向右滑动手势
- (void)addRightSwipeGesture
{

    ///向右滑动
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(autoScrollViewRightSwipeAction:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeRight];

}

///向右滑动时的事件
- (void)autoScrollViewRightSwipeAction:(UISwipeGestureRecognizer *)swipe
{
    
    ///手势滑动时锁定
    self.swipeGestureFlag = YES;
    
    ///重置下一页的frame
    self.nextShowCell.frame = CGRectMake(-self.frame.size.width, 0.0f, self.frame.size.width, self.frame.size.height);
    
    ///动画显示
    [self animationChangeView:CGRectMake(self.frame.size.width, 0.0f, self.frame.size.width, self.frame.size.height) andWillShowView:self.nextShowCell andFinishCallBack:^(BOOL finish) {
        
        if (finish) {
            
            ///移除原显示页
            [self.currentShowCell removeFromSuperview];
            
            self.currentShowCell = self.nextShowCell;
            
            ///更新当前显示的下标
            self.currentIndex = [self getLeftPrepareShowViewIndex];
            
            ///更新当前页面的显示时间
            self.currentShowTime = [self getCurrentPageShowTime];
            
            ///更新下一页视图
            self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getLeftPrepareShowViewIndex]];
            
            ///下一页添加到滚动视图上
            self.nextShowCell.frame = CGRectMake(-self.frame.size.width, 0.0f, self.frame.size.width, self.frame.size.height);
            
            ///加载
            [self addSubview:self.nextShowCell];
            
            ///开启下一次的动画
            [self startAnimination];
            
            ///开放锁定
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.currentShowTime - 0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                self.swipeGestureFlag = NO;
                
            });
            
        }
        
    }];
    
}

///添加向上滑动手势
- (void)addUpSwipeGesture
{

    ///左移
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(autoScrollViewUpSwipeAction:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeUp];

}

///向上滑动时的事件
- (void)autoScrollViewUpSwipeAction:(UISwipeGestureRecognizer *)swipe
{
    
    ///手势滑动时锁定
    self.swipeGestureFlag = YES;
    
    ///重置下一页的frame
    self.nextShowCell.frame = CGRectMake(0.0f, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    ///动画显示
    [self animationChangeView:CGRectMake(0.0f, -self.frame.size.height, self.frame.size.width, self.frame.size.height) andWillShowView:self.nextShowCell andFinishCallBack:^(BOOL finish) {
        
        if (finish) {
            
            ///移除原显示页
            [self.currentShowCell removeFromSuperview];
            
            self.currentShowCell = self.nextShowCell;
            
            ///更新当前显示的下标
            self.currentIndex = [self getLeftPrepareShowViewIndex];
            
            ///更新当前页面的显示时间
            self.currentShowTime = [self getCurrentPageShowTime];
            
            ///更新下一页视图
            self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getLeftPrepareShowViewIndex]];
            
            ///下一页添加到滚动视图上
            self.nextShowCell.frame = CGRectMake(0.0f, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            
            ///加载
            [self addSubview:self.nextShowCell];
            
            ///开启下一次的动画
            [self startAnimination];
            
            ///开放锁定
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.currentShowTime - 0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                self.swipeGestureFlag = NO;
                
            });
            
        }
        
    }];
    
}

///添加向下滑动手势
- (void)addDownSwipeGesture
{

    ///左移
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(autoScrollViewDownSwipeAction:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipeDown];

}

///向下滑动时的事件
- (void)autoScrollViewDownSwipeAction:(UISwipeGestureRecognizer *)swipe
{
    
    ///手势滑动时锁定
    self.swipeGestureFlag = YES;
    
    ///重置下一页的frame
    self.nextShowCell.frame = CGRectMake(0.0f, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    ///动画显示
    [self animationChangeView:CGRectMake(0.0f, self.frame.size.height, self.frame.size.width, self.frame.size.height) andWillShowView:self.nextShowCell andFinishCallBack:^(BOOL finish) {
        
        if (finish) {
            
            ///移除原显示页
            [self.currentShowCell removeFromSuperview];
            
            self.currentShowCell = self.nextShowCell;
            
            ///更新当前显示的下标
            self.currentIndex = [self getRightPrepareShowViewIndex];
            
            ///更新当前页面的显示时间
            self.currentShowTime = [self getCurrentPageShowTime];
            
            ///更新下一页视图
            self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getRightPrepareShowViewIndex]];
            
            ///下一页添加到滚动视图上
            self.nextShowCell.frame = CGRectMake(0.0f, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
            
            ///加载
            [self addSubview:self.nextShowCell];
            
            ///开启下一次的动画
            [self startAnimination];
            
            ///开放锁定
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.currentShowTime - 0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                self.swipeGestureFlag = NO;
                
            });
            
        }
        
    }];
    
}

@end
