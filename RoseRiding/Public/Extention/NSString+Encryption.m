//
//  NSString+Encryption.m
//  RoseRiding
//
//  Created by mac on 2020/4/30.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "NSString+Encryption.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Encryption)


+ (NSString *)md5:(NSString *) input {

    const char *cStr = [input UTF8String];

    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}
@end
