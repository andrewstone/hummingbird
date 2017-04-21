//
//  PercentageRect.m
//  Janie
//
//  Created by This One on 3/30/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import "PercentageRect.h"

@implementation PercentageRect

- (CGRect)rectInView:(UIImageView *)view maintainsAspect:(BOOL)aspect{
    CGRect r = view.bounds;
    CGSize imageSize = view.image.size;
    CGFloat xOffset = 0.0;
    CGFloat yOffset = 0.0;
    CGFloat wMultiplier = r.size.width;
    CGFloat hMultiplier = r.size.height;
    
    if (aspect) {
        // if aspect ratios are the same, then no origin offset
        CGFloat imageAspectRatio = imageSize.width/imageSize.height;
        CGFloat viewAspectRatio = r.size.width/r.size.height;
        if (viewAspectRatio < imageAspectRatio) {
            // offset Y by half the difference
            CGFloat h = 1/(imageAspectRatio / r.size.width);
            yOffset = floor((r.size.height - h)/2.0);
            hMultiplier = viewAspectRatio /imageAspectRatio * r.size.height;
            
        } else if (viewAspectRatio > imageAspectRatio) {
            // offset x by half the difference
            CGFloat w = imageAspectRatio * r.size.height;
            xOffset = floor((r.size.width - w)/2.0);
            wMultiplier = imageAspectRatio/viewAspectRatio * r.size.width;
            
        }
    }
    
    return CGRectMake(_percentages.origin.x * wMultiplier + xOffset, _percentages.origin.y * hMultiplier + yOffset, _percentages.size.width * wMultiplier, _percentages.size.height * hMultiplier);
}

- (id)initWithPercentageX:(CGFloat)xPercent y:(CGFloat)yPercent width:(CGFloat)widthPercent height:(CGFloat)heightPercent {
    self = [super init];
    _percentages = CGRectMake(xPercent, yPercent, widthPercent, heightPercent);
    return self;
}

@end
