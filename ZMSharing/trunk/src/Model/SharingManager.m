//
//  SharingManager.m
//  Sharing
//
//  Created by Zouhair Mahieddine on 12/10/11.
//  Copyright 2011 Zedenem. All rights reserved.
//

#import "SharingManager.h"

static SharingManager *sharedInstance_ = nil;

@implementation SharingManager

@synthesize enabledSharingTools;
@synthesize delegate;
@synthesize facebookSession = _facebookSession;

- (void)dealloc {
	[_facebookSession release];
	[twitterEngine release];
	[super dealloc];
}

#pragma mark - Singleton access methods
+ (SharingManager *)sharedSharingManager {
	@synchronized(self) {
		if (sharedInstance_ == nil) {
			sharedInstance_ = [[self alloc] init];
			
			[[NSNotificationCenter defaultCenter] addObserver:sharedInstance_ selector:@selector(applicationWillTerminate) name:@"UIApplicationWillTerminateNotification" object:nil];
			[[NSNotificationCenter defaultCenter] addObserver:sharedInstance_ selector:@selector(applicationDidBecomeActive) name:@"UIApplicationDidBecomeActiveNotification" object:nil];
		}
    }
	return(sharedInstance_);
}
- (NSString *)description {
	NSMutableString *description = [NSMutableString stringWithString:@"SharingTools : "];
	
	if (enabledSharingTools == 0)		{ [description appendString:@"SharingManagerNone"]; }
	if (enabledSharingTools>>0 & 01)	{ [description appendString:@"SharingManagerMail | "]; }
	if (enabledSharingTools>>1 & 01)	{ [description appendString:@"SharingManagerSMS | "]; }
	if (enabledSharingTools>>2 & 01)	{ [description appendString:@"SharingManagerMMS | "]; }
	if (enabledSharingTools>>3 & 01)	{ [description appendString:@"SharingManagerPrint | "]; }
	if (enabledSharingTools>>4 & 01)	{ [description appendString:@"SharingManagerTwitter | "]; }
	if (enabledSharingTools>>5 & 01)	{ [description appendString:@"SharingManagerFacebook | "]; }
	if (enabledSharingTools>>6 & 01)	{ [description appendString:@"SharingManagerGoogle | "]; }
	
	return description;
}

#pragma mark - General Sharing Manager access methods
- (UIActionSheet *)sharingActionSheet {
	UIActionSheet *sharingActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"Sharing_Library_ACTIONSHEET_TITLE", @"Sharing_Library", @"") delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	
	if ([self canShareByMail])		{ [sharingActionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"Sharing_Library_BY_MAIL", @"Sharing_Library", @"")]; }
	if ([self canShareBySMS])		{ [sharingActionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"Sharing_Library_BY_SMS", @"Sharing_Library", @"")]; }
	if ([self canShareByMMS])		{ [sharingActionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"Sharing_Library_BY_MMS", @"Sharing_Library", @"")]; }
	if ([self canPrint])			{ [sharingActionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"Sharing_Library_PRINT", @"Sharing_Library", @"")]; }
	if ([self canShareByTwitter])	{ [sharingActionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"Sharing_Library_BY_TWITTER", @"Sharing_Library", @"")]; }
	if ([self canShareByFacebook])	{ [sharingActionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"Sharing_Library_BY_FACEBOOK", @"Sharing_Library", @"")]; }
	if ([self canShareByGoogle])	{ [sharingActionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"Sharing_Library_BY_GOOGLE", @"Sharing_Library", @"")]; }
	
	[sharingActionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"Sharing_Library_CANCEL", @"Sharing_Library", @"")];
	
	[sharingActionSheet setCancelButtonIndex:sharingActionSheet.numberOfButtons-1];
	
	return [sharingActionSheet autorelease];
}

#pragma mark - Sharing ActionSheet display methods
- (void)showSharingActionSheetFromTabBar:(UITabBar *)tabbar {
	UIActionSheet *sharingActionSheet = [[self sharingActionSheet] retain];
	[sharingActionSheet showFromTabBar:tabbar];
	[sharingActionSheet release];
}
- (void)showSharingActionSheetFromToolbar:(UIToolbar *)toolbar {
	UIActionSheet *sharingActionSheet = [[self sharingActionSheet] retain];
	[sharingActionSheet showFromToolbar:toolbar];
	[sharingActionSheet release];
}
- (void)showSharingActionSheetInView:(UIView *)view {
	UIActionSheet *sharingActionSheet = [[self sharingActionSheet] retain];
	[sharingActionSheet showInView:view];
	[sharingActionSheet release];
}
- (void)showSharingActionSheetFromBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated {
	UIActionSheet *sharingActionSheet = [[self sharingActionSheet] retain];
	[sharingActionSheet showFromBarButtonItem:barButtonItem animated:animated];
	[sharingActionSheet release];
}
- (void)showSharingActionSheetFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated {
	UIActionSheet *sharingActionSheet = [[self sharingActionSheet] retain];
	[sharingActionSheet showFromRect:rect inView:view animated:animated];
	[sharingActionSheet release];
}

#pragma mark - UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
	if ([buttonTitle isEqualToString:NSLocalizedStringFromTable(@"Sharing_Library_BY_MAIL", @"Sharing_Library", @"")]) {
		[self shareByMail];
	}
	else if ([buttonTitle isEqualToString:NSLocalizedStringFromTable(@"Sharing_Library_BY_SMS", @"Sharing_Library", @"")]) {
		[self shareBySMS];
	}
	else if ([buttonTitle isEqualToString:NSLocalizedStringFromTable(@"Sharing_Library_PRINT", @"Sharing_Library", @"")]) {
		[self print];
	}
	else if ([buttonTitle isEqualToString:NSLocalizedStringFromTable(@"Sharing_Library_BY_FACEBOOK", @"Sharing_Library", @"")]) {
		[self shareByFacebook];
	}
	else if ([buttonTitle isEqualToString:NSLocalizedStringFromTable(@"Sharing_Library_BY_TWITTER", @"Sharing_Library", @"")]) {
		[self shareByTwitter];
	}
}
																					 
#pragma mark - Is Sharing Enabled methods
- (BOOL)canShareByMail {
	return (enabledSharingTools>>0 & 01
			&& [MFMailComposeViewController canSendMail]
			&& [self.delegate respondsToSelector:@selector(sharingManager:requiresInformationsToSendMail:)]
			&& [self.delegate respondsToSelector:@selector(sharingManager:needsToPresentMailComposeController:)]
			&& [self.delegate respondsToSelector:@selector(sharingManager:mailComposeController:didFinishWithResult:error:)]);
}
- (BOOL)canShareBySMS {
	return (enabledSharingTools>>1 & 01
			&& NSClassFromString(@"MFMessageComposeViewController") != nil
			&& [MFMessageComposeViewController canSendText]);
}
- (BOOL)canShareByMMS {
	return (enabledSharingTools>>2 & 01
			&& NO);
}
- (BOOL)canPrint {
	return (enabledSharingTools>>3 & 01
			&& NSClassFromString(@"UIPrintInteractionController") != nil
			&& [UIPrintInteractionController isPrintingAvailable]);
}
- (BOOL)canShareByTwitter {
	return (enabledSharingTools>>4 & 01
			//&& NSClassFromString(@"TWTweetComposeViewController") != nil
			//&& [TWTweetComposeViewController canSendTweet]
			);
}
- (BOOL)canShareByFacebook {
	return (enabledSharingTools>>5 & 01
			&& [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookAppID"] length] > 0
			);
}
- (BOOL)canShareByGoogle {
	return (enabledSharingTools>>6 & 01
			&& NO);
}

#pragma mark - Sharing methods
- (void)shareByMail {
	if ([self canShareByMail]) {
		MFMailComposeViewController *mfMailComposeViewController = [[MFMailComposeViewController alloc] init];
		[mfMailComposeViewController setMailComposeDelegate:self];
		
		SharingManager_MailObject *mailObject = [[SharingManager_MailObject alloc] init];
		if ([self.delegate respondsToSelector:@selector(sharingManager:requiresInformationsToSendMail:)]) {
			[self.delegate sharingManager:self requiresInformationsToSendMail:mailObject];
		}
		
		[mfMailComposeViewController setSubject:mailObject.subject];
		[mfMailComposeViewController setToRecipients:mailObject.toRecipients];
		[mfMailComposeViewController setCcRecipients:mailObject.ccRecipients];
		[mfMailComposeViewController setBccRecipients:mailObject.bccRecipients];
		[mfMailComposeViewController setMessageBody:mailObject.body isHTML:mailObject.bodyIsHTML];
		for (SharingManager_MailObject_Attachment *attachment in mailObject.attachments) {
			[mfMailComposeViewController addAttachmentData:attachment.data mimeType:attachment.mimeType fileName:attachment.filename];
		}
		
		[mailObject release];
		
		if ([self.delegate respondsToSelector:@selector(sharingManager:needsToPresentMailComposeController:)]) {
			[self.delegate sharingManager:self needsToPresentMailComposeController:mfMailComposeViewController];
		}
	}
}
- (void)shareBySMS {
	if ([self canShareBySMS]) {
		MFMessageComposeViewController *mfMessageComposeViewController = [[MFMessageComposeViewController alloc] init];
		[mfMessageComposeViewController setMessageComposeDelegate:self];
		
		SharingManager_MessageObject *messageObject = [[SharingManager_MessageObject alloc] init];
		if ([self.delegate respondsToSelector:@selector(sharingManager:requiresInformationsToSendMessage:)]) {
			[self.delegate sharingManager:self requiresInformationsToSendMessage:messageObject];
		}
		
		[mfMessageComposeViewController setRecipients:messageObject.recipients];
		[mfMessageComposeViewController setBody:messageObject.body];
		
		[messageObject release];
		
		if ([self.delegate respondsToSelector:@selector(sharingManager:needsToPresentMessageComposeController:)]) {
			[self.delegate sharingManager:self needsToPresentMessageComposeController:mfMessageComposeViewController];
		}
	}
}
- (void)print {
	if ([self canPrint]) {
		[[UIPrintInteractionController sharedPrintController] setDelegate:self];
		
		NSMutableArray *printingItems = [[NSMutableArray alloc] init];
		if ([self.delegate respondsToSelector:@selector(sharingManagerRequiresItemsToPrint:)]) {
			[printingItems addObjectsFromArray:[self.delegate sharingManagerRequiresItemsToPrint:self]];
		}
		
		[[UIPrintInteractionController sharedPrintController] setPrintingItems:printingItems];
		
		[printingItems release];
		
		if ([self.delegate respondsToSelector:@selector(sharingManagerRequiresPrintJobName:)]) {
			UIPrintInfo *printInfo = [UIPrintInfo printInfo];
			[printInfo setJobName:[self.delegate sharingManagerRequiresPrintJobName:self]];
			[UIPrintInteractionController sharedPrintController].printInfo = printInfo;
		}
		
		if ([self.delegate respondsToSelector:@selector(sharingManagerNeedsToPresentPrintController:)]) {
			[self.delegate sharingManagerNeedsToPresentPrintController:self];
		}
	}
}
- (void)shareByFacebook {
	if ([self canShareByFacebook]) {
		if (!FBSession.activeSession.isOpen) {
			[self openFacebookSessionAndShareAutomatically:YES];
		}
		else {
			if ([self.delegate respondsToSelector:@selector(sharingManager:requiresInformationsToSendFacebookPost:)]) {
				SharingManager_FacebookPostObject *facebookPostObject = [[SharingManager_FacebookPostObject alloc] init];
				[self.delegate sharingManager:self requiresInformationsToSendFacebookPost:facebookPostObject];
				
				NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
											   facebookPostObject.name, @"name",
											   facebookPostObject.caption, @"caption",
											   facebookPostObject.description, @"description",
											   facebookPostObject.link, @"link",
											   facebookPostObject.pictureURL, @"picture", nil];
				[FBRequestConnection startWithGraphPath:@"me/feed" parameters:params HTTPMethod:@"POST"
									  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
										  if ([self.delegate respondsToSelector:@selector(sharingManager:didFinishFacebookPostingWithError:)]) {
											  [self.delegate sharingManager:self didFinishFacebookPostingWithError:error];
										  }
									  }];
			}
		}
	}
}
- (void)shareByTwitter {
	if ([self canShareByTwitter]) {
		if (NSClassFromString(@"TWTweetComposeViewController") != nil && [TWTweetComposeViewController canSendTweet]) {
			TWTweetComposeViewController *twTweetComposeViewController = [[TWTweetComposeViewController alloc] init];
			
			SharingManager_TweetObject *tweetObject = [[SharingManager_TweetObject alloc] init];
			if ([self.delegate respondsToSelector:@selector(sharingManager:requiresInformationsToSendTweet:)]) {
				[self.delegate sharingManager:self requiresInformationsToSendTweet:tweetObject];
			}
			
			[twTweetComposeViewController setInitialText:tweetObject.text];
			
			for (UIImage *image in tweetObject.images) {
				BOOL imageAddedSuccessfully = [twTweetComposeViewController addImage:image];
				if (!imageAddedSuccessfully) { break; }
			}
			for (NSURL *url in tweetObject.urls) {
				BOOL urlAddedSuccessfully = [twTweetComposeViewController addURL:url];
				if (!urlAddedSuccessfully) { break; }
			}
			
			[tweetObject release];
			
			if ([self.delegate respondsToSelector:@selector(sharingManager:needsToPresentTweetComposeController:)]) {
				[self.delegate sharingManager:self needsToPresentTweetComposeController:twTweetComposeViewController];
			}
		}
		else {
			if (!twitterEngine) {
				twitterEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
				if ([self.delegate respondsToSelector:@selector(sharingManagerRequiresTwitterConsumerKey:)]) {
					twitterEngine.consumerKey = [self.delegate sharingManagerRequiresTwitterConsumerKey:self];
				}
				if ([self.delegate respondsToSelector:@selector(sharingManagerRequiresTwitterConsumerSecret:)]) {
					twitterEngine.consumerSecret = [self.delegate sharingManagerRequiresTwitterConsumerSecret:self];
				}
			}
			
			if (![twitterEngine isAuthorized]) {
				SA_OAuthTwitterController *twitterLoginController = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:twitterEngine delegate:self];  
				
				if (twitterLoginController && [self.delegate respondsToSelector:@selector(sharingManager:needsToPresentTwitterLoginController:)]) {
					[self.delegate sharingManager:self needsToPresentTwitterLoginController:twitterLoginController];
				}
			}
			else {
				[self sendTwitterUpdate];
			}
		}
	}
}
- (void)sendTwitterUpdate {
	SharingManager_TweetObject *tweetObject = [[SharingManager_TweetObject alloc] init];
	if ([self.delegate respondsToSelector:@selector(sharingManager:requiresInformationsToSendTweet:)]) {
		[self.delegate sharingManager:self requiresInformationsToSendTweet:tweetObject];
	}
	if (sharingManager_TweetComposeViewController) {
		sharingManager_TweetComposeViewController = nil; [sharingManager_TweetComposeViewController release];
	}
	sharingManager_TweetComposeViewController = [[SharingManager_TweetComposeViewController alloc] init];
	sharingManager_TweetComposeViewController.delegate = self;
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:sharingManager_TweetComposeViewController];
	if ([self.delegate respondsToSelector:@selector(sharingManager:needsToPresentCustomTweetComposeController:)]) {
		[self.delegate sharingManager:self needsToPresentCustomTweetComposeController:navigationController];
	}
	[navigationController release];
	[sharingManager_TweetComposeViewController setInitialText:tweetObject.text];
}

#pragma mark - Printing available for datas methods
- (BOOL)canPrintData:(NSData *)data {
	return [UIPrintInteractionController canPrintData:data];
}
- (BOOL)canPrintURL:(NSURL *)url {
	return [UIPrintInteractionController canPrintURL:url];
}

#pragma mark - Facebook sharing specific methods
- (BOOL)handleOpenURL:(NSURL *)url {
	if (FBSession.activeSession.state != FBSessionStateClosed) {
		return [FBSession.activeSession handleOpenURL:url];
	}
	else {
		return NO;
	}
}
- (BOOL)openFacebookSession {
	[self openFacebookSessionAndShareAutomatically:NO];
}
- (BOOL)openFacebookSessionAndShareAutomatically:(BOOL)shareAutomatically {
    self.facebookSession = [[[FBSession alloc] init] autorelease];
	[FBSession setActiveSession:self.facebookSession];
	
	NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions", nil];
    return [FBSession openActiveSessionWithPermissions:permissions allowLoginUI:YES
									 completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                         [self facebookSessionStateChanged:session state:state error:error shareAutomatically:shareAutomatically];
                                     }];
}
- (BOOL)closeFacebookSession {
	[FBSession.activeSession close];
	return FBSession.activeSession.state == FBSessionStateClosed;
}
- (FBSessionState)facebookSessionState {
	return FBSession.activeSession.state;
}

/*
 * Callback for session changes.
 */
- (void)facebookSessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error shareAutomatically:(BOOL)shareAutomatically {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FBSessionStateChangedNotification object:session];
    switch (state) {
        case FBSessionStateOpen:
            if (!error && shareAutomatically) {
				[self shareByFacebook];
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
}
- (void)applicationWillTerminate {
	[self closeFacebookSession];
}
- (void)applicationDidBecomeActive {
	if (FBSession.activeSession.state == FBSessionStateCreatedOpening) {
		[self closeFacebookSession];
	}
}

#pragma mark - Print Controller display methods
- (void)showPrintControllerAnimated:(BOOL)animated completionHandler:(UIPrintInteractionCompletionHandler)completion {
	[[UIPrintInteractionController sharedPrintController] presentAnimated:animated completionHandler:completion];
}
- (void)showPrintControllerFromBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated completionHandler:(UIPrintInteractionCompletionHandler)completion {
	[[UIPrintInteractionController sharedPrintController] presentFromBarButtonItem:barButtonItem animated:animated completionHandler:completion];
}
- (void)showPrintControllerFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated completionHandler:(UIPrintInteractionCompletionHandler)completion {
	[[UIPrintInteractionController sharedPrintController] presentFromRect:rect inView:view animated:animated completionHandler:completion];
}
- (void)dismissPrintControllerAnimated:(BOOL)animated {
	[[UIPrintInteractionController sharedPrintController] dismissAnimated:animated];
}

#pragma mark - MFMailComposeViewControllerDelegate methods
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	if ([self.delegate respondsToSelector:@selector(sharingManager:mailComposeController:didFinishWithResult:error:)]) {
		[self.delegate sharingManager:self mailComposeController:controller didFinishWithResult:result error:error];
	}
}

#pragma mark - MFMessageComposeViewControllerDelegate methods
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	if ([self.delegate respondsToSelector:@selector(sharingManager:messageComposeController:didFinishWithResult:)]) {
		[self.delegate sharingManager:self messageComposeController:controller didFinishWithResult:result];
	}
}

#pragma mark - Twitter+OAuth
#pragma mark SA_OAuthTwitterEngineDelegate methods
- (void)storeCachedTwitterOAuthData:(NSString *)data forUsername:(NSString *)username {
	[[NSUserDefaults standardUserDefaults] setObject:data forKey:@"TWAuthData"];
	[[NSUserDefaults standardUserDefaults] synchronize];  
}
- (NSString *)cachedTwitterOAuthDataForUsername:(NSString *)username {
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"TWAuthData"];  
}
#pragma mark MGTwitterEngineDelegate methods
- (void)requestSucceeded:(NSString *)connectionIdentifier {
	[sharingManager_TweetComposeViewController performSelectorOnMainThread:@selector(showTweetSendingSuccessAndDismiss) withObject:nil waitUntilDone:NO];
	[sharingManager_TweetComposeViewController showTweetSendingSuccessAndDismiss];
}
- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
	[sharingManager_TweetComposeViewController performSelectorOnMainThread:@selector(showTweetSendingFailureAndDismiss) withObject:nil waitUntilDone:NO];
}
#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	[self sendTwitterUpdate];
}
- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {}
- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {}
#pragma mark - SharingManager_TweetComposeViewControllerDelegate methods
- (void)sharingManager_TweetComposeViewController:(SharingManager_TweetComposeViewController *)sharingManager_TweetComposeViewController didFinishTypingTweet:(NSString *)tweet {
	[twitterEngine sendUpdate:tweet];
}

@end