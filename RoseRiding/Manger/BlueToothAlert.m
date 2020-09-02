//
//  BlueToothAlert.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/28.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "BlueToothAlert.h"

@implementation BlueToothAlert

+ (void)showAlertWith:(BlueToothAlertType)type Clcik:(nonnull void (^)(BlueToothAlertType type))click{
    BlueToothAlert *alert = [[self alloc] init];
    [alert showAlert:type Clcik:click];
}
- (instancetype)init{
    if (self = [super initWithFrame:UIKeyWindow.bounds]) {
         self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return self;
}

- (void)showAlert:(BlueToothAlertType)type Clcik:(nonnull void (^)(BlueToothAlertType type))click{
  //TODO masonry(sdautolayout) 可以根据子视图自动适应高度这里暂不适配(采用vue fix布局思想)
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    CGFloat height = 0;
    NSString *alertStr = @"";
    if (type == ActivateDeviceWait) {
        height = 218;
        alertStr = [GlobalControlManger enStr:@"please wait while your activation is being processed." geStr:@"Einen Augenblick bitte,bis die Aktivierung verarbeitet wird."];
    }else if (type == ActivateDeviceFail){
        height = 230;
        alertStr = [GlobalControlManger enStr:@"eSim activation failed. Please contact ROSE Customer Service." geStr:@"eSim Aktivierung fehlgeschlagen. Bitte ROSE Kundenservice kontaktieren."];
    }else if (type == ActivateDeviceSuccess){
        height = 178;
        alertStr = [GlobalControlManger enStr:@"eSim activation successful." geStr:@"eSim erfolgreich aktiviert."];
    }else if (type == NormalWaring){
        height = 278;
        alertStr = [GlobalControlManger enStr:@"your bike has registered an alarm and may have been tampered with. For security we recommend you check your bike." geStr:@"Der Alarm wurde registriert und wurde möglicherweise manipuliert. Bitte das Fahrrad aus Sicherheitsgründen checken."];
    }else if (type == LowBatteryRemian30){
        height = 218;
        alertStr = [GlobalControlManger enStr:@"Low Battery 30% battery remaining" geStr:@"DWarnung Batterie schwach 30% Batterie verblieben"];
    }else if (type == LowBatteryRemian15){
        height = 218;
        alertStr = [GlobalControlManger enStr:@"Low Battery 15% battery remaining" geStr:@"DWarnung Batterie schwach 15% Batterie verblieben"];
    }else if (type == ServiceExpired){
        height = 228;
        alertStr = [GlobalControlManger enStr:@"Your subscription has expired, please contact ROSE to purchase a new subscription." geStr:@"Aktuell Abo ist abgelaufen. Bitte ROSE für weiteren Service kontaktieren."];
    }else if (type == Nodevice){
        height = 218;
        alertStr = [GlobalControlManger enStr:@"No device found. Please add a new device." geStr:@"Kein Gerät gefunden. Bitte ein neues Gerät hinzufügen."];
    }else if (type == RemianDays){
        height = 178;
        alertStr = [GlobalControlManger enStr:@"Service remaining days." geStr:@"Service verbleibende tage."];
    }else if (type == BluetoothLow)
    {
        height = 218;
        alertStr = [GlobalControlManger enStr:@"Bluetooth authentication failed.Please contact ROSE Customer Service." geStr:@"Bluetooth authentication failed.Please contact ROSE Customer Service."];
    }
    else{
        return;
    }
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@312);
        make.height.equalTo(@(height));
    }];
    contentView.layer.cornerRadius = 8;

    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close setBackgroundImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
    [contentView addSubview:close];
    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(contentView).offset(-28);
        make.top.equalTo(contentView).offset(20);
        make.height.equalTo(@19);
        make.width.equalTo(@19);
    }];
    [[close rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self removeFromSuperview];
    }];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHexString:@"#121212"];
    label.text = alertStr;
    label.font = kFont(20);
    [contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(contentView).offset(15);
        make.trailing.equalTo(contentView).offset(-15);
        make.top.equalTo(contentView).offset(60);
    }];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    
    
    UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:add];
    [add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(label.mas_bottom).offset(20);
        make.height.equalTo(@48);
        make.width.equalTo(@244);
    }];
    [add setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [add setTitle:@"OK" forState:UIControlStateNormal];
    add.backgroundColor = [UIColor colorWithHexString:@"#15BA39"];
    add.layer.cornerRadius = 4;
    [[add rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self removeFromSuperview];
        if (click) {
            click(type);
        }
    }];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    [contentView addSubview:activityIndicator];
    [activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(label.mas_bottom).offset(20);
        make.height.equalTo(@48);
        make.width.equalTo(@48);
    }];
    
    if (type == ActivateDeviceWait) {
        activityIndicator.hidden = NO;
        [activityIndicator startAnimating];
        add.hidden = YES;
    }else{
        activityIndicator.hidden = YES;
         [activityIndicator stopAnimating];
        add.hidden = NO;
    }
    [UIKeyWindow addSubview:self];
}

@end
