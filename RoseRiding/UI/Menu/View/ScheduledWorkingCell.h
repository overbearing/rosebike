//
//  ScheduledWorkingCell.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/13.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ScheduledWorkingCellEdit)(void);
typedef void(^ScheduledWorkingCellDel)(void);

@interface ScheduledWorkingCell : UITableViewCell

- (void)configureCellWithName:(NSString *)name isEdit:(BOOL)isEdit;
@property (nonatomic , copy)ScheduledWorkingCellDel delAction;
@property (nonatomic , copy)ScheduledWorkingCellEdit editAction;
@end

NS_ASSUME_NONNULL_END
