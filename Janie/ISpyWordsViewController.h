//
//  ISpyWordsViewController.h
//  Janie
//
//  Created by This One on 7/31/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataViewController;

@interface ISpyWordsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *actionsTableView;
@property (weak, nonatomic) IBOutlet UIImageView *wordsImageView;
@property (weak, nonatomic) DataViewController *owner;

- (IBAction)doneAction:(id)sender;


@end
