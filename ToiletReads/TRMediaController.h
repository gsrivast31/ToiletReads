//
//  TRMediaController.h
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 11/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

@interface TRMediaController : NSObject

+ (id)sharedInstance;

// Logic
- (void)saveImage:(UIImage *)image
     withFilename:(NSString *)filename
          success:(void (^)(void))successCallback
          failure:(void (^)(NSError *))failureCallback;
- (void)deleteImageWithFilename:(NSString *)filename
                        success:(void (^)(void))successCallback
                        failure:(void (^)(NSError *))failureCallback;
- (UIImage *)imageWithFilename:(NSString *)filename;
- (void)imageWithFilenameAsync:(NSString *)filename
                       success:(void (^)(UIImage *))successCallback
                       failure:(void (^)(NSError *))failureCallback;
- (void)imageFromURL:(NSString*)urlString
             success:(void (^)(UIImage *))successCallback
              failure:(void (^)(NSError *))failureCallback;

// Helpers
- (UIImage *)resizeImage:(UIImage *)image
                  toSize:(CGSize)newSize;
+ (BOOL)canStoreMedia;

@end
