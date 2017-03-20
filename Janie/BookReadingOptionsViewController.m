//
//  BookReadingOptionsViewController.m
//  Janie
//
//  Created by This One on 3/19/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import "BookReadingOptionsViewController.h"

@interface BookReadingOptionsViewController ()

@end

@implementation BookReadingOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
- (IBAction)changePlayMusicAction:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"PlayMusic"];
    [[NSUserDefaults standardUserDefaults] synchronize];    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayMusic" object:self];

}

- (IBAction)changeAutoPlayAction:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"AutoPlay"];
    [[NSUserDefaults standardUserDefaults] synchronize];    [[NSNotificationCenter defaultCenter] postNotificationName:@"AutoPlay" object:self];

}
@end
