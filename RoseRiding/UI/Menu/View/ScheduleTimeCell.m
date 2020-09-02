//
//  ScheduleTimeCell.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/13.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "ScheduleTimeCell.h"

@interface ScheduleTimeCell ()


- (IBAction)showimage:(UIButton *)sender;

@end

@implementation ScheduleTimeCell

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
        case 0:{
            self.name.text = [GlobalControlManger enStr:@"every Sunday" geStr:@"every Sunday"];
        }
            break;
        case 1:{
            self.name.text = [GlobalControlManger enStr:@"every Monday" geStr:@"Every eonday"];
        }
            break;
        case 2:{
            self.name.text = [GlobalControlManger enStr: @"every Tuesday" geStr: @"every Tuesday"];
        }
            break;
        case 3:{
            self.name.text = [GlobalControlManger enStr:@"every Wednesday" geStr:@"every Wednesday"];
        }
            break;
        case 4:{
            self.name.text = [GlobalControlManger enStr:@"every Thursday" geStr:@"every Thursday"];
        }
            break;
        case 5:{
            self.name.text = [GlobalControlManger enStr:@"every Friday" geStr:@"every Friday"];
        }
            break;
        case 6:{
            self.name.text = [GlobalControlManger enStr:@"every Saturday" geStr:@"every Saturday"];
        }
            break;
        default:
            break;
    }
    
    self.selectIcon.hidden = YES;
}

- (IBAction)showimage:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.selectIcon.hidden = !sender.selected;
    if (sender.selected) {
        if (self.choose) {
            self.choose();
        }
    }else{
        if (self.deletetime) {
            self.deletetime();
              
        }
    }
}
@end
