//
//  jxdribbble_comments.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-14.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_comments.h"

@implementation jxdribbble_comments

- (id)initWithCommentInfo : (NSDictionary *)commentInfo
{
    self = [super init];
    if (self)
    {
        _id = [commentInfo objectForKey:@"id"];
        _likes_count = [commentInfo objectForKey:@"likes_count"];
        _body = [commentInfo objectForKey:@"body"];
        _player = [[jxdribbble_player alloc] initWithPlayerInfo:[commentInfo objectForKey:@"player"]];
        _created_at = [commentInfo objectForKey:@"created_at"];
    }
    
    return self;
    
}

@end
