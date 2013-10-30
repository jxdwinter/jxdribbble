//
//  jxdribbble_FindAPlayerViewController.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-17.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_FindAPlayerViewController.h"
#import "jxdribbble_player.h"
#import "jxdribbble_PlayerViewController.h"

@interface jxdribbble_FindAPlayerViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UITextField *usernameTextField;

@end

@implementation jxdribbble_FindAPlayerViewController

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
	// Do any additional setup after loading the view.
    self.title = @"Find A Player";

    [self.navigationController.navigationBar setTranslucent:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToPreViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_spinner setCenter:CGPointMake(300.0 , 20.0)];
    [self.view addSubview:_spinner];
    //[_spinner startAnimating];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:_spinner];
    [self navigationItem].rightBarButtonItem = barButton;
    
    self.usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(60.0, 150.0, 200.0, 20.0)];
    self.usernameTextField.delegate = self;
    self.usernameTextField.placeholder = @"Enter a player name";
    self.usernameTextField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
    self.usernameTextField.textColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameTextField.returnKeyType = UIReturnKeySearch;
    self.usernameTextField.enablesReturnKeyAutomatically = YES;
    self.usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.usernameTextField];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(60.0, 170.5, 200.0, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
    [self.view addSubview:lineView];
    
    [self.usernameTextField becomeFirstResponder];
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self getUserWithUsername:textField.text];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)backToPreViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getUserWithUsername : (NSString *) username
{
    if ([CheckNetwork isExistenceNetwork])
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [_spinner startAnimating];
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
            [_spinner stopAnimating];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [_spinner stopAnimating];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@":( No player named %@",self.usernameTextField.text]
                                                               delegate:nil cancelButtonTitle:@"I'll try another one" otherButtonTitles:nil, nil];
            [alertView show];
        }];
        
        [operation start];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
