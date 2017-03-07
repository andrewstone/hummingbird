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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.imageView.image = [self.dataObject pageImage];
    self.dataLabel.text = [self.dataObject pageLabel];
    
    self.englishTextView.text = [self.dataObject english];
    self.spanishTextView.text = [self.dataObject spanish];
    
    // text could be stored as a dict that might have additional information
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.dataObject.playOnLoad)
        [self playNextSound:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.dataObject.imageFullPage) {
        CGRect r = self.imageView.frame;
        CGRect vr = self.view.frame;
        vr.origin = CGPointZero;
        self.imageView.frame = vr;
        [self.view bringSubviewToFront:self.imageView];
    }
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
