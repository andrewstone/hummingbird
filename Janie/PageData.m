//
//  PageData.m
//  Janie
//
//  Created by This One on 3/5/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import "PageData.h"

@implementation PageData

+ (PageData *)pageDataWithDictionary:(NSDictionary *)d {
    return [[self alloc] initWithDictionary:d];
}

- (PageData *)initWithDictionary:(NSDictionary *)d {
    self = [self init];
    _imageName = [[d valueForKey:@"imageName"] copy];
    _pageLabel = [d valueForKey:@"pageLabel"];
    
    // audio
    _playOnLoad = [[d valueForKey:@"playOnLoad"] boolValue];
    _leaveSongRunning = [[d valueForKey:@"leaveSongRunning"]boolValue];
    _english = [d valueForKey:@"english"];
    _spanish = [d valueForKey:@"spanish"];
    _imageFullPage = [[d valueForKey:@"imageFullPage"] boolValue];
    
    NSArray *a = [d valueForKey:@"audioFileNames"];
    if (a) {
        _audioFiles = [[NSMutableArray alloc] initWithArray:a];
    }
    
    // add more functionality
    return self;
}

- (UIImage *)pageImage {
    return [UIImage imageNamed:_imageName];
}

/*
@property (nonatomic) NSString *imageName;
@property (nonatomic) NSArray *audioFiles;
@property (nonatomic) BOOL playOnLoad;
@property (nonatomic) NSString *pageLabel;   // could be a number, or label like Preface etc.
*/

@end
