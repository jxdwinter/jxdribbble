//
//  RootViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 6/26/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [menuButton setImage:[UIImage imageNamed:@"nav_menu"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    
}

- (void)swipeHandler:(UIPanGestureRecognizer *)sender
{
    /**
     *  comment this line, there's a bug when slide right quickly
     */
    //[[self sideMenu] showFromPanGesture:sender];
}

#pragma mark -
#pragma mark Button actions

- (void)showMenu
{
    [[self sideMenu] show];
}

@end
