//
//  ImageLoader.h
//  CallSignNetworkingManager
//
//  Created by macbook on 24/05/2025.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#ifndef NetworkManager_h
#define NetworkManager_h

NS_ASSUME_NONNULL_BEGIN

@interface ImageDownloader : NSObject

+ (void)loadImageFromURL:(NSURL *)url completion:(void(^)(UIImage * _Nullable image))completion;

@end

NS_ASSUME_NONNULL_END

#endif
