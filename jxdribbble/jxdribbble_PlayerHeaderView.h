//
//  jxdribbble_PlayerHeaderView.h
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-16.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jxdribbble_player.h"

@interface jxdribbble_PlayerHeaderView : UIView

@property (nonatomic, strong) jxdribbble_player *player;

- (id) initWithPlayerInfo : (jxdribbble_player *) playInfo;

@end
