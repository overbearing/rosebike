//
//  WorkingModeController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/12.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "WorkingModeController.h"
#import "WorkingModeListController.h"
#import "ScheduledWorkingController.h"



@interface WorkingModeController ()<JXCategoryViewDelegate>

@property (nonatomic , strong)JXCategoryTitleView *segment;
@property (nonatomic , strong)NSMutableArray *childVCS;

@end

@implementation WorkingModeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    self.barStyle = NavigationBarStyleWhite;
    self.title = @"Working Mode";
}

- (NSMutableArray *)childVCS{
    if (!_childVCS) {
        _childVCS = [NSMutableArray array];
    }
    return _childVCS;
}

- (void)setupUI{
    
    self.segment = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, kNavHeight, UIWidth, 50)];
    self.segment.delegate = self;
    self.segment.titleColor = [UIColor colorWithHexString:@"#838383"];
    self.segment.titleSelectedColor = [UIColor colorWithHexString:@"#121212"];
    [self.view addSubview:self.segment];
    
    self.segment.titles = @[@"Fixed Working Mode", @"Scheduled Working Mode"];
    self.segment.titleColorGradientEnabled = YES;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor colorWithHexString:@"#121212"];
    lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    self.segment.indicators = @[lineView];
    
    WorkingModeListController *VC = [[WorkingModeListController alloc] init];
    [self addChildViewController:VC];
    VC.view.frame = CGRectMake(0, kNavHeight + 50, UIWidth, UIHeight - kNavHeight - 50);
    [self.view addSubview:VC.view];
    ScheduledWorkingController *VC1 = [[ScheduledWorkingController alloc] init];
    [self addChildViewController:VC1];
    VC1.view.frame = CGRectMake(0, kNavHeight + 50, UIWidth, UIHeight - kNavHeight - 50);
    [self.childVCS addObject:VC];
    [self.childVCS addObject:VC1];
}



//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    if (index == 0) {
        WorkingModeListController *VC = self.childVCS[0];
        ScheduledWorkingController *VC1 = self.childVCS[1];
        [VC1.view removeFromSuperview];
        [self.view addSubview:VC.view];
    }else{
        WorkingModeListController *VC = self.childVCS[0];
        ScheduledWorkingController *VC1 = self.childVCS[1];
        [VC.view removeFromSuperview];
        [self.view addSubview:VC1.view];
    }
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
