//
//  WebViewController.m
//  Janie
//
//  Created by This One on 8/4/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import "WebViewController.h"
#import "ISpyWordsViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://sethhoffmanmusic.com/janie-and-the-hummingbird"]]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (IBAction)doneAction:(id)sender {
    [self.owner doneAction:sender];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)contactAction:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *message = [[MFMailComposeViewController alloc] init];
        [message setMessageBody:@"My message here"  isHTML:NO];
        [message setToRecipients:[NSArray arrayWithObject:@"sethhoffmanmusic@gmail.com"]];
        [message setSubject:@"¡Hola Colibrí!"];
        message.mailComposeDelegate = self;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            message.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:message animated:YES completion:nil];

    } // else NSLog(@"cannot send mail");
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

@end
