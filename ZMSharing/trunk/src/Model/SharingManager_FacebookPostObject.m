//
//  SharingManager_FacebookPostObject.m
//  Sharing
//
//  Created by Zouhair Mahieddine on 19/10/11.
//  Copyright (c) 2011 Zedenem. All rights reserved.
//

#import "SharingManager_FacebookPostObject.h"

@implementation SharingManager_FacebookPostObject

@synthesize name = _name;
@synthesize caption = _caption;
@synthesize description = _description;
@synthesize pictureURL = _pictureURL;
@synthesize link = _link;

- (void)dealloc {
	[_name release];
	[_caption release];
	[_description release];
	[_pictureURL release];
	[_link release];
	[super dealloc];
}

@end
