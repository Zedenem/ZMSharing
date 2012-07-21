//
//  SharingManager_FacebookPostObject.m
//  Sharing
//
//  Created by Zouhair Mahieddine on 19/10/11.
//  Copyright (c) 2011 Zedenem. All rights reserved.
//

#import "SharingManager_FacebookPostObject.h"

@implementation SharingManager_FacebookPostObject

@synthesize name, caption, description, pictureURL, link;
@synthesize actionLink, actionName;

- (void)dealloc {
	[name release]; [caption release]; [description release]; [pictureURL release]; [link release];
	[actionLink release]; [actionName release];
	[super dealloc];
}

@end
