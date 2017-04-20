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

- (id)initWithPercentageRect:(PercentageRect *)r action:(NSString *)act shape:(NSString *)shape {
    self = [super initWithFrame:CGRectZero];
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    _percentageRect = r;
    _action = act ? NSSelectorFromString(act) : NSSelectorFromString(@"defaultAction:");
    _shape = shape;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
    [self addGestureRecognizer:tap];
    tap.delegate = self;
    return self;
}

- (void)doTap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.target performSelector:_action withObject:self];
#pragma clang diagnostic pop
}

- (void)drawRect:(CGRect)r {

    CGRect rect = self.bounds; // [self.percentageRect rectInView:view];
    UIColor *c = [UIColor colorWithRed:.7 green:0.0 blue:0.1 alpha:0.2];
    
    CGPathRef path;
    CGAffineTransform t = CGAffineTransformIdentity;
    if ([_shape isEqualToString:@"round"]) {
        path = CGPathCreateWithEllipseInRect(rect, &t);
    } else {
        path = CGPathCreateWithRect(rect, &t);
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, c.CGColor);
    CGContextAddPath(context, path);
    CGContextFillPath(context);

}

- (CGRect)desiredRectInView:(UIImageView *)parent {
    return [_percentageRect rectInView:parent];
}

@end
