//
//  MessageListCell.h
//  RoseRiding
//
//  Created by MR_THT on 2020/3/31.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageListCell : UITableViewCell

@property (nonatomic , strong)MessageListModel *model;

@end

NS_ASSUME_NONNULL_END
