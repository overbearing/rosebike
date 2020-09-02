//
//  timeTableViewCell.m
//  RoseRiding
//
//  Created by Mac on 2020/7/6.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "timeTableViewCell.h"
@interface timeTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *selectIcon;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
@implementation timeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureWithIndexpath:(NSIndexPath *)indexPath showSelect:(BOOL)show{
    if ([MyDevicemanger shareManger].mainDevice.isConnecting) {
            self.name.textColor = [UIColor lightGrayColor];
               }
    switch (indexPath.row) {
        case 0:
            self.name.text = @"10 s";
            break;
        case 1:
            self.name.text = @"40 s";
            break;
        default:
            break;
    }
    
    self.selectIcon.image = show ? [UIImage imageNamed:@"agreement_selected"]:[UIImage imageNamed:@"agreement_normal"];
}

@end
