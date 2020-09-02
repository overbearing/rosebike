//
//  YJJTextField.m
//  YJJTextField
//
//  Created by MR_THT on 2017/6/5.
//  Copyright © 2017年 MR_THT. All rights reserved.
//

#import "YJJTextField.h"

#define YJJ_Color(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

const static CGFloat animateDuration = 0.5;

@interface YJJTextField ()<UITextFieldDelegate>

/** 上浮的占位文本 */
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
/** 底部线条 */
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
/** 错误提示文本 */
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;

@property (nonatomic, strong)dispatch_source_t timer;


@end

@implementation YJJTextField

#pragma mark - 初始化
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.textField.delegate = self;
    
    self.textColor = YJJ_Color(85, 85, 85);
    self.textLengthLabelColor = YJJ_Color(92, 94, 102);
    self.placeHolderLabelColor = YJJ_Color(1, 183, 164);
    self.lineDefaultColor = YJJ_Color(220, 220, 220);
    self.lineSelectedColor = YJJ_Color(1, 183, 164);
    self.lineWarningColor = YJJ_Color(252, 57, 24);
}


#pragma mark - 公共方法
+ (instancetype)yjj_textField
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}

- (void)setPlaceHolderLabelHidden:(BOOL)isHidden
{
    if (isHidden) {
//        [UIView animateWithDuration:animateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.placeHolderLabel.alpha = 0.0f;
            self.textField.placeholder = self.placeholder;
            self.bottomLine.backgroundColor = self.lineDefaultColor;
//        } completion:nil];
    }else{
//        [UIView animateWithDuration:animateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.placeHolderLabel.alpha = 1.0f;
            self.placeHolderLabel.text = self.placeholder;
            self.textField.placeholder = @"";
            self.bottomLine.backgroundColor = self.lineSelectedColor;
//        } completion:nil];
    }
}

#pragma mark - UITextFieldDelegate
- (IBAction)textFieldEditingChanged:(UITextField *)sender
{
    if (sender.text.length > self.maxLength) {
//        [UIView animateWithDuration:animateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.errorLabel.alpha = 1.0;
            self.errorLabel.textColor = self.lineWarningColor;
            self.bottomLine.backgroundColor = self.lineWarningColor;
            self.textField.textColor = self.lineWarningColor;
            //self.placeHolderLabel.textColor = self.lineWarningColor;
//        } completion:nil];
    }else{
//        [UIView animateWithDuration:animateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.errorLabel.alpha = 0.0;
            self.bottomLine.backgroundColor = self.lineSelectedColor;
            self.textField.textColor = self.textColor;
            //self.placeHolderLabel.textColor = self.placeHolderLabelColor;
//        } completion:nil];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setPlaceHolderLabelHidden:NO];
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
//    [self setPlaceHolderLabelHidden:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    
//    [self setPlaceHolderLabelHidden:YES];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length > 0) {
        [self setPlaceHolderLabelHidden:NO];
    }else{
        [self setPlaceHolderLabelHidden:YES];
    }
}

#pragma mark - setter
- (void)setMaxLength:(NSInteger)maxLength
{
    _maxLength = maxLength;
}
- (void)setErrorStr:(NSString *)errorStr
{
    _errorStr = errorStr;
    self.errorLabel.text = errorStr;
}
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
    self.placeHolderLabel.text = placeholder;
}
- (void)setLeftImageName:(NSString *)leftImageName
{
    _leftImageName = leftImageName;
}
- (void)setTextFont:(CGFloat)textFont
{
    _textFont = textFont;
    self.textField.font = [UIFont systemFontOfSize:textFont];
}
- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.textField.textColor = textColor;
    self.tintColor = textColor;         // 光标颜色
}
- (void)setPlaceHolderFont:(CGFloat)placeHolderFont
{
    _placeHolderFont = placeHolderFont;
    [self.textField setValue:[UIFont systemFontOfSize:placeHolderFont] forKeyPath:@"_placeholderLabel.font"];
}
- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    _placeHolderColor = placeHolderColor;
    [self.textField setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
}
- (void)setTextLengthLabelColor:(UIColor *)textLengthLabelColor
{
    _textLengthLabelColor = textLengthLabelColor;
}
- (void)setPlaceHolderLabelColor:(UIColor *)placeHolderLabelColor
{
    _placeHolderLabelColor = placeHolderLabelColor;
    self.placeHolderLabel.textColor = placeHolderLabelColor;
}
- (void)setLineDefaultColor:(UIColor *)lineDefaultColor
{
    _lineDefaultColor = lineDefaultColor;
    self.bottomLine.backgroundColor = lineDefaultColor;
}
- (void)setLineSelectedColor:(UIColor *)lineSelectedColor
{
    _lineSelectedColor = lineSelectedColor;
}
- (void)setLineWarningColor:(UIColor *)lineWarningColor
{
    _lineWarningColor = lineWarningColor;
}

- (void)setShowVer:(BOOL)showVer{
    self.verificationBtn.hidden = !showVer;
}

- (void)beginCountdown{
    __block NSInteger second = 60;
     //(1)
     dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     //(2)
     self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
     //(3)
     dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
     //(4)
     dispatch_source_set_event_handler(self.timer, ^{
         dispatch_async(dispatch_get_main_queue(), ^{
             if (second == 0) {
                 self.verificationBtn.userInteractionEnabled = YES;
                 [self.verificationBtn setTitle:[NSString stringWithFormat:@"Get Code"] forState:UIControlStateNormal];
                 second = 60;
                 //(6)
                 dispatch_cancel(self.timer);
             } else {
                 self.verificationBtn.userInteractionEnabled = NO;
                 [self.verificationBtn setTitle:[NSString stringWithFormat:@"%lds",second] forState:UIControlStateNormal];
                 second--;
             }
         });
     });
     //(5)
     dispatch_resume(self.timer);
    
}

- (void)cancleCountdown{
    dispatch_cancel(self.timer);
}
- (IBAction)getVerCodeAction:(UIButton *)sender {
    
    if (self.getCode) {
        self.getCode();
    }
    
}

- (void)setCleanMode:(UITextFieldViewMode)cleanMode{
    self.textField.clearButtonMode = cleanMode;
}



@end
