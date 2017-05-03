//
//  ModelController.m
//  Janie
//
//  Created by This One on 3/3/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import "ModelController.h"
#import "DataViewController.h"
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

@implementation ModelController
static ModelController *sharedModel = nil;

+ (ModelController *)sharedModelController {
    if (!sharedModel) sharedModel = [[ModelController alloc] init];
    return sharedModel;
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

@end
