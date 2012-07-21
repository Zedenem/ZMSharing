//
//  SharingManager_TweetComposeViewController.h
//  Sharing
//
//  Created by Zouhair Mahieddine on 20/10/11.
//  Copyright (c) 2011 Zedenem. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SharingManager_TweetComposeViewControllerDelegate;

@interface SharingManager_TweetComposeViewController : UIViewController {
	id<SharingManager_TweetComposeViewControllerDelegate> delegate;
	
	IBOutlet UITextView *tweetTextView;
	
	IBOutlet UILabel *loadingLabel;
	IBOutlet UIActivityIndicatorView *loadingActivityIndicatorView;
}

@property (nonatomic, assign) id<SharingManager_TweetComposeViewControllerDelegate> delegate;

- (void)setInitialText:(NSString *)initialText;
- (void)showLoadingLabelWithText:(NSString *)loadingLabelText andAnimateActivityIndicatorView:(BOOL)activityIndicatorViewAnimated;

- (void)showCancelAndSendBarButtonItems;
- (void)hideCancelAndSendBarButtonItems;

- (void)dismiss;

#pragma mark - Management from SharingManager methods
- (void)showTweetSendingFailureAndDismiss;
- (void)showTweetSendingSuccessAndDismiss;

@end


@protocol SharingManager_TweetComposeViewControllerDelegate <NSObject>

- (void)sharingManager_TweetComposeViewController:(SharingManager_TweetComposeViewController *)sharingManager_TweetComposeViewController didFinishTypingTweet:(NSString *)tweet;

@end