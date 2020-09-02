//
//  BluetoothListCell.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/28.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^BluetoothListCellConnectClick)(void);
NS_ASSUME_NONNULL_BEGIN

@interface BluetoothListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (nonatomic , copy)BluetoothListCellConnectClick conenct;

@end

NS_ASSUME_NONNULL_END
