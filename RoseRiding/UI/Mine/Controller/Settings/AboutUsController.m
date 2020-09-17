//
//  AboutUsController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/31.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "AboutUsController.h"
#import <WebKit/WebKit.h>
@interface AboutUsController ()

@property (nonatomic , strong)WKWebView *webview;
@property (nonatomic , strong)NSString  *htmlContent;

@end

@implementation AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
     self.barStyle = NavigationBarStyleWhite;
    self.title = [GlobalControlManger enStr:@"about us" geStr:@"about us"];
    [self.view bringSubviewToFront:self.navView];
//    [self loadData];
}

- (void)setupUI{
    WKWebViewConfiguration *configure = [[WKWebViewConfiguration alloc] init];
    self.webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavHeight, UIWidth, UIHeight - kNavHeight) configuration:configure];
    [self.webview  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.leopardtech.co.uk/about/"]]];
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
