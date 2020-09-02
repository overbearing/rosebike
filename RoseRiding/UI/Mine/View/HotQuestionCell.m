//
//  HotQuestionCell.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/2.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "HotQuestionCell.h"

@interface HotQuestionCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;


@end

@implementation HotQuestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(0, 0, self.width, self.height - 10);
    for (UIView *obj in self.subviews) {
        if ([NSStringFromClass([obj class]) isEqualToString:@"_UITableCellAccessoryButton"]) {
            CGRect rect = obj.frame;
            rect.origin.y = rect.origin.y - 5;
            obj.frame = rect;
        }
    }
}

- (void)setModel:(HelpModel *)model{
    self.name.text = model.name;
}

@end
