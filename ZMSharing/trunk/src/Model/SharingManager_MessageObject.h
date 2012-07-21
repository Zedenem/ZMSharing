//
//  SharingManager_MessageObject.h
//  Sharing
//
//  Created by Zouhair Mahieddine on 18/10/11.
//  Copyright (c) 2011 Zedenem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SharingManager_Object.h"

@interface SharingManager_MessageObject : SharingManager_Object {
	NSString *body;
	NSArray *recipients;
}

@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSArray *recipients;

@end
