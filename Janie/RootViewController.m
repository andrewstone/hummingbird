//
//  RootViewController.m
//  Janie
//
//  Created by This One on 3/3/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import "RootViewController.h"
#import "ModelController.h"
#import "DataViewController.h"
#import "SDPageViewController.h"
#import "AppDelegate.h"

@interface RootViewController ()

@property (readonly, strong, nonatomic) ModelController *modelController;
@end

@implementation RootViewController {
    int _ManualTransition;
}

@synthesize modelController = _modelController;
- (BOOL)prefersStatusBarHidden { return YES; }

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[SDPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;

    DataViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    self.pageViewController.dataSource = self.modelController;

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];

    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0);
    }
    self.pageViewController.view.frame = pageViewRect;

    [self.pageViewController didMoveToParentViewController:self];
}

- (DataViewController *)turnPageFrom:(DataViewController *)dvc; {
    ModelController *model = [ModelController sharedModelController];
    DataViewController *nextDVC = (DataViewController *)[model pageViewController:self.pageViewController viewControllerAfterViewController:dvc];
    if (nextDVC) {
        [self.pageViewController setViewControllers:@[nextDVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    return nextDVC;

}

- (DataViewController *)goToPageWithDataViewController:(DataViewController *)nextDVC {
    if (nextDVC) {
        [self.pageViewController setViewControllers:@[nextDVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
    return nextDVC;
}

- (DataViewController *)goToFirstPage {
#define FIRST_REAL_PAGE_INDEX   2
    ModelController *model = [ModelController sharedModelController];
    DataViewController *dvc = [model viewControllerAtIndex:FIRST_REAL_PAGE_INDEX storyboard:self.storyboard];
    
    return [self goToPageWithDataViewController:dvc];
}
- (DataViewController *)goToSetUpPage {
#define SETUP_PAGE_INDEX   1
    ModelController *model = [ModelController sharedModelController];
    DataViewController *dvc = [model viewControllerAtIndex:SETUP_PAGE_INDEX storyboard:self.storyboard];
    
    return [self goToPageWithDataViewController:dvc];
}

- (DataViewController *)nextPage {
    NSArray *vcs = self.pageViewController.viewControllers;
    return [self turnPageFrom:[vcs lastObject]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (ModelController *)modelController {
    // Return the model controller object, creating it if necessary.
    // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [ModelController sharedModelController];
    }
    return _modelController;
}


#pragma mark - UIPageViewController delegate methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (UIInterfaceOrientationIsPortrait(orientation) || ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
        // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
        
        UIViewController *currentViewController = self.pageViewController.viewControllers[0];
        NSArray *viewControllers = @[currentViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        self.pageViewController.doubleSided = NO;
        return UIPageViewControllerSpineLocationMin;
    }

    // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
    DataViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = nil;

    NSUInteger indexOfCurrentViewController = [self.modelController indexOfViewController:currentViewController];
    if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
        UIViewController *nextViewController = [self.modelController pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
        viewControllers = @[currentViewController, nextViewController];
    } else {
        UIViewController *previousViewController = [self.modelController pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
        viewControllers = @[previousViewController, currentViewController];
    }
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];


    return UIPageViewControllerSpineLocationMid;
}

- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers;
{
    // NSLog(@"willTransitionToViewControllers");
    // a manual transition
    if (AUDIO_IS_SUNG && AUDIO_CONTROLLER) {
        DataViewController *currentViewController = self.pageViewController.viewControllers[0];
        [APP_DELEGATE stopAndClearSound];

        [[ModelController sharedModelController] pauseBounceInController:currentViewController];
        
        _ManualTransition = 1;
        
//        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"ReadOrPlayMusic"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    if (completed) {
    //NSLog(@"_ManualTransition = %d",_ManualTransition);
        if (_ManualTransition == 1) {
            // start up Bounce and
            [[ModelController sharedModelController] restoreBounceInController:(DataViewController *)[[pageViewController viewControllers]objectAtIndex:0]];

        }
    }
    
    _ManualTransition = 0;
//    else NSLog(@"did not TRANSITION");

}

@end
