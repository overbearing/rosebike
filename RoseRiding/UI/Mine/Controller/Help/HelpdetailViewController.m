//
//  HelpdetailViewController.m
//  RoseRiding
//
//  Created by 蜡笔小新 on 2020/9/15.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "HelpdetailViewController.h"

@interface HelpdetailViewController ()<UITextViewDelegate>
@property (nonatomic,strong)UITextView * content;
@end

@implementation HelpdetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.barStyle = NavigationBarStyleWhite;
    self.content= [[UITextView alloc]initWithFrame:CGRectMake(30, kNavHeight, UIWidth - 60, UIHeight - kNavHeight)];
    self.content.textColor = [UIColor grayColor];
    self.content.font = [UIFont systemFontOfSize:14];
    self.content.delegate = self;
    self.content.editable = NO;
    self.content.backgroundColor = [UIColor whiteColor];
    self.content.text = self.str;
    [self.view addSubview:self.content];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
