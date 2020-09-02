//
//  AddNewDeviceAlertView.h
//  RoseRiding
//
//  Created by LaoSun on 2020/4/15.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddNewDeviceAlertView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTF;

@property (nonatomic, copy) void(^returnTextBlock)(NSString *text);

-(void)hideAlertView;

@end

NS_ASSUME_NONNULL_END
