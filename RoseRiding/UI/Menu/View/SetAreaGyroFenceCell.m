//
//  SetAreaGyroFenceCell.m
//  RoseRiding
//
//  Created by MR_THT on 2020/5/4.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "SetAreaGyroFenceCell.h"

@interface SetAreaGyroFenceCell ()

@property (weak, nonatomic) IBOutlet UIImageView *selectIcon;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation SetAreaGyroFenceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithIndexpath:(NSIndexPath *)indexPath showSelect:(BOOL)show{
    switch (indexPath.row) {
        case 0:
            self.name.text = @"10";
            if (![MyDevicemanger shareManger].mainDevice.isConnecting) {
                self.name.textColor = [UIColor lightGrayColor];
            }
            break;
        case 1:
            self.name.text = @"100";
            break;
        case 2:
            self.name.text = @"200";
            break;
        case 3:
            self.name.text = @"300";
            break;
        default:
            break;
    }
    
    self.selectIcon.image = show ? [UIImage imageNamed:@"agreement_selected"]:[UIImage imageNamed:@"agreement_normal"];
}


@end
