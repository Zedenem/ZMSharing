//
//  SharingManager_TweetComposeViewController.m
//  Sharing
//
//  Created by Zouhair Mahieddine on 20/10/11.
//  Copyright (c) 2011 Zedenem. All rights reserved.
//

#import "SharingManager_TweetComposeViewController.h"

@implementation SharingManager_TweetComposeViewController

@synthesize delegate;

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
	self.title = NSLocalizedStringFromTable(@"Sharing_Library_NEW_TWEET", @"Sharing_Library", @"");
	[self showCancelAndSendBarButtonItems];
	[tweetTextView becomeFirstResponder];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)setInitialText:(NSString *)initialText {
	if ([tweetTextView.text length] == 0) {
		tweetTextView.text = initialText;
		[tweetTextView.delegate textViewDidChange:tweetTextView];
	}
}
- (void)showLoadingLabelWithText:(NSString *)loadingLabelText andAnimateActivityIndicatorView:(BOOL)activityIndicatorViewAnimated {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	loadingLabel.text = loadingLabelText;
	if (activityIndicatorViewAnimated) {
		[loadingActivityIndicatorView startAnimating];
	}
	else {
		[loadingActivityIndicatorView stopAnimating];
	}
	tweetTextView.alpha = 0.0;
	[UIView commitAnimations];
}

- (void)showCancelAndSendBarButtonItems {
	UIBarButtonItem *sendBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Sharing_Library_SEND", @"Sharing_Library", @"") style:UIBarButtonItemStyleDone target:self action:@selector(sendTweet)];
	UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];

	[self.navigationItem setRightBarButtonItem:sendBarButtonItem animated:YES];
	[self.navigationItem setLeftBarButtonItem:cancelBarButtonItem animated:YES];
}

- (void)hideCancelAndSendBarButtonItems {
	[self.navigationItem setRightBarButtonItem:nil animated:YES];
	[self.navigationItem setLeftBarButtonItem:nil animated:YES];
}

- (void)dismiss {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)sendTweet {
	[tweetTextView resignFirstResponder];
	if ([self.delegate respondsToSelector:@selector(sharingManager_TweetComposeViewController:didFinishTypingTweet:)]) {
		[self.delegate sharingManager_TweetComposeViewController:self didFinishTypingTweet:tweetTextView.text];
		[self showLoadingLabelWithText:NSLocalizedStringFromTable(@"Sharing_Library_TWEET_SENDING", @"Sharing_Library", @"") andAnimateActivityIndicatorView:YES];
		[self hideCancelAndSendBarButtonItems];
	}
	else {
		[self showLoadingLabelWithText:NSLocalizedStringFromTable(@"Sharing_Library_TWEET_SENDING_ERROR_OCCURRED", @"Sharing_Library", @"") andAnimateActivityIndicatorView:NO];
		[self hideCancelAndSendBarButtonItems];
		[self performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
	}
}

#pragma mark - Management from SharingManager methods
- (void)showTweetSendingFailureAndDismiss {
	[self showLoadingLabelWithText:NSLocalizedStringFromTable(@"Sharing_Library_TWEET_SENDING_ERROR_OCCURRED", @"Sharing_Library", @"") andAnimateActivityIndicatorView:NO];
	[self hideCancelAndSendBarButtonItems];
	[self performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
}
- (void)showTweetSendingSuccessAndDismiss {
	[self showLoadingLabelWithText:NSLocalizedStringFromTable(@"Sharing_Library_TWEET_SENT", @"Sharing_Library", @"") andAnimateActivityIndicatorView:NO];
	[self hideCancelAndSendBarButtonItems];
	[self performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
}

#pragma mark - UITextViewDelegate methods
- (void)textViewDidChange:(UITextView *)textView {
	if ([textView.text length] == 0 || [textView.text length] > 140) {
		[self.navigationItem.rightBarButtonItem setEnabled:NO];
	}
	else {
		[self.navigationItem.rightBarButtonItem setEnabled:YES];
	}
}

#pragma mark - UIKeyboard Notifications methods
- (void)keyboardWillShow:(NSNotification *)notification {
	CGSize keyboardSize = [self.view convertRect:[[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue] fromView:nil].size;
	double keyboardAnimationDuration = [[[notification userInfo] objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
	UIViewAnimationCurve keyboardAnimationCurve = [[[notification userInfo] objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] intValue];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:keyboardAnimationDuration];
	[UIView setAnimationCurve:keyboardAnimationCurve];
	tweetTextView.frame = CGRectMake(tweetTextView.frame.origin.x, tweetTextView.frame.origin.y, tweetTextView.frame.size.width, self.view.frame.size.height - tweetTextView.frame.origin.y*2 - keyboardSize.height);
	[UIView commitAnimations];
}
- (void)keyboardWillHide:(NSNotification *)notification {
	double keyboardAnimationDuration = [[[notification userInfo] objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
	UIViewAnimationCurve keyboardAnimationCurve = [[[notification userInfo] objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] intValue];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:keyboardAnimationDuration];
	[UIView setAnimationCurve:keyboardAnimationCurve];
	tweetTextView.frame = CGRectMake(tweetTextView.frame.origin.x, tweetTextView.frame.origin.y, tweetTextView.frame.size.width, self.view.frame.size.height - tweetTextView.frame.origin.y*2);
	[UIView commitAnimations];
}

@end
