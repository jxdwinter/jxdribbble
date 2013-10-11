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
    
    [self setupBorder];

    if(self.scrollForHideNavigation){
        float topInset = self.navigationController.navigationBar.frame.size.height;
        
        self.scrollForHideNavigation.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
    }
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [menuButton setImage:[UIImage imageNamed:@"nav_menu"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    /*
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [self.view addGestureRecognizer:gestureRecognizer];
    */
    
    [self.navigationController.navigationBar setTranslucent:YES];
    self.view.backgroundColor = [UIColor whiteColor];

    
}


- (void)setupBorder
{
    
    UIImageView *leftLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.5, 0.0, 0.5, [UIScreen mainScreen].bounds.size.height)];
    UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height - 1, 320.0, 0.5)];
    UIImageView *rightLine = [[UIImageView alloc] initWithFrame:CGRectMake(320.0 - 1, 0.0, 0.5, [UIScreen mainScreen].bounds.size.height)];
    UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.5, 320.0, 0.5)];
    
    leftLine.backgroundColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
    bottomLine.backgroundColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
    rightLine.backgroundColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
    topLine.backgroundColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
    
    [self.view addSubview:leftLine];
    [self.view addSubview:bottomLine];
    [self.view addSubview:rightLine];
    [self.view addSubview:topLine];
    
}

#ifdef __IPHONE_7_0
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#endif

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


#pragma mark
#pragma Navigation hide Scroll

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    isDecelerating = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    isDecelerating = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.scrollForHideNavigation != scrollView)
        return;
    if(scrollView.frame.size.height >= scrollView.contentSize.height)
        return;
    
    if(scrollView.contentOffset.y > -self.navigationController.navigationBar.frame.size.height && scrollView.contentOffset.y < 0)
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    else if(scrollView.contentOffset.y >= 0)
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    if(lastOffsetY < scrollView.contentOffset.y && scrollView.contentOffset.y >= -self.navigationController.navigationBar.frame.size.height){//moving up
        
        if(self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y  > 0){//not yet hidden
            float newY = self.navigationController.navigationBar.frame.origin.y - (scrollView.contentOffset.y - lastOffsetY);
            if(newY < -self.navigationController.navigationBar.frame.size.height)
                newY = -self.navigationController.navigationBar.frame.size.height;
            self.navigationController.navigationBar.frame = CGRectMake(self.navigationController.navigationBar.frame.origin.x,
                                                                       newY,
                                                                       self.navigationController.navigationBar.frame.size.width,
                                                                       self.navigationController.navigationBar.frame.size.height);
        }
    }else
        if(self.navigationController.navigationBar.frame.origin.y < [UIApplication sharedApplication].statusBarFrame.size.height  &&
           (self.scrollForHideNavigation.contentSize.height > self.scrollForHideNavigation.contentOffset.y + self.scrollForHideNavigation.frame.size.height)){//not yet shown
            float newY = self.navigationController.navigationBar.frame.origin.y + (lastOffsetY - scrollView.contentOffset.y);
            if(newY > [UIApplication sharedApplication].statusBarFrame.size.height)
                newY = [UIApplication sharedApplication].statusBarFrame.size.height;
            self.navigationController.navigationBar.frame = CGRectMake(self.navigationController.navigationBar.frame.origin.x,
                                                                       newY,
                                                                       self.navigationController.navigationBar.frame.size.width,
                                                                       self.navigationController.navigationBar.frame.size.height);
        }
    
    lastOffsetY = scrollView.contentOffset.y;
}



@end
