//
//  HotAction.h
//  Janie
//
//  Created by This One on 4/18/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PercentageRect;


@interface HotAction : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) PercentageRect *percentageRect;
@property (nonatomic, strong) NSString *shape;
@property (nonatomic, strong) NSString *englishWord;
@property (nonatomic, strong) NSString *spanishWord;
@property (nonatomic) NSArray *points;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;

- (id)initWithPercentageRect:(PercentageRect *)r action:(NSString *)act shape:(NSString *)shape path:(NSArray *)aPath english:(NSString *)engword spanish:(NSString *)spanWord;
- (CGRect)desiredRectInView:(UIImageView *)parent maintainsAspect:(BOOL)aspect;
- (NSString *)soundFile;


@end
