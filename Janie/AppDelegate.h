//
//  AppDelegate.h
//  Janie
//
//  Created by This One on 3/3/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVAudioPlayer, RootViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)  AVAudioPlayer *audioPlayer;

- (void)stopAndClearSound;

#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define ROOT_VIEW_CONTROLLER [[APP_DELEGATE window] rootViewController]
#define AUDIO_CONTROLLER [APP_DELEGATE audioPlayer]

#define NO_AUDIO ([[NSUserDefaults standardUserDefaults] integerForKey:@"ReadOrPlayMusic"] == 0)
#define AUDIO_IS_SUNG ([[NSUserDefaults standardUserDefaults] integerForKey:@"ReadOrPlayMusic"] == 2)
#define AUDIO_IS_READ ([[NSUserDefaults standardUserDefaults] integerForKey:@"ReadOrPlayMusic"] == 1)

#define AUTO_PLAY (AUDIO_IS_READ && [[NSUserDefaults standardUserDefaults] boolForKey:@"AutoPlay"])
@end

