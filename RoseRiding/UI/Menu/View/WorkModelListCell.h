//
//  WorkModelListCell.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/12.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkModel.h"


NS_ASSUME_NONNULL_BEGIN
typedef void(^WorkModelListCellTrans)(void);
@interface WorkModelListCell : UITableViewCell
-(void)configureWithIndexpath:(NSIndexPath *)indexPath;
@property (nonatomic, copy)WorkModelListCellTrans trans;
@property (nonatomic , strong)WorkModel *model;
@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
