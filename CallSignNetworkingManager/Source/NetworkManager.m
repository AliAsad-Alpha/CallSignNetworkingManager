//
//  NetworkManager.m
//  CallSignAssignment
//
//  Created by macbook on 22/05/2025.
//
// NetworkManager.m
#import "NetworkManager.h"
#import "NSError+NetworkError.h"
#import "Logger.h"

@implementation NetworkManager

static NetworkManager *sharedInstance = nil;

+ (instancetype)shared {
    static NetworkManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetworkManager alloc] init];
    });
    return instance;
}

+ (void)setShared:(NetworkManager *)manager {
    sharedInstance = manager;
}

- (void)sendRequest:(id<NetworkRequest>)request completion:(NetworkCompletionHandler)completion {
    
    if (self.sandboxMode && request.mockJSONResponse != nil) {
        NSData *mockData = [request.mockJSONResponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonError;
        NSDictionary *mockDict = [NSJSONSerialization JSONObjectWithData:mockData options:0 error:&jsonError];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (jsonError) {
                completion(nil, jsonError);
            } else {
                completion(mockDict, nil);
            }
        });
        return;
    }
    
    NSString *baseURLString = [request baseURL];
    NSString *fullURLString = [baseURLString stringByAppendingString:request.path];
    NSURL *url = [NSURL URLWithString:fullURLString];
    if (!url) {
        completion(nil, [NSError invalidURLError]);
        return;
    }
    NSMutableURLRequest *urlRequest = nil;
    
    switch (request.method) {
        case HTTPMethodGET: {
            // Append query parameters
            if (request.parameters) {
                NSURLComponents *components = [NSURLComponents componentsWithString:fullURLString];
                NSMutableArray *queryItems = [NSMutableArray array];
                for (NSString *key in request.parameters) {
                    NSString *value = [NSString stringWithFormat:@"%@", request.parameters[key]];
                    [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:value]];
                }
                components.queryItems = queryItems;
                url = components.URL;
            }
            urlRequest = [NSMutableURLRequest requestWithURL:url];
            urlRequest.HTTPMethod = @"GET";
            break;
        }
            
        case HTTPMethodPOST: {
            urlRequest = [NSMutableURLRequest requestWithURL:url];
            urlRequest.HTTPMethod = @"POST";
            if (request.parameters) {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:request.parameters options:0 error:nil];
                urlRequest.HTTPBody = jsonData;
            }
            break;
        }
            
            // 🔧 Optional: Extend for PUT, DELETE, etc.
        case HTTPMethodPUT: {
            urlRequest = [NSMutableURLRequest requestWithURL:url];
            urlRequest.HTTPMethod = @"PUT";
            if (request.parameters) {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:request.parameters options:0 error:nil];
                urlRequest.HTTPBody = jsonData;
            }
            break;
        }
            
        case HTTPMethodDELETE: {
            urlRequest = [NSMutableURLRequest requestWithURL:url];
            urlRequest.HTTPMethod = @"DELETE";
            break;
        }
            
        default:
            NSLog(@"Unsupported HTTP method");
            return;
    }
    
    // Add headers
    NSMutableDictionary *allHeaders = [NSMutableDictionary dictionaryWithDictionary:@{@"Content-Type": @"application/json"}];
    if (request.headers) {
        [allHeaders addEntriesFromDictionary:request.headers];
    }
    urlRequest.allHTTPHeaderFields = allHeaders;
    
    // Make the request
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
                                  dataTaskWithRequest:urlRequest
                                  completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [Logger logJSONFromData:data];
        if (error) {
            if ([error.domain isEqualToString:NSURLErrorDomain]) {
                if (error.code == NSURLErrorNotConnectedToInternet ){
                    NSLog(@"❌ No internet connection");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, [NSError serverErrorWithStatusCode: error.code]);
                    });
                } else {
                    NSLog(@"❗ Other network / server error: %@", error.localizedDescription);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, [NSError serverErrorWithStatusCode:error.code]);
                    });
                }
            } else {
                NSLog(@"❗ Unknown error: %@", error.localizedDescription);
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, [NSError unknownError:error]);
                });
                
            }
            return;
        }
        NSDictionary *json = nil;
        if (data) {
            NSError *jsonError = nil;
            json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, [NSError decodingFailedError]);
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, [NSError decodingFailedError]);
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(json, nil);
        });
    }];
    
    [task resume];
}


@end
