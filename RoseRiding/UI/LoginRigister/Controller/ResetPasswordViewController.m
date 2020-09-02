//
//  ResetPasswordViewController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/27.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "ResetPasswordWithEmail.h"
#import "ResetPasswordWithPhone.h"


@interface ResetPasswordViewController ()<JXCategoryViewDelegate>

@property (nonatomic , strong)JXCategoryTitleView *segment;

@property (nonatomic , strong)UIScrollView   *scrollowView;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    self.barStyle = NavigationBarStyleWhite;
    self.title = [GlobalControlManger enStr:@"reset password" geStr:@"reset password"];
    [self.view bringSubviewToFront:self.navView];
}



- (void)setupUI{
    
//    self.segment = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, kNavHeight, UIWidth, 50)];
//    self.segment.delegate = self;
//    self.segment.titleColor = [UIColor colorWithHexString:@"#838383"];
//    self.segment.titleSelectedColor = [UIColor colorWithHexString:@"#121212"];
//    [self.view addSubview:self.segment];
//
//    self.segment.titles = @[@"Change phone number", @"Change email"];
//    self.segment.titleColorGradientEnabled = YES;
//    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
//    lineView.indicatorColor = [UIColor colorWithHexString:@"#121212"];
//    lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
//    self.segment.indicators = @[lineView];
    
    self.scrollowView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavHeight, UIWidth, UIHeight - kNavHeight)];
    [self.view addSubview:self.scrollowView];
    self.scrollowView.contentSize = CGSizeMake(UIWidth * 1, self.scrollowView.height);
    self.scrollowView.pagingEnabled = YES;
    if (@available(iOS 11.0, *)) {
        self.scrollowView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        // Fallback on earlier versions
    }
    
    ResetPasswordWithEmail *resetWithEmailVC = [[ResetPasswordWithEmail alloc] init];
    [self addChildViewController:resetWithEmailVC];
//    ResetPasswordWithPhone *resetWithPhoneVC = [[ResetPasswordWithPhone alloc] init];
//    [self addChildViewController:resetWithPhoneVC];
//    resetWithPhoneVC.view.frame = CGRectMake(0, 0, UIWidth, self.scrollowView.height);
    resetWithEmailVC.view.frame = CGRectMake(0, 0, UIWidth, self.scrollowView.height);
//    [self.scrollowView addSubview:resetWithPhoneVC.view];
    [self.scrollowView addSubview:resetWithEmailVC.view];
    
}

//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    [self.scrollowView setContentOffset:CGPointMake(UIWidth * index, 0) animated:YES];
}

//点击选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index{

}

//滚动选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index{

}

//正在滚动中的回调
- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio{
    
}

@end
