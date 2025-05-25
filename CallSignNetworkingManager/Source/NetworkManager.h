//
//  NetworkManager.h
//  CallSignAssignment
//
//  Created by macbook on 22/05/2025.
//

#ifndef NetworkManager_h
#define NetworkManager_h

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^NetworkCompletionHandler)(NSDictionary * _Nullable response, NSError * _Nullable error);

@interface NetworkManager : NSObject

+ (instancetype)shared;

+ (void)setShared:(NetworkManager *)manager;

- (void)sendRequest:(id<NetworkRequest>)request completion:(NetworkCompletionHandler)completion;

@property (nonatomic, assign) BOOL sandboxMode;

@end


NS_ASSUME_NONNULL_END

#endif /* NetworkManager_h */
