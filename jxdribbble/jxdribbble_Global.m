//
//  jxdribbble_Global.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 12/5/13.
//  Copyright (c) 2013 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_Global.h"

@implementation jxdribbble_Global

+ (UIColor *)globlaColor
{
    return [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
}

+ (UIFont *)globlaFontWithSize : (CGFloat) size
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}

+(UIColor *)globlaTextColor
{
    return [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
}

@end
