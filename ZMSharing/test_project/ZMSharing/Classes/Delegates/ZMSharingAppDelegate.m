//
//  SharingAppDelegate.m
//  Sharing
//
//  Created by Zouhair Mahieddine on 12/10/11.
//  Copyright 2011 Zedenem. All rights reserved.
//

#import "ZMSharingAppDelegate.h"
#import "RootViewController.h"

@implementation ZMSharingAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[self.window addSubview:self.viewController.view];
	[self.window sendSubviewToBack:self.viewController.view];
	
	[self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}
- (void)applicationDidBecomeActive:(UIApplication *)application {}
- (void)applicationWillTerminate:(UIApplication *)application {}
- (void)dealloc {
	[_window release];
    [super dealloc];
}

#warning ZMSharingManager Requirements
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[SharingManager sharedSharingManager] handleOpenURL:url];
}

// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[SharingManager sharedSharingManager] handleOpenURL:url]; 
}

@end
