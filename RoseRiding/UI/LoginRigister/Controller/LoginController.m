//
//  LoginController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/26.
//  Copyright © 2020 MR_THT. All rights reserved.
//




#import "LoginController.h"
#import "RegistViewController.h"
#import "YJJTextField.h"
#import "ResetPasswordViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import "NSString+Encryption.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <WebKit/WebKit.h>
#import <UMShare/UMShare.h>
#import <AuthenticationServices/AuthenticationServices.h>
//#import <Twitter/Twitter.h>
//#import <FirebaseAuth/FirebaseAuth.h>


@interface LoginController ()<GIDSignInDelegate,FBSDKLoginButtonDelegate,ASAuthorizationControllerDelegate,ASWebAuthenticationPresentationContextProviding>

@property (nonatomic, assign) YJJTextField *userNameField;
@property (nonatomic, assign) YJJTextField *passwordField;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) NSArray *textFieldArr;
@property (nonatomic, strong) UILabel *resetPassWordTopTip;
@property (nonatomic, strong) UILabel *resetPassWordBottomTip;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong)BabyBluetooth   *baby;
@property (nonatomic, strong)NSArray * imageArray;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UIButton * googleBtn;
@property (nonatomic, strong) UIButton * facebookBtn;
@property (nonatomic, strong) UIButton * twitterBtn;
@property (nonatomic, strong) UIButton * appleBtn;

@end

@implementation LoginController

static NSString * const  twitterID = @"https://api.twitter.com/oauth/authorize?oauth_token=1260152678191112193-vwOYR7q87vbgVSziZaW1Q08yH1neFP";

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setRACSignal];
    self.leftButton.hidden = YES;
}
- (NSArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSArray arrayWithObjects:@"google_icon.png",@"skype-2 黑色.png",@"facebook_icon.png",@"twitter_icon.png", nil];
    }
    return _imageArray;
}
- (void)setupUI
{
//   NSURL *url = [NSURL URLWithString:@"https://twitter.com/login"];
//
//    WKWebView *webView = [[WKWebView alloc] init];
//       
//       [self.view addSubview:webView];
//       
//       // 加载网页
//       NSURLRequest *request = [NSURLRequest requestWithURL:url];
//       [webView loadRequest:request];
//       
//       // KVO监听属性改变
//       /*
//        KVO使用:
//           addObserver：观察者
//           forKeyPath：观察webview哪个属性
//           options：NSKeyValueObservingOptionNew观察新值改变
//        注意点：对象销毁前 一定要记得移除 -dealloc
//        */
//       [webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
//       [webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
//       [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
//       
//       // 进度条
//       [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rose_logo_white"]];
    [self.view addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(Adaptive(isIphoneX?132:120));
        make.width.equalTo(@124);
        make.height.equalTo(@61.5);
    }];
    
    YJJTextField *userNameField = [YJJTextField yjj_textField];
    userNameField.maxLength = NSIntegerMax;
    userNameField.errorStr = @"*字数长度不得超过11位";
    userNameField.placeholder = @"Email / Phonenumber";
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
    passwordField.placeholder = [GlobalControlManger enStr:@"Password" geStr:@"Password"];
    passwordField.leftImageName = @"password_login";
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
    
    self.textFieldArr = @[userNameField,passwordField];
    
    UIButton *loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [loginBtn setTitle:@"LOGIN" forState:(UIControlStateNormal)];
    [loginBtn setBackgroundColor:[UIColor colorWithHexString:@"#121212"]];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [loginBtn setTitleColor:[UIColor colorWithHexString:@"#4B4B4B"] forState:(UIControlStateNormal)];
//    loginBtn.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.mas_bottom).offset(Adaptive(20));
        make.trailing.equalTo(self.view).offset(-Adaptive(65));
        make.leading.equalTo(self.view).offset(Adaptive(65));
        make.height.equalTo(@48);
    }];
    self.loginBtn.layer.cornerRadius = 2;
    
    self.resetPassWordTopTip = [[UILabel alloc] init];
    self.resetPassWordTopTip.textColor = [UIColor colorWithHexString:@"#4B4B4B"];
    self.resetPassWordTopTip.text = [GlobalControlManger enStr:@"FORGOT PASSWORD?" geStr:@"FORGOT PASSWORD?"];
    self.resetPassWordTopTip.userInteractionEnabled = YES;
    self.resetPassWordTopTip.font = kFont(12);
    [self.view addSubview:self.resetPassWordTopTip];
    [self.resetPassWordTopTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.mas_bottom).offset(Adaptive(31));
        make.centerX.equalTo(self.view);
    }];
    self.resetPassWordBottomTip = [[UILabel alloc] init];
    self.resetPassWordBottomTip.textColor = [UIColor colorWithHexString:@"#4B4B4B"];
    self.resetPassWordBottomTip.attributedText = [[NSMutableAttributedString alloc]initWithString:@"Sign up" attributes:@{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    self.resetPassWordBottomTip.userInteractionEnabled = YES;
    self.resetPassWordBottomTip.font = kFont(12);
    [self.view addSubview:self.resetPassWordBottomTip];
    [self.resetPassWordBottomTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resetPassWordTopTip.mas_bottom).offset(Adaptive(4));
        make.centerX.equalTo(self.view);
    }];
    [self.resetPassWordTopTip addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetPassWord:)]];
    [self.resetPassWordBottomTip addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singUp:)]];
    self.bottomView = [[UIView alloc]init];
//    self.bottomView.backgroundColor = [UIColor redColor];
     
    [self.view addSubview:_bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.view).offset(-Adaptive(48));
        make.centerX.equalTo(self.view);
        make.width.equalTo(@Adaptive(136));
        make.height.equalTo(@20);
    }];
  
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDButton *applebtn = [[ASAuthorizationAppleIDButton alloc]initWithAuthorizationButtonType:ASAuthorizationAppleIDButtonTypeSignIn authorizationButtonStyle:ASAuthorizationAppleIDButtonStyleBlack];
        [applebtn addTarget:self action:@selector(signInWithApple) forControlEvents:UIControlEventTouchUpInside];
        applebtn.center = self.view.center;
        [self.view addSubview:applebtn];
        [applebtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-Adaptive(80));
            make.centerX.equalTo(self.view);
            make.width.offset(130);
            make.height.offset(30);
        }];
    } else {
        // Fallback on earlier versions
    }
//    [self.appleBtn setBackgroundImage:[UIImage imageNamed:@"Apple_icon"] forState:UIControlStateNormal];
//    [self.bottomView addSubview:self.appleBtn];
    self.googleBtn=[[UIButton alloc]init];
    self.googleBtn.layer.cornerRadius = 2.0f;
    self.googleBtn.layer.masksToBounds = YES;
    [self.googleBtn setBackgroundImage:[UIImage imageNamed:@"google_icon"] forState:UIControlStateNormal];
    [self.googleBtn addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView  addSubview:self.googleBtn];
    [self.googleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomView).offset(20);
              make.width.equalTo(@20);
              make.height.equalTo(@20);
              make.top.equalTo(self.bottomView).offset(0);
          }];
    self.facebookBtn = [[UIButton alloc]init];
    self.facebookBtn.layer.cornerRadius = 2.0f;
    self.facebookBtn.layer.masksToBounds = YES;
    [self.facebookBtn setBackgroundImage:[UIImage imageNamed:@"facebook_icon"] forState:UIControlStateNormal];
    [self.facebookBtn addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.facebookBtn];
    [self.facebookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.bottomView).offset(-20);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.top.equalTo(self.bottomView).offset(0);
    }];
//    self.twitterBtn = [[UIButton alloc]init];
//    [self.twitterBtn setBackgroundImage:[UIImage imageNamed:@"twitter_icon"] forState:UIControlStateNormal];
//    [self.twitterBtn addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.bottomView addSubview:self.twitterBtn];
//    [self.twitterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(self.bottomView).offset(0);
//        make.top.equalTo(self.bottomView).offset(0);
//        make.width.equalTo(@20);
//        make.height.equalTo(@20);
//    }];
    // Automatically sign in the user.
//    [GIDSignInButton class];
     GIDSignIn *signIn = [GIDSignIn sharedInstance];
     signIn.shouldFetchBasicProfile = YES;
     signIn.delegate = self;
     signIn.presentingViewController = self;
    if (!self->_islogout) {
       [signIn restorePreviousSignIn];
    }  
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.delegate = self;
//    // Optional: Place the button in the center of your view.
//           loginButton.center = self.view.center;
//           [self.view addSubview:loginButton];
//           loginButton.permissions = @[@"public_profile", @"email"];
//               if ([FBSDKAccessToken currentAccessToken]) {
//           ////         User is logged in, do work such as go to next view controller.
//                    [self dismissViewControllerAnimated:YES completion:nil];
//               }
//  
//
//    [self.view addSubview:loginButton];
}
-(void)signInWithApple API_AVAILABLE(ios(13.0)){
   
        ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc]init];
   
   
        ASAuthorizationAppleIDRequest * request = [provider createRequest];
   
    request.requestedScopes = @[ASAuthorizationScopeFullName,ASAuthorizationScopeEmail];
    
    ASAuthorizationController *vc= [[ASAuthorizationController alloc]initWithAuthorizationRequests:@[request]];
    vc.delegate = self;
    vc.presentationContextProvider = self;
    
    [vc performRequests];
}
- (void)handleClick:(UIButton *)btn{
    if (btn == self.googleBtn) {
        NSLog(@"jumptogoogle");
        [[GIDSignIn sharedInstance]signIn];
    }else if (btn == self.facebookBtn) {
        NSLog(@"jumptofacebook");
//        FBSDKAccessToken * token = [FBSDKAccessToken currentAccessToken];
//        if (token) {
//            NSLog(@"facebookLogin_cur_asscessToken=%@",token.userID);
//        }else{
            // 点击 Facebook 登录按钮的时候调用如下代码即可调用 Facebook 登录功能
             FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
             [loginManager logInWithPermissions:@[@"public_profile", @"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
                 NSDictionary*params= @{@"fields":@"id,name,email,age_range,first_name,last_name,link,gender,locale,picture,timezone,updated_time,verified"};
                 
                 FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                               initWithGraphPath:result.token.userID
                                               parameters:params
                                               HTTPMethod:@"GET"];
                 [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     NSLog(@"00000--------------%@",result);
                     /*
                      {
                      "age_range" =     {
                      min = 21;
                      };
                      "first_name" = "\U6dd1\U5a1f";
                      gender = female;
                      id = 320561731689112;
                      "last_name" = "\U6f58";
                      link = "https://www.facebook.com/app_scoped_user_id/320561731689112/";
                      locale = "zh_CN";
                      name = "\U6f58\U6dd1\U5a1f";
                      picture =     {
                      data =         {
                      "is_silhouette" = 0;
                      url = "https://fb-s-c-a.akamaihd.net/h-ak-fbx/v/t1.0-1/p50x50/18157158_290358084709477_3057447496862917877_n.jpg?oh=01ba6b3a5190122f3959a3f4ed553ae8&oe=5A0ADBF5&__gda__=1509731522_7a226b0977470e13b2611f970b6e2719";
                      };
                      };
                      timezone = 8;
                      "updated_time" = "2017-04-29T07:54:31+0000";
                      verified = 1;
                      }
                      */
                     NSString * email = result[@"email"];
                     [self dsfLoginwithaccount:email andtype:@"2"];
                 }];
                 if (error) {
                     NSLog(@"Process error");
                 } else if (result.isCancelled) {
                     NSLog(@"Cancelled");
                     return;
                 } else {
                     NSLog(@"token信息：%@", result.token.userID);
                 }
             }];
        }
//    }
else if (btn == self.twitterBtn) {
        NSLog(@"jumptotwitter");
//       NSURL *url = [NSURL URLWithString:@"https://twitter.com/login"];
//      //
//    [[UIApplication sharedApplication]openURL:url options:@{UIApplicationLaunchOptionsSourceApplicationKey:twitterID} completionHandler:^(BOOL success) {
//
//    }];
//    [self getAuthWithUserInfoFromTwitter];
    [Toast showToastMessage:@"This feature is not yet available"];
    return;
}
}
// 在需要进行获取用户信息的UIViewController中加入如下代码

- (void)getAuthWithUserInfoFromTwitter
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Twitter currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            UMSocialUserInfoResponse *resp = result;

            // 授权信息
            NSLog(@"Twitter uid: %@", resp.uid);
            NSLog(@"Twitter accessToken: %@", resp.accessToken);

            // 用户信息
            NSLog(@"Twitter name: %@", resp.name);
            NSLog(@"Twitter iconurl: %@", resp.iconurl);

            // 第三方平台SDK源数据
            NSLog(@"Twitter originalResponse: %@", resp.originalResponse);
        }
    }];
}
//- (void)getUserInfoWithResult:(NSString*)userId{
//    NSDictionary*params = @{@"fields":@"id,name,picture"};
//    FBSDKGraphRequest * request = [[FBSDKGraphRequest alloc]initWithGraphPath:userId parameters:params HTTPMethod:@"GET"];
//    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection * _Nullable connection, id  _Nullable result, NSError * _Nullable error) {
//        NSLog(@"FBSDKGraphRequest = %@",result);
//        NSDictionary * resultDict = (NSDictionary*)result;
//        NSString * userName = resultDict[@"name"];c
//        NSString * url = resultDict[@"picture"][@"data"][@"url"];
//        NSMutableDictionary * dictionary = [[NSMutableDictionary alloc]init];
//        [dictionary setValue:userId forKey:@"facebook_id"];
//        [dictionary setValue:userName forKey:@"facebook_name"];
//        [dictionary setValue:url forKey:@"facebook_photo"];
//    }];
//}
- (void)setRACSignal
{
    // 创建用户名信号道
    RACSignal *userNameSignal = [self.userNameField.textField.rac_textSignal map:^id(id value) {
        return @([self isValidEamil:value]);
    }];
    
    // 创建密码信号道
    RACSignal *passwordSignal = [self.passwordField.textField.rac_textSignal map:^id(id value) {
        return @([self isValidPassword:value]);
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
    RACSignal *loginSignal = [RACSignal combineLatest:@[userNameSignal, passwordSignal] reduce:^id(NSNumber *userNameValue, NSNumber *passwordValue){
        return @([userNameValue boolValue] && [passwordValue boolValue]);
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
        [self loginAction];
    }];
    
}

- (void)resetPassWord:(UITapGestureRecognizer *)gesture{
    ResetPasswordViewController *VC = [ResetPasswordViewController new];
    VC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:VC animated:YES completion:nil];
}

- (void)singUp:(UITapGestureRecognizer *)gesture{
//    [self changeAccounttype];
    RegistViewController *VC = [RegistViewController new];
       VC.modalPresentationStyle = UIModalPresentationFullScreen;
       VC.isMail = YES;
       [self presentViewController:VC animated:YES completion:nil];
}
- (void)changeAccounttype{
    RegistViewController *VC = [RegistViewController new];
    VC.modalPresentationStyle = UIModalPresentationFullScreen;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Email" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        VC.isMail = YES;
       
       [self presentViewController:VC animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Phonenumber" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        VC.isMail = NO;
        [self presentViewController:VC animated:YES completion:nil];
    }]];
   
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


// 验证用户名
- (BOOL)isValidUsername:(NSString *)username {
    
    // 验证用户名 - 手机号码
    NSString *regEx = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    
    return [phoneTest evaluateWithObject:username];
}

// 验证密码 - 由数字和26个英文字母组成的字符串
- (BOOL)isValidPassword:(NSString *)password {
    
//    NSString *regEx = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$";
//    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
//    return [passwordTest evaluateWithObject:password];
    return YES;
}
- (BOOL)isValidEamil:(NSString *)email{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
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
- (void)loginAction{
    //三目运算处理
    NSString *url = host(@"login/login");
    if (self.passwordField.textField.text.length <6 || self.passwordField.textField.text.length > 30) {
        [Toast showToastMessage:@"Password is invalid"];
        return;;
    }
     AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *deviceTokenString = [self createDeviceTokenString:appDelegate.deviceToken];
    NSDictionary *para = @{@"email":self.userNameField.textField.text,@"password":self.passwordField.textField.text, @"address": deviceTokenString};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
          [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger stateCode = [result[@"code"] integerValue];
        NSString *msg = result[@"msg"];
        if (![msg isEqualToString:@""]) {
            [Toast showToastMessage:msg];
        }
        if (stateCode == 1) {
            //成功获取datas保存用户信息
            [[UserInfo shareUserInfo] setUserData:result[@"data"]];
            //本地存储用户账号信息(判断账户信息是否存在，是更新，否写入)
            [JPUSHService setAlias:[NSString stringWithFormat:@"imei_%@",result[@"data"][@"id"]] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
              } seq:1];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
            //返回首页
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } fail:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)dsfLoginwithaccount:(NSString*)account andtype:(NSString*)type {
    NSString * url = host(@"user/fgtLogin");
    if (account == nil) {
        return;
    }
    [[NetworkingManger shareManger]postDataWithUrl:url para:@{@"account_type":type,@"account":account} success:^(NSDictionary * _Nonnull result) {
        NSInteger stateCode = [result[@"code"] integerValue];        
        if (stateCode == 1) {
            NSLog(@"%@",result);
            //成功获取datas保存用户信息
                       [[UserInfo shareUserInfo] setUserData:result[@"data"]];
                       //本地存储用户账号信息(判断账户信息是否存在，是更新，否写入)
                       [JPUSHService setAlias:[NSString stringWithFormat:@"imei_%@",result[@"data"][@"id"]] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                         } seq:1];
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
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
                       //返回首页
                       [self dismissViewControllerAnimated:YES completion:nil];
        }
        NSString * msg = [result objectForKey:@"msg"];
        if (![msg isEqualToString:@""]) {
             [Toast showToastMessage:msg];
        }
       
    } fail:^(NSError * _Nonnull error) {
        NSLog(@"error-------------------%@",error);
    }];
}

- (void)signIn:(GIDSignIn*)signIn didSignInForUser:(GIDGoogleUser*)user withError:(NSError*)error
{
    
    NSLog(@"user %@",user);
    NSLog(@"error %@",error);
    if (error != nil) {
         if (error.code == kGIDSignInErrorCodeHasNoAuthInKeychain) {
           NSLog(@"The user has not signed in before or they have since signed out.");
         } else {
           NSLog(@"%@", error.localizedDescription);
         }
         return;
       }
       // Perform any operations on signed in user here.
       NSString *userId = user.userID;                  // For client-side use only!
       NSString *idToken = user.authentication.idToken; // Safe to send to the server
       NSString *fullName = user.profile.name;
       NSString *givenName = user.profile.givenName;
       NSString *familyName = user.profile.familyName;
       NSString *email = user.profile.email;
    if (email == nil || email.length == 0) {
        return;
    }
    [self dsfLoginwithaccount:email andtype:@"1"];
}

- (void)loginButton:(nonnull FBSDKLoginButton *)loginButton didCompleteWithResult:(nullable FBSDKLoginManagerLoginResult *)result error:(nullable NSError *)error {
    NSLog(@"授权成功");
    NSLog(@"result--------%@",result);
//     [self dsfLoginwithaccount:email andtype:@"2"];
}

- (void)loginButtonDidLogOut:(nonnull FBSDKLoginButton *)loginButton {
//    NSLog(@"退出登录");
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller
API_AVAILABLE(ios(13.0)){
   return  self.view.window;
}
#pragma mark- 授权成功的回调
-(void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization
API_AVAILABLE(ios(13.0)){
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        
        ASAuthorizationAppleIDCredential * credential = authorization.credential;
        
        NSString *state = credential.state;
        
        NSString * userID = credential.user;
        
        NSPersonNameComponents *fullName = credential.fullName;
        NSString * email = credential.email;
        //refresh token
        NSString * authorizationCode = [[NSString alloc]initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];
        // access token
        NSString * identityToken = [[NSString alloc]initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
        
        ASUserDetectionStatus realUserStatus = credential.realUserStatus;
         
         NSLog(@"state: %@", state);
         NSLog(@"userID: %@", userID);
         NSLog(@"fullName: %@", fullName);
         NSLog(@"email: %@", email);
         NSLog(@"authorizationCode: %@", authorizationCode);
         NSLog(@"identityToken: %@", identityToken);
         NSLog(@"realUserStatus: %@", @(realUserStatus));
        if (userID != nil) {
            [self dsfLoginwithaccount:[NSString stringWithFormat:@"%@@apple.com",userID] andtype:@"3"];
        }
    }
   
}
 
#pragma mark- 授权失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error
API_AVAILABLE(ios(13.0)){
    
    NSString * errorMsg = nil;
    
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    
    }
  
}

@end
