//
//  SharingManager_MailObject_Attachment.h
//  Sharing
//
//  Created by Zouhair Mahieddine on 15/10/11.
//  Copyright (c) 2011 Zedenem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharingManager_MailObject_Attachment : NSObject {
	NSData *data;
	NSString *mimeType, *filename;
}

@property (nonatomic, readonly) NSData *data;
@property (nonatomic, readonly) NSString *mimeType, *filename;

- (id)initWithData:(NSData *)_data mimeType:(NSString *)_mimeType filename:(NSString *)_filename;

@end
