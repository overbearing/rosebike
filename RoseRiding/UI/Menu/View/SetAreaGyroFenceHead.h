//
//  SetAreaGyroFenceHead.h
//  RoseRiding
//
//  Created by MR_THT on 2020/5/4.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SetAreaGyroFenceHeadShow)(void);

@interface SetAreaGyroFenceHead : UIView

@property (nonatomic , copy)SetAreaGyroFenceHeadShow show;



@end

NS_ASSUME_NONNULL_END
