//
//  ModelController.m
//  Janie
//
//  Created by This One on 3/3/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import "ModelController.h"
#import "DataViewController.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "PageData.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


@interface ModelController ()

@property (readonly, strong, nonatomic) NSArray *pageData;
@end

@implementation ModelController {
    NSMutableAttributedString *originalAttributedString;
    NSArray *bounceTimes;
    NSInteger bouncePointer;
    NSTimeInterval bounceStartTime;
    NSTimer *bounceTimer;
    UITextView *currentTextView;
    DataViewController *currentController;
    NSArray *englishStartTimes;
    NSArray *spanishStartTimes;
    NSArray *englishStartBounce;
    NSArray *spanishStartBounce;
}


static ModelController *sharedModel = nil;

+ (ModelController *)sharedModelController {
    if (!sharedModel) sharedModel = [[ModelController alloc] init];
    return sharedModel;
}

- (NSUInteger)numberOfPages {
    return _pageData.count;
}

- (NSArray *)englishSongList {
    return [_globals valueForKey:@"englishSongList"];
}

- (NSArray *)spanishSongList {
    return [_globals valueForKey:@"spanishSongList"];
}

- (NSString *)spanishSong {
    return [[_globals valueForKey:@"audioFileNamesSongs"] objectAtIndex:0];
}

- (NSString *)englishSong {
    return [[_globals valueForKey:@"audioFileNamesSongs"] objectAtIndex:1];
}

- (NSString *)currentSong {
    NSInteger which = [[NSUserDefaults standardUserDefaults] integerForKey:@"WhichLanguage"];
    if (which == 1) return [self spanishSong];
    else return [self englishSong];
}

- (NSArray *)currentSongList {
    NSInteger which = [[NSUserDefaults standardUserDefaults] integerForKey:@"WhichLanguage"];
    if (which == 1) return [self spanishSongList];
    else return [self englishSongList];
}

- (NSArray *)currentStartTimes {
    NSInteger which = [[NSUserDefaults standardUserDefaults] integerForKey:@"WhichLanguage"];
    if (which == 1) return spanishStartTimes;
    else return englishStartTimes;
}

- (NSArray *)currentStartBouncePointers {
    NSInteger which = [[NSUserDefaults standardUserDefaults] integerForKey:@"WhichLanguage"];
    if (which == 1) return spanishStartBounce;
    else return englishStartBounce;
}

- (NSArray *)getPageData {
    NSMutableArray *a = [NSMutableArray array];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PageData" ofType:@"plist"];
    NSData *d = [NSData dataWithContentsOfFile:path];
    NSError *e = NULL;
    NSPropertyListFormat format;
    if (d) {
    NSDictionary *dict = [NSPropertyListSerialization propertyListWithData:d options:(NSPropertyListImmutable) format:&format error:&e];
        NSArray *pagesInfo = [dict valueForKey:@"pages"];
        _globals = [dict valueForKey:@"globals"];
        
        for (NSDictionary *p in pagesInfo) {
            PageData *pageData = [PageData pageDataWithDictionary:p];
            if (pageData) [a addObject:pageData];
        }
    }
    return a;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Create the data model.
        _pageData = [self getPageData];
    }
    return self;
}

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }

    // Create a new view controller and pass suitable data.
    DataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
    dataViewController.dataObject = self.pageData[index];
    return dataViewController;
}


- (NSUInteger)indexOfViewController:(DataViewController *)viewController {
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.pageData indexOfObject:viewController.dataObject];
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

// Global song playing bounce text:
- (void)timerNextLoop:(NSTimer *)timer {
    DataViewController *next = [[timer userInfo] valueForKey:@"dvc"];
    UITextView *textView = [[timer userInfo] valueForKey:@"textview"];
    if ([[[timer userInfo]valueForKey:@"turnPage"] boolValue]) {
        next = [(RootViewController *)ROOT_VIEW_CONTROLLER nextPage];
        NSDictionary *d = [next valuesForBouncing:YES];
        originalAttributedString = [d valueForKey:@"string"];
        textView = [d valueForKey:@"textView"];
        currentTextView = textView;
    }
    [self nextLoopIn:next];
}

- (void)nextLoopIn:(DataViewController *)dvc {
    bouncePointer++;
    
    if (bouncePointer < bounceTimes.count) {
        // if something goes wrong don't do this!
        if (AUDIO_CONTROLLER == nil) return;
        
        NSDictionary *info = bounceTimes[bouncePointer];
        NSNumber * turnThePage = [info valueForKey:@"turnPage"];
        NSTimeInterval endTime = [[info valueForKey:@"endTime"] doubleValue];
        NSTimeInterval elapsed = CFAbsoluteTimeGetCurrent() - bounceStartTime;
        NSTimeInterval duration = endTime - elapsed;
        NSRange range = NSMakeRange([(NSNumber *)[info valueForKey:@"start"] integerValue],
                                    [(NSNumber *)[info valueForKey:@"length"] integerValue]);
        NSMutableAttributedString *newString = [[NSMutableAttributedString  alloc] initWithAttributedString:originalAttributedString];
        
        // now add whatever attributes you like to our range:
        //        [newString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleThick] range:range];
        //        [newString addAttribute:NSUnderlineColorAttributeName value:[UIColor redColor] range:range];
        
        //[newString addAttribute:NSExpansionAttributeName value:[NSNumber numberWithDouble:log(1.1)] range:range];
        // length = 2, range = 0,2 max = 2
        if (NSMaxRange(range) <= newString.length)
        [newString addAttribute:NSFontAttributeName value:dvc.dataObject.boldFont range:range];
        currentTextView.attributedText = newString;
        
        // now make a callback at then end of our time:
        bounceTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(timerNextLoop:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:dvc,@"dvc",turnThePage,@"turnPage", nil] repeats:NO];
        
    } else currentTextView.attributedText = originalAttributedString;
    
}

- (void)stopBounce {
    if (bounceTimes) {
        [bounceTimer invalidate];
        bounceTimer = nil;
        bounceTimes = nil;
    }
}


- (void)bounceTextWithController:(DataViewController *)dvc {
    BOOL reset = [self indexOfViewController:dvc] == 2 ? YES : NO;
    [self bounceTextWithController:dvc stopBounce:reset];
}

- (void)bounceTextWithController:(DataViewController *)dvc stopBounce:(BOOL)stopBounce {
    
    if (stopBounce) [self stopBounce];
    
    NSDictionary *d = [dvc valuesForBouncing:YES];

    if (stopBounce) {
        bounceStartTime = 0;
        bounceTimes = nil;
        bouncePointer = -1;
    }
    currentController = dvc;
    currentTextView = [d valueForKey:@"textView"];
    originalAttributedString = [d valueForKey:@"string"];
    bounceTimes = [d valueForKey:@"bounceTimes"];

    // does this page have a word list for the current language?
    if (bounceTimes.count) {
        if (stopBounce || bounceStartTime == 0)
            bounceStartTime = CFAbsoluteTimeGetCurrent();
        [self nextLoopIn:(DataViewController *)dvc];
    }
    
}

- (void)updateBounceTextWithController:(DataViewController *)dvc {
    NSDictionary *d = [dvc valuesForBouncing:YES];
    currentController = dvc;
    currentTextView = [d valueForKey:@"textView"];
    originalAttributedString = [d valueForKey:@"string"];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    currentController.playPauseButton.selected = NO;
    [self stopBounce];
}

- (void)stopBounceInController:(DataViewController *)dvc {
    // restore text
    NSDictionary *d = [dvc valuesForBouncing:YES];
    UITextView *textView = [d valueForKey:@"textView"];
    [textView setAttributedText: [d valueForKey:@"string"]];
    [self stopBounce];
    // reset ivars:
    bounceStartTime = 0;
    bounceTimes = nil;
    bouncePointer = -1;
}
- (void)restoreBounceInController:(DataViewController *)dvc {
    // not on last page or first or second pages
    NSUInteger which = [self indexOfViewController:dvc];
    if (which == 0 || which == 1 || which ==_pageData.count-1)
        return;
    
    [self updateBounceTextWithController:dvc];
    bounceStartTime = CFAbsoluteTimeGetCurrent() - [self startTimeForPage:[self indexOfViewController:dvc]];
    bouncePointer = [self bouncePointerForPage:[self indexOfViewController:dvc]];
    if (bounceTimes.count) {
        [self nextLoopIn:(DataViewController *)dvc];
    }

}

- (void)pauseBounceInController:(DataViewController *)dvc {
    // restore text
    NSDictionary *d = [dvc valuesForBouncing:YES];
    UITextView *textView = [d valueForKey:@"textView"];
    [textView setAttributedText: [d valueForKey:@"string"]];
    
    // leave pointers, but stop timer:
    [bounceTimer invalidate];
    bounceTimer = nil;
}


- (NSArray *)getStartTimes:(NSArray *)songList {
    NSMutableArray *a = [NSMutableArray array];
    
    
    // Title Page, Dedication page and First page (item2) begin at 0.0:
    for (int i = 0; i < 3; i++)
    [a addObject:[NSNumber numberWithDouble:0.0]];
    for (int i = 3; i < songList.count;i++) {
        NSDictionary *d = [songList objectAtIndex:i];
        if ([[d valueForKey:@"turnPage"]boolValue]) {
            [a addObject:[d valueForKey:@"endTime"]];
        }
    }
    
    return a;
}

- (void)getStartTimes {
    englishStartTimes = [self getStartTimes:[self englishSongList]];
    spanishStartTimes = [self getStartTimes:[self spanishSongList]];
}

- (NSArray *)getBounceTimes:(NSArray *)songList {
    NSMutableArray *a = [NSMutableArray array];
    
    
    // Title Page, Dedication page and First page (item2) begin at 0.0:
    for (int i = 0; i < 3; i++)
        [a addObject:[NSNumber numberWithUnsignedInteger:0]];
    for (int i = 3; i < songList.count;i++) {
        NSDictionary *d = [songList objectAtIndex:i];
        if ([[d valueForKey:@"turnPage"]boolValue]) {
            [a addObject:[NSNumber numberWithUnsignedInteger:i]];
        }
    }
    
    return a;
}

- (void)getBounceTimes {
    englishStartBounce = [self getBounceTimes:[self englishSongList]];
    spanishStartBounce = [self getBounceTimes:[self spanishSongList]];
}
- (NSTimeInterval)startTimeForPage:(NSUInteger)page {
    if (!englishStartTimes) [self getStartTimes];
        return [[[self currentStartTimes] objectAtIndex:page] doubleValue];
}

- (NSUInteger)bouncePointerForPage:(NSUInteger)page {
    if (!englishStartBounce) [self getBounceTimes];
    return [[[self currentStartBouncePointers]objectAtIndex:page] unsignedIntValue];
}
@end
