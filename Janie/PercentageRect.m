//
//  PercentageRect.m
//  Janie
//
//  Created by This One on 3/30/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import "PercentageRect.h"

@implementation PercentageRect

- (CGRect)rectInView:(UIView *)view {
    CGRect r = view.bounds;
    return CGRectMake(_percentages.origin.x * r.size.width, _percentages.origin.y * r.size.height, _percentages.size.width * r.size.width, _percentages.size.height * r.size.height);
}

- (id)initWithPercentageX:(CGFloat)xPercent y:(CGFloat)yPercent width:(CGFloat)widthPercent height:(CGFloat)heightPercent {
    self = [super init];
    _percentages = CGRectMake(xPercent, yPercent, widthPercent, heightPercent);
    return self;
}

@end
