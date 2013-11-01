//
//  jxdribbble_shots.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-12.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_shots.h"

@implementation jxdribbble_shots

- (instancetype)initWithShotInfo:(NSDictionary *)shotInfo
{
    self = [super init];
    if (self)
    {
        _id = [shotInfo objectForKey:@"id"];
        _title = [shotInfo objectForKey:@"title"];
        _height = [shotInfo objectForKey:@"height"];
        _width = [shotInfo objectForKey:@"width"];
        _likes_count = [shotInfo objectForKey:@"likes_count"];
        _comments_count = [shotInfo objectForKey:@"comments_count"];
        _rebounds_count = [shotInfo objectForKey:@"rebounds_count"];
        _url = [shotInfo objectForKey:@"url"];
        _short_url = [shotInfo objectForKey:@"short_url"];
        _views_count = [shotInfo objectForKey:@"views_count"];
        _rebound_source_id = [shotInfo objectForKey:@"rebound_source_id"];
        _image_url = [shotInfo objectForKey:@"image_url"];
        _image_teaser_url = [shotInfo objectForKey:@"image_teaser_url"];
        _player = [[jxdribbble_player alloc] initWithPlayerInfo:[shotInfo objectForKey:@"player"]];
        _created_at = [shotInfo objectForKey:@"created_at"];
    }
    
    return self;
    
}

@end
