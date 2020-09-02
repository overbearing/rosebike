//
//  UserInfoHeadView.h
//  RoseRiding
//
//  Created by MR_THT on 2020/3/31.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^UserInfoHeadViewSubmit)(NSString * _Nullable str);
typedef void(^UserInfoHeadViewChangeHeadImg)(void);
@interface UserInfoHeadView : UIView

@property (nonatomic, strong)UIImageView *headImg;
@property (nonatomic, strong)UITextField     *nick;
@property (nonatomic, strong)UIButton    *edit;
@property (nonatomic, copy)UserInfoHeadViewSubmit submit;
@property (nonatomic, copy)UserInfoHeadViewChangeHeadImg changeHeadImg;
@end

NS_ASSUME_NONNULL_END
