//
//  RootViewController.m
//  Sharing
//
//  Created by Zouhair Mahieddine on 15/10/11.
//  Copyright (c) 2011 Zedenem. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	[[SharingManager sharedSharingManager] setDelegate:self];
	[SharingManager sharedSharingManager].enabledSharingTools = SharingManagerMail | SharingManagerSMS | SharingManagerPrint | SharingManagerFacebook | SharingManagerTwitter;
	NSLog(@"%@", [[SharingManager sharedSharingManager] description]);
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark Sharing methods
- (IBAction)share:(id)sender {
	[[SharingManager sharedSharingManager] showSharingActionSheetInView:self.view];
}

#pragma mark - SharingManagerDelegate methods

#pragma mark Required to enable sharing by mail
- (void)sharingManager:(SharingManager *)sharingManager requiresInformationsToSendMail:(SharingManager_MailObject *)mailObject {
	[mailObject setSubject:@"Mail Subject"];
	[mailObject setToRecipients:[NSArray arrayWithObject:@"test@zedenem.com"]];
	[mailObject setCcRecipients:[NSArray arrayWithObject:@"test@zedenem.com"]];
	[mailObject setBccRecipients:[NSArray arrayWithObject:@"test@zedenem.com"]];
	[mailObject setMessageBody:@"<h1>Message Body</h1><p>This message body is in HTML...</p>" isHTML:YES];
	[mailObject addAttachmentData:UIImagePNGRepresentation([UIImage imageNamed:@"icon.png"]) mimeType:@"image/png" fileName:@"icon.png"];
	[mailObject addAttachmentData:UIImagePNGRepresentation([UIImage imageNamed:@"icon.png"]) mimeType:@"image/png" fileName:@"icon.png"];
}
- (void)sharingManager:(SharingManager *)sharingManager needsToPresentMailComposeController:(MFMailComposeViewController *)mfMailComposeViewController {
	[self presentModalViewController:mfMailComposeViewController animated:YES];
}
- (void)sharingManager:(SharingManager *)sharingManager mailComposeController:(MFMailComposeViewController *)mailComposeController didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[self dismissModalViewControllerAnimated:YES];
	switch (result) {
		case MFMailComposeResultFailed:
			[[[[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"AN_ERROR_OCCURRED", @"Sharing_Library", @"") message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @"Sharing_Library", @"") otherButtonTitles:nil] autorelease] show];
			break;
		default:
			break;
	}
}

#pragma mark Required to enable sharing by sms
- (void)sharingManager:(SharingManager *)sharingManager requiresInformationsToSendMessage:(SharingManager_MessageObject *)messageObject {
	[messageObject setBody:@"This is a text message"];
	[messageObject setRecipients:[NSArray arrayWithObjects:@"test@zedenem.com", @"0000000000", nil]];
}
- (void)sharingManager:(SharingManager *)sharingManager needsToPresentMessageComposeController:(MFMessageComposeViewController *)messageComposeController {
	[self presentModalViewController:messageComposeController animated:YES];
}
- (void)sharingManager:(SharingManager *)sharingManager messageComposeController:(MFMessageComposeViewController *)messageComposeController didFinishWithResult:(MessageComposeResult)result {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark Required to enable printing
- (NSArray *)sharingManagerRequiresItemsToPrint:(SharingManager *)sharingManager {
	return [NSArray arrayWithObject:[UIImage imageNamed:@"icon.png"]];
}
- (NSString *)sharingManagerRequiresPrintJobName:(SharingManager *)sharingManager {
	return @"ZM Sharing Library : Icon printing";
}
- (void)sharingManagerNeedsToPresentPrintController:(SharingManager *)sharingManager {
	[[SharingManager sharedSharingManager] showPrintControllerAnimated:YES completionHandler:nil];
}

#pragma mark Required to enable sharing by facebook
- (NSString *)sharingManagerRequiresFacebookAppId:(SharingManager *)sharingManager {
	return @"188092274603997";
}
- (void)sharingManager:(SharingManager *)sharingManager requiresInformationsToSendFacebookPost:(SharingManager_FacebookPostObject *)facebookPostObject {
	facebookPostObject.name = @"I'm using the ZMSharing Library test app";
	facebookPostObject.caption = @"ZMSharing Library for iOS.";
	facebookPostObject.description = @"This is a facebook post";
	facebookPostObject.pictureURL = @"http://zedenem.com/wp-content/themes/Zedenem/images/logo.png";
	facebookPostObject.link = @"http://www.mobile-health.fr/apps/sharinglibrary";
	facebookPostObject.actionLink = @"https://github.com/Zedenem/ZMSharing";
	facebookPostObject.actionName = @"See more on github!";
}

#pragma mark Required to enable sharing by twitter
- (void)sharingManager:(SharingManager *)sharingManager requiresInformationsToSendTweet:(SharingManager_TweetObject *)tweetObject {
	[tweetObject setText:@"This is a tweet"];
}
- (void)sharingManager:(SharingManager *)sharingManager needsToPresentTweetComposeController:(TWTweetComposeViewController *)tweetComposeController {
	[self presentModalViewController:tweetComposeController animated:YES];
}
- (void)sharingManager:(SharingManager *)sharingManager twitterSharingDidFinishWithResult:(MessageComposeResult)result {
	
}

#pragma mark Required to enable sharing by twitter on iOS < 5.0 devices
- (NSString *)sharingManagerRequiresTwitterConsumerKey:(SharingManager *)sharingManager {
	return @"yji8zn1ub16gs57xdUZKaA";
}
- (NSString *)sharingManagerRequiresTwitterConsumerSecret:(SharingManager *)sharingManager {
	return @"2JW4X4lG301KohbgJBKq3ffgTVrAXIdQX0buDhQ";
}
- (void)sharingManager:(SharingManager *)sharingManager needsToPresentTwitterLoginController:(SA_OAuthTwitterController *)twitterLoginController {
	[self presentModalViewController:twitterLoginController animated:YES];
}
- (void)sharingManager:(SharingManager *)sharingManager needsToPresentCustomTweetComposeController:(UINavigationController *)tweetComposeController {
	[self presentModalViewController:tweetComposeController animated:YES];
}






@end
