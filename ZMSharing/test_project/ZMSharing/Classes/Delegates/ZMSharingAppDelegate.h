//
//  SharingAppDelegate.h
//  Sharing
//
//  Created by Zouhair Mahieddine on 12/10/11.
//  Copyright 2011 Zedenem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface ZMSharingAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *viewController;

@end
