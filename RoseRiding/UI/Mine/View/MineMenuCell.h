//
//  MineMenuCell.h
//  RoseRiding
//
//  Created by MR_THT on 2020/3/30.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineMenuCell : UITableViewCell

- (void)configureCellWithIndexpath:(NSIndexPath *)indexPath showTip:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
