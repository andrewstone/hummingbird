//
//  DataViewController.m
//  Janie
//
//  Created by This One on 3/3/17.
//  Copyright © 2017 This One. All rights reserved.
//
#import "DataViewController.h"
#import "PageData.h"
#import "AppDelegate.h"

@interface DataViewController ()

@end

@implementation DataViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotTap:)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.spanishTextView addGestureRecognizer:tap];
    if (self.dataObject.initialAction)
        [self performSelector:self.dataObject.initialAction withObject:self.dataObject];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSAttributedString *)stringForText:(NSString *)s isSpanish:(BOOL)isSpanish {
    if (!s) return nil;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.headIndent = 0; // <--- indention if you need it
    paragraphStyle.firstLineHeadIndent = 0;
    
    paragraphStyle.lineSpacing = self.dataObject.lineSpacing; // <--- magic line spacing here!
    paragraphStyle.paragraphSpacing = self.dataObject.lineSpacing; // <--- magic line spacing here!
    paragraphStyle.paragraphSpacingBefore = 0; // <--- magic line spacing here!
    paragraphStyle.alignment = isSpanish ? NSTextAlignmentLeft : NSTextAlignmentRight;
    
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"WhichLanguage"] > 0)
        paragraphStyle.alignment = NSTextAlignmentCenter;

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: paragraphStyle, NSParagraphStyleAttributeName, self.dataObject.textFont, NSFontAttributeName,nil];
    
    return [[NSAttributedString alloc] initWithString:s attributes:dict];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.dataObject.imageFullPage) {
        [[[(UIImageView *)self.view subviews] objectAtIndex:0] setHidden:YES];
        [(UIImageView *)self.view setContentMode:UIViewContentModeScaleAspectFit];
        [(UIImageView *)self.view setImage:[self.dataObject pageImage]];
        self.imageView.hidden = YES;
        self.dataLabel.hidden = YES;
    } else {
        self.imageView.image = [self.dataObject pageImage];
  //      self.dataLabel.text = [self.dataObject pageLabel];

        self.englishTextView.font = [self.dataObject textFont];
        self.spanishTextView.font = [self.dataObject textFont];

        int which = [[NSUserDefaults standardUserDefaults] integerForKey:@"WhichLanguage"];
        if (which == 0) {
        self.englishTextView.attributedText = [self stringForText:self.dataObject.english isSpanish:NO];
        self.spanishTextView.attributedText = [self stringForText:self.dataObject.spanish isSpanish:YES];
        } else {
            NSString *text = which == 1 ? self.dataObject.spanish :  self.dataObject.english;
            self.spanishTextView.attributedText = [self stringForText:text isSpanish:which == 1];
        }
    }
    // text could be stored as a dict that might have additional information
}




- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.dataObject.playOnLoad)
        [self playNextSound:nil];
}


#define dDeviceOrientation [[UIDevice currentDevice] orientation]
#define isPortrait  UIDeviceOrientationIsPortrait(dDeviceOrientation)
#define isLandscape UIDeviceOrientationIsLandscape(dDeviceOrientation)

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    


//    CGRect screen = [[UIScreen mainScreen] bounds];
//    float height = screen.size.height;
//    float width = screen.size.width;
//    float screenRatio = width/height;
    
    CGRect vRect = self.containerView.bounds;
    CGRect iRect = self.imageView.frame;
    CGRect cRect = self.textViews.frame;
    
    CGFloat tweakTextViewHeight  = self.dataObject.tweakTextViewHeight;
    CGFloat tweakTextViewCenter = self.dataObject.tweakTextViewCenter;
    
    iRect.size.width = vRect.size.width;
    cRect.size.width = vRect.size.width;
    
#define IPAD_RATIO_W_H    0.75
#define IPHONE_RATIO_W_H   0.75
#define TOP_TEXT_MARGIN  5.0

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // we are always laying out in portrait because in landscape, we show two pages at once!
        
        iRect.size.height = floor(vRect.size.height * IPAD_RATIO_W_H) - tweakTextViewHeight;
        cRect.origin.y = iRect.size.height + TOP_TEXT_MARGIN;
        cRect.size.height = vRect.size.height - (iRect.size.height + TOP_TEXT_MARGIN);
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // No Landscape support because it won't fit on iPhone
        iRect.size.height = floor(vRect.size.height * IPHONE_RATIO_W_H) - tweakTextViewHeight;
        cRect.origin.y = iRect.size.height;
        cRect.size.height = vRect.size.height - iRect.size.height;
    } else {
        // No WATCH or TV support! ;-)
    }
#define LEFT_SPANISH_MARGIN  4.0
#define RIGHT_ENGLISH_MARGIN 4.0
    
    self.imageView.frame = iRect;
    self.textViews.frame = cRect;   // see if the items inside are right though!
// if only English or Spanish, then resize the Spanish to full size...
    int which = [[NSUserDefaults standardUserDefaults] integerForKey:@"WhichLanguage"];
    
    CGRect eT = _englishTextView.frame;
    CGRect sT = _spanishTextView.frame;
    
    eT.size.height = cRect.size.height;
    sT.size.height = cRect.size.height;
    if (which == 0) {
        eT.size.width = floor(cRect.size.width/2.0) + tweakTextViewCenter;
        eT.origin = CGPointMake(cRect.size.width - eT.size.width - RIGHT_ENGLISH_MARGIN, 0.0);
        sT.size.width = cRect.size.width/2.0 - tweakTextViewCenter;
    } else {
        sT.size.width = cRect.size.width;
    }
    sT.origin = CGPointMake(LEFT_SPANISH_MARGIN,0.0);
    self.englishTextView.frame = eT;
    self.spanishTextView.frame = sT;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    AVAudioPlayer *player = [(AppDelegate *)[[UIApplication sharedApplication] delegate]audioPlayer];
    BOOL shouldStop = self.dataObject.audioFiles.count > 0 && !self.dataObject.leaveSongRunning;
    if (player.isPlaying && shouldStop) {
        [player stop];
        player = nil;
    }
}
- (NSString *)nextSound {
    static int whichSound = 0;
    NSArray *sounds = [self.dataObject audioFiles];
    NSString * soundFile = sounds.count > whichSound ? sounds[whichSound] : nil;
    
    if (soundFile == nil && sounds.count == 1) {
        whichSound = 0; // reset to first
        return sounds[whichSound];
    } else whichSound++;
    
    if (sounds.count == 2) {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"WhichLanguage"] == 1)
            soundFile = sounds[0];
        else soundFile = sounds[1];
    }
    return soundFile;

}

- (IBAction)playNextSound:(id)sender {
    NSString *nextSound = [self nextSound];
    if (nextSound) {
        NSString *soundFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:nextSound];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        NSError *e = NULL;
        AVAudioPlayer *player = [(AppDelegate *)[[UIApplication sharedApplication] delegate]audioPlayer];
        
        if (player) {
            [player stop];
            player = nil;
        }

        player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&e];
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] setAudioPlayer:player];
        
        [player play];
    }

}

- (IBAction)pauseOrRestart:(id)sender {
    AVAudioPlayer *player = [(AppDelegate *)[[UIApplication sharedApplication] delegate]audioPlayer];
    if (player.isPlaying) [player pause];
    else [player play];
}

- (IBAction)swapLanguages:(id)sender {
    int which = [[NSUserDefaults standardUserDefaults] integerForKey:@"WhichLanguage"];
    which = which == 1 ? 2 : 1;
    [[NSUserDefaults standardUserDefaults] setInteger:which forKey:@"WhichLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *text = which == 1 ? self.dataObject.spanish :  self.dataObject.english;
    self.spanishTextView.attributedText = [self stringForText:text isSpanish:which == 1];
    [self playNextSound:self];
}

- (void)gotTap:(UITapGestureRecognizer *)tap {
//    CGPoint pt = [tap locationInView:self.view];
//    float ratio = pt.x/self.view.size.width;
//    if (ratio < .2 || ratio > .8) {
//        // we fail it
//        
//    }

    if (tap.state == UIGestureRecognizerStateBegan) {
        
    }
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self swapLanguages:self];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint pt = [gestureRecognizer locationInView:self.view];
    float ratio = pt.x/self.view.frame.size.width;
    BOOL dontDoIt =   (ratio < .2 || ratio > .8);
    return !dontDoIt;
}

- (IBAction)runOptions:(id)sender {
    if (!self.optionsController) {
        self.optionsController = [[BookReadingOptionsViewController alloc] initWithNibName:nil bundle:nil];
    }
    CGRect r = self.view.bounds;
    CGRect or = self.optionsController.view.frame;
    or.origin.x = (r.size.width - or.size.width)/2.0;
    or.origin.y = r.size.height - or.size.height;
    self.optionsController.view.frame = or;
    [self.view addSubview:self.optionsController.view];
}
@end
