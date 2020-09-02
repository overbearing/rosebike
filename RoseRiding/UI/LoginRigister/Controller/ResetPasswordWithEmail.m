//
//  ResetPasswordWithEmail.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/23.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "ResetPasswordWithEmail.h"

@interface ResetPasswordWithEmail ()

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UITextField *passwordDouble;
@property (weak, nonatomic) IBOutlet UIButton *submit;

@property (nonatomic, strong)dispatch_source_t timer;

@end

@implementation ResetPasswordWithEmail

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideNavigationView = YES;
    self.password.placeholder = [GlobalControlManger enStr:@"new password" geStr:@"new password"];
    self.passwordDouble.placeholder = [GlobalControlManger enStr:@"Double check" geStr:@"double check"];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)getCode:(id)sender {
    
    if (![self isValidEamil:self.email.text]) {
        NSString *msg = @"please input a valid eamil";
        [Toast showToastMessage:msg];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = host(@"email/email");
    NSDictionary *para = @{@"id":@"2",@"email":self.email.text};
    [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger stateCode = [result[@"code"] integerValue];
        NSString *msg = result[@"msg"];
        if (![msg isEqualToString:@""]) {
            [Toast showToastMessage:msg];
        }
        if (stateCode == 1) {
            //成功
            [self beginCountdown];
        }
    } fail:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (IBAction)submitAction:(id)sender {
    if (self.email.text.length == 0) {
         [Toast showToastMessage:@"please input email"];
        return;
    }
    
    if (![self isValidEamil:self.email.text]) {
        NSString *msg = [GlobalControlManger enStr:@"please input a valid email" geStr:@"please input a valid email"];
        [Toast showToastMessage:msg];
        return;
    }
    
    if (self.code.text.length == 0) {
         [Toast showToastMessage:[GlobalControlManger enStr:@"please input code" geStr:@"please input code"]];
        return;
    }
    if (self.password.text.length == 0) {
        [Toast showToastMessage:[GlobalControlManger enStr: @"please input password" geStr:@"please input password"]];
        return;
    }
    if (self.passwordDouble.text.length == 0) {
        [Toast showToastMessage:[GlobalControlManger enStr:@"please input password again"geStr:@"please input password again"]];
        return;
    }
    
    if (![self.password.text isEqualToString:self.passwordDouble.text]) {
        [Toast showToastMessage:[GlobalControlManger enStr:@"please input some password" geStr: @"please input some password"]];
           return;
    }
    
    if (![self isValidPassword:self.password.text]) {
        NSString *msg = [GlobalControlManger enStr:@"● include both upper and lower case characters;\n● include at least one number;\n● be at least 8 characters long" geStr:@"● include both upper and lower case characters;\n● include at least one number;\n● be at least 8 characters long"];
        [Toast showToastMessage:msg];
        return;
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = host(@"user/retrieve");
    NSDictionary *para = @{@"email":self.email.text,@"yzm":self.code.text,@"password":self.password.text,@"repeat":self.passwordDouble.text};
    [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger stateCode = [result[@"code"] integerValue];
        NSString *msg = result[@"msg"];
        if (![msg isEqualToString:@""]) {
            [Toast showToastMessage:msg];
        }        if (stateCode == 1) {
            //返回
            [self goBack];
        }
    } fail:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
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
                 self.getCodeBtn.userInteractionEnabled = YES;
                 [self.getCodeBtn setTitle:[NSString stringWithFormat:@"Get Code"] forState:UIControlStateNormal];
                 second = 60;
                 //(6)
                 dispatch_cancel(self.timer);
             } else {
                 self.getCodeBtn.userInteractionEnabled = NO;
                 [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%lds",second] forState:UIControlStateNormal];
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

// 验证密码 - 由数字和26个英文字母组成的字符串
- (BOOL)isValidPassword:(NSString *)password {
    NSString *regEx = @"^(?![0-9]+$)(?![a-z]+$)(?![A-Z]+$)[0-9A-Za-z]{8,20}$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    if ([passwordTest evaluateWithObject:password]) {
        //是否包含大写字母
        NSString *regex = @"^[0-9a-z]+$";
        NSPredicate *predicateRe = [NSPredicate predicateWithFormat:@"self matches %@", regex];
        return ![predicateRe evaluateWithObject:password];
    }else{
        return NO;
    }
}

- (BOOL)isValidEamil:(NSString *)email{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}



@end
