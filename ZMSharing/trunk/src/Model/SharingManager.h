//
//  SharingManager.h
//  Sharing
//
//  Created by Zouhair Mahieddine on 12/10/11.
//  Copyright 2011 Zedenem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SA_OAuthTwitterController.h"
#import "SA_OAuthTwitterEngine.h"

#import "SharingManager_MailObject.h"
#import "SharingManager_MessageObject.h"
#import "SharingManager_FacebookPostObject.h"
#import "SharingManager_TweetObject.h"

#import "SharingManager_TweetComposeViewController.h"

/** Notifications */
#define FBSessionStateChangedNotification @"com.example.Login:FBSessionStateChangedNotification"

typedef enum NSUInteger {
	SharingManagerNone		= 0,
	SharingManagerMail		= 1 << 0,
	SharingManagerSMS		= 1 << 1,
	SharingManagerMMS		= 1 << 2,
	SharingManagerPrint		= 1 << 3,
	SharingManagerTwitter	= 1 << 4,
	SharingManagerFacebook	= 1 << 5,
	SharingManagerGoogle	= 1 << 6,
}  SharingManagerSharingTools;

@protocol SharingManagerDelegate;

@interface SharingManager : NSObject <UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIPrintInteractionControllerDelegate, MGTwitterEngineDelegate, SA_OAuthTwitterEngineDelegate, SA_OAuthTwitterControllerDelegate, SharingManager_TweetComposeViewControllerDelegate> {
	id<SharingManagerDelegate> delegate;
	
	SharingManagerSharingTools enabledSharingTools:7;
	
	SA_OAuthTwitterEngine *twitterEngine;
	SharingManager_TweetComposeViewController *sharingManager_TweetComposeViewController;
}

@property (nonatomic, assign) id<SharingManagerDelegate> delegate;
@property SharingManagerSharingTools enabledSharingTools;

@property (retain, nonatomic) FBSession *facebookSession;

#pragma mark - Singleton access methods
+ (SharingManager *)sharedSharingManager;

#pragma mark - General Sharing Manager access methods
- (UIActionSheet *)sharingActionSheet;

#pragma mark - Sharing ActionSheet display methods
- (void)showSharingActionSheetFromTabBar:(UITabBar *)tabbar;
- (void)showSharingActionSheetFromToolbar:(UIToolbar *)toolbar;
- (void)showSharingActionSheetInView:(UIView *)view;
- (void)showSharingActionSheetFromBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated;
- (void)showSharingActionSheetFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;

#pragma mark - Is Sharing Enabled methods
- (BOOL)canShareByMail;
- (BOOL)canShareBySMS;
- (BOOL)canShareByMMS;
- (BOOL)canPrint;
- (BOOL)canShareByTwitter;
- (BOOL)canShareByFacebook;
- (BOOL)canShareByGoogle;

#pragma mark - Sharing methods
- (void)shareByMail;
- (void)shareBySMS;
- (void)print;
- (void)shareByFacebook;
- (void)shareByTwitter;
- (void)sendTwitterUpdate;

#pragma mark - Printing available for datas methods
- (BOOL)canPrintData:(NSData *)data;
- (BOOL)canPrintURL:(NSURL *)url;

#pragma mark - Facebook sharing specific methods
- (BOOL)handleOpenURL:(NSURL *)url;
- (BOOL)openFacebookSession;
- (BOOL)closeFacebookSession;
- (FBSessionState)facebookSessionState;

#pragma mark - Print Controller display methods
- (void)showPrintControllerAnimated:(BOOL)animated completionHandler:(UIPrintInteractionCompletionHandler)completion;
- (void)showPrintControllerFromBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated completionHandler:(UIPrintInteractionCompletionHandler)completion;
- (void)showPrintControllerFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated completionHandler:(UIPrintInteractionCompletionHandler)completion;
- (void)dismissPrintControllerAnimated:(BOOL)animated;

@end


@protocol SharingManagerDelegate <NSObject>

@optional
// Required to enable sharing by mail
- (void)sharingManager:(SharingManager *)sharingManager requiresInformationsToSendMail:(SharingManager_MailObject *)mailObject;
- (void)sharingManager:(SharingManager *)sharingManager needsToPresentMailComposeController:(MFMailComposeViewController *)mailComposeController;
- (void)sharingManager:(SharingManager *)sharingManager mailComposeController:(MFMailComposeViewController *)mailComposeController didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error;

// Required to enable sharing by sms
- (void)sharingManager:(SharingManager *)sharingManager requiresInformationsToSendMessage:(SharingManager_MessageObject *)messageObject;
- (void)sharingManager:(SharingManager *)sharingManager needsToPresentMessageComposeController:(MFMessageComposeViewController *)messageComposeController;
- (void)sharingManager:(SharingManager *)sharingManager messageComposeController:(MFMessageComposeViewController *)messageComposeController didFinishWithResult:(MessageComposeResult)result;

// Required to enable printing
- (NSArray *)sharingManagerRequiresItemsToPrint:(SharingManager *)sharingManager;
- (NSString *)sharingManagerRequiresPrintJobName:(SharingManager *)sharingManager;
- (void)sharingManagerNeedsToPresentPrintController:(SharingManager *)sharingManager;

// Required to enable sharing by facebook
- (void)sharingManager:(SharingManager *)sharingManager requiresInformationsToSendFacebookPost:(SharingManager_FacebookPostObject *)facebookPostObject;
- (void)sharingManager:(SharingManager *)sharingManager didFinishFacebookPostingWithError:(NSError *)error;

// Required to enable sharing by twitter
- (void)sharingManager:(SharingManager *)sharingManager requiresInformationsToSendTweet:(SharingManager_TweetObject *)tweetObject;
- (void)sharingManager:(SharingManager *)sharingManager needsToPresentTweetComposeController:(TWTweetComposeViewController *)tweetComposeController;
- (void)sharingManager:(SharingManager *)sharingManager twitterSharingDidFinishWithResult:(MessageComposeResult)result;

// Required to enable sharing by twitter on iOS < 5.0 devices
- (NSString *)sharingManagerRequiresTwitterConsumerKey:(SharingManager *)sharingManager;
- (NSString *)sharingManagerRequiresTwitterConsumerSecret:(SharingManager *)sharingManager;
- (void)sharingManager:(SharingManager *)sharingManager needsToPresentTwitterLoginController:(SA_OAuthTwitterController *)twitterLoginController;
- (void)sharingManager:(SharingManager *)sharingManager needsToPresentCustomTweetComposeController:(UINavigationController *)tweetComposeController;

@end