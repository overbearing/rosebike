//
//  DeviceMangerCell.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/9.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "DeviceMangerCell.h"
#define kDeleteButtonWidth      87.0f
//#define kTagButtonWidth         100.0f
#define kCriticalTranslationX   30
#define kShouldSlideX           -2

@interface DeviceMangerCell ()
{
    UIPanGestureRecognizer *_pan;
//    UITapGestureRecognizer *_tap;
    UIButton *_deleteButton;
    BOOL _shouldSlide;
    BOOL isConnecting;
}
@property (nonatomic, assign) BOOL isSlided;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *blueStatus;
@property (weak, nonatomic) IBOutlet UIView *backgroundview;
@property (weak, nonatomic) IBOutlet UIView *deleteview;

@property (weak, nonatomic) IBOutlet UIButton *transButton;
@property (weak, nonatomic) IBOutlet UIImageView *bike_white;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation DeviceMangerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.deleteBtn.hidden = YES;
    [self initUI];
    [self setupGestureRecognizer];
}
- (void)initUI{
    self.deleteview.hidden = NO;
    [self insertSubview:self.deleteBtn belowSubview:self.contentView];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self);
           make.trailing.equalTo(self);
           make.bottom.equalTo(self).offset(-14);
           make.width.equalTo(@kDeleteButtonWidth);
       }];
}
- (void)setupGestureRecognizer
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    _pan = pan;
    pan.delegate = self;
    pan.delaysTouchesBegan = YES;
    [self.contentView addGestureRecognizer:pan];
}


- (void)panView:(UIPanGestureRecognizer *)pan
{
    
    CGPoint point = [pan translationInView:pan.view];
    
    if (self.contentView.left <= kShouldSlideX) {
        _shouldSlide = YES;
    }

    if (fabs(point.y) < 1.0) {
        if (_shouldSlide) {
            [self slideWithTranslation:point.x];
           
        } else if (fabs(point.x) >= 1.0) {
            [self slideWithTranslation:point.x];

        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        CGFloat x = 0;
        if (self.contentView.left < -kCriticalTranslationX-15 && !self.isSlided) {
            x = -(kDeleteButtonWidth-15);
            
        }
        [self cellSlideAnimationWithX:x];
        _shouldSlide = NO;
    }
    
    [pan setTranslation:CGPointZero inView:pan.view];
}


- (void)cellSlideAnimationWithX:(CGFloat)x
{
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.contentView.left = x;
    } completion:^(BOOL finished) {
        self.isSlided = (x != 0);
       
    }];
}

- (void)slideWithTranslation:(CGFloat)value
{
    if (self.contentView.left < -(kDeleteButtonWidth-15) * 1.1 || self.contentView.left > 15) {
        value = 0;
    }
    
    self.contentView.left += value;
}
- (void)setIsSlided:(BOOL)isSlided
{
    _isSlided = isSlided;
}
- (void)setModel:(BikeDeviceModel *)model{
    
    self.name.text = model.equipment;
    self.blueStatus.text = model.isConnecting ? [GlobalControlManger enStr:@"in use" geStr:@"in use"]:[GlobalControlManger enStr:@"idle" geStr:@"idle"];
    self.name.textColor = [UIColor colorWithHexString:model.isConnecting? @"#FFFFFF":@"#121212"];
    self.blueStatus.textColor = [UIColor colorWithHexString:model.isConnecting? @"#FFFFFF":@"#121212"];
//    [self.transButton setBackgroundImage:[UIImage imageNamed:model.isConnecting? @"zhuanrang_white":@"zhuanrang"]forState:UIControlStateNormal];
    self.backgroundview.backgroundColor = [UIColor colorWithHexString:model.isConnecting ? @"#1fba41":@"#f8f8f8"];
    self.bike_white.image = [UIImage imageNamed:model.isConnecting?@"white_bicycle": @"np_bicycle"];
    isConnecting = model.isConnecting;
    self.transButton.selected = isConnecting;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (self.contentView.left <= kShouldSlideX && otherGestureRecognizer != _pan) {
        return NO;
    }
    return YES;
}

- (IBAction)editAction:(id)sender {
    if (self.edit) {
        self.edit();
    }
}
- (IBAction)delAction:(id)sender {
    if (self.del) {
         self.del();
     }
}


@end
