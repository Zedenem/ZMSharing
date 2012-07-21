//
//  SharingManager_MailObject.m
//  Sharing
//
//  Created by Zouhair Mahieddine on 15/10/11.
//  Copyright (c) 2011 Zedenem. All rights reserved.
//

#import "SharingManager_MailObject.h"

@implementation SharingManager_MailObject

@synthesize subject, body;
@synthesize toRecipients, ccRecipients, bccRecipients;
@synthesize bodyIsHTML;
@synthesize attachments;

- (void)dealloc {
	[subject release]; [body release];
	[toRecipients release]; [ccRecipients release]; [bccRecipients release];
	[attachments release];
	[super dealloc];
}

- (void)setMessageBody:(NSString *)_body isHTML:(BOOL)_bodyIsHTML {
	body = _body;
	bodyIsHTML = _bodyIsHTML;
}
- (void)addAttachmentData:(NSData*)attachmentData mimeType:(NSString*)mimeType fileName:(NSString*)filename {
	if (attachments == nil) { attachments = [[NSMutableArray alloc] init]; }
	
	SharingManager_MailObject_Attachment *attachment = [[SharingManager_MailObject_Attachment alloc] initWithData:attachmentData mimeType:mimeType filename:filename];
	[attachments addObject:attachment];
	[attachment release];
}

@end
