//
//  NetworkingManger.h
//  RoseRiding
//
//  Created by MR_THT on 2020/3/23.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkingManger : NSObject

+ (NetworkingManger *)shareManger;

- (void)getDataWithUrl:(NSString *)url para:(NSDictionary * _Nullable)dic success:(void(^)(NSDictionary *result))success fail:(void(^)(NSError *error))fail;

- (void)postDataWithUrl:(NSString *)url para:(NSDictionary * _Nullable)dic success:(void(^)(NSDictionary *result))success fail:(void(^)(NSError *error))fail;

- (void)uploadFile:(NSString *)url para:(NSDictionary * _Nullable)dic data:(NSData *)fileData fileName:(NSString *)fileName mimetype:(NSString *)mimetype success:(void(^)(NSDictionary *result))success fail:(void(^)(NSError *error))fail;

@end

NS_ASSUME_NONNULL_END
