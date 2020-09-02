//
//  MangerMentCell.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/7.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "MangerMentCell.h"

@interface MangerMentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *count;

@end

@implementation MangerMentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellwith:(NSIndexPath *)indexpath{
    if (indexpath.row == 0) {
        self.icon.image = [UIImage imageNamed:@"numdevice"];
        self.name.text = [GlobalControlManger enStr:@"number of devices" geStr:@"number of devices"];
        self.count.text = [NSString stringWithFormat:@"%ld",[MyDevicemanger shareManger].Devices.count];
        self.count.hidden = NO;
        self.accessoryType = UITableViewCellAccessoryNone;
    }else if (indexpath.row == 1){
        self.icon.image = [UIImage imageNamed:@"phone"];
        self.name.text = [GlobalControlManger enStr:@"name of major device" geStr:@"name of major device"];
        self.count.text = @"5";
        self.count.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexpath.row == 2){
        self.icon.image = [UIImage imageNamed:@"add_de"];
        self.name.text = [GlobalControlManger enStr:@"device manager" geStr:@"device manager"];
        self.count.text = @"5";
        self.count.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexpath.row == 3){
        self.icon.image = [UIImage imageNamed:@"workmodel"];
        self.name.text = [GlobalControlManger enStr:@"woking mode" geStr:@"woking mode"];
        self.count.text = @"5";
        self.count.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

@end
