//
//  NSError+NetworkError.m
//  CallSignNetworkingManager
//
//  Created by macbook on 24/05/2025.
//

#import "NSError+NetworkError.h"

// Define the error domain
NSErrorDomain const NetworkErrorDomain = @"com.callSign.NetworkError";

@implementation NSError (NetworkError)

// Invalid URL error
+ (NSError *)invalidURLError {
    return [NSError errorWithDomain:NetworkErrorDomain
                               code:1000
                           userInfo:@{ NSLocalizedDescriptionKey: @"network_error_invalid_url" }];
}

// No data received error
+ (NSError *)noDataError {
    return [NSError errorWithDomain:NetworkErrorDomain
                               code:1001
                           userInfo:@{ NSLocalizedDescriptionKey: @"network_error_no_data" }];
}

// Decoding failed error
+ (NSError *)decodingFailedError {
    return [NSError errorWithDomain:NetworkErrorDomain
                               code:1002
                           userInfo:@{ NSLocalizedDescriptionKey: @"network_error_decode" }];
}

// Server error with a specific status code
+ (NSError *)serverErrorWithStatusCode:(NSInteger)statusCode {
    return [NSError errorWithDomain:NetworkErrorDomain
                               code:1003
                           userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:@"network_error_no_internet"] }];
}

// SSL pinning failed error
+ (NSError *)sslPinningFailedError {
    return [NSError errorWithDomain:NetworkErrorDomain
                               code:1004
                           userInfo:@{ NSLocalizedDescriptionKey: @"network_error_ssl_failed" }];
}

// Unknown error with an underlying error
+ (NSError *)unknownError:(NSError *)underlyingError {
    return [NSError errorWithDomain:NetworkErrorDomain
                               code:1005
                           userInfo:@{ NSLocalizedDescriptionKey: @"network_error_unknown",
                                      NSUnderlyingErrorKey: underlyingError }];
}

@end

