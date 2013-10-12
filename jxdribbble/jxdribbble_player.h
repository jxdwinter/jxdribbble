//
//  jxdribbble_player.h
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-12.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface jxdribbble_player : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *followers_count;
@property (nonatomic, copy) NSString *draftees_count;
@property (nonatomic, copy) NSString *likes_count;
@property (nonatomic, copy) NSString *likes_received_count;
@property (nonatomic, copy) NSString *comments_count;
@property (nonatomic, copy) NSString *comments_received_count;
@property (nonatomic, copy) NSString *rebounds_count;
@property (nonatomic, copy) NSString *rebounds_received_count;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *avatar_url;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *twitter_screen_name;
@property (nonatomic, copy) NSString *website_url;
@property (nonatomic, copy) NSString *drafted_by_player_id;
@property (nonatomic, copy) NSString *shots_count;
@property (nonatomic, copy) NSString *following_count;
@property (nonatomic, copy) NSString *created_at;

- (id)initWithPlayerInfo : (NSDictionary *) playInfo;

@end
