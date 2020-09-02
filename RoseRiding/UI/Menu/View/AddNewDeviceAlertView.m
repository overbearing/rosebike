//
//  AddNewDeviceAlertView.m
//  RoseRiding
//
//  Created by LaoSun on 2020/4/15.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "AddNewDeviceAlertView.h"

@implementation AddNewDeviceAlertView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"AddNewDeviceAlertView" owner:self options:nil] lastObject];
    if(self)
    {
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithRed:18/255.0 green:18/255.0 blue:18/255.0 alpha:0.58];
        
        self.bgView.layer.cornerRadius = 8.0;
        self.bgView.layer.masksToBounds = YES;
        
        self.inputTF.layer.cornerRadius = 19.0;
        self.inputTF.layer.masksToBounds = YES;
        self.inputTF.delegate = self;
        
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 0){
        if (_returnTextBlock) {
            self.returnTextBlock(textField.text);
        }
        return YES;
    }else {
        
        return NO;
    }
}

- (IBAction)hideViewClick:(UIButton *)sender {
    [self removeFromSuperview];
}

-(void)hideAlertView {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
