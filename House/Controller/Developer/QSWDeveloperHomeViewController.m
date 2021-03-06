//
//  QSWDeveloperHomeViewController.m
//  House
//
//  Created by 王树朋 on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWDeveloperHomeViewController.h"
#import "QSWDeveloperActivityViewController.h"

@interface QSWDeveloperHomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *salingButton;//!<

@property (weak, nonatomic) IBOutlet UIButton *activeButton;//!<

@end

@implementation QSWDeveloperHomeViewController

///添加导航栏
-(void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    
    [self setNavigationBarTitle:@"开发商名称"];
    
}

///添加中间view
-(void)createMainShowUI
{
    
    [super createMainShowUI];

}

#pragma mark -按钮事件
///在售楼盘按钮点击事件
- (IBAction)salingButton:(id)sender {
    

    
}

///当前活动按钮点击事件
- (IBAction)activeButton:(id)sender {
    
    QSWDeveloperActivityViewController *VC=[[QSWDeveloperActivityViewController alloc]init];
    
    [self.navigationController pushViewController:VC animated:YES];
    
}

///设置按钮点击事件
- (IBAction)settingButton:(id)sender {
    
    
    
}

///消息按钮点击事件
- (IBAction)messageButton:(id)sender {
    
    
    
}

@end
