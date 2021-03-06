//
//  QSCoreDataManager.m
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager.h"
#import "QSYAppDelegate.h"
#import "QSCDFilterDataModel.h"

@implementation QSCoreDataManager

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
+ (NSArray *)getEntityListWithKey:(NSString *)entityName
{

    return [self getEntityListWithKey:entityName andSortKeyWord:nil andAscend:YES];
    
}

///返回指定实体中的所有数据，并按给定的字段排序查询
+ (NSArray *)getEntityListWithKey:(NSString *)entityName andSortKeyWord:(NSString *)keyword andAscend:(BOOL)isAscend
{
    
    ///查询成功
    return [self searchEntityListWithKey:entityName andFieldKey:keyword andSearchKey:nil andAscend:isAscend];

}

///查询给定实体中，指定关键字的数据，并返回
+ (NSArray *)searchEntityListWithKey:(NSString *)entityName andFieldKey:(NSString *)keyword andSearchKey:(NSString *)searchKey
{

    return [self searchEntityListWithKey:entityName andFieldKey:keyword andSearchKey:searchKey andAscend:YES];

}

///查询指定实体中，指定字段满足指定查询条件的数据集合
+ (NSArray *)searchEntityListWithKey:(NSString *)entityName andFieldKey:(NSString *)keyword andSearchKey:(NSString *)searchKey andAscend:(BOOL)isAscend
{
    
    ///设置查询过滤
    NSPredicate *predicate = nil;
    NSSortDescriptor *sort = nil;
    
    if (keyword) {
        
        if (searchKey) {
            
            ///过滤条件
            predicate = [NSPredicate predicateWithFormat:[[NSString stringWithFormat:@"%@ == ",keyword] stringByAppendingString:@"%@"],searchKey];
            
        }
        
        ///排序
        sort = [[NSSortDescriptor alloc] initWithKey:keyword ascending:isAscend];
        
    }
    
    return [self searchEntityListWithKey:entityName andCustomPredicate:predicate andCustomSort:sort];

}

///根据给定的predicate和排序，查找实体中的对应数据，并以数组返回
+ (NSArray *)searchEntityListWithKey:(NSString *)entityName andCustomPredicate:(NSPredicate *)predicate andCustomSort:(NSSortDescriptor *)sort
{

    QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    NSEntityDescription *enty = [NSEntityDescription entityForName:entityName inManagedObjectContext:mainContext];
    
    ///设置查找
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:enty];
    
    ///设置查询过滤
    if (predicate) {
        
        [request setPredicate:predicate];
        
    }
    
    ///设置排序
    if (sort) {
        
        [request setSortDescriptors:@[sort]];
        
    }
    
    __block NSError *error;
    __block NSArray *resultList = nil;
    
    if ([NSThread isMainThread]) {
        
        resultList = [mainContext executeFetchRequest:request error:&error];
        
    } else {
    
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            resultList = [mainContext executeFetchRequest:request error:&error];
            
        });
    
    }
    
    ///判断是否查询失败
    if (error) {
        
        return nil;
        
    }
    
    ///如果获取返回的个数为0也直接返回nil
    if (0 >= [resultList count]) {
        
        return nil;
        
    }
    
    ///查询成功
    return resultList;

}

#pragma mark - 单个实体数据查询
/**
 *  @author             yangshengmeng, 15-01-26 15:01:31
 *
 *  @brief              根据给定的关键字，在指定的实体中查询数据并返回
 *
 *  @param entityname   实体名称
 *  @param fieldName    字段名
 *  @param searchKey    关键字
 *
 *  @return             返回搜索的结果
 *
 *  @since              1.0.0
 */
+ (id)searchEntityWithKey:(NSString *)entityName andFieldName:(NSString *)fieldName andFieldSearchKey:(NSString *)searchKey
{
    
    NSArray *resultList = [self searchEntityListWithKey:entityName andFieldKey:fieldName andSearchKey:searchKey];
    
    ///判断是否查询失败
    if (nil == resultList) {
        
        return nil;
        
    }
    
    ///如果获取返回的个数为0也直接返回nil
    if (0 >= [resultList count]) {
        
        return nil;
        
    }
    
    ///查询成功
    id resultModel = [resultList firstObject];
    return resultModel;
    
}

///按给定的两个条件查询对应记录
+ (id)searchEntityWithKey:(NSString *)entityName andFieldName:(NSString *)fieldName andFieldSearchKey:(NSString *)searchKey andSecondFieldName:(NSString *)secondFieldName andSecndFieldValue:(NSString *)secondFieldValue
{
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[[[NSString stringWithFormat:@"%@ == ",fieldName] stringByAppendingString:@"%@ AND "] stringByAppendingString:[[NSString stringWithFormat:@"%@ == ",secondFieldName] stringByAppendingString:@"%@"]],searchKey,secondFieldValue];
    
    return [self searchEntityWithKey:entityName andCustomPredicate:predicate];

}

///根据给定的predecate查询对应的实体
+ (id)searchEntityWithKey:(NSString *)entityName andCustomPredicate:(NSPredicate *)predicate
{

    NSArray *resultList = [self searchEntityListWithKey:entityName andCustomPredicate:predicate andCustomSort:nil];
    
    ///如果获取返回的个数为0也直接返回nil
    if (0 >= [resultList count]) {
        
        return nil;
        
    }
    
    return [resultList firstObject];

}

#pragma mark - 更新操作
/**
 *  @author                     yangshengmeng, 15-02-05 09:02:15
 *
 *  @brief                      更新指定记录中的指定字段信息
 *
 *  @param entityName           实体名
 *  @param filterFieldName      指定记录的指定字段
 *  @param filterValue          指定字段的值
 *  @param updateFieldName      需要更新的字段名
 *  @param updateFieldNewValue  需要更新的字段新值
 *
 *  @return                     返回是否更新成功
 *
 *  @since                      1.0.0
 */
+ (BOOL)updateFieldWithKey:(NSString *)entityName andFilterFieldName:(NSString *)filterFieldName andFilterFieldValue:(NSString *)filterValue andUpdateFieldName:(NSString *)updateFieldName andUpdateFieldNewValue:(NSString *)updateFieldNewValue
{
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[[NSString stringWithFormat:@"%@ == ",filterFieldName] stringByAppendingString:@"%@"],filterValue];
    
    return [self updateFieldWithKey:entityName andPredicate:predicate andUpdateFieldName:updateFieldName andNewValue:updateFieldNewValue];
    
}

///根据给定的查询条件，更新指定字段信息
+ (BOOL)updateFieldWithKey:(NSString *)entityName andPredicate:(NSPredicate *)predicate andUpdateFieldName:(NSString *)fieldName andNewValue:(NSString *)newValue
{

    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有上下文
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///判断是否存在过滤器
    if (predicate) {
        
        [fetchRequest setPredicate:predicate];
        
    }
    
    NSError *error=nil;
    NSArray *fetchResultArray = [tempContext executeFetchRequest:fetchRequest error:&error];
    
    ///判断读取出来的原数据
    if (nil == fetchResultArray) {
        
        NSLog(@"CoreData.GetData.Error:%@",error);
        return NO;
        
    }
    
    ///遍历更新
    if ([fetchResultArray count] > 0) {
        
        for (int i = 0; i < [fetchResultArray count]; i++) {
            
            ///获取模型后更新保存
            QSCDFilterDataModel *model = fetchResultArray[i];
            [model setValue:newValue forKey:fieldName];
            [tempContext save:&error];
            
            ///判断保存是否成功
            if (error) {
                
                break;
                
            }
            
        }
        
    }
    
    if (error) {
        
        NSLog(@"=====================更新指定记录某字段信息出错========================");
        NSLog(@"entity anme : %@    error:%@",entityName,error);
        NSLog(@"=====================更新指定记录某字段信息出错========================");
        return NO;
        
    }
    
    ///保存数据到本地
    if ([NSThread isMainThread]) {
        
        [appDelegate saveContextWithWait:YES];
        
    } else {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [appDelegate saveContextWithWait:NO];
            
        });
        
    }
    
    return YES;

}

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
+ (id)getUnirecordFieldWithKey:(NSString *)entityName andKeyword:(NSString *)keyword
{
    
    NSArray *resultList = [NSArray arrayWithArray:[self getEntityListWithKey:entityName andSortKeyWord:keyword andAscend:YES]];
    
    ///判断是否查询失败
    if (nil == resultList) {
        
        return nil;
        
    }
    
    ///如果获取返回的个数为0也直接返回nil
    if (0 >= [resultList count]) {
        
        return nil;
        
    }
    
    ///查询成功
    NSManagedObject *resultModel = [resultList firstObject];
    id tempResult = [resultModel valueForKey:keyword];
    return tempResult ? tempResult : nil;

}

///更新单记录表中，指定字段的信息
+ (BOOL)updateUnirecordFieldWithKey:(NSString *)entityName andUpdateField:(NSString *)fieldName andFieldNewValue:(id)newValue
{

    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有上下文
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///查询条件
    NSPredicate* predicate = [NSPredicate predicateWithValue:YES];
    [fetchRequest setPredicate:predicate];
    
    NSError *error=nil;
    NSArray *fetchResultArray = [tempContext executeFetchRequest:fetchRequest error:&error];
    
    ///判断读取出来的原数据
    if (nil == fetchResultArray) {
        
        NSLog(@"CoreData.GetData.Error:%@",error);
        return NO;
        
    }
    
    ///检测原来是否已有数据
    if (0 >= [fetchResultArray count]) {
        
        ///插入数据
        NSObject *model = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:tempContext];
        [model setValue:newValue forKey:fieldName];
        [tempContext save:&error];
        
    } else {
    
        ///获取模型后更新保存
        NSObject *model = fetchResultArray[0];
        [model setValue:newValue forKey:fieldName];
        [tempContext save:&error];
    
    }
    
    if (error) {
        
        return NO;
        
    }
    
    ///保存数据到本地
    if ([NSThread isMainThread]) {
        
        [appDelegate saveContextWithWait:YES];
        
    } else {
    
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [appDelegate saveContextWithWait:NO];
            
        });
    
    }
    
    return YES;

}

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
+ (BOOL)clearEntityListWithEntityName:(NSString *)entityName
{

    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有上下文
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:tempContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setIncludesPropertyValues:NO];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *resultArray = [tempContext executeFetchRequest:fetchRequest error:&error];
    
    ///查询失败
    if (error) {
        
        NSLog(@"CoreData.GetData.Error:%@",error);
        return NO;
        
    }
    
    ///如果本身数据就为0，则直接返回YES
    if (0 >= [resultArray count]) {
        
        return YES;
        
    }
    
    ///遍历删除
    for (NSManagedObject *obj in resultArray) {
        
        [tempContext deleteObject:obj];
        
    }
    
    ///确认删除结果
    BOOL isChangeSuccess = [tempContext save:&error];
    if (!isChangeSuccess) {
        
        NSLog(@"CoreData.DeleteData.Error:%@",error);
        
    }
    
    ///保存数据到本地
    if ([NSThread isMainThread]) {
        
        [appDelegate saveContextWithWait:YES];
        
    } else {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [appDelegate saveContextWithWait:NO];
            
        });
        
    }
    
    return isChangeSuccess;

}

/**
 *  @author             yangshengmeng, 15-01-26 18:01:50
 *
 *  @brief              删除给定实体中对应字段为特定关键字的所有记录
 *
 *  @param entityName   实体名
 *  @param fieldKey     字段名
 *  @param deleteKey    字段的内容
 *
 *  @return             返回删除是否成功
 *
 *  @since              1.0.0
 */
+ (BOOL)clearEntityListWithEntityName:(NSString *)entityName andFieldKey:(NSString *)fieldKey andDeleteKey:(NSString *)deleteKey
{

    ///获取主线程上下文
    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有上下文
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:tempContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setIncludesPropertyValues:NO];
    [fetchRequest setEntity:entity];
    
    ///设置查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[[NSString stringWithFormat:@"%@ == ",fieldKey] stringByAppendingString:@"%@"],deleteKey];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *resultArray = [tempContext executeFetchRequest:fetchRequest error:&error];
    
    ///查询失败
    if (error) {
        
        NSLog(@"CoreData.GetData.Error:%@",error);
        return NO;
        
    }
    
    ///如果本身数据就为0，则直接返回YES
    if (0 >= [resultArray count]) {
        
        return YES;
        
    }
    
    ///遍历删除
    for (NSManagedObject *obj in resultArray) {
        
        [tempContext deleteObject:obj];
        
    }
    
    ///确认删除结果
    BOOL isChangeSuccess = [tempContext save:&error];
    if (!isChangeSuccess) {
        
        NSLog(@"CoreData.DeleteData.Error:%@",error);
        
    }
    
    ///保存数据到本地
    if ([NSThread isMainThread]) {
        
        [appDelegate saveContextWithWait:YES];
        
    } else {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [appDelegate saveContextWithWait:NO];
            
        });
        
    }
    
    return isChangeSuccess;

}

@end
