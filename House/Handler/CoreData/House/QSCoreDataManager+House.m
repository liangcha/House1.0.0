//
//  QSCoreDataManager+House.m
//  House
//
//  Created by ysmeng on 15/1/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager+House.h"
#import "QSBaseConfigurationDataModel.h"

///配置信息的CoreData模型
#define COREDATA_ENTITYNAME_BASECONFIGURATION_INFO @"QSCDBaseConfigurationDataModel"

///房子列表的过滤条件
#define COREDATA_ENTITYNAME_HOUSELIST_FILTER @"QSCDHouseListFilter"

@implementation QSCoreDataManager (House)

/**
 *  @author yangshengmeng, 15-01-27 17:01:17
 *
 *  @brief  获取本地配置的户型数据
 *
 *  @return 返回户型数据
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseType
{

    NSMutableArray *houseTypeList = [[NSMutableArray alloc] init];
    NSArray *houseTypeTempArray = @[@"一室",@"二室",@"三室",@"四室",@"五室",@"五室以上"];
    NSArray *houseTypeKeyArray = @[@"1",@"2",@"3",@"4",@"5",@"5-over"];
    for (int i = 0; i < [houseTypeTempArray count]; i++) {
        
        QSBaseConfigurationDataModel *tempModel = [[QSBaseConfigurationDataModel alloc] init];
        tempModel.key = houseTypeKeyArray[i];
        tempModel.val = houseTypeTempArray[i];
        [houseTypeList addObject:tempModel];
        
    }
    return [NSArray arrayWithArray:houseTypeList];

}

/**
 *  @author yangshengmeng, 15-02-02 09:02:41
 *
 *  @brief  获取房子售价的类型
 *
 *  @return 返回售价类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseSalePriceType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"house_price"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

/**
 *  @author yangshengmeng, 15-02-02 09:02:16
 *
 *  @brief  获取房子面积类型列表数据
 *
 *  @return 返回房子面积类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseAreaType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"house_area"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

/**
 *  @author yangshengmeng, 15-02-02 09:02:48
 *
 *  @brief  获取房子出租的方式类型
 *
 *  @return 返回出租方式类型列表
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseRentType
{
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"rent_property"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];
    
}

/**
 *  @author yangshengmeng, 15-02-02 09:02:29
 *
 *  @brief  返回出租房的租金类型列表
 *
 *  @return 返回类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseRentPriceType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"rent_price"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

/**
 *  @author yangshengmeng, 15-02-02 09:02:44
 *
 *  @brief  获取出租房的租金支付方式选择项
 *
 *  @return 返回租金支付方式选择项数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseRentPayType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"payment"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

/**
 *  @author yangshengmeng, 15-02-02 10:02:46
 *
 *  @brief  获取房子的装修类型
 *
 *  @return 返回房子装修类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseDecorationType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"decoration_type"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

/**
 *  @author yangshengmeng, 15-02-02 10:02:15
 *
 *  @brief  获取房子朝向类型数据
 *
 *  @return 返回房子朝向类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseFaceType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"house_face"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

/**
 *  @author yangshengmeng, 15-02-02 10:02:25
 *
 *  @brief  获取房子的楼层类型数据
 *
 *  @return 返回房子楼层类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseFloorType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"floor_which"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

/**
 *  @author yangshengmeng, 15-02-02 10:02:22
 *
 *  @brief  获取房子的产权年限数据
 *
 *  @return 返回产权选择项数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHousePropertyRightType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"used_year"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

/**
 *  @author yangshengmeng, 15-02-05 14:02:40
 *
 *  @brief  获取房子的房龄类型数组
 *
 *  @return 返回房龄数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseUsedYearType
{

    NSMutableArray *houseUsedYearTypeList = [[NSMutableArray alloc] init];
    NSArray *houseUsedYearTypeTempArray = @[@"2年以下",@"2-5年",@"5-10年",@"10年以上"];
    NSArray *houseUsedYearTypeKeyArray = @[@"2-under",@"2-5",@"5-10",@"10-over"];
    for (int i = 0; i < [houseUsedYearTypeTempArray count]; i++) {
        
        QSBaseConfigurationDataModel *tempModel = [[QSBaseConfigurationDataModel alloc] init];
        tempModel.key = houseUsedYearTypeKeyArray[i];
        tempModel.val = houseUsedYearTypeTempArray[i];
        [houseUsedYearTypeList addObject:tempModel];
        
    }
    return [NSArray arrayWithArray:houseUsedYearTypeList];

}

/**
 *  @author yangshengmeng, 15-01-29 15:01:06
 *
 *  @brief  返回房子列表中主要过滤类型
 *
 *  @return 返回类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseListMainType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"type"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

///查询主列表类型的对象
+ (id)getHouseListMainTypeModelWithID:(NSString *)typeID
{

    return [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"type" andSecondFieldName:@"key" andSecndFieldValue:typeID];

}

/**
 *  @author yangshengmeng, 15-02-02 09:02:31
 *
 *  @brief  获取房子的物业类型
 *
 *  @return 返回可以选择的物业类型
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseTradeType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"property_type"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

/**
 *  @author yangshengmeng, 15-01-27 17:01:23
 *
 *  @brief  返回购房目的数组
 *
 *  @return 返回数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getPurpostPerchaseType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"intent"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

/**
 *  @author     yangshengmeng, 15-02-12 13:02:13
 *
 *  @brief      查询对应特色标签的值
 *
 *  @param key  标签的key
 *
 *  @return     返回对应标签的值
 *
 *  @since      1.0.0
 */
+ (NSString *)getHouseFeatureWithKey:(NSString *)key andFilterType:(FILTER_MAIN_TYPE)listType
{
    
    switch (listType) {
            ///新房
        case fFilterMainTypeNewHouse:
        {
            
            QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"features" andSecondFieldName:@"key" andSecndFieldValue:key];
            return tempModel.val;
            
        }
            break;
            
            ///小区
        case fFilterMainTypeCommunity:
        {
            
            QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"features" andSecondFieldName:@"key" andSecndFieldValue:key];
            return tempModel.val;
            
        }
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
        {
        
            QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"features" andSecondFieldName:@"key" andSecndFieldValue:key];
            return tempModel.val;
        
        }
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
        {
            
            QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"features_rent" andSecondFieldName:@"key" andSecndFieldValue:key];
            return tempModel.val;
            
        }
            break;
            
        default:
            break;
    }
    
    return nil;

}

@end
