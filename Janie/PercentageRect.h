//
//  PercentageRect.h
//  Janie
//
//  Created by This One on 3/30/17.
//  Copyright © 2017 This One. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PercentageRect : NSObject
@property (nonatomic) CGRect percentages;
- (CGRect)rectInView:(UIView *)view;
- (id)initWithPercentageX:(CGFloat)xPercent y:(CGFloat)yPercent width:(CGFloat)widthPercent height:(CGFloat)heightPercent;

@end