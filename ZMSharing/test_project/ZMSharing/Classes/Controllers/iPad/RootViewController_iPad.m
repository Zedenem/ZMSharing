//
//  RootViewController_iPad.m
//  Sharing
//
//  Created by Zouhair Mahieddine on 15/10/11.
//  Copyright (c) 2011 Zedenem. All rights reserved.
//

#import "RootViewController_iPad.h"

@implementation RootViewController_iPad

#pragma mark Sharing methods
- (IBAction)share:(id)sender {
	UIButton *button = (UIButton *)sender;
	[[SharingManager sharedSharingManager] showSharingActionSheetFromRect:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height) inView:button animated:YES];
}


#pragma mark - SharingManagerDelegate methods
// Required to enable printing
- (void)sharingManagerNeedsToPresentPrintController:(SharingManager *)sharingManager {
	[[SharingManager sharedSharingManager] showPrintControllerFromRect:CGRectMake(self.view.center.x, self.view.center.y, 500, 300) inView:self.view animated:YES completionHandler:nil];
}

// Required to enable sharing by twitter on iOS < 5.0 devices
- (void)sharingManager:(SharingManager *)sharingManager needsToPresentCustomTweetComposeController:(UINavigationController *)tweetComposeController {
	//tweetComposeController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentModalViewController:tweetComposeController animated:YES];
}

@end
