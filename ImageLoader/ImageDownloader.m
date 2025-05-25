//
//  ImageLoader.m
//  CallSignNetworkingManager
//
//  Created by macbook on 24/05/2025.
//

#import "ImageDownloader.h"

@implementation ImageDownloader

// Static cache instance
+ (NSCache<NSString *, UIImage *> *)sharedImageCache {
    static NSCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[NSCache alloc] init];
        cache.countLimit = 50; // Optional: set max number of items
    });
    return cache;
}

+ (void)loadImageFromURL:(NSURL *)url completion:(void(^)(UIImage * _Nullable image))completion {
    if (!url) {
        completion(nil);
        return;
    }

    NSString *cacheKey = url.absoluteString;
    UIImage *cachedImage = [[self sharedImageCache] objectForKey:cacheKey];
    if (cachedImage) {
        completion(cachedImage);
        return;
    }

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url
                                                             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = nil;
        if (data && !error) {
            image = [UIImage imageWithData:data];
            if (image) {
                [[self sharedImageCache] setObject:image forKey:cacheKey];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    }];
    [task resume];
}

@end


