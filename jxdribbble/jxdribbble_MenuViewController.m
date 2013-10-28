//
//  DEMOMenuViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "jxdribbble_MenuViewController.h"
#import "jxdribbble_EveryoneViewController.h"
#import "jxdribbble_DebutsViewController.h"
#import "jxdribbble_PopularViewController.h"
#import "jxdribbble_FollowingViewController.h"
#import "jxdribbble_SettingsViewController.h"
#import "jxdribbble_FindAPlayerViewController.h"


@interface jxdribbble_MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, readwrite, nonatomic) UITableView *tableView;

@property (strong, nonatomic) jxdribbble_DebutsViewController   *debutsViewController;
@property (strong, nonatomic) jxdribbble_PopularViewController  *popularViewController;
@property (strong, nonatomic) jxdribbble_FollowingViewController *followingViewController;
@property (strong, nonatomic) jxdribbble_SettingsViewController *settingsViewController;
@property (strong, nonatomic) jxdribbble_FindAPlayerViewController *findAPlayerViewController;

@end

@implementation jxdribbble_MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self preferredStatusBarStyle];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 6) / 2.0f, self.view.frame.size.width, 54 * 6) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.scrollsToTop = NO;
        tableView.backgroundView = nil;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *navigationController = (UINavigationController *)self.sideMenuViewController.contentViewController;
    jxdribbble_AppDelegate *appDelegate = (jxdribbble_AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    switch (indexPath.row) {
        case 0:
            if ( !appDelegate.everyoneViewController )
            {
                appDelegate.everyoneViewController =[[jxdribbble_EveryoneViewController alloc] init];
            }
            navigationController.viewControllers = @[appDelegate.everyoneViewController];
            
            [self.sideMenuViewController hideMenuViewController];
            break;
            
        case 1:
            if (!self.debutsViewController)
            {
                self.debutsViewController = [[jxdribbble_DebutsViewController alloc] init];
            }
            navigationController.viewControllers = @[self.debutsViewController];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 2:
            if (!self.popularViewController)
            {
                self.popularViewController = [[jxdribbble_PopularViewController alloc] init];
            }
            navigationController.viewControllers = @[self.popularViewController];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 3:
            if (!self.followingViewController)
            {
                self.followingViewController = [[jxdribbble_FollowingViewController alloc] init];
            }
            navigationController.viewControllers = @[self.followingViewController];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 4:
            if (!self.findAPlayerViewController)
            {
                self.findAPlayerViewController = [[jxdribbble_FindAPlayerViewController alloc] init];
            }
            navigationController.viewControllers = @[self.findAPlayerViewController];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 5:
            if (!self.settingsViewController)
            {
                self.settingsViewController = [[jxdribbble_SettingsViewController alloc] init];
            }
            navigationController.viewControllers = @[self.settingsViewController];
            [self.sideMenuViewController hideMenuViewController];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-light" size:21];
        cell.textLabel.textColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    NSArray *titles = @[@"            Everyone", @"            Debuts", @"            Popular", @"            Following", @"            Find player",@"            About"];
    //NSArray *images = @[@"IconHome", @"IconCalendar", @"IconProfile", @"IconSettings", @"IconEmpty"];
    cell.textLabel.text = titles[indexPath.row];
    //cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
