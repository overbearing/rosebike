//
//  AllMessageTableViewCell.m
//  RoseRiding
//
//  Created by Mac on 2020/6/2.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "AllMessageTableViewCell.h"

@interface AllMessageTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *messageTitle;
@property (weak, nonatomic) IBOutlet UILabel *messageContent;
@property (weak, nonatomic) IBOutlet UILabel *messageTime;

@end
@implementation AllMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(AllMessageListModel *)model{
    self.messageTitle.text = model.msgTtile;
    self.messageContent.text = model.value;
    self.messageTime.text = model.date;
    NSArray *array = [self.messageTime.text componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
    NSString * newtime = @"";
    for (int i = (int)array.count-1 ; i>= 0; i--) {
         newtime = [newtime stringByAppendingFormat:@"%@.", [array objectAtIndex:i]];
    }
    self.messageTime.text = newtime;
//        NSLog(@"%@",model.time);

}
@end
