//
//  EditDeviceCell.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/6.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "EditDeviceCell.h"

@interface EditDeviceCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *leftName;
@property (weak, nonatomic) IBOutlet UITextField *rightContent;

@end

@implementation EditDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.rightContent.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCanInput:(BOOL)canInput{
    _canInput = canInput;
    self.rightContent.enabled = canInput;
}

- (void)configureLeftName:(NSString *)name rightInfo:(NSString *)info{
    self.leftName.text = name;
    self.rightContent.text = info;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

@end
