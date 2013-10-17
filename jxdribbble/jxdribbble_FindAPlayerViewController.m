//
//  jxdribbble_FindAPlayerViewController.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-17.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_FindAPlayerViewController.h"
#import "jxdribbble_NavigationViewController.h"

@interface jxdribbble_FindAPlayerViewController ()

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
    self.title = @"FIND A PLAYER";
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [menuButton setImage:[UIImage imageNamed:@"nav_menu"] forState:UIControlStateNormal];
    [menuButton addTarget:(jxdribbble_NavigationViewController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    [self.navigationController.navigationBar setTranslucent:YES];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
