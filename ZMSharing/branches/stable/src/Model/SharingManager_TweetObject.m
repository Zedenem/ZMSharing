//
//  SharingManager_TweetObject.m
//  Sharing
//
//  Created by Zouhair Mahieddine on 19/10/11.
//  Copyright (c) 2011 Zedenem. All rights reserved.
//

#import "SharingManager_TweetObject.h"

@implementation SharingManager_TweetObject

@synthesize text;
@synthesize images, urls;

- (void)dealloc {
	[text release];
	[images release]; [urls release];
	[super dealloc];
}

- (void)addImage:(UIImage *)image {
	if (images == nil) { images = [[NSMutableArray alloc] init]; }
	[images addObject:image];
}
- (void)addURL:(NSURL *)url {
	if (urls == nil) { urls = [[NSMutableArray alloc] init]; }
	[urls addObject:url];
}

- (void)removeAllImages {
	if (images) { [images removeAllObjects]; }
}
- (void)removeAllURLs {
	if (urls) { [urls removeAllObjects]; }
}

@end
