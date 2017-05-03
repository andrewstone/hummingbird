//
//  DataViewController.h
//  Janie
//
//  Created by This One on 3/3/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "PageData.h"
#import "BookReadingOptionsViewController.h"


@interface DataViewController : UIViewController <AVAudioPlayerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *englishTextView;
@property (strong, nonatomic) IBOutlet UITextView *spanishTextView;
@property (strong, nonatomic) IBOutlet UIView *textViews;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *playContainerView;
@property (strong, nonatomic) IBOutlet UIButton *playPauseButton;
@property (strong, nonatomic) PageData *dataObject;
@property (strong, nonatomic) BookReadingOptionsViewController* optionsController;
@property (nonatomic) BOOL fullScreen;

- (IBAction)playNextSound:(id)sender; // if just 1, just that gets played, otherwise loops through array
- (IBAction)playPause:(id)sender;
- (IBAction)restartAudio:(id)sender;
- (IBAction)swapLanguages:(id)sender;
- (IBAction)imageViewTapped:(id)sender;
- (IBAction)turnThePageProgrammatically:(id)sender;

 // the default action of HotAction tap:
- (IBAction)defaultAction:(id)sender;
 // if you add more in PageData.plist, add them here too:

@end

