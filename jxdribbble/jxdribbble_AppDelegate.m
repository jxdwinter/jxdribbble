//
//  jxdribbble_AppDelegate.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-10.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_AppDelegate.h"
#import <Crashlytics/Crashlytics.h>
#import "EvernoteSDK.h"

#import "jxdribbble_EveryoneViewController.h"
#import "jxdribbble_DebutsViewController.h"
#import "jxdribbble_PopularViewController.h"
#import "jxdribbble_FollowingViewController.h"
#import "jxdribbble_SettingsViewController.h"

@implementation jxdribbble_AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:@"adb6c6dba2e462026e3494de452a18ec98b17ee6"];
    
    DBAccountManager* accountMgr =
    [[DBAccountManager alloc] initWithAppKey:@"2yqq9welxonx0md" secret:@"h1u6salza4qq34h"];
    [DBAccountManager setSharedManager:accountMgr];
    
    DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
    if (account)
    {
        self.filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem:self.filesystem];
    }
    
    NSString *EVERNOTE_HOST = @"www.evernote.com";
    
    // Fill in the consumer key and secret with the values that you received from Evernote
    // To get an API key, visit http://dev.evernote.com/documentation/cloud/
    NSString *CONSUMER_KEY = @"jxdwinter";
    NSString *CONSUMER_SECRET = @"4126f1fcbcecce39";
    
    // set up Evernote session singleton
    [EvernoteSession setSharedSessionHost:EVERNOTE_HOST
                              consumerKey:CONSUMER_KEY
                           consumerSecret:CONSUMER_SECRET];
    
    [Flurry startSession:@"XGS87XNNXS7B7C2P6FX7"];
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache setMaxCacheSize:1024*1024*200];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // Override point for customization after application launch.

    [[UINavigationBar appearance] setBarTintColor:[jxdribbble_Global globlaColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    shadow.shadowOffset = CGSizeMake(0, 0);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor],
                                                           NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [jxdribbble_Global globlaFontWithSize:20],
                                                           NSFontAttributeName, nil]];
    
    [[UITabBar appearance] setTintColor:[jxdribbble_Global globlaColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8]];

    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.view.backgroundColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    jxdribbble_EveryoneViewController *everyoneViewController = [[jxdribbble_EveryoneViewController alloc] init];
    jxdribbble_DebutsViewController *debutsViewController = [[jxdribbble_DebutsViewController alloc] init];
    jxdribbble_PopularViewController *popularViewController = [[jxdribbble_PopularViewController alloc] init];
    jxdribbble_FollowingViewController *followingViewController = [[jxdribbble_FollowingViewController alloc] init];
    jxdribbble_SettingsViewController *settingsViewController = [[jxdribbble_SettingsViewController alloc] init];

    UINavigationController* everyoneNavController = [[UINavigationController alloc] initWithRootViewController:everyoneViewController];
    UINavigationController* debutsNavController = [[UINavigationController alloc] initWithRootViewController:debutsViewController];
    UINavigationController* popularNavController = [[UINavigationController alloc] initWithRootViewController:popularViewController];
    UINavigationController* followingNavController = [[UINavigationController alloc] initWithRootViewController:followingViewController];
    UINavigationController* settingsNavController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    
    NSArray* controllers = @[everyoneNavController,debutsNavController,popularNavController,followingNavController,settingsNavController];
    self.tabBarController.viewControllers = controllers;
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItem5 = [tabBar.items objectAtIndex:4];
    
    
    tabBarItem1.image = [UIImage imageNamed:@"ico_people"] ;
    tabBarItem1.selectedImage = [UIImage imageNamed:@"ico_people_pre"];
    tabBarItem1.title = @"Everyone";
    
    tabBarItem2.image = [UIImage imageNamed:@"ico_debuts"];
    tabBarItem2.selectedImage = [UIImage imageNamed:@"ico_debuts_pre"];
    tabBarItem2.title = @"Debuts";
    
    tabBarItem3.image = [UIImage imageNamed:@"ico_love"];
    tabBarItem3.selectedImage = [UIImage imageNamed:@"ico_love_pre"];
    tabBarItem3.title = @"Popular";
    
    tabBarItem4.image = [UIImage imageNamed:@"ico_popular"];
    tabBarItem4.selectedImage = [UIImage imageNamed:@"ico_popular_pre"];
    tabBarItem4.title = @"Following";
    
    tabBarItem5.image = [UIImage imageNamed:@"ico_more"];
    tabBarItem5.selectedImage = [UIImage imageNamed:@"ico_more_pre"];
    tabBarItem5.title = @"Others";
    
    self.tabBarController.selectedIndex = 2;
    
    self.window.rootViewController = self.tabBarController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
    
    
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(NSString *)source annotation:(id)annotation
{
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
    NSString *prefix = [urlStr substringToIndex:3];
    
    /**
     *  Dropbox
     */
    if ([prefix isEqualToString:@"db-"])
    {
        DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
        if (account)
        {
            self.filesystem = [[DBFilesystem alloc] initWithAccount:account];
            [DBFilesystem setSharedFilesystem:self.filesystem];
            return YES;
        }
        return NO;
    }
    /**
     *  Evernote
     */
    else if ([prefix isEqualToString:@"en-"])
    {
        BOOL canHandle = NO;
        if ([[NSString stringWithFormat:@"en-%@", [[EvernoteSession sharedSession] consumerKey]] isEqualToString:[url scheme]] == YES) {
            canHandle = [[EvernoteSession sharedSession] canHandleOpenURL:url];
        }
        return canHandle;
    }
    
    return NO;
    
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
    
    [[EvernoteSession sharedSession] handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
