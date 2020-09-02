//
//  UserInfoMenuCell.h
//  RoseRiding
//
//  Created by MR_THT on 2020/3/31.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoMenuCell : UITableViewCell

- (void)configureCellWithIndexpath:(NSIndexPath *)indexPath rightContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
