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
    _tweakFontSizeAmount = [[d valueForKey:@"tweakFontSizeAmount"] floatValue];
    _tweakTextViewHeight = [[d valueForKey:@"tweakTextViewHeight"] floatValue];
    _tweakTextViewCenter = [[d valueForKey:@"tweakTextViewCenter"] floatValue];
    
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

#define dDeviceOrientation [[UIDevice currentDevice] orientation]
#define isPortrait  UIDeviceOrientationIsPortrait(dDeviceOrientation)


- (UIFont *)textFont {
    BOOL oneLanguage = ([[NSUserDefaults standardUserDefaults] integerForKey:@"WhichLanguage"] > 0);
    BOOL isPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    float size = isPad ? (isPortrait ? 18.0 : 16.0) : 15.0;

    // on iPad we tweak to fill:
    if (isPad || self.tweakFontSizeAmount < 0)
        size += self.tweakFontSizeAmount;
    

    if (oneLanguage) size += 5.0;


    return _textInItalics ? [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:size] : [UIFont fontWithName:@"TimesNewRomanPSMT" size:size];
}

- (float)lineSpacing {
    BOOL isPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    return ( isPad ? -3.0 : -1.0);
}

@end
