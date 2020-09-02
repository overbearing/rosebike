//
//  EditDeviceCell.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/6.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditDeviceCell : UITableViewCell

@property (nonatomic , assign)BOOL canInput;
- (void)configureLeftName:(NSString *)name rightInfo:(NSString *)info;

@end

NS_ASSUME_NONNULL_END
