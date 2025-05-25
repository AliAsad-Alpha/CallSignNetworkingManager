//
//  Logger.m
//  CallSignNetworkingManager
//
//  Created by macbook on 24/05/2025.
//

#import "Logger.h"

@implementation Logger

static BOOL _enabled = YES;

+ (BOOL)enabled {
    return _enabled;
}

+ (void)setEnabled:(BOOL)value {
    _enabled = value;
}

+ (void)logMessage:(NSString *)message {
    if (!self.enabled) return;
    NSLog(@"[LOG] %@", message);
}

+ (void)logError:(NSError *)error {
    if (!self.enabled || !error) return;
    NSLog(@"[ERROR] Domain: %@ | Code: %ld | Description: %@",
          error.domain, (long)error.code, error.localizedDescription);
}

+ (void)logJSONFromData:(NSData *)data {
    if (!self.enabled) return;
    if (!data) {
        [self logMessage:@"[JSON] No data provided."];
        return;
    }

    NSError *jsonError;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingMutableContainers
                                                      error:&jsonError];
    if (jsonError) {
        [self logError:jsonError];
    } else {
        [self logPrettyJSON:jsonObject];
    }
}

+ (void)logPrettyJSON:(id)jsonObject {
    if (!self.enabled) return;
    if (!jsonObject) {
        [self logMessage:@"[JSON] nil object"];
        return;
    }

    NSError *error;
    NSData *prettyData = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                         options:NSJSONWritingPrettyPrinted
                                                           error:&error];
    if (error) {
        [self logError:error];
        return;
    }

    NSString *prettyPrintedJSON = [[NSString alloc] initWithData:prettyData encoding:NSUTF8StringEncoding];
    [self logMessage:[NSString stringWithFormat:@"[JSON]\n%@", prettyPrintedJSON]];
}

@end
