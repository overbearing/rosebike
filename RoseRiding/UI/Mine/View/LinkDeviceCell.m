//
//  LinkDeviceCell.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/5.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "LinkDeviceCell.h"

@interface LinkDeviceCell ()
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;

@end

@implementation LinkDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.linkLabel.clipsToBounds = YES;
    self.linkLabel.layer.cornerRadius = 4;
    self.linkLabel.layer.borderColor = [UIColor colorWithHexString:@"#EDEDED"].CGColor;
    self.linkLabel.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
