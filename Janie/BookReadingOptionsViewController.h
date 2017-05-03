//
//  BookReadingOptionsViewController.h
//  Janie
//
//  Created by This One on 3/19/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookReadingOptionsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *playAudioSegmentedController;
@property (weak, nonatomic) IBOutlet UISwitch *autoPlaySwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *languageController;

- (IBAction)changePlayMusicAction:(UISegmentedControl *)sender;
- (IBAction)changeAutoPlayAction:(UISwitch *)sender;
- (IBAction)changeLanguageAction:(UISegmentedControl *)sender;


@end
