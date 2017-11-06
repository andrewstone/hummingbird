//
//  BookReadingHelpViewController.m
//  Janie
//
//  Created by This One on 11/5/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import "BookReadingHelpViewController.h"
#import "DataViewController.h"


@interface BookReadingHelpViewController ()

@end

@implementation BookReadingHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneAction:(id)sender {
    [self.myController removeHelpPanel:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
