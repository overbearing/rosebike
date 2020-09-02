//
//  MenuCell.h
//  RoseRiding
//
//  Created by MR_THT on 2020/3/30.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenuCell : UITableViewCell

@property (nonatomic, assign)BOOL isSetting;

- (void)configureCellwith:(NSIndexPath *)indexpath;

@end

NS_ASSUME_NONNULL_END
