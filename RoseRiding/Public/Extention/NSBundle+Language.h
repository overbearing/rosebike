//
//  NSBundle+Language.h
//  RoseRiding
//
//  Created by Mac on 2020/7/1.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#define GCLocalizedString(KEY) [[NSBundle mainBundle] localizedStringForKey:KEY value:nil table:@"Localizable"]
@interface NSBundle (Language)
+ (void)setLanguage:(NSString *)language;
@end
NS_ASSUME_NONNULL_END
