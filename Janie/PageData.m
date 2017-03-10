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
    _textInItalics = [[d valueForKey:@"textInItalics"] boolValue];
    
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


- (UIFont *)textFont {
    BOOL isPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    float size = isPad ? 18.0 : 15.0;

    return _textInItalics ? [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:size] : [UIFont fontWithName:@"TimesNewRomanPSMT" size:size];
}

- (float)lineSpacing {
    BOOL isPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    return ( isPad ? -1.0 : -1.0);
}

@end
