//
//  jxdribbble_Global.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 12/5/13.
//  Copyright (c) 2013 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_Global.h"

#import <CommonCrypto/CommonDigest.h>

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

+ (BOOL)is_file_exist:(NSString *)name
{
    NSFileManager *file_manager = [NSFileManager defaultManager];
    return [file_manager fileExistsAtPath:name];
}

+ (NSString *) getMD5Value:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return  output;
}


@end
