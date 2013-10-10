//
//  jxdribbble_AppDelegate.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-10.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_AppDelegate.h"
#import <Crashlytics/Crashlytics.h>


#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@implementation jxdribbble_AppDelegate
{
    NSMutableArray *_addedItems;
    NSMutableArray *_menuItems;

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:@"adb6c6dba2e462026e3494de452a18ec98b17ee6"];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    
    
    _addedItems = [NSMutableArray array];
    _menuItems = [NSMutableArray array];
    
    // Simple menus
    //
    RESideMenuItem *everyoneItem = [[RESideMenuItem alloc] initWithTitle:@"Everyone" action:^(RESideMenu *menu, RESideMenuItem *item) {
        
        if (!self.everyoneViewController)
        {
            self.everyoneViewController = [[jxdribbble_EveryoneViewController alloc] init];
        }
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.everyoneViewController];
        [menu displayContentController:navigationController];
    }];
    
    RESideMenuItem *debutsItem = [[RESideMenuItem alloc] initWithTitle:@"Debuts" action:^(RESideMenu *menu, RESideMenuItem *item) {
        if (!self.debutsViewController)
        {
            self.debutsViewController = [[jxdribbble_DebutsViewController alloc] init];
        }
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.debutsViewController];
        [menu displayContentController:navigationController];
    }];
    
    RESideMenuItem *popularItem = [[RESideMenuItem alloc] initWithTitle:@"Popular" action:^(RESideMenu *menu, RESideMenuItem *item) {
        if (!self.popularViewController)
        {
            self.popularViewController = [[jxdribbble_PopularViewController alloc] init];
        }
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.popularViewController];
        [menu displayContentController:navigationController];
    }];
    
    RESideMenuItem *followingItem = [[RESideMenuItem alloc] initWithTitle:@"Following" action:^(RESideMenu *menu, RESideMenuItem *item) {
        if (!self.followingViewController)
        {
            self.followingViewController = [[jxdribbble_FollowingViewController alloc] init];
        }
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.followingViewController];
        [menu displayContentController:navigationController];
    }];
    
    
    RESideMenuItem *settingsItem = [[RESideMenuItem alloc] initWithTitle:@"Settings" action:^(RESideMenu *menu, RESideMenuItem *item) {
        if (!self.settingsViewController)
        {
            self.settingsViewController = [[jxdribbble_SettingsViewController alloc] init];
        }
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.settingsViewController];
        [menu displayContentController:navigationController];
    }];
    
    _sideMenu = [[RESideMenu alloc] initWithItems:@[everyoneItem, debutsItem, popularItem, followingItem,settingsItem]];
    
    _sideMenu.verticalPortraitOffset = IS_WIDESCREEN ? 110 : 76;
    _sideMenu.verticalLandscapeOffset = 16;
    _sideMenu.openStatusBarStyle = UIStatusBarStyleLightContent;
    
    // Call the home action rather than duplicating the initialisation
    everyoneItem.action(_sideMenu, everyoneItem);
    
    self.window.rootViewController = _sideMenu;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
