//
//  jxdribbble_player.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-12.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_player.h"

@implementation jxdribbble_player

- (instancetype) initWithPlayerInfo:(NSDictionary *)playInfo
{
    self = [super init];
    
    if (self)
    {
        _id = [playInfo objectForKey:@"id"];
        _name = [playInfo objectForKey:@"name"];
        _location = [playInfo objectForKey:@"location"];
        _followers_count = [playInfo objectForKey:@"followers_count"];
        _draftees_count = [playInfo objectForKey:@"draftees_count"];
        _likes_count = [playInfo objectForKey:@"likes_count"];
        _likes_received_count = [playInfo objectForKey:@"likes_received_count"];
        _comments_count = [playInfo objectForKey:@"comments_count"];
        _comments_received_count = [playInfo objectForKey:@"comments_received_count"];
        _rebounds_count = [playInfo objectForKey:@"rebounds_count"];
        _rebounds_received_count = [playInfo objectForKey:@"rebounds_received_count"];
        _url = [playInfo objectForKey:@"url"];
        _avatar_url = [playInfo objectForKey:@"avatar_url"];
        _username = [playInfo objectForKey:@"username"];
        _twitter_screen_name = [playInfo objectForKey:@"twitter_screen_name"];
        _website_url = [playInfo objectForKey:@"website_url"];
        _drafted_by_player_id = [playInfo objectForKey:@"drafted_by_player_id"];
        _shots_count = [playInfo objectForKey:@"shots_count"];
        _following_count = [playInfo objectForKey:@"following_count"];
        _created_at = [playInfo objectForKey:@"created_at"];
        
    }
    
    return self;
    
}

- (id)initWithUsername : (NSString *) username
{
    self = [super init];
    
    if (self)
    {
        _username = username;
    }
    
    return self;
    
}

@end
