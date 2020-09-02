//
//  GlobalControlManger.h
//  RoseRiding
//
//  Created by MR_THT on 2020/3/23.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GlobalControlManger : NSObject

+ (NSString *)enStr:(NSString *)enStr geStr:(NSString *)geStr;

+ (UIColor *)lightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;

+ (NSString *)reversalString:(NSString *)originString;

+ (NSString *)replaceString:(NSString *)originString;

+ (NSString *) sha1:(NSString *)input;

@end

NS_ASSUME_NONNULL_END
