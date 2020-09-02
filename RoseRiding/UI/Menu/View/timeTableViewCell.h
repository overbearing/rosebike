//
//  timeTableViewCell.h
//  RoseRiding
//
//  Created by Mac on 2020/7/6.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface timeTableViewCell : UITableViewCell
- (void)configureWithIndexpath:(NSIndexPath *)indexPath showSelect:(BOOL)show;
@end

NS_ASSUME_NONNULL_END
