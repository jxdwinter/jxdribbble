//
//  jxdribbble_PlayerListViewController.h
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-16.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jxdribbble_player.h"

@interface jxdribbble_PlayerListViewController : UIViewController

/**
 *  following = 1
 *  follower  = 2
 *  draftees  = 3
 */
@property (nonatomic, strong) jxdribbble_player *player;
@property (nonatomic, assign) int viewControllerType;

@end
