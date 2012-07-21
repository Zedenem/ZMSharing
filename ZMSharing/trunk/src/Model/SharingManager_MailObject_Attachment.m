//
//  SharingManager_MailObject_Attachment.m
//  Sharing
//
//  Created by Zouhair Mahieddine on 15/10/11.
//  Copyright (c) 2011 Zedenem. All rights reserved.
//

#import "SharingManager_MailObject_Attachment.h"

@implementation SharingManager_MailObject_Attachment

@synthesize data;
@synthesize filename, mimeType;

- (id)initWithData:(NSData *)_data mimeType:(NSString *)_mimeType filename:(NSString *)_filename {
	self = [super init];
	if (self) {
		@try { data = [[NSData alloc] initWithData:_data]; }				@catch (NSException *exception) { data = [[NSData alloc] init]; }
		@try { mimeType = [[NSString alloc] initWithString:_mimeType]; }	@catch (NSException *exception) { mimeType = [[NSString alloc] init]; }
		@try { filename = [[NSString alloc] initWithString:_filename]; }	@catch (NSException *exception) { filename = [[NSString alloc] init]; }
	}
	return self;
}
- (void)dealloc {
	[data release];
	[mimeType release];
	[filename release];
	[super dealloc];
}

@end
