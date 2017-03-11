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

        self.englishTextView.attributedText = [self stringForText:self.dataObject.english isSpanish:NO];
        self.spanishTextView.attributedText = [self stringForText:self.dataObject.spanish isSpanish:YES];
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
    CGRect eT = _englishTextView.frame;
    CGRect sT = _spanishTextView.frame;
    eT.size.height = cRect.size.height;
    eT.size.width = floor(cRect.size.width/2.0) + tweakTextViewCenter;
    eT.origin = CGPointMake(cRect.size.width - eT.size.width - RIGHT_ENGLISH_MARGIN, 0);
    sT.size.height = cRect.size.height;
    sT.size.width = cRect.size.width/2.0 - tweakTextViewCenter;
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

@end
