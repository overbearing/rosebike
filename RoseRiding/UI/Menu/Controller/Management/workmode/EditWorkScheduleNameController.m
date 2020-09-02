//
//  EditWorkScheduleNameController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/13.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "EditWorkScheduleNameController.h"
#import "NSString+YYAdd.h"
@interface EditWorkScheduleNameController ()

@property (nonatomic , strong , nullable)ScheWorkModel *model;

@end

@implementation EditWorkScheduleNameController

- (instancetype)initWithWorkModel:(ScheWorkModel *)model{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.barStyle = NavigationBarStyleWhite;
    self.title = @"Modify name";
    if (self.model == nil) {
        self.nameText.text = nil;
        self.nameText.placeholder = @"input schedule name";
    }else{
        self.nameText.text = self.model.modify_name;
    }
}

-  (void)goBack{
    if (self.inputResult) {
        if (!self.nameText.text.isNotBlank) {
            [Toast showToastMessage:@"The name cannot be empty"];
            return;
        }else{
            self.inputResult(self.nameText.text);
        }
    }
    [super goBack];
}

@end
