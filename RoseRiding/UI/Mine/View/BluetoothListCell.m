//
//  BluetoothListCell.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/28.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "BluetoothListCell.h"


@implementation BluetoothListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)connect:(id)sender {
    if (self.conenct) {
        self.conenct();
    }
}


@end
