//
//  HelpCell.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/31.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "HelpCell.h"

@interface HelpCell ()
@property (weak, nonatomic) IBOutlet UILabel *menuname;

@property (weak, nonatomic) IBOutlet UILabel *rightConetnt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightContentCons;


@end

@implementation HelpCell



- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(0, 10, self.width, self.height - 10);
    for (UIView *obj in self.subviews) {
        if ([NSStringFromClass([obj class]) isEqualToString:@"_UITableCellAccessoryButton"]) {
            CGRect rect = obj.frame;
            rect.origin.y = rect.origin.y + 5;
            obj.frame = rect;
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            self.menuname.text = [GlobalControlManger enStr:@"Support Email" geStr:@"Support Email"];
            self.rightConetnt.hidden = NO;
            self.rightContentCons.constant = 17;
            self.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
        case 1:
        {
            self.menuname.text = [GlobalControlManger enStr:@"User Agreement" geStr:@"User Agreement"];
            self.rightConetnt.hidden = YES;
            self.rightContentCons.constant = 17;
             self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 2:
        {
            self.menuname.text = [GlobalControlManger enStr: @"Hot Questions" geStr: @"Hot Questions"];
            self.rightConetnt.hidden = YES;
            self.rightContentCons.constant = 17;
             self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        default:
            break;
    }
}

@end
