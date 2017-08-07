//
//  RootViewController.h
//  Janie
//
//  Created by This One on 3/3/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataViewController, SDPageViewController;

@interface RootViewController : UIViewController <UIPageViewControllerDelegate>

@property (strong, nonatomic) SDPageViewController *pageViewController;

- (DataViewController *)turnPageFrom:(DataViewController *)dvc;
- (DataViewController *)nextPage;
- (DataViewController *)goToFirstPage;


@end

