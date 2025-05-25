//
//  NSError+NetworkError.h
//  CallSignNetworkingManager
//
//  Created by macbook on 24/05/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (NetworkError)
// Create custom errors for different network error scenarios
+ (NSError *)invalidURLError;
+ (NSError *)noDataError;
+ (NSError *)decodingFailedError;
+ (NSError *)serverErrorWithStatusCode:(NSInteger)statusCode;
+ (NSError *)sslPinningFailedError;
+ (NSError *)unknownError:(NSError *)underlyingError;
@end

NS_ASSUME_NONNULL_END

