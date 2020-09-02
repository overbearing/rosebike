//
//  DHGuidePageHUD.m
//  DHGuidePageHUD
//
//  Created by Apple on 16/7/14.
//  Copyright © 2016年 dingding3w. All rights reserved.
//

#import "DHGuidePageHUD.h"
#import "DHGifImageOperation.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "LXPageControl.h"


#define DDHidden_TIME   1.0
#define DDScreenW   [UIScreen mainScreen].bounds.size.width
#define DDScreenH   [UIScreen mainScreen].bounds.size.height

@interface DHGuidePageHUD ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray                 *imageArray;
@property (nonatomic, strong) UIPageControl           *imagePageControl;
@property (nonatomic, assign) NSInteger               slideIntoNumber;
@property (nonatomic, strong) MPMoviePlayerController *playerController;
@property (nonatomic, strong) LXPageControl           *pageControl;
@property (nonatomic, strong) UIScrollView *guidePageView;
@end

@implementation DHGuidePageHUD

- (instancetype)dh_initWithFrame:(CGRect)frame imageNameArray:(NSArray<NSString *> *)imageNameArray buttonIsHidden:(BOOL)isHidden backGronudImage:(NSString *)backgroundImg{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.slideInto = NO;
        if (isHidden == YES) {
            self.imageArray = imageNameArray;
        }
        
        // 设置引导视图的scrollview
        UIScrollView *guidePageView = [[UIScrollView alloc]initWithFrame:frame];
        [guidePageView setBackgroundColor:[UIColor clearColor]];
        [guidePageView setContentSize:CGSizeMake(DDScreenW*imageNameArray.count, DDScreenH)];
        [guidePageView setBounces:NO];
        [guidePageView setPagingEnabled:YES];
        [guidePageView setShowsHorizontalScrollIndicator:NO];
        [guidePageView setDelegate:self];
        [self addSubview:guidePageView];
        self.guidePageView = guidePageView;
        
//        if (@available(iOS 13.0, *)) {
//            guidePageView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        }
        // 设置引导页上的跳过按钮
        UIButton *skipButton = [[UIButton alloc]initWithFrame:CGRectMake(DDScreenW*0.8, DDScreenW*0.1, 50, 25)];
        [skipButton setTitle:@"跳过" forState:UIControlStateNormal];
        [skipButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [skipButton setBackgroundColor:[UIColor grayColor]];
        // [skipButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        // [skipButton.layer setCornerRadius:5.0];
        [skipButton.layer setCornerRadius:(skipButton.frame.size.height * 0.5)];
        [skipButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:skipButton];
        skipButton.hidden = YES;
        
        // 添加在引导视图上的多张引导图片
        for (int i=0; i<imageNameArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(UIWidth*i, 0, UIWidth, DDScreenH)];
//            imageView.contentMode = UIViewContentModeScaleAspectFill;
            if ([[DHGifImageOperation dh_contentTypeForImageData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNameArray[i] ofType:nil]]] isEqualToString:@"gif"]) {
                NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNameArray[i] ofType:nil]];
                imageView = (UIImageView *)[[DHGifImageOperation alloc] initWithFrame:imageView.frame gifImageData:localData];
                [guidePageView addSubview:imageView];
            } else {
                imageView.image = [UIImage imageNamed:imageNameArray[i]];
                [guidePageView addSubview:imageView];
            }
            
            // 设置在最后一张图片上显示进入体验按钮
            if (isHidden == NO) {
                [imageView setUserInteractionEnabled:YES];
                UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake((DDScreenW - Adaptive(108))/2, DDScreenH - Adaptive(91), Adaptive(108), Adaptive(42))];
                [startButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium]];
                startButton.layer.cornerRadius = Adaptive(5);
                if (i != imageNameArray.count - 1) {
                    [startButton setBackgroundImage:[UIImage imageNamed:@"Next"]  forState:UIControlStateNormal];
                    [startButton addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    [startButton setBackgroundImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
                    [startButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                startButton.tag = i;
                [imageView addSubview:startButton];
            }
        }
        
        // 设置引导页上的页面控制器
//        self.imagePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(DDScreenW*0.0, DDScreenH - Adaptive(34) - (Device_iPhoneX ? 20 : 0), DDScreenW*1.0, 10)];
//        self.imagePageControl.currentPage = 0;
//        self.imagePageControl.numberOfPages = imageNameArray.count;
//        self.imagePageControl.pageIndicatorTintColor = kColor(@"#EAEAEA");
//        self.imagePageControl.currentPageIndicatorTintColor = kColor(theme_color_main);
        [self addSubview:self.imagePageControl];
        [self setupPageControlView:imageNameArray.count];
        
    }
    return self;
}

- (void)nextClick:(UIButton *)btn{
    [self.guidePageView setContentOffset:CGPointMake(UIWidth * (btn.tag + 1), 0) animated:YES];
    self.pageControl.currentPage = btn.tag + 1;
}

- (void)setupPageControlView:(NSInteger)page {
    LXPageControl *pageControl = [[LXPageControl alloc] init];
    pageControl.numberOfPages = page;
    pageControl.itemWidth = 40;
    pageControl.itemHeight = 5;
    pageControl.itemSpacing = 8;
    pageControl.selectedImage = [UIImage imageNamed:@"pagecontrol_selected"];
    pageControl.unselectedImage = [UIImage imageNamed:@"pagecontrol_normal"];
    [self addSubview:pageControl];
    
    CGSize itemSize = CGSizeMake(page*(pageControl.itemWidth+pageControl.itemSpacing), pageControl.itemHeight);
    pageControl.frame = CGRectMake((UIWidth - 146)/2, UIHeight - kNavHeight - 49 - kSafeAreaBottomHeight - 5, 146, 5);
    [pageControl setupPageControl];
    self.pageControl = pageControl;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
    int page = scrollview.contentOffset.x / scrollview.frame.size.width;
    if (self.imageArray && page == self.imageArray.count-1 && self.slideInto == YES) {
        [self buttonClick:nil];
    }
    if (self.imageArray && page < self.imageArray.count-1 && self.slideInto == YES) {
        self.slideIntoNumber = 1;
    }
    if (self.imageArray && page == self.imageArray.count-1 && self.slideInto == YES) {
        UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:nil action:nil];
        if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight){
            self.slideIntoNumber++;
            if (self.slideIntoNumber == 3) {
                [self buttonClick:nil];
            }
        }
    }
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 四舍五入,保证pageControl状态跟随手指滑动及时刷新
    [self.imagePageControl setCurrentPage:(int)((scrollView.contentOffset.x / scrollView.frame.size.width) + 0.5f)];
}

#pragma mark - EventClick
- (void)buttonClick:(UIButton *)button {
    [UIView animateWithDuration:DDHidden_TIME animations:^{
        self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DDHidden_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSelector:@selector(removeGuidePageHUD) withObject:nil afterDelay:0];
        });
    }];
}

- (void)removeGuidePageHUD {
    [self removeFromSuperview];
    if (self.dismiss) {
        self.dismiss();
    }
     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLFORKEY];
    
}

/**< APP视频新特性页面(新增测试模块内容) */
- (instancetype)dh_initWithFrame:(CGRect)frame videoURL:(NSURL *)videoURL {
    if ([super initWithFrame:frame]) {
        self.playerController = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
        [self.playerController.view setFrame:frame];
        [self.playerController.view setAlpha:1.0];
        [self.playerController setControlStyle:MPMovieControlStyleNone];
        [self.playerController setRepeatMode:MPMovieRepeatModeOne];
        [self.playerController setShouldAutoplay:YES];
        [self.playerController prepareToPlay];
        [self addSubview:self.playerController.view];
        
        // 视频引导页进入按钮
        UIButton *movieStartButton = [[UIButton alloc] initWithFrame:CGRectMake(20, DDScreenH-30-40, DDScreenW-40, 40)];
        [movieStartButton.layer setBorderWidth:1.0];
        [movieStartButton.layer setCornerRadius:20.0];
        [movieStartButton.layer setBorderColor:[UIColor whiteColor].CGColor];
        [movieStartButton setTitle:@"开始体验" forState:UIControlStateNormal];
        [movieStartButton setAlpha:0.0];
        [self.playerController.view addSubview:movieStartButton];
        [movieStartButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [UIView animateWithDuration:DDHidden_TIME animations:^{
            [movieStartButton setAlpha:1.0];
        }];
    }
    return self;
}

@end
