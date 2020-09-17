//
//  MineMenuCell.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/30.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "MineMenuCell.h"

@interface MineMenuCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *tip;


@end

@implementation MineMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithIndexpath:(NSIndexPath *)indexPath showTip:(BOOL)show{
    
    switch (indexPath.row) {
        case 0:
        {
            self.name.text = [GlobalControlManger enStr:@"My Bikes" geStr: @"My Bikes"];
            self.icon.image = [UIImage imageNamed:@"mine_device"];
            self.tip.hidden = YES;
        }
            break;
        case 1:
        {
            self.name.text = [GlobalControlManger enStr:@"message" geStr:@"message"];
            self.icon.image = [UIImage imageNamed:@"mine_message_normal"];
            self.tip.hidden = YES;
        }
            break;
        case 2:
        {
            self.name.text = [GlobalControlManger enStr:@"help" geStr:@"help"];
            self.icon.image = [UIImage imageNamed:@"mine_help"];
            self.tip.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

@end
