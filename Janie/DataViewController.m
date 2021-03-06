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
#import "ModelController.h"
#import "RootViewController.h"
#import "HotAction.h"
#import "PercentageRect.h"

@interface DataViewController ()

@end

@implementation DataViewController {
    // here is where the class can declare private ivars which are not visible to consumers of this class
    NSMutableAttributedString *originalAttributedString;
    NSArray *bounceTimes;
    NSInteger bouncePointer;
    NSTimeInterval bounceStartTime;
    NSTimer *bounceTimer;
    BOOL overrideAudio;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(autoPlayNotification:) name:@"AutoPlay" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playMusicNotification:) name:@"ReadOrPlayMusic" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(whichLanguageNotification:) name:@"WhichLanguage" object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotTap:)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.spanishTextView addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
    tap.numberOfTapsRequired = 2;
    tap.delegate = self;
    // HERE
    [self.view addGestureRecognizer:tap];
    
    
    
//    SEL example = NSSelectorFromString(@"runOptions:");
//    if (self.dataObject.initialAction == example)
//        [self runOptions:self.dataObject];
    
    if (self.dataObject.initialAction) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:self.dataObject.initialAction withObject:self.dataObject];
#pragma clang diagnostic pop
    
   }
}

// NSNotificationCenter lets objects that know nothing about
// each other to talk to each other - these are posted from
// the BookOptionsViewController

- (void)autoPlayNotification:(NSNotification *)note {
//    [self startOrStopAutoPlay:[[NSUserDefaults standardUserDefaults] boolForKey:@"AutoPlay"]];
}

- (void)startOrStopAutoPlay:(BOOL)start {
    if (start) {
        [self turnThePageProgrammatically:self];
    } else {
        
    }

}


- (void)whichLanguageNotification:(NSNotification *)note {
    NSInteger which = [[NSUserDefaults standardUserDefaults] integerForKey:@"WhichLanguage"];
    
    if (which == 0) {
        
    } else if (which == 1) {
        
    } else {
        
    }

    [self coreSetupText];
    if (!AUDIO_IS_SUNG) [self playNextSound:nil];

}

- (void)playMusicNotification:(NSNotification *)note {
    if (AUDIO_IS_SUNG) {
        [APP_DELEGATE stopAndClearSound];
    }
    // else [self playNextSound:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableAttributedString *)stringForText:(NSString *)s isSpanish:(BOOL)isSpanish {
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
    
    return [[NSMutableAttributedString alloc] initWithString:s attributes:dict];
}


- (void)timerNextLoop:(NSTimer *)timer {
    [self nextLoop:[timer userInfo]];
}

- (void)nextLoop:(UITextView *)textView {
    bouncePointer++;
    if (bouncePointer < bounceTimes.count) {
        NSDictionary *info = bounceTimes[bouncePointer];
        NSTimeInterval endTime = [[info valueForKey:@"endTime"] doubleValue];
        NSTimeInterval elapsed = CFAbsoluteTimeGetCurrent() - bounceStartTime;
        NSTimeInterval duration = endTime - elapsed;
        NSRange range = NSMakeRange([(NSNumber *)[info valueForKey:@"start"] integerValue],
                                                  [(NSNumber *)[info valueForKey:@"length"] integerValue]);
        NSMutableAttributedString *newString = [[NSMutableAttributedString  alloc] initWithAttributedString:originalAttributedString];
        
        // now add whatever attributes you like to our range:
//        [newString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleThick] range:range];
//        [newString addAttribute:NSUnderlineColorAttributeName value:[UIColor redColor] range:range];
        
        //[newString addAttribute:NSExpansionAttributeName value:[NSNumber numberWithDouble:log(1.1)] range:range];
        
        if (NSMaxRange(range) <= newString.length) {
            [newString addAttribute:NSFontAttributeName value:self.dataObject.boldFont range:range];
        } // else NSLog(@"range overrun: %@",newString);
        
        textView.attributedText = newString;
        
        // now make a callback at then end of our time:
        bounceTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(timerNextLoop:) userInfo:textView repeats:NO];
                                                  
    } else textView.attributedText = originalAttributedString;

}



- (void)bounceText {
    [self bounceText:YES];
}


- (NSDictionary *)valuesForBouncing:(BOOL)sung {
    NSInteger which = [[NSUserDefaults standardUserDefaults] integerForKey:@"WhichLanguage"];
    UITextView *textView = nil;
    NSAttributedString *string = nil;
    NSArray *bounces = nil;
    
    if (which == 1) {
        string = [self stringForText:self.dataObject.spanish isSpanish:YES];
        textView = self.spanishTextView;
        bounces = sung ? [ModelController sharedModelController].spanishSongList: self.dataObject.spanishWordList;
    } else if (which == 2) {
        string = [self stringForText:self.dataObject.english isSpanish:NO];
        textView = self.spanishTextView;
        bounces = sung ? [ModelController sharedModelController].englishSongList : self.dataObject.englishWordList;
    } else if (which == 0) {
        string = [self stringForText:self.dataObject.english isSpanish:NO];
        textView = self.englishTextView;
        bounces = sung ? [ModelController sharedModelController].englishSongList : self.dataObject.englishWordList;
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:textView,@"textView", string,@"string",bounces,@"bounceTimes", nil];
}


- (void)bounceText:(BOOL)stopBounce {
        
    if (stopBounce) [self stopBounce];
    
    NSDictionary *d = [self valuesForBouncing:NO];
    UITextView *textView = [d valueForKey:@"textView"];
    
    if (stopBounce) {
        bounceTimes = nil;
        bouncePointer = -1;
        bounceStartTime = 0;
    }
    
    originalAttributedString = [d valueForKey:@"string"];
    bounceTimes = [d valueForKey:@"bounceTimes"];
    
    // does this page have a word list for the current language?
    if (bounceTimes.count) {
        if (stopBounce || bounceStartTime == 0)
            bounceStartTime = CFAbsoluteTimeGetCurrent();
        [self nextLoop:textView];
    }

}
- (void)coreSetupText {
    self.englishTextView.font = [self.dataObject textFont];
    self.spanishTextView.font = [self.dataObject textFont];
    
    NSInteger which = [[NSUserDefaults standardUserDefaults] integerForKey:@"WhichLanguage"];
    if (which == 0) {
        self.englishTextView.attributedText = [self stringForText:self.dataObject.english isSpanish:NO];
        self.spanishTextView.attributedText = [self stringForText:self.dataObject.spanish isSpanish:YES];
    } else {
        NSString *text = which == 1 ? self.dataObject.spanish :  self.dataObject.english;
        self.spanishTextView.attributedText = [self stringForText:text isSpanish:which == 1];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.dataObject.imageFullPage) {
        // HERE THIS IS NOT FOR PAN ZOOM BUT FOR SHOWING PAGES 1 and 2:
        [[[(UIImageView *)self.view subviews] objectAtIndex:0] setHidden:YES];
        [(UIImageView *)self.view setContentMode:UIViewContentModeScaleAspectFit];
        [(UIImageView *)self.view setImage:[self.dataObject pageImage]];
        self.imageView.hidden = YES;
        self.dataLabel.hidden = YES;
    } else {
        self.imageView.image = [self.dataObject pageImage];
        self.dataLabel.text =
        [NSString stringWithFormat:@"%lu", (unsigned long)([[ModelController sharedModelController]indexOfViewController:self] - 1)];
        [self coreSetupText];
    }
}




- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSUInteger pageIndex = [[ModelController sharedModelController]indexOfViewController:self];
    BOOL isDedicationPage = pageIndex == 1;
    BOOL isFinalPage = (pageIndex == [[ModelController sharedModelController]numberOfPages] - 1);
    if (!((pageIndex == 0|| isDedicationPage || isFinalPage) && AUDIO_IS_SUNG))
        [self playNextSound:nil];
    else if (isDedicationPage || isFinalPage) {
        [[ModelController sharedModelController] stopBounce];
        [APP_DELEGATE stopAndClearSound];
    } else if (AUDIO_IS_SUNG && [AUDIO_CONTROLLER isPlaying]) {
        self.playPauseButton.selected = YES;
    }
    
    self.playPauseButton.hidden = NO_AUDIO;
    self.playContainerView.hidden = NO;
    // Here we add the special hot actions
    for (HotAction *hotty in self.dataObject.hotRects) {
        [hotty setFrame:[hotty desiredRectInView:self.imageView maintainsAspect:YES]];
        [hotty setTarget:self];
        [self.imageView addSubview:hotty];
    }
}


#define dDeviceOrientation [[UIDevice currentDevice] orientation]
#define isPortrait  UIDeviceOrientationIsPortrait(dDeviceOrientation)
#define isLandscape UIDeviceOrientationIsLandscape(dDeviceOrientation)

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.fullScreen){
        CGSize size = self.fullImageView.image.size;
        CGRect rect = self.view.bounds;
        CGRect br = self.nextPageButton.frame;
        self.fullImageScrollView.frame = rect;
        self.fullImageScrollView.contentSize=size;
        br.origin.x = rect.size.width - br.size.width;
        br.origin.y = rect.size.height/2.0;
        self.nextPageButton.frame = br;
//        self.fullImageView.frame = CGRectMake(0.0,0.0,size.width,size.height);
    }


//    CGRect screen = [[UIScreen mainScreen] bounds];
//    float height = screen.size.height;
//    float width = screen.size.width;
//    float screenRatio = width/height;
    
    CGRect vRect = self.containerView.bounds;
    CGRect iRect = self.imageView.frame;
    CGRect cRect = self.textViews.frame;
    CGRect pRect = self.playContainerView.frame;
    
    pRect.origin = CGPointMake(floor((vRect.size.width - pRect.size.width)/2.0), vRect.size.height - pRect.size.height);
    self.playContainerView.frame = pRect;
    
    self.dataLabel.font = [self.dataObject textFont];
    [self.dataLabel sizeToFit];
    CGRect lRext = self.dataLabel.frame;
    lRext.origin = CGPointMake(vRect.size.width - lRext.size.width - 8.0,vRect.size.height - lRext.size.height - 3.0);
    self.dataLabel.frame = lRext;

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
        // if it's a 5S, we need to tweak it more!
        if ([[UIScreen mainScreen] bounds].size.height <= 568.0)
            tweakTextViewHeight = MAX(tweakTextViewHeight, 14.0);
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
    // layout hot rects:
    // HERE
    UIImageView * currentImageView = self.fullScreen ? (UIImageView *)self.fullImageView : self.imageView;

    for (HotAction *hotty in self.dataObject.hotRects) {
        [hotty setFrame:[hotty desiredRectInView:currentImageView maintainsAspect:!self.fullScreen]];
    }
    
    self.textViews.frame = cRect;   // see if the items inside are right though!
// if only English or Spanish, then resize the Spanish to full size...
    NSInteger which = [[NSUserDefaults standardUserDefaults] integerForKey:@"WhichLanguage"];
    
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
- (void)stopBounce {
    if (AUDIO_IS_SUNG) {

    } else {
        if (bounceTimes) {
            [bounceTimer invalidate];
            bounceTimer = nil;
            bounceTimes = nil;
        }
    }
}

- (void)stopBounceInController:(DataViewController *)dvc {
    // restore text
    NSDictionary *d = [dvc valuesForBouncing:YES];
    UITextView *textView = [d valueForKey:@"textView"];
    [textView setAttributedText: [d valueForKey:@"string"]];
    [self stopBounce];
}

- (void)pauseBounceInController:(DataViewController *)dvc {
    // restore text
    NSDictionary *d = [dvc valuesForBouncing:YES];
    UITextView *textView = [d valueForKey:@"textView"];
    [textView setAttributedText: [d valueForKey:@"string"]];
    
    // leave pointers, but stop timer:
    [bounceTimer invalidate];
    bounceTimer = nil;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    AVAudioPlayer *player = AUDIO_CONTROLLER;
    BOOL shouldStop = self.dataObject.audioFiles.count > 0 && !self.dataObject.leaveSongRunning;
    if (player.isPlaying && shouldStop && !AUDIO_IS_SUNG) {
        [APP_DELEGATE stopAndClearSound];
    }
    [self stopBounce];
}
- (NSString *)nextSound {
    NSArray *sounds = [self.dataObject audioFiles];
    NSString * soundFile = nil;
    
    if (sounds.count == 2) {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"WhichLanguage"] == 1)
            soundFile = sounds[0];
        else soundFile = sounds[1];
    }
    return soundFile;

}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    self.playPauseButton.selected = NO;
;
    if (flag) {
        // we'll automatically turn the page if "AutoPlay" is On
        // of course, we automatically turn the page if Song is singing
        
        if (AUDIO_IS_READ && !self.wasPlayedByHiddenObject) {
            if (AUTO_PLAY)
                [self turnThePageProgrammatically:self];
        }
    }
    self.wasPlayedByHiddenObject = NO;

}

- (void)corePlay:(AVAudioPlayer *)player atTime:(NSTimeInterval)start {
    BOOL played = NO;
    
        [player prepareToPlay];
        player.currentTime = start;
        played = [player play];
    
   // if (!played) NSLog(@"Could not play atTime %f",start);
    self.playPauseButton.selected = YES;
}

- (void)corePlaySound:(NSString *)nextSound {
    [self corePlaySound:nextSound atTime:0.0f];
}

- (void)corePlaySound:(NSString *)nextSound atTime:(NSTimeInterval)start delegate:(id)del {
    NSString *soundFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:nextSound];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    NSError *e = NULL;
    AVAudioPlayer *player = AUDIO_CONTROLLER;
    
    if (player) {
        [APP_DELEGATE stopAndClearSound];
    }
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&e];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setAudioPlayer:player];
    player.delegate = del;
    
    [self corePlay:player atTime:start];
}

- (void)corePlaySound:(NSString *)nextSound atTime:(NSTimeInterval)start {
    [self corePlaySound:nextSound atTime:start delegate:(AUDIO_IS_SUNG) ? [ModelController sharedModelController] : self];
}

- (void)coreNextSound {
    NSString *nextSound = [self nextSound];
    if (nextSound) {
        [self corePlaySound:nextSound];
        [self bounceText];
    }
}

- (IBAction)playNextSound:(id)sender {
    if (AUDIO_IS_SUNG) {
        // we just leave it going if it's not there already
        AVAudioPlayer *player = AUDIO_CONTROLLER;
        
        // there will be no player if manually turned - find page!
        ModelController *mc = [ModelController sharedModelController];
        NSUInteger pageIndex = [mc indexOfViewController:self];
        NSTimeInterval time = [mc startTimeForPage:pageIndex];

        if (!player) {
            [self corePlaySound:[mc currentSong] atTime:time];
            if (time == 0.0f)
            [mc bounceTextWithController:self];
            else [mc updateBounceTextWithController:self];
        } else {
            [mc updateBounceTextWithController:self];
        }

    } else if (AUDIO_IS_READ || self.dataObject.playOnLoad || overrideAudio)
    {
        [self coreNextSound];
    } else {
        [APP_DELEGATE stopAndClearSound];
    }
}

- (IBAction)playPause:(id)sender {
    AVAudioPlayer *player = AUDIO_CONTROLLER;
    if (player.isPlaying) {
        [[self musicDelegate] pauseBounceInController:self];
        [player pause];
        self.playPauseButton.selected = NO;
    } else {
        if (player) {
            [player play]; // see docs on playAtTime:
            self.playPauseButton.selected = YES;
            [self bounceText:NO];
        } else [self coreNextSound];
    }
}

- (IBAction)justPause:(id)sender {

}

- (IBAction)restartFromBeginnning:(id)sender {
    AVAudioPlayer *player = AUDIO_CONTROLLER;
    
    if (player.isPlaying) {
        [[self musicDelegate] stopBounceInController:self];
        [APP_DELEGATE stopAndClearSound];
        player = nil;
    }
    
    [(RootViewController *)ROOT_VIEW_CONTROLLER goToSetUpPage];

//    if ([[ModelController sharedModelController] indexOfViewController:self] == 2)
//        [(RootViewController *)ROOT_VIEW_CONTROLLER goToSetUpPage];
//        else
//    [(RootViewController *)ROOT_VIEW_CONTROLLER goToFirstPage];
}


- (IBAction)restartAudio:(id)sender {
    AVAudioPlayer *player = AUDIO_CONTROLLER;
    NSTimeInterval time = 0.0f;
    
    if (player.isPlaying) {
        if (AUDIO_IS_SUNG)
            [[self musicDelegate] pauseBounceInController:self];
        else
            [[self musicDelegate] stopBounceInController:self];

        [APP_DELEGATE stopAndClearSound];
        player = nil;
        self.playPauseButton.selected = NO;
        return;
    }
    
    if (AUDIO_IS_SUNG) {
        ModelController *mc = [ModelController sharedModelController];
        NSUInteger pageIndex = [mc indexOfViewController:self];
        time = [mc startTimeForPage:pageIndex];

        [self corePlaySound:[mc currentSong] atTime:time];
        [[ModelController sharedModelController] restoreBounceInController:self];

    } else {
            [self coreNextSound];
    }
    
}


- (IBAction)swapLanguages:(id)sender {
    NSInteger which = [[NSUserDefaults standardUserDefaults] integerForKey:@"WhichLanguage"];
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
    CGRect viewRect = [self.view bounds];
    CGPoint pt = [tap locationInView:self.view];
    BOOL tooLow = viewRect.size.height - pt.y < 30.0;
    if (tap.state == UIGestureRecognizerStateBegan) {
        
    }
    if (tap.state == UIGestureRecognizerStateEnded) {
        if (!AUDIO_IS_SUNG && !tooLow)
            [self swapLanguages:self];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint pt = [gestureRecognizer locationInView:self.view];
    float ratio = pt.x/self.view.frame.size.width;
    BOOL dontDoIt =   (ratio < .2 || ratio > .8);
    
   // NSLog(@"shouldBegin: %@", NSStringFromClass([[gestureRecognizer view] class]));
    return !dontDoIt;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
   // NSLog(@"other gesture is %@:%@ and has delegate of %@",NSStringFromClass([[otherGestureRecognizer view]class]),otherGestureRecognizer,NSStringFromClass([[otherGestureRecognizer delegate]class]));
    return YES;
}

- (IBAction)runOptions:(id)sender {
    if (!self.optionsController) {
        self.optionsController = [[BookReadingOptionsViewController alloc] initWithNibName:nil bundle:nil];
    }
    CGRect r = self.view.bounds;
    CGRect or = self.optionsController.view.frame;
    or.origin.x = (r.size.width - or.size.width)/2.0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

    or.origin.y = or.size.height; // 0.0; //r.size.height - or.size.height;
    } else or.origin.y = 30.0;
    
    self.optionsController.view.frame = or;
    self.optionsController.myController = self;
    [self.view addSubview:self.optionsController.view];
    
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"SawHelp"]) {
              [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SawHelp"];
            [self performSelector:@selector(runOptionsHelpPanel:) withObject:self afterDelay:2.0];
            
              }
}


- (IBAction)runOptionsHelpPanel:(id)button {
    // a subpanel of BookReadingOptionsViewController, but we need to clean up
    // so we'll own it:
    if (!self.bookReadingHelpController) {
        self.bookReadingHelpController = [[BookReadingHelpViewController alloc] initWithNibName:nil bundle:nil];
    }
    CGRect r = self.view.bounds;
    CGRect or = self.bookReadingHelpController.view.frame;
    or.origin.x = (r.size.width - or.size.width)/2.0;
    or.origin.y = 32.0; // 0.0; //r.size.height - or.size.height;
    
    CGRect start = CGRectMake(0, 0, or.size.width, or.size.height);
    
    self.bookReadingHelpController.view.frame = start; // the right size
    CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    t = CGAffineTransformTranslate(t, -(4 * or.size.width), -(4 * or.size.height));

    self.bookReadingHelpController.view.transform = t;
   self.bookReadingHelpController.view.layer.cornerRadius = 10.0;
    self.bookReadingHelpController.view.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.bookReadingHelpController.view.layer.borderWidth = 2.0;
    self.bookReadingHelpController.myController = self;
    self.bookReadingHelpController.view.alpha = 0.0;
    [self.view addSubview:self.bookReadingHelpController.view];
    [UIView animateWithDuration:0.5 animations:^{
        self.bookReadingHelpController.view.transform = CGAffineTransformIdentity;
        self.bookReadingHelpController.view.frame = or;
        self.bookReadingHelpController.view.alpha = 1.0;
   } completion:^(BOOL finished) {
        ;
    }];
    
}
- (IBAction)removeHelpPanel:(id)sender {
    if (self.bookReadingHelpController) {
        CGRect r = self.bookReadingHelpController.view.frame;
        [UIView animateWithDuration:0.4 delay:0.01 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGAffineTransform t = CGAffineTransformMakeScale(0.1, 0.1);
            t = CGAffineTransformTranslate(t, -(4 * r.size.width), -(4 * r.size.height));
            self.bookReadingHelpController.view.transform = t;
            self.bookReadingHelpController.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.bookReadingHelpController.view removeFromSuperview];
            self.bookReadingHelpController = nil;
        }];
    }
}

- (IBAction)runISpyAction:(id)sender {
    if (!self.ispyController) {
        self.ispyController = [[ISpyWordsViewController alloc] initWithNibName:nil bundle:nil];
        self.ispyController.owner = self;
    }
    CGRect r = self.view.bounds;
 //   CGRect or = self.ispyController.view.frame;
//    or.origin.x = (r.size.width - or.size.width)/2.0;
//    or.origin.y = r.size.height - or.size.height;
    self.ispyController.view.frame = r;
    [self.view addSubview:self.ispyController.view];
}

- (UIImageView *)hotActionsParentView {
    // HERE

//    return self.fullScreen ? (UIImageView *)self.view : self.imageView;
    return self.fullScreen ? (UIImageView *)self.fullImageView : self.imageView;
}

- (NSArray *)hotActions {
    return self.dataObject.hotRects;
}

- (IBAction)imageViewTapped:(UITapGestureRecognizer *)sender {
    // we are either in the bigly state or the regular state
    if (sender.state == UIGestureRecognizerStateEnded) {
    for (HotAction *hotty in self.dataObject.hotRects) {
        [hotty removeFromSuperview];
    }
        UIImageView *previousImageView = [self hotActionsParentView];
        CGSize previousImageSize = previousImageView.bounds.size;
        CGPoint center = [sender locationInView:previousImageView];
        PercentageRect *centerAsPercent = [[PercentageRect alloc] initWithPercentageX:center.x/previousImageSize.width y:center.y/previousImageSize.height width:0.01 height:0.01];

    [UIView animateWithDuration:0.3 animations:^{
        if (self.fullScreen) {
            // HERE

            [(UIImageView *)self.fullImageView setImage:nil];
            self.containerView.alpha = 1.0;
            self.fullImageScrollView.alpha = 0.0;
        } else {
            UIImage *newImage = [self.imageView.image copy];
            CGSize size = [newImage size];
            CGRect rect = self.view.bounds;
            self.fullImageScrollView.hidden = 0;

            self.fullImageScrollView.frame = rect;
            self.fullImageScrollView.contentSize=size;

            [(UIImageView *)self.fullImageView setImage:newImage];
            self.fullImageScrollView.contentSize=size;
            self.fullImageView.frame = CGRectMake(0.0,0.0,size.width,size.height);
            self.fullImageView.userInteractionEnabled = YES;

            self.containerView.alpha = 0.0;
            self.fullImageScrollView.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
        self.fullScreen = !self.fullScreen;
        // HERE
        UIImageView * which = self.fullScreen ? (UIImageView *)self.fullImageView : self.imageView;
        if (!self.fullScreen)
            self.fullImageScrollView.hidden = 1;
        
        if (self.fullScreen) {
            // scroll to where the double tap was
            CGRect centerRect = [centerAsPercent rectInView:self.fullImageView maintainsAspect:YES];
            CGPoint center = centerRect.origin;
#define AROUND_CENTER 100
            centerRect = CGRectMake(center.x - AROUND_CENTER, center.y - AROUND_CENTER,
                                    AROUND_CENTER*2, AROUND_CENTER*2); // right around the tap
            [self.fullImageScrollView scrollRectToVisible:centerRect animated:NO];
        }
        for (HotAction *hotty in self.dataObject.hotRects) {
            [which addSubview:hotty];
            [hotty setFrame:[hotty desiredRectInView:which maintainsAspect:!self.fullScreen]];
        }

    }];
    }
}

- (IBAction)turnThePageProgrammatically:(id)sender {
    RootViewController *rootController =(RootViewController*)ROOT_VIEW_CONTROLLER;

    [rootController turnPageFrom:self];
}

- (id)musicDelegate {
    AVAudioPlayer *player = AUDIO_CONTROLLER;
    if (player) return player.delegate;
    if (AUDIO_IS_SUNG) return [ModelController sharedModelController];
    return self;
}

- (IBAction)defaultAction:(HotAction *)sender {
    //play something
    if (NO_AUDIO || !AUDIO_CONTROLLER || ![AUDIO_CONTROLLER isPlaying] ) {
        NSString *sound = [sender soundFile];
        [[self musicDelegate] stopBounceInController:self];
        self.wasPlayedByHiddenObject = YES;
        [self corePlaySound:sound atTime:0.0f delegate:self];
    }
}


@end
