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
#import <Dropbox/Dropbox.h>

@interface jxdribbble_AppDelegate : UIResponder <UIApplicationDelegate,RESideMenuDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RESideMenu *sideMenuViewController;
@property (strong, nonatomic) DBFilesystem *filesystem;


@end
