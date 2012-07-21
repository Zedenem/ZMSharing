//
//  SharingManager_FacebookPostObject.h
//  Sharing
//
//  Created by Zouhair Mahieddine on 19/10/11.
//  Copyright (c) 2011 Zedenem. All rights reserved.
//

#import "SharingManager_Object.h"

@interface SharingManager_FacebookPostObject : SharingManager_Object {
	NSString *name, *caption, *description, *pictureURL, *link;
	NSString *actionLink, *actionName;
}

@property (nonatomic, copy) NSString *name, *caption, *description, *pictureURL, *link;
@property (nonatomic, copy) NSString *actionLink, *actionName;

@end
