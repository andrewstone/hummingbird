//
//  PageData.m
//  Janie
//
//  Created by This One on 3/5/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import "PageData.h"
#import "PercentageRect.h"
#import "HotAction.h"

@implementation PageData

+ (PageData *)pageDataWithDictionary:(NSDictionary *)d {
    return [[self alloc] initWithDictionary:d];
}

- (NSMutableArray *)getHotRects:(NSArray *)a {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:a.count];
    
    for (NSDictionary *d in a) {
        NSDictionary *rect = [d valueForKey:@"rect"];
        PercentageRect *pr = [[PercentageRect alloc] initWithPercentageX:[[rect valueForKey:@"x"] doubleValue] y:[[rect valueForKey:@"y"] doubleValue] width:[[rect valueForKey:@"width"]doubleValue] height:[[rect valueForKey:@"height"]doubleValue]];
        
        HotAction *hot = [[HotAction alloc] initWithPercentageRect:pr action:[d valueForKey:@"action"] shape:[d valueForKey:@"shape"]
                                                            path:[d valueForKey:@"points"]
                          english:[d valueForKey:@"english"] spanish:[d valueForKey:@"spanish"]];
        if (hot)
            [array addObject:hot];
    }
    return array;
    
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
    
    NSString *actionName = [d valueForKey:@"InitialAction"];
    if (actionName) self.initialAction = NSSelectorFromString(actionName);
    
    NSArray *a = [d valueForKey:@"audioFileNames"];
    if (a) {
        _audioFiles = [[NSMutableArray alloc] initWithArray:a];
    }
    a = [d valueForKey:@"englishWordList"];
    if (a) _englishWordList = [[NSMutableArray alloc] initWithArray:a];
    a = [d valueForKey:@"spanishWordList"];
    if (a) _spanishWordList = [[NSMutableArray alloc] initWithArray:a];
    
    a = [d valueForKey:@"hotRects"];
    if (a) _hotRects = [self getHotRects:a];
    
    // hotRects = list of dicts where keys are:
    // rect = dict with keys x, y, width, height in 0.0-1.0 format
    // action = string of method to call on a tap
    
    
    return self;
}

- (UIImage *)pageImage {
    return [UIImage imageNamed:_imageName];
}

#define dDeviceOrientation [[UIDevice currentDevice] orientation]
#define isPortrait  UIDeviceOrientationIsPortrait(dDeviceOrientation)


- (CGFloat)fontSize {
    BOOL oneLanguage = ([[NSUserDefaults standardUserDefaults] integerForKey:@"WhichLanguage"] > 0);
    BOOL isPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    float size = isPad ? (isPortrait ? 18.0 : 16.0) : 14.0;
    
    // on iPad we tweak to fill:
    if (isPad || self.tweakFontSizeAmount < 0)
        size += self.tweakFontSizeAmount;
    
    
    if (oneLanguage) size += (isPad ? 7.0 : 4.0);
    return size;
}

- (UIFont *)textFont {

//#define FONT_NAME_STD   @"TimesNewRomanPS-BoldItalicMT"
//#define FONT_NAME_ITALICS   @"TimesNewRomanPS-BoldMT"
    
//#define FONT_NAME_STD   @"Baskerville"
//#define FONT_NAME_ITALICS   @"Baskerville-Italic"
    
#define FONT_NAME_STD   @"Palatino-Roman"
#define FONT_NAME_ITALICS   @"Palatino-Italic"
    
    CGFloat size = [self fontSize];
    
    return _textInItalics ? [UIFont fontWithName:FONT_NAME_ITALICS size:size] : [UIFont fontWithName:FONT_NAME_STD size:size];
}

//#define FONT_NAME_BOLD   @"Baskerville-Bold"
//#define FONT_NAME_BOLDITALICS   @"Baskerville-BoldItalic"
//#define FONT_NAME_BOLD   @"TimesNewRoman-Bold"
//#define FONT_NAME_BOLDITALICS   @"TimesNewRoman-BoldItalic"
#define FONT_NAME_BOLD   @"Palatino-Bold"
#define FONT_NAME_BOLDITALICS   @"Palatino-BoldItalic"


- (UIFont *)boldFont {
    CGFloat size = [self fontSize];
    
    return _textInItalics ? [UIFont fontWithName:FONT_NAME_BOLDITALICS size:size] : [UIFont fontWithName:FONT_NAME_BOLD size:size];
}

- (float)lineSpacing {
    BOOL isPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    return ( isPad ? -3.0 : -3.0);
}

@end
