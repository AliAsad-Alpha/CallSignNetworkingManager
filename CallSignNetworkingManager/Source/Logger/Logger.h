//
//  Logger.h
//  CallSignNetworkingManager
//
//  Created by macbook on 24/05/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Logger : NSObject

/// Toggle logging on/off
@property (class, nonatomic, assign) BOOL enabled;

+ (void)logMessage:(NSString *)message;
+ (void)logError:(NSError *)error;
+ (void)logJSONFromData:(NSData *)data;
+ (void)logPrettyJSON:(id)jsonObject;

@end

NS_ASSUME_NONNULL_END

