//
//  QSChatMessageListTableViewCell.h
//  House
//
//  Created by ysmeng on 15/2/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///消息列表中不同的cell类型
typedef enum
{

    mMessageListCellTypeNormal = 99,    //!<普通的消息提醒cell
    mMessageListCellTypeSystemInfo,     //!<房当家团队推送消息
    mMessageListCellTypeHouseRecommend  //!<推荐房源推送消息

}MESSAGELIST_CELL_TYPE;                 //!<消息提醒列表中不同的cell类型

/**
 *  @author yangshengmeng, 15-02-09 13:02:26
 *
 *  @brief  消息列表中，每一个消息提醒的cell
 *
 *  @since  1.0.0
 */
@interface QSChatMessageListTableViewCell : UITableViewCell

/**
 *  @author                 yangshengmeng, 15-02-09 14:02:25
 *
 *  @brief                  根据cell的类型，创建对应的消息提醒cell
 *
 *  @param style            cell的风格
 *  @param reuseIdentifier  复用标签
 *  @param cellType         消息cell的类型
 *
 *  @return                 返回当前创建的cell
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andCellType:(MESSAGELIST_CELL_TYPE)cellType;

@end
