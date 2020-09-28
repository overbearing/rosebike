
//
//  RegistViewController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/27.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "RegistViewController.h"
#import "YJJTextField.h"
#import "UserAgreementController.h"

#import "NSString+Encryption.h"
@interface RegistViewController ()

@property (nonatomic, assign) YJJTextField *userNameField;
@property (nonatomic, assign) YJJTextField *passwordField;
@property (nonatomic, assign) YJJTextField *verificationCode;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) NSArray *textFieldArr;
@property (nonatomic, strong) UILabel *resetPassWordTopTip;
@property (nonatomic, strong) UILabel * currentLocale;
@property (nonatomic, strong) UIButton *agreeBtn;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, assign) BOOL       canGetVerificationcode;
@property (nonatomic, assign) BOOL       agreeUserAgreement;
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//   self.deviceTokenString = [self createDeviceTokenString:appDelegate.deviceToken];
      [self setupUI];
    [self setRACSignal];
    self.barStyle = NavigationBarStyleWhite;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [IQKeyboardManager sharedManager].enable = YES;
}

- (NSString*) createDeviceTokenString:(NSData*) deviceToken {
    const unsigned char *tokenChars = deviceToken.bytes;

    NSMutableString *tokenString = [NSMutableString string];
    for (int i=0; i < deviceToken.length; i++) {
        NSString *hex = [NSString stringWithFormat:@"%02x", tokenChars[i]];
        [tokenString appendString:hex];
    }
    return tokenString;
}
- (void)setupUI
{
    self.icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rose_logo_white"]];
    [self.view addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(Adaptive(isIphoneX?132:120));
        make.width.equalTo(@124);
        make.height.equalTo(@61.5);
    }];
    self.currentLocale = [[UILabel alloc]init];
    self.currentLocale.textColor = [UIColor blackColor];
    self.currentLocale.font = [UIFont systemFontOfSize:16];
    self.currentLocale.text = [NSString stringWithFormat:@"+ %@",[self configNSLocale]];
    self.currentLocale.hidden = self.isMail;
    [self.view addSubview:self.currentLocale];
    [self.currentLocale mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.view).offset(Adaptive(isIphoneX?270:220));
               make.trailing.equalTo(self.view).offset(-Adaptive(65));
        make.leading.equalTo(self.view).offset(15);
               make.height.equalTo(@60);
        
    }];
    YJJTextField *userNameField = [YJJTextField yjj_textField];
    userNameField.maxLength = NSIntegerMax;
    userNameField.errorStr = @"*字数长度不得超过11位";
    if (self.isMail) {
        userNameField.placeholder = @"Email";
    }else{
        userNameField.placeholder = @"Phone Number";
    }
    userNameField.placeHolderLabelColor = [UIColor colorWithHexString:@"#838383"];
    userNameField.lineDefaultColor = [UIColor colorWithHexString:@"#EDEDED"];
    userNameField.lineSelectedColor = [UIColor colorWithHexString:@"#EDEDED"];
    [self.view addSubview:userNameField];
    self.userNameField = userNameField;
    [self.userNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(Adaptive(isIphoneX?272:220));
        make.trailing.equalTo(self.view).offset(-Adaptive(65));
        make.leading.equalTo(self.view).offset(Adaptive(65));
        make.height.equalTo(@70);
    }];
    YJJTextField *passwordField = [YJJTextField yjj_textField];
    passwordField.maxLength = NSIntegerMax;
    passwordField.errorStr = @"*密码长度不得超过8位";
    passwordField.placeholder = @"Set Password";
    passwordField.textField.secureTextEntry = YES;
    passwordField.placeHolderLabelColor = [UIColor colorWithHexString:@"#838383"];
    passwordField.lineDefaultColor = [UIColor colorWithHexString:@"#EDEDED"];
    passwordField.lineSelectedColor = [UIColor colorWithHexString:@"#EDEDED"];
    [self.view addSubview:passwordField];
    self.passwordField = passwordField;
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameField.mas_bottom).offset(Adaptive(10));
        make.trailing.equalTo(self.view).offset(-Adaptive(65));
        make.leading.equalTo(self.view).offset(Adaptive(65));
        make.height.equalTo(@70);
    }];
    YJJTextField *verificationCode = [YJJTextField yjj_textField];
    verificationCode.maxLength = NSIntegerMax;
    verificationCode.errorStr = @"*密码长度不得超过8位";
    verificationCode.placeholder = @"Verification code";
    verificationCode.placeHolderLabelColor = [UIColor colorWithHexString:@"#838383"];
    verificationCode.lineDefaultColor = [UIColor colorWithHexString:@"#EDEDED"];
    verificationCode.lineSelectedColor = [UIColor colorWithHexString:@"#EDEDED"];
    verificationCode.cleanMode = UITextFieldViewModeNever;
      [self.view addSubview:verificationCode];
      self.verificationCode = verificationCode;
      [self.verificationCode mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(self.passwordField.mas_bottom).offset(Adaptive(10));
          make.trailing.equalTo(self.view).offset(-Adaptive(65));
          make.leading.equalTo(self.view).offset(Adaptive(65));
          make.height.equalTo(@70);
      }];
    verificationCode.showVer = YES;
    kWeakSelf
    verificationCode.getCode = ^{
        if (weakSelf.userNameField.textField.text.length == 0) {
            NSString *msg = @"please input your email";
            [Toast showToastMessage:msg];
        }else{
            if ([self isValidEamil:self.userNameField.textField.text]) {
                if (self.passwordField.textField.text.length == 0) {
                    NSString *msg = @"please input your password";
                    [Toast showToastMessage:msg];
                }else{
                    if ([self isValidPassword:self.passwordField.textField.text]) {
                        [weakSelf getVerificationCode];
                    }else{
                        NSString *msg = @"● include both upper and lower case characters;\n● include at least one number;\n● be at least 8 charactrers long";
                        [Toast showToastMessage:msg];
                    }
                }
            }else{
                NSString *msg = @"please input a valid email";
                [Toast showToastMessage:msg];
            }
        }
    };
    self.textFieldArr = @[userNameField,passwordField,verificationCode];
    UIButton *loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [loginBtn setTitle:@"Sign up" forState:(UIControlStateNormal)];
    loginBtn.titleLabel.font = kFont(22);
    [loginBtn setBackgroundColor:[UIColor colorWithHexString:@"#121212"]];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verificationCode.mas_bottom).offset(Adaptive(20));
        make.trailing.equalTo(self.view).offset(-Adaptive(65));
        make.leading.equalTo(self.view).offset(Adaptive(65));
        make.height.equalTo(@48);
    }];
    self.loginBtn.layer.cornerRadius = 2;
    self.resetPassWordTopTip = [[UILabel alloc] init];
    self.resetPassWordTopTip.textColor = [UIColor colorWithHexString:@"#1C1C1C"];
    NSString *tip = [GlobalControlManger enStr:@"I agree to the terms of the User Agreement" geStr:@"I agree to the terms of the User Agreement"];
    self.resetPassWordTopTip.userInteractionEnabled = YES;
    self.resetPassWordTopTip.font = kFont(13);
    NSMutableAttributedString *att  = [[NSMutableAttributedString alloc]initWithString:tip];
    [att addAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:[tip rangeOfString:@"User Agreement"]];
    [att addAttributes:@{NSFontAttributeName:kFont(13)} range:NSMakeRange(0, tip.length)];
    [att addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#1C1C1C"]} range:NSMakeRange(0, tip.length)];
    self.resetPassWordTopTip.attributedText = att;
    [self.resetPassWordTopTip addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goUserAgent)]];
    [self.view addSubview:self.resetPassWordTopTip];
    [self.resetPassWordTopTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.mas_bottom).offset(Adaptive(31));
        make.centerX.equalTo(self.view).offset(16);
    }];
    
    self.agreeBtn = [[UIButton alloc] init];
    [self.agreeBtn setImage:[UIImage imageNamed:@"agreement_normal"] forState:UIControlStateNormal];
    [self.agreeBtn setImage:[UIImage imageNamed:@"agreement_selected"] forState:UIControlStateSelected];
    [self.view addSubview:self.agreeBtn];
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.resetPassWordTopTip.mas_left).offset(-8);
        make.centerY.equalTo(self.resetPassWordTopTip);
        make.width.height.equalTo(@(Adaptive(18)));
    }];
    [[self.agreeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.agreeBtn.selected = !self.agreeBtn.selected;
        self.agreeUserAgreement = self.agreeBtn.isSelected;
    }];
}

- (void)goUserAgent{
    UserAgreementController *VC = [UserAgreementController new];
    [self presentViewController:VC animated:YES completion:nil];
}

- (void)setRACSignal
{
    // 创建用户名信号道
    RACSignal *userNameSignal = [self.userNameField.textField.rac_textSignal map:^id(id value) {
        self.canGetVerificationcode = [self isValidEamil:value];
        return @([self isValidEamil:value]);
    }];
    
    // 创建密码信号道
    RACSignal *passwordSignal = [self.passwordField.textField.rac_textSignal map:^id(id value) {
        return @([self isValidPassword:value]);
    }];
    
    
    RACSignal *veryCodeSignal = [self.verificationCode.textField.rac_textSignal map:^id(id value) {
        return @([self isValidVeryCode:value]);
    }];
    
    // 通过信号道返回的值，设置文本字体颜色
    RAC(self.userNameField.textField, textColor) = [userNameSignal map:^id(id value) {
        return [value boolValue] ? [UIColor colorWithHexString:@"#1C1C1C"] : [UIColor colorWithHexString:@"#1C1C1C"];
    }];
    
    // 通过信号道返回的值，设置文本字体颜色
    RAC(self.passwordField.textField, textColor) = [passwordSignal map:^id(id value) {
        return [value boolValue] ? [UIColor colorWithHexString:@"#1C1C1C"] : [UIColor colorWithHexString:@"#1C1C1C"];
    }];
    
    // 创建登陆按钮信号道，并合并用户名和密码信号道
    RACSignal *loginSignal = [RACSignal combineLatest:@[userNameSignal, passwordSignal,veryCodeSignal] reduce:^id(NSNumber *userNameValue, NSNumber *passwordValue, NSNumber *veryCodeValue){
        return @([userNameValue boolValue] && [passwordValue boolValue] && [veryCodeValue boolValue]);
    }];
    
    
    // 订阅信号
    [loginSignal subscribeNext:^(id boolValue) {
//        if ([boolValue boolValue]) {
//            self.loginBtn.userInteractionEnabled = YES;
//            [self.loginBtn setBackgroundColor:[UIColor colorWithHexString:@"#121212"]];
//            [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        }else {
//            self.loginBtn.userInteractionEnabled = NO;
//            [self.loginBtn setBackgroundColor:[UIColor colorWithHexString:@"#EDEDED"]];
//            [self.loginBtn setTitleColor:[UIColor colorWithHexString:@"#4B4B4B"] forState:UIControlStateNormal];
//        }
    }];
    
    [[self.loginBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(UIButton *sender) {
        [self subbmit];
    }];
    
}
- (NSString*)configNSLocale{
    NSLocale *currentLocalestr = [NSLocale currentLocale];
    NSString * countryCode = [currentLocalestr objectForKey:NSLocaleCountryCode];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"englishCountryJson" ofType:@"txt"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray * array = [[self jsonStringToKeyValues:content] objectForKey:@"data"];
    NSString * code = @"";
    for (NSDictionary *dict in array) {
        if ([[dict objectForKey:@"countryCode"]isEqualToString:countryCode]) {
            code = [dict objectForKey:@"phoneCode"];
        }
    NSLog(@"name=%@ phonecode=%@ countrycode=%@",[dict objectForKey:@"countryName"],[dict objectForKey:@"phoneCode"],[dict objectForKey:@"countryCode"]);
    }
    return code;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//json字符串转化成OC键值对
- (id)jsonStringToKeyValues:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = nil;
    if (JSONData) {
        responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    }
    return responseJSON;
}
// 验证用户名
- (BOOL)isValidUsername:(NSString *)username {
    
    // 验证用户名 - 手机号码
    NSString *regEx = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    
    return [phoneTest evaluateWithObject:username];
}

- (BOOL)isValidEmail {
    NSString *regex = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    NSPredicate *predicateRe = [NSPredicate predicateWithFormat:@"self matches %@", regex];
    return [predicateRe evaluateWithObject:self];
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
-(BOOL)isValidVeryCode:(NSString *)verificationCode{
    return verificationCode.length > 0;
}
- (BOOL)isValidEamil:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
#pragma mark 获取验证码
- (void)getVerificationCode{
    //TODO 获取验证码地址(三木运算)
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = host(@"email/email");
    NSDictionary *para = @{@"id":@"1",@"email":self.userNameField.textField.text};
    [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger stateCode = [result[@"code"] integerValue];
        NSString *msg = result[@"msg"];
        if (![msg isEqualToString:@""]) {
            [Toast showToastMessage:msg];
        }
        if (stateCode == 1) {
            //成功
            [self.verificationCode beginCountdown];
        }
    } fail:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark //twilio注册
- (void)registertwilio{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *deviceTokenString = [self createDeviceTokenString:appDelegate.deviceToken];
    NSLog(@"%@,%@",deviceTokenString,[UserInfo shareUserInfo].token);
    
    if ([UserInfo shareUserInfo].token == nil || deviceTokenString == nil) {
        return;
    }
    NSString * url = host(@"users/twilioregister");
    [[NetworkingManger shareManger]postDataWithUrl:url para:@{@"address":deviceTokenString,@"token":[UserInfo shareUserInfo].token} success:^(NSDictionary * _Nonnull result) {
        NSLog(@"%@",result);
        [Toast showToastMessage:result[@"msg"] inview:self.view];
        } fail:^(NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
}
#pragma mark 提交注册
- (void)subbmit{
    if (self.userNameField.textField.text.length == 0) {
        NSString *msg = [NSString stringWithFormat:@"please input your %@",self.isMail?@"email":@"phonenumber"];
        [Toast showToastMessage:msg];
        return;
    }else{
        if (![self isValidEamil:self.userNameField.textField.text]) {
            NSString *msg = @"please input a valid email";
            [Toast showToastMessage:msg];
            return;
        }
    }
    if (self.passwordField.textField.text.length == 0) {
        NSString *msg = @"please input your password";
        [Toast showToastMessage:msg];
        return;
    }else{
        if (![self isValidPassword:self.passwordField.textField.text]) {
            NSString *msg = @"● include both upper and lower case characters;\n● include at least one number;\n● be at least 8 charactrers long";
            [Toast showToastMessage:msg];
            return;
        }
    }
    if (self.verificationCode.textField.text.length == 0) {
        NSString *msg = @"please input your verificationCode";
        [Toast showToastMessage:msg];
        return;
    }
    
    if (!self.agreeUserAgreement) {
         [Toast showToastMessage:@"Please agree to the user agreement first"];
        return;
    }

//    if (self.passwordField.textField.text.length <6 || self.passwordField.textField.text.length > 30) {
//        [Toast showToastMessage:@"Password is invalid"];
//        return;;
//    }
    //三目运算处理
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = host(@"register/resem");
    NSDictionary *para = @{@"imei":@"1",@"email":self.userNameField.textField.text,@"password":self.passwordField.textField.text ,@"yzm":self.verificationCode.textField.text,@"from":@"1",@"appname":@"rose"};
    [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger stateCode = [result[@"code"] integerValue];
        NSString *msg = result[@"msg"];
        if (![msg isEqualToString:@""]) {
            [Toast showToastMessage:msg inview:self.view interval:1];
        }
        if (stateCode == 1) {
            //成功获取datas保存用户信息
            [[UserInfo shareUserInfo] setUserData:result[@"data"]];
            [self registertwilio];
            //本地存储用户账号信息(判断账户信息是否存在，是更新，否写入)
            NSMutableArray *localAccounts = [[[NSUserDefaults standardUserDefaults] objectForKey:@"accounts"] mutableCopy];
            if (localAccounts == nil) {
                localAccounts = [NSMutableArray array];
            }
            if (localAccounts.count == 0) {
                NSMutableDictionary *dic = [result[@"data"] mutableCopy];
                [dic setValue:@"1" forKey:@"isMain"];
                [localAccounts addObject:dic];
            }else{
                for (NSDictionary *userInfo in localAccounts) {
                    if ([[UserInfo shareUserInfo].Id isEqual:userInfo[@"id"]]) {
                        [localAccounts removeObject:userInfo];
                        NSMutableDictionary *dic = [result[@"data"] mutableCopy];
                        [dic setValue:@"1" forKey:@"isMain"];
                        [localAccounts addObject:dic];
                    }else{
                        NSMutableDictionary *dic = [result[@"data"] mutableCopy];
                        [dic setValue:@"1" forKey:@"isMain"];
                        [localAccounts addObject:dic];
                    }
                }
            }
            [[NSUserDefaults standardUserDefaults] setObject:localAccounts forKey:@"accounts"];
            //返回首页
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    } fail:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

- (void)dealloc{
    [self.verificationCode cancleCountdown];
}



@end
