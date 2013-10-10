//
//  jxdribbble_AppDelegate.h
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-10.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "jxdribbble_EveryoneViewController.h"
#import "jxdribbble_DebutsViewController.h"
#import "jxdribbble_PopularViewController.h"
#import "jxdribbble_FollowingViewController.h"
#import "jxdribbble_SettingsViewController.h"

@interface jxdribbble_AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, readonly, nonatomic) RESideMenu *sideMenu;

@property (strong, nonatomic) jxdribbble_EveryoneViewController  *everyoneViewController;
@property (strong, nonatomic) jxdribbble_DebutsViewController    *debutsViewController;
@property (strong, nonatomic) jxdribbble_PopularViewController   *popularViewController;
@property (strong, nonatomic) jxdribbble_FollowingViewController *followingViewController;
@property (strong, nonatomic) jxdribbble_SettingsViewController  *settingsViewController;

@end
