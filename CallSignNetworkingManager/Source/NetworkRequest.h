//
//  NetworkRequest.h
//  CallSignNetworkingManager
//
//  Created by macbook on 23/05/2025.
//

#import <Foundation/Foundation.h>

#ifndef NetworkRequest_h
#define NetworkRequest_h

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HTTPMethod) {
    HTTPMethodGET,
    HTTPMethodPOST,
    HTTPMethodPUT,
    HTTPMethodDELETE
};

@protocol NetworkRequest <NSObject>

@property (nonatomic, readonly) NSString *baseURL;
@property (nonatomic, readonly) NSString *path;
@property (nonatomic, readonly) HTTPMethod method;
@property (nonatomic, readonly, nullable) NSDictionary<NSString *, NSString *> *headers;
@property (nonatomic, readonly, nullable) NSDictionary *parameters;
/// Optional mock JSON response string (used when sandbox mode is ON)
@property (nonatomic, readonly, nullable) NSString *mockJSONResponse;

@end

NS_ASSUME_NONNULL_END

#endif /* NetworkRequest_h */
