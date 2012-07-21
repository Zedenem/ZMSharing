//
//  SharingManager_MessageObject.m
//  Sharing
//
//  Created by Zouhair Mahieddine on 18/10/11.
//  Copyright (c) 2011 Zedenem. All rights reserved.
//

#import "SharingManager_MessageObject.h"

@implementation SharingManager_MessageObject

@synthesize body;
@synthesize recipients;

- (void)dealloc {
	[body release];
	[recipients release];
	[super dealloc];
}

@end
