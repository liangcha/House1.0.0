//
//  QSCoreDataManager.h
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @author yangshengmeng, 15-01-21 18:01:59
 *
 *  @brief  CoreData操作控制器
 *
 *  @since  1.0.0
 */
@interface QSCoreDataManager : NSObject

#pragma mark - 实体数据查询
/**
 *  @author             yangshengmeng, 15-01-26 16:01:28
 *
 *  @brief              返回某个实体中的所有数据
 *
 *  @param entityName   实体名
 *
 *  @return             返回对应实体中所有数据的数组
 *
 *  @since              1.0.0
 */
+ (NSArray *)getEntityListWithKey:(NSString *)entityName;

///返回指定实体中的所有数据，并按给定的字段排序查询
+ (NSArray *)getEntityListWithKey:(NSString *)entityName andSortKeyWord:(NSString *)keyword andAscend:(BOOL)isAscend;

///查询给定实体中，指定关键字的数据，并返回
+ (NSArray *)searchEntityListWithKey:(NSString *)entityName andFieldKey:(NSString *)keyword andSearchKey:(NSString *)searchKey;

///查询指定实体中，指定字段满足指定查询条件的数据集合
+ (NSArray *)searchEntityListWithKey:(NSString *)entityName andFieldKey:(NSString *)keyword andSearchKey:(NSString *)searchKey andAscend:(BOOL)isAscend;

///根据给定的predicate和排序，查找实体中的对应数据，并以数组返回
+ (NSArray *)searchEntityListWithKey:(NSString *)entityName andCustomPredicate:(NSPredicate *)predicate andCustomSort:(NSSortDescriptor *)sort;

#pragma mark - 单个实体数据查询
/**
 *  @author             yangshengmeng, 15-01-26 15:01:31
 *
 *  @brief              根据给定的关键字，在指定的实体中查询数据并返回第一个实体
 *
 *  @param entityname   实体名称
 *  @param fieldName    字段名
 *  @param searchKey    关键字
 *
 *  @return             返回搜索的结果
 *
 *  @since              1.0.0
 */
+ (id)searchEntityWithKey:(NSString *)entityName andFieldName:(NSString *)fieldName andFieldSearchKey:(NSString *)searchKey;

///根据限定的两个字段信息，查询结果
+ (id)searchEntityWithKey:(NSString *)entityName andFieldName:(NSString *)fieldName andFieldSearchKey:(NSString *)searchKey andSecondFieldName:(NSString *)secondFieldName andSecndFieldValue:(NSString *)secondFieldValue;

///根据给定的predecate查询对应的实体
+ (id)searchEntityWithKey:(NSString *)entityName andCustomPredicate:(NSPredicate *)predicate;

#pragma mark - 更新操作
/**
 *  @author                     yangshengmeng, 15-02-05 15:02:46
 *
 *  @brief                      更新数据
 *
 *  @param entityName           实体名
 *  @param filterFieldName      第一过滤条件
 *  @param filterValue          第一过滤条件的值
 *  @param updateFieldName      需要更新的字段字
 *  @param updateFieldNewValue  需要更新的字段新值
 *
 *  @return                     返回是否更新成功
 *
 *  @since                      1.0.0
 */
+ (BOOL)updateFieldWithKey:(NSString *)entityName andFilterFieldName:(NSString *)filterFieldName andFilterFieldValue:(NSString *)filterValue andUpdateFieldName:(NSString *)updateFieldName andUpdateFieldNewValue:(NSString *)updateFieldNewValue;

///根据给定的查询条件，更新指定字段信息
+ (BOOL)updateFieldWithKey:(NSString *)entityName andPredicate:(NSPredicate *)predicate andUpdateFieldName:(NSString *)fieldName andNewValue:(NSString *)newValue;

#pragma mark - 单记录的实体数据操作
/**
 *  @author             yangshengmeng, 15-01-26 17:01:37
 *
 *  @brief              获取单记录实体数据中指定的字段信息
 *
 *  @param entityName   实体名
 *  @param keyword      字段名
 *
 *  @return             返回给定字段的信息
 *
 *  @since              1.0.0
 */
+ (id)getUnirecordFieldWithKey:(NSString *)entityName andKeyword:(NSString *)keyword;

///更新单记录表中，指定字段的信息
+ (BOOL)updateUnirecordFieldWithKey:(NSString *)entityName andUpdateField:(NSString *)fieldName andFieldNewValue:(id)newValue;

#pragma mark - 清空实体记录API
/**
 *  @author             yangshengmeng, 15-01-21 23:01:28
 *
 *  @brief              清空某个实体模型中所有的数据
 *
 *  @param entityName   实体名
 *
 *  @return             删除结果标识：YES-删除成功,NO-删除失败
 *
 *  @since              1.0.0
 */
+ (BOOL)clearEntityListWithEntityName:(NSString *)entityName;

///删除给定实体中对应字段为特定关键字的所有记录
+ (BOOL)clearEntityListWithEntityName:(NSString *)entityName andFieldKey:(NSString *)fieldKey andDeleteKey:(NSString *)deleteKey;

@end
