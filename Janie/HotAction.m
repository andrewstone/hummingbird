//
//  HotAction.m
//  Janie
//
//  Created by This One on 4/18/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import "HotAction.h"
#import "PercentageRect.h"
#import "DataViewController.h"


@implementation HotAction 

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // first hittest as needed!
    BOOL hitPath = YES;
    CGPoint pt = [touch locationInView:self];
    CGAffineTransform m = CGAffineTransformIdentity;
    if (self.points) {
        CGPathRef p = [self pathFromPoints];
        hitPath = CGPathContainsPoint(p, &m, pt, 0);
        CGPathRelease(p);
    } else if ([self.shape isEqualToString:@"round"]) {
        CGPathRef p = CGPathCreateWithEllipseInRect(self.bounds, &m);
        hitPath = CGPathContainsPoint(p, &m, pt, 0);
        CGPathRelease(p);
    }
    return hitPath;
}


- (id)initWithPercentageRect:(PercentageRect *)r action:(NSString *)act shape:(NSString *)shape  path:(NSArray *)pointsDict english:(NSString *)engword spanish:(NSString *)spanWord {
    self = [super initWithFrame:CGRectZero];
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    _percentageRect = r;
    _action = act ? NSSelectorFromString(act) : NSSelectorFromString(@"defaultAction:");
    _shape = shape;
    _points = pointsDict;
    _spanishWord = spanWord;
    _englishWord = engword;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
    [self addGestureRecognizer:tap];
    tap.delegate = self;
    return self;
}


- (void)doTap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.target performSelector:_action withObject:self];
#pragma clang diagnostic pop
        
    }
}

- (void)drawRect:(CGRect)r {

/**/ // to test where it is!
    CGRect rect = self.bounds; // [self.percentageRect rectInView:view];
    UIColor *c = [UIColor colorWithRed:.7 green:0.0 blue:0.1 alpha:0.2];
    
    CGPathRef p;
    CGAffineTransform t = CGAffineTransformIdentity;
    
    if (_points) {
        p = [self pathFromPoints];
    } else if ([_shape isEqualToString:@"round"]) {
        p = CGPathCreateWithEllipseInRect(rect, &t);
    } else {
        p = CGPathCreateWithRect(rect, &t);
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, c.CGColor);
    CGContextAddPath(context, p);
    CGContextFillPath(context);
    CGPathRelease(p);/*
*/

}

- (CGRect)desiredRectInView:(UIImageView *)parent maintainsAspect:(BOOL)aspect {
    return [_percentageRect rectInView:parent maintainsAspect:aspect];
}

- (CGPathRef)pathFromPoints {
    CGMutablePathRef p = CGPathCreateMutable();
    CGAffineTransform m = CGAffineTransformIdentity;
    
    NSArray *points = [_percentageRect transformedPoints:_points size:self.bounds.size];
    if (points.count > 2) {
        CGPathMoveToPoint(p, &m, [[points[0] objectAtIndex:0] doubleValue], [[points[0] objectAtIndex:1] doubleValue]);
        for (int i = 1; i < points.count; i++) {
            CGPathAddLineToPoint(p, &m, [[points[i] objectAtIndex:0]doubleValue], [[points[i] objectAtIndex:1]doubleValue]);
        }
    }
    
    return p;
}

- (NSString *)soundFile {
    NSInteger which = [[NSUserDefaults standardUserDefaults] integerForKey:@"WhichLanguage"];
    if (which == 2) {
        return _englishWord ? _englishWord : @"hurray.m4a";
    } else {
        return _spanishWord ? _spanishWord : @"hurray.m4a";
    }
}


@end
