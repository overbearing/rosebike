//
//  ScheduledWorkingCell.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/13.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "ScheduledWorkingCell.h"

@interface ScheduledWorkingCell ()

@property (weak, nonatomic) IBOutlet UIButton *name;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingCons;


@end

@implementation ScheduledWorkingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.name.layer.borderColor = [[UIColor colorWithHexString:@"#121212"] CGColor];
    self.name.layer.borderWidth = 1;
    // Configure the view for the selected state
}

- (void)configureCellWithName:(NSString *)name isEdit:(BOOL)isEdit{
    [self.name setTitle:name forState:UIControlStateNormal];
    if (isEdit) {
        self.delBtn.hidden = NO;
        self.trailingCons.constant = 75;
    }else{
        self.delBtn.hidden = YES;
        self.trailingCons.constant = 24;
    }
}
- (IBAction)edit:(id)sender {
    if (self.editAction) {
        self.editAction();
    }
    
}
- (IBAction)del:(id)sender {
    if (self.delAction) {
        self.delAction();
      }
    
}

@end
