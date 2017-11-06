//
//  BookReadingOptionsViewController.m
//  Janie
//
//  Created by This One on 3/19/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import "BookReadingOptionsViewController.h"
#import "DataViewController.h"
@interface BookReadingOptionsViewController ()

@end

@implementation BookReadingOptionsViewController

- (IBAction)runHelpAction:(UIButton *)sender {
    [self.myController runOptionsHelpPanel:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.autoPlaySwitch.on = [ud boolForKey:@"AutoPlay"];
    self.languageController.selectedSegmentIndex = [ud integerForKey:@"WhichLanguage"];
    
    NSUInteger which =[ud integerForKey:@"ReadOrPlayMusic"];
    
    self.playAudioSegmentedController.selectedSegmentIndex = which;
    
        _autoPlayContainer.alpha = (which == 1 ? 1.0 : 0.0);

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeLanguageAction:(UISegmentedControl *)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:[sender selectedSegmentIndex] forKey:@"WhichLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WhichLanguage" object:self];
}
- (IBAction)changePlayMusicAction:(UISegmentedControl *)sender {
    
    NSUInteger which = sender.selectedSegmentIndex;
    [[NSUserDefaults standardUserDefaults] setInteger:which forKey:@"ReadOrPlayMusic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [UIView animateWithDuration:0.3 animations:^{
        _autoPlayContainer.alpha = (which == 1 ? 1.0 : 0.0);
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReadOrPlayMusic" object:self];

}

- (IBAction)changeAutoPlayAction:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"AutoPlay"];
    [[NSUserDefaults standardUserDefaults] synchronize];    [[NSNotificationCenter defaultCenter] postNotificationName:@"AutoPlay" object:sender];

}
@end
