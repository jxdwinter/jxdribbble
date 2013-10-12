//
//  jxdribbble_shots.h
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-12.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "jxdribbble_player.h"

@interface jxdribbble_shots : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *likes_count;
@property (nonatomic, copy) NSString *comments_count;
@property (nonatomic, copy) NSString *rebounds_count;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *short_url;
@property (nonatomic, copy) NSString *views_count;
@property (nonatomic, copy) NSString *rebound_source_id;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *image_teaser_url;
@property (nonatomic, strong) jxdribbble_player *player;
@property (nonatomic, copy) NSString *created_at;

- (id)initWithShotInfo : (NSDictionary *)shotInfo;

@end
