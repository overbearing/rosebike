//
//  MsgDetailCell.m
//  RoseRiding
//
//  Created by Mac on 2020/6/5.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "MsgDetailCell.h"
@interface MsgDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *msgtitle;
@property (weak, nonatomic) IBOutlet UILabel *msgcontent;
@property (weak, nonatomic) IBOutlet UILabel *msgtime;
@end
@implementation MsgDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(MsgDetailModel *)model{
//    self.msgtitle.text = model.title;
//     //(@"msgTtile------------%@",model.msgtype);
    self.msgcontent.text = model.value;
    self.msgtime.text = model.date;
    NSArray *array = [model.date componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
       NSString * newtime = @"";
       for (int i = (int)array.count-1 ; i>= 0; i--) {
            newtime = [newtime stringByAppendingFormat:@"%@.", [array objectAtIndex:i]];
       }
    self.msgtime.text = [newtime stringByAppendingString:[NSString stringWithFormat:@"%@",model.time]] ;
      
}
@end
