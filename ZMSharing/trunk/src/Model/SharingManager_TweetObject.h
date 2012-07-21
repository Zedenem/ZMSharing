//
//  SharingManager_TweetObject.h
//  Sharing
//
//  Created by Zouhair Mahieddine on 19/10/11.
//  Copyright (c) 2011 Zedenem. All rights reserved.
//

#import "SharingManager_Object.h"

@interface SharingManager_TweetObject : SharingManager_Object {
	NSString *text;
	NSMutableArray *images, *urls;
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic, readonly) NSMutableArray *images, *urls;

- (void)addImage:(UIImage *)image;
- (void)addURL:(NSURL *)url;

- (void)removeAllImages;
- (void)removeAllURLs;

@end
