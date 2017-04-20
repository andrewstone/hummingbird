//
//  PageData.h
//  Janie
//
//  Created by This One on 3/5/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PageData : NSObject

+ (PageData *)pageDataWithDictionary:(NSDictionary *)d;

@property (nonatomic) NSString *imageName;

@property (nonatomic) NSString *pageLabel;   // could be a number, or label like Preface etc.
@property (nonatomic) NSString *english;
@property (nonatomic) NSString *spanish;
@property (nonatomic) SEL initialAction;
@property (nonatomic) NSArray *audioFiles;
@property (nonatomic) NSArray *englishWordList;
@property (nonatomic) NSArray *spanishWordList;
@property (nonatomic) NSArray *hotRects;
@property (nonatomic) CGFloat tweakFontSizeAmount;
@property (nonatomic) CGFloat tweakTextViewHeight;
@property (nonatomic) CGFloat tweakTextViewCenter;
@property (nonatomic) BOOL playOnLoad;
@property (nonatomic) BOOL leaveSongRunning;

@property (nonatomic) BOOL imageFullPage;
@property (nonatomic) BOOL textInItalics;


- (UIImage *)pageImage;
- (UIFont *)textFont;
- (float)lineSpacing;
- (UIFont *)boldFont;

@end
