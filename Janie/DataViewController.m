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

- (NSAttributedString *)stringForText:(NSString *)s {
    if (!s) return nil;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // paragraphStyle.headIndent = 15; // <--- indention if you need it
    paragraphStyle.firstLineHeadIndent = 15;
    
    paragraphStyle.lineSpacing = self.dataObject.lineSpacing; // <--- magic line spacing here!

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:NSParagraphStyleAttributeName, paragraphStyle, NSFontAttributeName, self.dataObject.textFont,nil];
    
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

        self.englishTextView.attributedText = [self stringForText:[self.dataObject english]];
        self.spanishTextView.attributedText = [self stringForText:[self.dataObject spanish]];
    }
    // text could be stored as a dict that might have additional information
}




- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.dataObject.playOnLoad)
        [self playNextSound:nil];
}

//- (void)viewDidLayoutSubviews {
////    [super viewDidLayoutSubviews];
////    if (self.dataObject.imageFullPage) {
////        CGRect r = self.imageView.frame;
////        CGRect vr = self.view.frame;
////        vr.origin = CGPointZero;
////        self.imageView.frame = vr;
////        [self.view bringSubviewToFront:self.imageView];
////    }
//}

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
