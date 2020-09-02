//
//  UserAgreementController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/2.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "UserAgreementController.h"
#import <WebKit/WebKit.h>

@interface UserAgreementController ()
@property (nonatomic , strong)WKWebView *webview;
@property (nonatomic , strong)NSString  *htmlContent;
@end

@implementation UserAgreementController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    self.barStyle = NavigationBarStyleWhite;
    self.title = @"User Agreement";
    [self.view bringSubviewToFront:self.navView];
//    [self loadData];
}

- (void)setupUI{
    WKWebViewConfiguration *configure = [[WKWebViewConfiguration alloc] init];
    self.webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavHeight, UIWidth, UIHeight - kNavHeight) configuration:configure];
    [self.webview  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://rose.leopardtech.co.uk/user_agreement.html"]]];
    [self.view addSubview:self.webview];
}

- (void)loadData{
    [[NetworkingManger shareManger] postDataWithUrl:host(@"api/agreement") para:@{} success:^(NSDictionary * _Nonnull result) {
        NSInteger stateCode = [result[@"code"] integerValue];
        if (stateCode != 1) {
            [Toast showToastMessage:result[@"msg"] inview:self.view];
            return;
        }
        @try {
            self.htmlContent = [result[@"data"] firstObject][@"text"];
            [self.webview loadHTMLString:self.htmlContent baseURL:nil];
        } @catch (NSException *exception) {
            
        }

    } fail:^(NSError * _Nonnull error) {
    }];
}

@end
