//
//  jxdribbble_comments.h
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-14.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "jxdribbble_player.h"

@interface jxdribbble_comments : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *likes_count;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, strong) jxdribbble_player *player;
@property (nonatomic, copy) NSString *created_at;

- (id)initWithCommentInfo : (NSDictionary *)commentInfo;

@end
