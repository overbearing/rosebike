//
//  NSString+Encryption.h
//  RoseRiding
//
//  Created by mac on 2020/4/30.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface NSString (Encryption)

+ (NSString *)md5:(NSString *) input;
@end

NS_ASSUME_NONNULL_END
