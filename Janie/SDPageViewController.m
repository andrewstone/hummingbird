//
//  SDPageViewController.m
//  Janie
//
//  Created by This One on 7/31/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import "SDPageViewController.h"
#import "HotAction.h"
#import "AppDelegate.h"
#import "DataViewController.h"

@interface UIPageViewController(mio)
- (BOOL)_shouldNavigateInDirection:(long long *)arg1 inResponseToTapGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

@end

@interface SDPageViewController ()
- (BOOL)_shouldNavigateInDirection:(long long *)arg1 inResponseToTapGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

@end

@implementation SDPageViewController

- (BOOL)_shouldNavigateInDirection:(long long *)arg1 inResponseToTapGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    BOOL result = [super _shouldNavigateInDirection:arg1 inResponseToTapGestureRecognizer:otherGestureRecognizer];

    /* this may be needed to get it to fly in store:
    NSString *s = [NSString stringWithFormat:@"%c%@%@%@",'_',@"shouldNavigateInDirection",@":",@"inResponseToTapGestureRecognizer:"];
    id result = [super performSelector:NSSelectorFromString(s) withObject:(id)arg1 withObject:otherGestureRecognizer];
    */
    
    // if the tap is over a hidden object - quickly ignore
    DataViewController *dvc = [[self viewControllers] objectAtIndex:0];
    NSArray *hotties = [dvc hotActions];
    CGPoint pt = [otherGestureRecognizer locationInView:[dvc hotActionsParentView]];
    
    for (NSUInteger i = 0; i < hotties.count; i++) {
        HotAction *hot = hotties[i];
        CGRect f = [hot frame];
        if (CGRectContainsPoint(f, pt)) {
            return NO;
        }
    }
                  
    return result > 0;
}

/*
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL result = YES;
    
    if ([[otherGestureRecognizer view] isKindOfClass:[HotAction class]]) {
        return NO;
    }
    return result;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer  {
    if ([[otherGestureRecognizer view] isKindOfClass:[HotAction class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([[otherGestureRecognizer view] isKindOfClass:[HotAction class]]) {
        return YES;
    }
    return NO;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
