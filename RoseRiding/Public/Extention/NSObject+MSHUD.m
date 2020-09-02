//
//  NSObject+MSHUD.m
//  RoseRiding
//
//  Created by LaoSun on 2020/4/13.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "NSObject+MSHUD.h"

//#import <AppKit/AppKit.h>


@implementation NSObject (MSHUD)

- (void)showTextHUD:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
       [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
       MBProgressHUD *textHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
       textHUD.mode = MBProgressHUDModeText;
       textHUD.label.text = text;
       textHUD.label.textColor = [UIColor whiteColor];
       textHUD.margin = 10;
       textHUD.bezelView.color = [UIColor blackColor];
       textHUD.userInteractionEnabled = NO;
       [textHUD showAnimated:YES];
       [textHUD hideAnimated:YES afterDelay:2.5];
    });
    
}

-(void)showTextLoadingHUD:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
        MBProgressHUD *textHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
        textHUD.mode = MBProgressHUDModeIndeterminate;
        textHUD.label.text = text;
        textHUD.label.textColor = [UIColor whiteColor];
        textHUD.margin = 10;
        textHUD.bezelView.color = [UIColor blackColor];
        textHUD.userInteractionEnabled = NO;
        [textHUD showAnimated:YES];
    });
}

- (void)showLoadingHUD {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.square = YES;
        hud.userInteractionEnabled = NO;
        hud.bezelView.color = [UIColor whiteColor];
        [hud showAnimated:YES];
    });
    
}

- (void)hideLoadingHUD {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
    });
}

@end
