//
//  QSCoreDataManager+User.m
//  House
//
//  Created by ysmeng on 15/1/22.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager+User.h"

///应用配置信息的CoreData模型
#define COREDATA_ENTITYNAME_USER_INFO @"QSCDUserDataModel"

@implementation QSCoreDataManager (User)

///获取当前用户ID
+ (NSString *)getUserID
{

    return (NSString *)[self getDataWithKey:COREDATA_ENTITYNAME_USER_INFO andKeyword:@"user_id"];

}

@end