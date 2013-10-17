//
//  jxdribbble_SettingsViewController.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-10.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_SettingsViewController.h"
#import "jxdribbble_NavigationViewController.h"
#import "jxdribbble_player.h"
#import "jxdribbble_PlayerViewController.h"

@interface jxdribbble_SettingsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView    *tableView;
@property (strong, nonatomic) UIButton *logoutButton;

@end

@implementation jxdribbble_SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"SETTINGS";
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [menuButton setImage:[UIImage imageNamed:@"nav_menu"] forState:UIControlStateNormal];
    [menuButton addTarget:(jxdribbble_NavigationViewController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    self.logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 25.0, 25.0)];
    [self.logoutButton setImage:[UIImage imageNamed:@"logout"] forState:UIControlStateNormal];
    [self.logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.logoutButton];
    
    [self.navigationController.navigationBar setTranslucent:YES];
    self.view.backgroundColor = [UIColor whiteColor];

    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 110.0)];
    headerView.image = [UIImage imageNamed:@"logo"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    self.tableView.tableHeaderView = headerView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setBackgroundView:nil];
    self.tableView.backgroundColor = [UIColor clearColor];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}

- (void)logout
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:@"" forKey:@"username"];
    [userDefaults synchronize];
    [self.tableView reloadData];
    self.logoutButton.hidden = YES;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    jxdribbble_AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
    appDelegate.sideMenuViewController.panGestureEnabled = YES;
    
    [self.tableView reloadData];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefaults stringForKey:@"username"];
    if ( username && username.length != 0 )
    {
        self.logoutButton.hidden = NO;
    }
    else self.logoutButton.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 )
    {
        return 1;
    }
    else return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ( section == 0)
    {
        if ( row == 0 )
        {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *username = [userDefaults stringForKey:@"username"];
            if ( username && username.length != 0 )
            {
                cell.textLabel.text = username;
            }
            else
            {
                cell.textLabel.text = @"Are you a player?";
            }
        }
        
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
        
    }
    
    else if ( section == 1 )
    {
        if ( row == 0 )
        {
            cell.textLabel.text = @"Tell friends this App";
        }
        else if ( row == 1)
        {
            cell.textLabel.text = @"Rate this App";
        }
        else if ( row == 2 )
        {
            cell.textLabel.text = @"Contact jxdribbble";
        }
        else if ( row == 3 )
        {
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            cell.textLabel.text = [NSString stringWithFormat:@"Version : %@",version];
        }
        
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
        
    }
    
    
    cell.textLabel.textColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    if ( section == 0)
    {
        if ( row == 0 )
        {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *username = [userDefaults stringForKey:@"username"];
            if ( username && username.length != 0 )
            {
                [self getUserWithUsername:username];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"A Dribbble Player?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
                UITextField * textField = [alertView textFieldAtIndex:0];
                textField.keyboardType = UIKeyboardAppearanceDefault;
                [alertView show];
            }
        }
    }
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 )
    {
        NSString *username = [[alertView textFieldAtIndex:0] text];
        if ( username && username.length > 0 )
        {
            [self checkUserWithUsername:username];
        }
    }
}


- (void) checkUserWithUsername : (NSString *) username
{
    if ([CheckNetwork isExistenceNetwork])
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.dribbble.com/players/%@",username]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *jsonDic = JSON;
            jxdribbble_player *player = [[jxdribbble_player alloc] initWithPlayerInfo:jsonDic];
            if (player)
            {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setValue:username forKey:@"username"];
                [userDefaults synchronize];
                self.logoutButton.hidden = NO;
                [self.tableView reloadData];
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
        
        [operation start];
    }

}

- (void)getUserWithUsername : (NSString *) username
{
    if ([CheckNetwork isExistenceNetwork])
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.dribbble.com/players/%@",username]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *jsonDic = JSON;
            jxdribbble_player *player = [[jxdribbble_player alloc] initWithPlayerInfo:jsonDic];
            if (player)
            {
                jxdribbble_PlayerViewController *playerViewController = [[jxdribbble_PlayerViewController alloc] init];
                playerViewController.player = player;
                [self.navigationController pushViewController:playerViewController animated:YES];
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
        
        [operation start];
    }
    
}

@end
