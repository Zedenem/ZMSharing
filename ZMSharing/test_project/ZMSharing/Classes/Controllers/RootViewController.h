//
//  RootViewController.h
//  Sharing
//
//  Created by Zouhair Mahieddine on 15/10/11.
//  Copyright (c) 2011 Zedenem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharingManager.h"

@interface RootViewController : UIViewController <SharingManagerDelegate>

- (IBAction)share:(id)sender;

@end
