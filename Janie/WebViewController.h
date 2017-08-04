//
//  WebViewController.h
//  Janie
//
//  Created by This One on 8/4/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@class ISpyWordsViewController;

@interface WebViewController : UIViewController <UIWebViewDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet ISpyWordsViewController *owner;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)doneAction:(id)sender;
- (IBAction)contactAction:(id)sender;



@end
