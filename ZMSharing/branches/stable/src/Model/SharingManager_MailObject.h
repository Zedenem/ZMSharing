//
//  SharingManager_MailObject.h
//  Sharing
//
//  Created by Zouhair Mahieddine on 15/10/11.
//  Copyright (c) 2011 Zedenem. All rights reserved.
//

#import "SharingManager_Object.h"
#import "SharingManager_MailObject_Attachment.h"

@interface SharingManager_MailObject : SharingManager_Object {
	NSString *subject, *body;
	NSArray *toRecipients, *ccRecipients, *bccRecipients;
	
	BOOL bodyIsHTML;
	
	NSMutableArray *attachments;
}

@property (nonatomic, copy) NSString *subject, *body;
@property (nonatomic, copy)	NSArray *toRecipients, *ccRecipients, *bccRecipients;
@property (nonatomic) BOOL bodyIsHTML;
@property (nonatomic, readonly) NSMutableArray *attachments;

- (void)setMessageBody:(NSString *)_body isHTML:(BOOL)_bodyIsHTML;
- (void)addAttachmentData:(NSData*)attachmentData mimeType:(NSString*)mimeType fileName:(NSString*)filename;

@end
