//
//  ModelController.h
//  Janie
//
//  Created by This One on 3/3/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>
@property (nonatomic, strong) NSDictionary *globals;

+ (ModelController *)sharedModelController;

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;


- (NSArray *)englishSongList;
- (NSArray *)spanishSongList;
- (NSString *)spanishSong;
- (NSString *)englishSong;

- (NSString *)currentSong;
- (NSArray *)currentSongList;

- (void)bounceTextWithController:(DataViewController *)dvc;
@end

