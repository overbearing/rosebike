//
//  ResetPasswordWithPhone.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/23.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "ResetPasswordWithPhone.h"

@interface ResetPasswordWithPhone ()

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *getCodeBtn;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UITextField *passwordDouble;
@property (weak, nonatomic) IBOutlet UIButton *submit;

@end

@implementation ResetPasswordWithPhone

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideNavigationView = YES;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)getCode:(id)sender {
    
    
}

- (IBAction)submitAction:(id)sender {
    
    
}

@end
