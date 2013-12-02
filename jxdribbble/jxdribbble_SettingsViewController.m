//
//  jxdribbble_SettingsViewController.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-10.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_SettingsViewController.h"
#import "jxdribbble_player.h"
#import "jxdribbble_PlayerViewController.h"
#import <MessageUI/MessageUI.h>
#import <Dropbox/Dropbox.h>
#import "EvernoteSession.h"
#import "EvernoteUserStore.h"
#import "jxdribbble_FindAPlayerViewController.h"
#import "jxdribbble_PlayerLikesViewController.h"

@interface jxdribbble_SettingsViewController ()<UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView    *tableView;
@property (strong, nonatomic) UIButton *logoutButton;
@property (strong, nonatomic) UITableViewCell *theCell;
@property (strong, nonatomic) UIActionSheet *unlinkDropbox;
@property (strong, nonatomic) UIActionSheet *unlinkEvernote;

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
    self.title = @"Others";
    
    self.logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 25.0, 25.0)];
    [self.logoutButton setImage:[UIImage imageNamed:@"logout"] forState:UIControlStateNormal];
    [self.logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.logoutButton];
    
    [self.navigationController.navigationBar setTranslucent:YES];
    self.view.backgroundColor = [UIColor whiteColor];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, [UIScreen mainScreen].bounds.size.height ) style:UITableViewStyleGrouped];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0,49, 0);
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
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 )
    {
        return 1;
    }
    else if ( section == 1 )
    {
        return 1;
    }
    else if ( section == 2)
    {
        return 2;
    }
    else if ( section == 3 )
    {
        return 6;
    }
    else return 2;
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
            self.theCell = cell;
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
        }
    }
    else if ( section == 1 )
    {
        if ( row == 0 )
        {
            cell.textLabel.text = [NSString stringWithFormat:@"Find a Player"];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
        }
    }
    else if (section == 2 )
    {
        if ( row == 0 )
        {
            DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
            if (account)
            {
                if (!account.info.userName || [account.info.userName isKindOfClass:[NSNull class]])
                {
                    cell.textLabel.text = [NSString stringWithFormat:@"Dropbox : "];
                }
                else cell.textLabel.text = [NSString stringWithFormat:@"Dropbox : %@",account.info.userName];
            }
            else
            {
                cell.textLabel.text = @"Link to Dropbox";
            }
        }
        else if ( row == 1 )
        {
            EvernoteSession *session = [EvernoteSession sharedSession];
            if ( session.isAuthenticated )
            {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *username = [userDefaults stringForKey:@"evernote_uesrname"];
                if (!username || [username isKindOfClass:[NSNull class]])
                {
                    EvernoteUserStore *userStore = [EvernoteUserStore userStore];
                    [userStore getUserWithSuccess:^(EDAMUser *user) {
                        // success
                        NSLog(@"Authenticated as %@", [user username]);
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        [userDefaults setValue:[user username] forKey:@"evernote_uesrname"];
                        [userDefaults synchronize];
                        [self.tableView reloadData];
                    } failure:^(NSError *error) {
                        // failure
                        NSLog(@"Error getting user: %@", error);
                    } ];
                }
                cell.textLabel.text = [NSString stringWithFormat:@"Evernote : %@",username];
            }
            else cell.textLabel.text = [NSString stringWithFormat:@"%@", @"Link to Evernote"];
        }
       
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    else if ( section == 3 )
    {
        if ( row == 0 )
        {
            cell.textLabel.text = @"Tell friends this App";
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else if ( row == 1)
        {
            cell.textLabel.text = @"Rate this App";
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else if ( row == 2 )
        {
            cell.textLabel.text = @"Contact jxdribbble";
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else if ( row == 3 )
        {
            cell.textLabel.text = @"Product designer : @FloydJin";
        }
        else if ( row == 4)
        {
            cell.textLabel.text = @"Developer & designer : @jxdwinter";
        }
        else if ( row == 5 )
        {
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            cell.textLabel.text = [NSString stringWithFormat:@"Version : %@",version];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
        
    }
    else if ( section == 4 )
    {
        if ( row == 0 )
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@",@"All screenshots © their respective owners."];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else if ( row == 1 )
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@",@"Powered by  © Dribbble"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
        
    }
    
    
    cell.textLabel.textColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
    
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
                textField.placeholder = @"Enter your player name";
                textField.keyboardType = UIKeyboardAppearanceDefault;
                [alertView show];
            }
        }
    }
    else if ( section == 1 )
    {
        if ( row == 0 )
        {
            jxdribbble_FindAPlayerViewController *findAPlayerViewController = [[jxdribbble_FindAPlayerViewController alloc] init];
            [self.navigationController pushViewController:findAPlayerViewController animated:YES];
        }
    }
    else if ( section == 2 )
    {
        if ( row == 0 )
        {
            DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
            if (account)
            {
                self.unlinkDropbox = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"NO" destructiveButtonTitle:@"Unlink Dropbox" otherButtonTitles:nil, nil];
                self.unlinkDropbox.actionSheetStyle = UIActionSheetStyleDefault;
                [self.unlinkDropbox showInView:self.view];
            }
            else
            {
                [[DBAccountManager sharedManager] linkFromController:self];
            }
        }
        else if ( row == 1 )
        {
            EvernoteSession *session = [EvernoteSession sharedSession];
            NSLog(@"Session host: %@", [session host]);
            NSLog(@"Session key: %@", [session consumerKey]);
            NSLog(@"Session secret: %@", [session consumerSecret]);
            
            /**
             *  如果已经授权
             */
            if ( session.isAuthenticated )
            {
                self.unlinkEvernote = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"NO" destructiveButtonTitle:@"Unlink Evernote" otherButtonTitles:nil, nil];
                self.unlinkEvernote.actionSheetStyle = UIActionSheetStyleDefault;
                [self.unlinkEvernote showInView:self.view];
            }
            else
            {
                [session authenticateWithViewController:self completionHandler:^(NSError *error) {
                    if (error || !session.isAuthenticated){
                        if (error) {
                            NSLog(@"Error authenticating with Evernote Cloud API: %@", error);
                        }
                        if (!session.isAuthenticated) {
                            NSLog(@"Session not authenticated");
                        }
                    } else {
                        // We're authenticated!
                        EvernoteUserStore *userStore = [EvernoteUserStore userStore];
                        [userStore getUserWithSuccess:^(EDAMUser *user) {
                            // success
                            NSLog(@"Authenticated as %@", [user username]);
                            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                            [userDefaults setValue:[user username] forKey:@"evernote_uesrname"];
                            [userDefaults synchronize];
                            [self.tableView reloadData];
                        } failure:^(NSError *error) {
                            // failure
                            NSLog(@"Error getting user: %@", error);
                        } ];
                    }
                }];
            }
        }
    }
    else if ( section == 3 )
    {
        if ( row == 0 )
        {
            NSString *textToShare = [NSString stringWithFormat:@"Check out this awesome dribbble client %@",@"https://itunes.apple.com/us/app/jxdribbble/id729549824?ls=1&mt=8"];
            NSURL *urlToShare = [NSURL URLWithString:[NSString stringWithFormat:@""]];
            NSArray *activityItems = @[textToShare, urlToShare];
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
            activityViewController.excludedActivityTypes = @[UIActivityTypePostToVimeo,UIActivityTypeAddToReadingList,UIActivityTypeAssignToContact,UIActivityTypeAirDrop,UIActivityTypeCopyToPasteboard,UIActivityTypePostToFlickr,UIActivityTypePrint,UIActivityTypeSaveToCameraRoll];
            [self presentViewController:activityViewController animated:YES completion:nil];
        }
        
        else if ( row == 1 )
        {
            NSString *urlStr = @"https://itunes.apple.com/us/app/jxdribbble/id729549824?ls=1&mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
        
        else if ( row == 2 )
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"cancel"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"Twitter me",@"Email me", nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            [actionSheet showInView:self.view];
        }
        else if ( row == 3)
        {
            BOOL isTweetbotInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"tweetbot:///user_profile/FloydJin"]]];
            if ( isTweetbotInstalled )
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tweetbot:///user_profile/FloydJin"]]];
            }
            else
            {
                NSString *urlStr = @"https://twitter.com/FloydJin";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            }
        }
        else if ( row == 4 )
        {
            BOOL isTweetbotInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"tweetbot:///user_profile/jxdwinter"]]];
            if ( isTweetbotInstalled )
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tweetbot:///user_profile/jxdwinter"]]];
            }
            else
            {
                NSString *urlStr = @"https://twitter.com/jxdwinter";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            }
        }
    }
}


#pragma mark -  actionsheetdelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( actionSheet == self.unlinkDropbox )
    {
        if (buttonIndex == 0)
        {
            DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
            [account unlink];
            [self.tableView reloadData];
        }
    }
    else if ( actionSheet == self.unlinkEvernote )
    {
        if (buttonIndex == 0)
        {
            [[EvernoteSession sharedSession] logout];
            [self.tableView reloadData];
        }
    }
    else
    {
        if (buttonIndex == 0)
        {
            BOOL isTweetbotInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"tweetbot:///post?text=@jxdribbble"]]];
            if ( isTweetbotInstalled )
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tweetbot:///post?text=@jxdribbble"]]];
            }
            else
            {
               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/jxdribbble"]]];
            }
        }
        else if ( buttonIndex == 1 )
        {
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setSubject:@""];
            [controller setToRecipients:[NSArray arrayWithObject:@"jxdribbble@gmail.com"]];
            [controller setMessageBody:@"Hello there." isHTML:NO];
            [self presentViewController:controller animated:YES completion:^{
                
            }];
        }
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
            button.titleLabel.textColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
        }
    }
}


- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent)
    {
        
    }
    else if (result == MFMailComposeResultCancelled)
    {
        
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.dribbble.com/%@",username]];
        
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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@":( No player named %@",username]
                                                               delegate:nil cancelButtonTitle:@"I'll try another one" otherButtonTitles:nil, nil];
            [alertView show];
        }];
        
        [operation start];
    }

}

- (void)getUserWithUsername : (NSString *) username
{
    if ([CheckNetwork isExistenceNetwork])
    {
        
        self.theCell.userInteractionEnabled = NO;
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.dribbble.com/%@",username]];
        
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
            self.theCell.userInteractionEnabled = YES;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            self.theCell.userInteractionEnabled = YES;
        }];
        
        [operation start];
    }
    
}

@end
